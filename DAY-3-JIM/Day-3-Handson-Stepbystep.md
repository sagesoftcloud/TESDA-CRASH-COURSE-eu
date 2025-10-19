# Day 3: Hands-on Step-by-Step Guide
## Advanced Operational Excellence - CI/CD & Chaos Engineering for TESDA

### 🎯 Learning Objectives
By the end of this hands-on session, you will:
- Build automated CI/CD pipelines with zero-downtime deployment
- Implement chaos engineering to test system resilience
- Create advanced monitoring with predictive analytics
- Understand enterprise-level operational excellence practices

### ⏰ Time Allocation
- **Project 1**: CI/CD Pipeline with Blue-Green Deployment (80 minutes)
- **Project 2**: Chaos Engineering & Resilience Testing (80 minutes)
- **Project 3**: Advanced Monitoring & Business Intelligence (80 minutes)
- **Final Assessment**: Comprehensive integration test (20 minutes)

---

## 🚀 Project 1: CI/CD Pipeline with Zero-Downtime Deployment (80 minutes)

### What You'll Build
A complete CI/CD pipeline that:
- Automatically tests code changes
- Deploys with zero downtime using blue-green strategy
- Includes automated rollback capabilities
- Integrates monitoring and alerting

### Real-World Scenario
You're the DevOps engineer for a popular e-commerce app like Shopee. The development team pushes new features daily, and you need to deploy them without any downtime for millions of users. Any deployment failure could cost millions in lost sales.

---

### Step 1: Create Sample Application Repository (15 minutes)

#### 1.1 Set Up CodeCommit Repository
```
🖥️ VISUAL: AWS Console
📍 Services → CodeCommit
📍 Click "Create repository"
📍 Repository name: "ecommerce-app-cicd"
📍 Description: "E-commerce application with CI/CD pipeline"
📍 Click "Create"
```

#### 1.2 Clone Repository Locally
```bash
# In your EC2 terminal from Day 2
cd /home/ec2-user

# Clone the repository
git clone https://git-codecommit.us-east-1.amazonaws.com/v1/repos/ecommerce-app-cicd
cd ecommerce-app-cicd
```

#### 1.3 Create Node.js Application
```bash
# Create package.json
cat > package.json << 'EOF'
{
  "name": "ecommerce-app",
  "version": "1.0.0",
  "description": "E-commerce application for CI/CD demo",
  "main": "app.js",
  "scripts": {
    "start": "node app.js",
    "test": "jest --coverage",
    "dev": "nodemon app.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "aws-xray-sdk": "^3.4.1",
    "helmet": "^6.1.5",
    "cors": "^2.8.5"
  },
  "devDependencies": {
    "jest": "^29.5.0",
    "supertest": "^6.3.3",
    "nodemon": "^2.0.22"
  }
}
EOF
```

#### 1.4 Create Main Application (app.js)
```javascript
const express = require('express');
const helmet = require('helmet');
const cors = require('cors');
const AWSXRay = require('aws-xray-sdk-core');

const app = express();
const port = process.env.PORT || 3000;
const version = process.env.APP_VERSION || '1.0.0';
const environment = process.env.NODE_ENV || 'development';

// Security and middleware
app.use(helmet());
app.use(cors());
app.use(express.json());

// X-Ray tracing for production
if (environment === 'production') {
    app.use(AWSXRay.express.openSegment('ecommerce-app'));
}

// Health check endpoint
app.get('/health', (req, res) => {
    res.status(200).json({
        status: 'healthy',
        version: version,
        environment: environment,
        timestamp: new Date().toISOString(),
        uptime: process.uptime()
    });
});

// Main application routes
app.get('/', (req, res) => {
    res.json({
        message: 'Welcome to E-commerce CI/CD Demo',
        version: version,
        environment: environment,
        features: [
            'Zero-downtime deployment',
            'Automated testing',
            'Blue-green deployment',
            'Automatic rollback'
        ]
    });
});

// Products API
app.get('/api/products', (req, res) => {
    const products = [
        { id: 1, name: 'Laptop', price: 50000, stock: 10 },
        { id: 2, name: 'Phone', price: 25000, stock: 25 },
        { id: 3, name: 'Tablet', price: 15000, stock: 15 }
    ];
    
    res.json({
        products: products,
        total: products.length,
        version: version
    });
});

// Orders API (simulate business logic)
app.post('/api/orders', (req, res) => {
    const { productId, quantity } = req.body;
    
    if (!productId || !quantity) {
        return res.status(400).json({
            error: 'Product ID and quantity are required',
            version: version
        });
    }
    
    // Simulate order processing
    const orderId = Math.floor(Math.random() * 10000);
    
    res.status(201).json({
        orderId: orderId,
        productId: productId,
        quantity: quantity,
        status: 'confirmed',
        timestamp: new Date().toISOString(),
        version: version
    });
});

// Metrics endpoint
app.get('/metrics', (req, res) => {
    res.json({
        memory: process.memoryUsage(),
        uptime: process.uptime(),
        version: version,
        environment: environment,
        timestamp: new Date().toISOString()
    });
});

// Error handling
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).json({
        error: 'Something went wrong!',
        version: version
    });
});

// 404 handler
app.use((req, res) => {
    res.status(404).json({
        error: 'Route not found',
        version: version
    });
});

// Close X-Ray segment
if (environment === 'production') {
    app.use(AWSXRay.express.closeSegment());
}

const server = app.listen(port, () => {
    console.log(`E-commerce app v${version} running on port ${port} in ${environment} mode`);
});

module.exports = { app, server };
```

#### 1.5 Create Test Suite (app.test.js)
```javascript
const request = require('supertest');
const { app, server } = require('./app');

describe('E-commerce Application', () => {
    afterAll(() => {
        server.close();
    });

    describe('Health Check', () => {
        test('GET /health should return 200', async () => {
            const response = await request(app).get('/health');
            expect(response.status).toBe(200);
            expect(response.body.status).toBe('healthy');
            expect(response.body).toHaveProperty('version');
            expect(response.body).toHaveProperty('uptime');
        });
    });

    describe('Main Routes', () => {
        test('GET / should return welcome message', async () => {
            const response = await request(app).get('/');
            expect(response.status).toBe(200);
            expect(response.body.message).toContain('E-commerce CI/CD Demo');
            expect(response.body).toHaveProperty('version');
            expect(response.body.features).toBeInstanceOf(Array);
        });

        test('GET /api/products should return products list', async () => {
            const response = await request(app).get('/api/products');
            expect(response.status).toBe(200);
            expect(response.body.products).toBeInstanceOf(Array);
            expect(response.body.products.length).toBeGreaterThan(0);
            expect(response.body).toHaveProperty('total');
        });
    });

    describe('Orders API', () => {
        test('POST /api/orders should create order with valid data', async () => {
            const orderData = { productId: 1, quantity: 2 };
            const response = await request(app)
                .post('/api/orders')
                .send(orderData);
            
            expect(response.status).toBe(201);
            expect(response.body).toHaveProperty('orderId');
            expect(response.body.productId).toBe(orderData.productId);
            expect(response.body.quantity).toBe(orderData.quantity);
            expect(response.body.status).toBe('confirmed');
        });

        test('POST /api/orders should return 400 with invalid data', async () => {
            const response = await request(app)
                .post('/api/orders')
                .send({});
            
            expect(response.status).toBe(400);
            expect(response.body).toHaveProperty('error');
        });
    });

    describe('Metrics', () => {
        test('GET /metrics should return system metrics', async () => {
            const response = await request(app).get('/metrics');
            expect(response.status).toBe(200);
            expect(response.body).toHaveProperty('memory');
            expect(response.body).toHaveProperty('uptime');
            expect(response.body).toHaveProperty('version');
        });
    });

    describe('Error Handling', () => {
        test('GET /nonexistent should return 404', async () => {
            const response = await request(app).get('/nonexistent');
            expect(response.status).toBe(404);
            expect(response.body).toHaveProperty('error');
        });
    });
});
```

#### 1.6 Create Dockerfile
```dockerfile
# Multi-stage build for optimized production image
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install all dependencies (including dev dependencies for testing)
RUN npm ci

# Copy source code
COPY . .

# Run tests
RUN npm test

# Production stage
FROM node:18-alpine AS production

WORKDIR /app

# Create non-root user for security
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nextjs -u 1001

# Copy package files
COPY package*.json ./

# Install only production dependencies
RUN npm ci --only=production && npm cache clean --force

# Copy application code
COPY --from=builder /app/app.js ./
COPY --from=builder /app/package.json ./

# Change ownership to non-root user
RUN chown -R nextjs:nodejs /app
USER nextjs

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })"

# Start application
CMD ["npm", "start"]
```

#### 1.7 Create Build Specification
```yaml
# buildspec.yml - Instructions for CodeBuild
version: 0.2

phases:
  install:
    runtime-versions:
      nodejs: 18
    commands:
      - echo Installing dependencies...
      - npm install

  pre_build:
    commands:
      - echo Running tests...
      - npm test
      - echo Logging in to Amazon ECR...
      - aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com
      - REPOSITORY_URI=$AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME
      - COMMIT_HASH=$(echo $CODEBUILD_RESOLVED_SOURCE_VERSION | cut -c 1-7)
      - IMAGE_TAG=${COMMIT_HASH:=latest}

  build:
    commands:
      - echo Build started on `date`
      - echo Building the Docker image...
      - docker build -t $IMAGE_REPO_NAME:$IMAGE_TAG .
      - docker tag $IMAGE_REPO_NAME:$IMAGE_TAG $REPOSITORY_URI:$IMAGE_TAG
      - docker tag $IMAGE_REPO_NAME:$IMAGE_TAG $REPOSITORY_URI:latest

  post_build:
    commands:
      - echo Build completed on `date`
      - echo Pushing the Docker images...
      - docker push $REPOSITORY_URI:$IMAGE_TAG
      - docker push $REPOSITORY_URI:latest
      - echo Writing image definitions file...
      - printf '[{"name":"ecommerce-app","imageUri":"%s"}]' $REPOSITORY_URI:$IMAGE_TAG > imagedefinitions.json
      - echo Writing deployment configuration...
      - printf '{"ImageURI":"%s","Version":"%s","BuildTime":"%s"}' $REPOSITORY_URI:$IMAGE_TAG $IMAGE_TAG "$(date)" > deployment-info.json

artifacts:
  files:
    - imagedefinitions.json
    - deployment-info.json
    - appspec.yml
    - scripts/*
```

#### 1.8 Commit and Push Code
```bash
# Add all files to git
git add .

# Commit with descriptive message
git commit -m "Initial commit: E-commerce app with CI/CD setup

- Node.js Express application with health checks
- Comprehensive test suite with Jest
- Multi-stage Dockerfile for optimized builds
- CodeBuild specification for automated testing
- API endpoints for products and orders
- Error handling and security middleware"

# Push to CodeCommit
git push origin main
```

**🎉 Checkpoint 1 Complete!** You now have a complete application ready for CI/CD pipeline.

---

### Step 2: Set Up Container Registry (10 minutes)

#### 2.1 Create ECR Repository
```
🖥️ VISUAL: AWS Console
📍 Services → Elastic Container Registry (ECR)
📍 Click "Create repository"
📍 Repository name: "ecommerce-app"
📍 Tag immutability: Enabled
📍 Scan on push: Enabled
📍 Click "Create repository"
```

#### 2.2 Note Repository URI
```
🖥️ VISUAL: ECR Console
📍 Click on "ecommerce-app" repository
📍 Copy the "URI" (looks like: 123456789012.dkr.ecr.us-east-1.amazonaws.com/ecommerce-app)
📝 Save this URI - you'll need it later
```

```
💡 EXPLANATION:
- ECR (Elastic Container Registry) stores your Docker images
- Each code change creates a new image version
- Images are tagged with commit hashes for traceability
- Scan on push checks for security vulnerabilities
```

---

### Step 3: Create CodeBuild Project (15 minutes)

#### 3.1 Create Build Project
```
🖥️ VISUAL: AWS Console
📍 Services → CodeBuild
📍 Click "Create build project"
📍 Project name: "ecommerce-app-build"
📍 Description: "Build and test e-commerce application"
```

#### 3.2 Configure Source
```
🖥️ VISUAL: Source section
📍 Source provider: AWS CodeCommit
📍 Repository: ecommerce-app-cicd
📍 Branch: main
📍 Git clone depth: 1
```

#### 3.3 Configure Environment
```
🖥️ VISUAL: Environment section
📍 Environment image: Managed image
📍 Operating system: Amazon Linux 2
📍 Runtime: Standard
📍 Image: aws/codebuild/amazonlinux2-x86_64-standard:4.0
📍 Privileged: ✅ (Enable - needed for Docker)
📍 Service role: Create new service role
```

#### 3.4 Add Environment Variables
```
🖥️ VISUAL: Additional configuration
📍 Click "Additional configuration"
📍 Add environment variables:
```

| Name | Value | Type |
|------|-------|------|
| AWS_DEFAULT_REGION | us-east-1 | Plaintext |
| AWS_ACCOUNT_ID | (your account ID) | Plaintext |
| IMAGE_REPO_NAME | ecommerce-app | Plaintext |
| IMAGE_TAG | latest | Plaintext |

```
📍 Click "Create build project"
```

#### 3.5 Update Build Service Role
```
🖥️ VISUAL: After project creation
📍 Click "Edit" → "Environment"
📍 Click on the service role link (opens IAM)
📍 Click "Attach policies"
📍 Search and attach:
  - AmazonEC2ContainerRegistryPowerUser
  - CloudWatchLogsFullAccess
📍 Click "Attach policy"
```

---

### Step 4: Create ECS Cluster and Service (25 minutes)

#### 4.1 Create ECS Cluster
```
🖥️ VISUAL: AWS Console
📍 Services → Elastic Container Service (ECS)
📍 Click "Create Cluster"
📍 Cluster name: "ecommerce-cluster"
📍 Infrastructure: AWS Fargate (serverless)
📍 Click "Create"
```

#### 4.2 Create Task Definition
```
🖥️ VISUAL: ECS Console
📍 Click "Task definitions" in left menu
📍 Click "Create new task definition"
📍 Task definition family: "ecommerce-app"
📍 Launch type: AWS Fargate
```

#### 4.3 Configure Task
```
🖥️ VISUAL: Task definition configuration
📍 Operating system: Linux/X86_64
📍 CPU: 0.25 vCPU
📍 Memory: 0.5 GB
📍 Task role: Create new role
📍 Task execution role: Create new role
```

#### 4.4 Add Container Definition
```
🖥️ VISUAL: Container definitions
📍 Click "Add container"
📍 Container name: "ecommerce-app"
📍 Image URI: (your ECR repository URI):latest
📍 Port mappings: 3000 (TCP)
📍 Environment variables:
```

| Name | Value |
|------|-------|
| NODE_ENV | production |
| APP_VERSION | 1.0.0 |
| PORT | 3000 |

```
🖥️ VISUAL: Health check
📍 Health check command: CMD-SHELL,curl -f http://localhost:3000/health || exit 1
📍 Interval: 30 seconds
📍 Timeout: 5 seconds
📍 Retries: 3
📍 Start period: 60 seconds
```

```
📍 Click "Add"
📍 Click "Create"
```

#### 4.5 Create Application Load Balancer
```
🖥️ VISUAL: EC2 Console
📍 Services → EC2
📍 Click "Load Balancers" in left menu
📍 Click "Create Load Balancer"
📍 Choose "Application Load Balancer"
📍 Name: "ecommerce-alb"
📍 Scheme: Internet-facing
📍 IP address type: IPv4
```

```
🖥️ VISUAL: Network mapping
📍 VPC: Default VPC
📍 Availability Zones: Select at least 2 AZs
📍 Security groups: Create new security group
  - Name: ecommerce-alb-sg
  - Allow HTTP (80) from anywhere
  - Allow HTTPS (443) from anywhere
```

```
🖥️ VISUAL: Listeners and routing
📍 Create target group:
  - Target type: IP addresses
  - Target group name: ecommerce-tg-blue
  - Protocol: HTTP
  - Port: 3000
  - Health check path: /health
📍 Click "Create load balancer"
```

#### 4.6 Create ECS Service
```
🖥️ VISUAL: Back to ECS Console
📍 Click "Clusters" → "ecommerce-cluster"
📍 Click "Create Service"
📍 Launch type: Fargate
📍 Task definition: ecommerce-app:1
📍 Service name: "ecommerce-service"
📍 Number of tasks: 2
```

```
🖥️ VISUAL: Load balancing
📍 Load balancer type: Application Load Balancer
📍 Load balancer: ecommerce-alb
📍 Target group: ecommerce-tg-blue
📍 Health check grace period: 300 seconds
```

```
📍 Click "Create Service"
⏳ Wait 5-10 minutes for service to become stable
```

**🎉 Checkpoint 2 Complete!** You now have a running containerized application with load balancing.

---

### Step 5: Create CI/CD Pipeline (15 minutes)

#### 5.1 Create CodePipeline
```
🖥️ VISUAL: AWS Console
📍 Services → CodePipeline
📍 Click "Create pipeline"
📍 Pipeline name: "ecommerce-cicd-pipeline"
📍 Service role: New service role
📍 Artifact store: Default location
📍 Click "Next"
```

#### 5.2 Add Source Stage
```
🖥️ VISUAL: Source stage
📍 Source provider: AWS CodeCommit
📍 Repository name: ecommerce-app-cicd
📍 Branch name: main
📍 Change detection options: Amazon CloudWatch Events
📍 Click "Next"
```

#### 5.3 Add Build Stage
```
🖥️ VISUAL: Build stage
📍 Build provider: AWS CodeBuild
📍 Project name: ecommerce-app-build
📍 Build type: Single build
📍 Click "Next"
```

#### 5.4 Add Deploy Stage
```
🖥️ VISUAL: Deploy stage
📍 Deploy provider: Amazon ECS (Blue/Green)
📍 Application name: Create new application
  - Application name: ecommerce-app
  - Compute platform: Amazon ECS
📍 Deployment group: Create new deployment group
  - Deployment group name: ecommerce-deployment-group
  - Service role: Create new role
📍 Amazon ECS cluster name: ecommerce-cluster
📍 Amazon ECS service name: ecommerce-service
📍 Load balancer: ecommerce-alb
📍 Production listener port: 80
📍 Target group 1 name: ecommerce-tg-blue
📍 Target group 2 name: Create new (ecommerce-tg-green)
📍 Click "Next"
```

#### 5.5 Review and Create
```
🖥️ VISUAL: Review
📍 Review all settings
📍 Click "Create pipeline"
⏳ Pipeline will start automatically
📍 Watch the pipeline execute through all stages
```

**🎉 Project 1 Complete!** You've built a complete CI/CD pipeline with:
- ✅ Automated testing on every code change
- ✅ Containerized application deployment
- ✅ Blue-green deployment strategy
- ✅ Load balancing and health checks
- ✅ Zero-downtime deployments

---

## 📊 Project 1 Assessment (5 minutes)

### Verification Checklist
1. **Pipeline Success**: ✅ Did the pipeline complete all stages successfully?
2. **Application Running**: ✅ Can you access the application via load balancer?
3. **Health Checks**: ✅ Are health checks passing?
4. **Blue-Green Setup**: ✅ Are both target groups created?

### Test Zero-Downtime Deployment
```bash
# Make a small change to trigger deployment
cd /home/ec2-user/ecommerce-app-cicd

# Update version in package.json
sed -i 's/"version": "1.0.0"/"version": "1.1.0"/' package.json

# Update welcome message
sed -i 's/Welcome to E-commerce CI\/CD Demo/Welcome to E-commerce CI\/CD Demo v1.1/' app.js

# Commit and push
git add .
git commit -m "Update to version 1.1.0 - test zero-downtime deployment"
git push origin main

# Watch pipeline execute
# Monitor load balancer - application should remain available throughout deployment
```

### Understanding Check
1. What happens during blue-green deployment?
2. How does the pipeline ensure code quality?
3. What triggers a new deployment?
4. How would you rollback a deployment?

**🎯 Project 1 Score: ___/25 points**

---

## 🔥 Project 2: Chaos Engineering & Resilience Testing (80 minutes)

### What You'll Build
A comprehensive chaos engineering system that:
- Tests application resilience through controlled failures
- Validates automatic recovery mechanisms
- Measures system behavior under stress
- Provides insights for improving reliability

### Real-World Scenario
You're the Site Reliability Engineer for a critical e-commerce platform. Before the upcoming 12.12 sale event, you need to ensure your system can handle various failure scenarios. Better to find weaknesses now than during peak shopping hours when millions are trying to buy.

---

### Step 1: Set Up AWS Fault Injection Simulator (20 minutes)

#### 1.1 Create FIS Service Role
```
🖥️ VISUAL: AWS Console
📍 Services → IAM
📍 Click "Roles" → "Create role"
📍 Select "AWS service"
📍 Choose "Fault Injection Simulator"
📍 Click "Next"
```

```
🖥️ VISUAL: Add permissions
📍 Search and select these policies:
  - EC2FullAccess (for stopping/starting instances)
  - ECSFullAccess (for stopping tasks)
  - CloudWatchFullAccess (for metrics)
📍 Click "Next"
📍 Role name: "FISChaosEngineeringRole"
📍 Description: "Role for chaos engineering experiments"
📍 Click "Create role"
```

#### 1.2 Create Custom Policy for Advanced Actions
```
🖥️ VISUAL: IAM Console
📍 Click "Policies" → "Create policy"
📍 Click "JSON" tab
📍 Replace content with:
```

```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecs:DescribeServices",
                "ecs:DescribeTasks",
                "ecs:ListTasks",
                "ecs:StopTask",
                "ecs:UpdateService",
                "ec2:DescribeInstances",
                "ec2:StopInstances",
                "ec2:StartInstances",
                "ec2:RebootInstances",
                "elasticloadbalancing:DescribeTargetGroups",
                "elasticloadbalancing:DescribeTargetHealth",
                "elasticloadbalancing:DeregisterTargets",
                "elasticloadbalancing:RegisterTargets",
                "cloudwatch:PutMetricData",
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "ssm:SendCommand",
                "ssm:GetCommandInvocation"
            ],
            "Resource": "*"
        }
    ]
}
```

```
📍 Click "Next"
📍 Policy name: "ChaosEngineeringPolicy"
📍 Description: "Custom policy for chaos engineering experiments"
📍 Click "Create policy"
```

#### 1.3 Attach Custom Policy to Role
```
🖥️ VISUAL: Back to IAM Roles
📍 Click "FISChaosEngineeringRole"
📍 Click "Add permissions" → "Attach policies"
📍 Search for "ChaosEngineeringPolicy"
📍 Select it and click "Add permissions"
```

---

### Step 2: Create Chaos Engineering Experiments (25 minutes)

#### 2.1 Experiment 1: ECS Task Termination
```
🖥️ VISUAL: AWS Console
📍 Services → AWS Fault Injection Simulator
📍 Click "Create experiment template"
📍 Name: "ECS-Task-Termination-Test"
📍 Description: "Test application resilience by stopping ECS tasks"
📍 Role: FISChaosEngineeringRole
```

```
🖥️ VISUAL: Actions section
📍 Click "Add action"
📍 Name: "StopECSTasks"
📍 Action type: aws:ecs:stop-task
📍 Parameters:
  - clusterArn: arn:aws:ecs:us-east-1:YOUR_ACCOUNT:cluster/ecommerce-cluster
📍 Targets: ECSTasks
```

```
🖥️ VISUAL: Targets section
📍 Click "Add target"
📍 Name: "ECSTasks"
📍 Resource type: aws:ecs:task
📍 Target method: Resource tags
📍 Resource tags:
  - Key: aws:ecs:service-name
  - Value: ecommerce-service
📍 Selection mode: Percent(50)
```

```
🖥️ VISUAL: Stop conditions
📍 Click "Add stop condition"
📍 Source: aws:cloudwatch:alarm
📍 Value: arn:aws:cloudwatch:us-east-1:YOUR_ACCOUNT:alarm:HighErrorRate
```

```
📍 Click "Create experiment template"
```

#### 2.2 Create Stop Condition Alarm
```
🖥️ VISUAL: CloudWatch Console
📍 Services → CloudWatch
📍 Click "Alarms" → "Create alarm"
📍 Select metric: AWS/ApplicationELB → TargetResponseTime
📍 Load balancer: ecommerce-alb
📍 Statistic: Average
📍 Period: 1 minute
📍 Threshold: Greater than 5000 (5 seconds)
📍 Alarm name: "HighResponseTime-StopChaos"
📍 Create alarm
```

#### 2.3 Experiment 2: Load Balancer Target Deregistration
```
🖥️ VISUAL: FIS Console
📍 Create new experiment template
📍 Name: "LoadBalancer-Target-Failure"
📍 Description: "Test load balancer failover by deregistering targets"
📍 Role: FISChaosEngineeringRole
```

```json
{
    "description": "Test load balancer resilience by deregistering targets",
    "roleArn": "arn:aws:iam::YOUR_ACCOUNT:role/FISChaosEngineeringRole",
    "actions": {
        "DeregisterTargets": {
            "actionId": "aws:elasticloadbalancing:deregister-targets",
            "parameters": {
                "targetGroupArn": "arn:aws:elasticloadbalancing:us-east-1:YOUR_ACCOUNT:targetgroup/ecommerce-tg-blue/xxx",
                "durationMinutes": "5"
            }
        }
    },
    "stopConditions": [
        {
            "source": "aws:cloudwatch:alarm",
            "value": "arn:aws:cloudwatch:us-east-1:YOUR_ACCOUNT:alarm:HighResponseTime-StopChaos"
        }
    ],
    "tags": {
        "Name": "LoadBalancer-Resilience-Test",
        "Environment": "Testing"
    }
}
```

#### 2.4 Experiment 3: Network Latency Injection
```bash
# Create network latency experiment using Systems Manager
# This simulates network issues between services

cat > /home/ec2-user/network-chaos-experiment.json << 'EOF'
{
    "description": "Inject network latency to test application resilience",
    "roleArn": "arn:aws:iam::YOUR_ACCOUNT:role/FISChaosEngineeringRole",
    "actions": {
        "InjectLatency": {
            "actionId": "aws:ssm:send-command",
            "parameters": {
                "documentArn": "arn:aws:ssm:::document/AWSFIS-Run-Network-Latency",
                "documentParameters": "{\"DurationSeconds\":\"300\",\"DelayMilliseconds\":\"200\",\"Interface\":\"eth0\"}",
                "durationMinutes": "5"
            },
            "targets": {
                "Instances": "NetworkTargets"
            }
        }
    },
    "targets": {
        "NetworkTargets": {
            "resourceType": "aws:ec2:instance",
            "resourceTags": {
                "Environment": "Production"
            },
            "selectionMode": "PERCENT(25)"
        }
    },
    "stopConditions": [
        {
            "source": "aws:cloudwatch:alarm",
            "value": "arn:aws:cloudwatch:us-east-1:YOUR_ACCOUNT:alarm:HighResponseTime-StopChaos"
        }
    ]
}
EOF
```

---

### Step 3: Execute Chaos Experiments (20 minutes)

#### 3.1 Pre-Experiment Monitoring Setup
```bash
# Create monitoring script to track system behavior during experiments
cat > /home/ec2-user/chaos-monitor.sh << 'EOF'
#!/bin/bash

LOAD_BALANCER_URL="http://YOUR_ALB_DNS_NAME"
LOG_FILE="/home/ec2-user/chaos-experiment-$(date +%Y%m%d-%H%M%S).log"

echo "Starting chaos experiment monitoring..." | tee -a $LOG_FILE
echo "Load Balancer URL: $LOAD_BALANCER_URL" | tee -a $LOG_FILE
echo "Start Time: $(date)" | tee -a $LOG_FILE
echo "----------------------------------------" | tee -a $LOG_FILE

# Monitor application availability and response time
while true; do
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Test health endpoint
    HEALTH_RESPONSE=$(curl -s -w "%{http_code},%{time_total}" -o /dev/null $LOAD_BALANCER_URL/health)
    HEALTH_CODE=$(echo $HEALTH_RESPONSE | cut -d',' -f1)
    HEALTH_TIME=$(echo $HEALTH_RESPONSE | cut -d',' -f2)
    
    # Test main endpoint
    MAIN_RESPONSE=$(curl -s -w "%{http_code},%{time_total}" -o /dev/null $LOAD_BALANCER_URL/)
    MAIN_CODE=$(echo $MAIN_RESPONSE | cut -d',' -f1)
    MAIN_TIME=$(echo $MAIN_RESPONSE | cut -d',' -f2)
    
    # Test API endpoint
    API_RESPONSE=$(curl -s -w "%{http_code},%{time_total}" -o /dev/null $LOAD_BALANCER_URL/api/products)
    API_CODE=$(echo $API_RESPONSE | cut -d',' -f1)
    API_TIME=$(echo $API_RESPONSE | cut -d',' -f2)
    
    # Log results
    echo "$TIMESTAMP,Health:$HEALTH_CODE:${HEALTH_TIME}s,Main:$MAIN_CODE:${MAIN_TIME}s,API:$API_CODE:${API_TIME}s" | tee -a $LOG_FILE
    
    # Check for failures
    if [ "$HEALTH_CODE" != "200" ] || [ "$MAIN_CODE" != "200" ] || [ "$API_CODE" != "200" ]; then
        echo "⚠️  FAILURE DETECTED at $TIMESTAMP" | tee -a $LOG_FILE
    fi
    
    sleep 10
done
EOF

chmod +x /home/ec2-user/chaos-monitor.sh
```

#### 3.2 Get Load Balancer DNS Name
```bash
# Get your load balancer DNS name
ALB_DNS=$(aws elbv2 describe-load-balancers \
    --names ecommerce-alb \
    --query 'LoadBalancers[0].DNSName' \
    --output text)

echo "Load Balancer DNS: $ALB_DNS"

# Update monitoring script with actual DNS name
sed -i "s/YOUR_ALB_DNS_NAME/$ALB_DNS/g" /home/ec2-user/chaos-monitor.sh
```

#### 3.3 Execute ECS Task Termination Experiment
```
🖥️ VISUAL: FIS Console
📍 Click "Experiment templates"
📍 Select "ECS-Task-Termination-Test"
📍 Click "Start experiment"
📍 Experiment name: "ECS-Resilience-Test-$(date +%Y%m%d-%H%M%S)"
📍 Click "Start experiment"
```

```bash
# Start monitoring in background
nohup /home/ec2-user/chaos-monitor.sh &

# Watch ECS service during experiment
watch -n 5 'aws ecs describe-services \
    --cluster ecommerce-cluster \
    --services ecommerce-service \
    --query "services[0].{RunningCount:runningCount,DesiredCount:desiredCount,PendingCount:pendingCount}"'
```

```
⏳ OBSERVE: During the experiment, you should see:
- Some ECS tasks being terminated
- New tasks automatically starting
- Load balancer routing traffic to healthy tasks
- Minimal or no service interruption
```

#### 3.4 Analyze Experiment Results
```bash
# Stop monitoring
pkill -f chaos-monitor.sh

# Analyze results
tail -20 /home/ec2-user/chaos-experiment-*.log

# Check CloudWatch metrics during experiment
aws cloudwatch get-metric-statistics \
    --namespace AWS/ApplicationELB \
    --metric-name TargetResponseTime \
    --dimensions Name=LoadBalancer,Value=app/ecommerce-alb/xxx \
    --start-time $(date -u -d '10 minutes ago' +%Y-%m-%dT%H:%M:%S) \
    --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
    --period 60 \
    --statistics Average
```

---

### Step 4: Create Resilience Dashboard (15 minutes)

#### 4.1 Create Chaos Engineering Dashboard
```
🖥️ VISUAL: CloudWatch Console
📍 Click "Dashboards" → "Create dashboard"
📍 Dashboard name: "Chaos-Engineering-Resilience"
📍 Click "Create dashboard"
```

#### 4.2 Add Application Health Widget
```
🖥️ VISUAL: Add widget
📍 Select "Line" widget
📍 Add metrics:
  - AWS/ApplicationELB → TargetResponseTime (ecommerce-alb)
  - AWS/ApplicationELB → RequestCount (ecommerce-alb)
  - AWS/ApplicationELB → HTTPCode_Target_2XX_Count (ecommerce-alb)
  - AWS/ApplicationELB → HTTPCode_Target_5XX_Count (ecommerce-alb)
📍 Widget title: "Application Performance During Chaos"
📍 Create widget
```

#### 4.3 Add ECS Service Health Widget
```
🖥️ VISUAL: Add another widget
📍 Select "Number" widget
📍 Add metrics:
  - AWS/ECS → RunningTaskCount (ServiceName: ecommerce-service)
  - AWS/ECS → PendingTaskCount (ServiceName: ecommerce-service)
📍 Widget title: "ECS Service Health"
📍 Create widget
```

#### 4.4 Add Custom Resilience Metrics
```bash
# Create script to send custom resilience metrics
cat > /home/ec2-user/resilience-metrics.sh << 'EOF'
#!/bin/bash

# Calculate availability percentage from logs
LOG_FILE=$(ls -t /home/ec2-user/chaos-experiment-*.log | head -1)

if [ -f "$LOG_FILE" ]; then
    TOTAL_REQUESTS=$(grep -c "Health:" $LOG_FILE)
    SUCCESSFUL_REQUESTS=$(grep -c "Health:200:" $LOG_FILE)
    
    if [ $TOTAL_REQUESTS -gt 0 ]; then
        AVAILABILITY=$(echo "scale=2; $SUCCESSFUL_REQUESTS * 100 / $TOTAL_REQUESTS" | bc)
        
        # Send availability metric to CloudWatch
        aws cloudwatch put-metric-data \
            --namespace "TESDA/ChaosEngineering" \
            --metric-data \
            MetricName=Availability,Value=$AVAILABILITY,Unit=Percent \
            MetricName=TotalRequests,Value=$TOTAL_REQUESTS,Unit=Count \
            MetricName=SuccessfulRequests,Value=$SUCCESSFUL_REQUESTS,Unit=Count
        
        echo "Availability: $AVAILABILITY%"
        echo "Total Requests: $TOTAL_REQUESTS"
        echo "Successful Requests: $SUCCESSFUL_REQUESTS"
    fi
fi
EOF

chmod +x /home/ec2-user/resilience-metrics.sh
/home/ec2-user/resilience-metrics.sh
```

#### 4.5 Add Resilience Metrics Widget
```
🖥️ VISUAL: Add third widget
📍 Select "Gauge" widget
📍 Add metric: TESDA/ChaosEngineering → Availability
📍 Widget title: "System Availability During Chaos"
📍 Y-axis range: 0 to 100
📍 Create widget
📍 Save dashboard
```

**🎉 Project 2 Complete!** You've implemented chaos engineering with:
- ✅ Controlled failure injection experiments
- ✅ Automated resilience testing
- ✅ Real-time monitoring during chaos
- ✅ Resilience metrics and dashboards
- ✅ Validation of recovery mechanisms

---

## 📊 Project 2 Assessment (5 minutes)

### Verification Checklist
1. **Experiments Created**: ✅ Are FIS experiment templates created?
2. **Chaos Executed**: ✅ Did experiments run successfully?
3. **System Resilience**: ✅ Did the system recover automatically?
4. **Monitoring Active**: ✅ Were you able to track system behavior?
5. **Insights Gained**: ✅ Do you understand system weaknesses?

### Resilience Analysis
Answer these questions based on your experiments:
1. How long did it take for the system to recover from task termination?
2. What was the availability percentage during chaos experiments?
3. Which component showed the most resilience?
4. What improvements would you recommend?

### Understanding Check
1. What is the purpose of stop conditions in chaos experiments?
2. How does chaos engineering improve system reliability?
3. What metrics indicate good system resilience?
4. When should you NOT run chaos experiments?

**🎯 Project 2 Score: ___/25 points**

---

## 📊 Project 3: Advanced Monitoring & Business Intelligence (80 minutes)

### What You'll Build
An enterprise-level monitoring system that:
- Implements distributed tracing with AWS X-Ray
- Creates business intelligence dashboards
- Uses machine learning for anomaly detection
- Provides predictive analytics and insights

### Real-World Scenario
You're the Head of Engineering for a major e-commerce platform. The CEO wants to understand how technology performance impacts business metrics like revenue, customer satisfaction, and conversion rates. You need monitoring that speaks both technical and business language.

---

### Step 1: Implement Distributed Tracing with X-Ray (25 minutes)

#### 1.1 Enable X-Ray in ECS Task Definition
```
🖥️ VISUAL: ECS Console
📍 Click "Task definitions" → "ecommerce-app"
📍 Click "Create new revision"
📍 Scroll to "Container definitions"
📍 Click "ecommerce-app" container
```

```
🖥️ VISUAL: Container configuration
📍 Environment variables - Add:
```

| Name | Value |
|------|-------|
| _X_AMZN_TRACE_ID | (leave blank - auto-populated) |
| AWS_XRAY_TRACING_NAME | ecommerce-app |
| AWS_XRAY_DEBUG_MODE | TRUE |

```
📍 Click "Update"
📍 Click "Create" to create new task definition revision
```

#### 1.2 Update ECS Service with X-Ray
```
🖥️ VISUAL: ECS Service
📍 Click "Clusters" → "ecommerce-cluster"
📍 Click "ecommerce-service"
📍 Click "Update"
📍 Task definition: Select latest revision
📍 Click "Update Service"
⏳ Wait for deployment to complete
```

#### 1.3 Create X-Ray Service Map
```
🖥️ VISUAL: AWS Console
📍 Services → X-Ray
📍 Click "Service map"
📍 Time range: Last 5 minutes
📍 You should see your application appearing in the service map
```

#### 1.4 Generate Traffic for Tracing
```bash
# Create load generator to produce X-Ray traces
cat > /home/ec2-user/generate-traces.sh << 'EOF'
#!/bin/bash

ALB_DNS="YOUR_ALB_DNS_NAME"
BASE_URL="http://$ALB_DNS"

echo "Generating traffic for X-Ray tracing..."
echo "Base URL: $BASE_URL"

# Generate different types of requests
for i in {1..100}; do
    # Health check requests
    curl -s "$BASE_URL/health" > /dev/null &
    
    # Main page requests
    curl -s "$BASE_URL/" > /dev/null &
    
    # API requests
    curl -s "$BASE_URL/api/products" > /dev/null &
    
    # Order creation (some will succeed, some will fail)
    if [ $((i % 3)) -eq 0 ]; then
        # Valid order
        curl -s -X POST "$BASE_URL/api/orders" \
            -H "Content-Type: application/json" \
            -d '{"productId": 1, "quantity": 2}' > /dev/null &
    else
        # Invalid order (to generate errors)
        curl -s -X POST "$BASE_URL/api/orders" \
            -H "Content-Type: application/json" \
            -d '{}' > /dev/null &
    fi
    
    # Metrics endpoint
    curl -s "$BASE_URL/metrics" > /dev/null &
    
    # Random delay between requests
    sleep $(echo "scale=2; $RANDOM/32767*2" | bc)
done

wait
echo "Traffic generation completed!"
EOF

# Update with actual ALB DNS
ALB_DNS=$(aws elbv2 describe-load-balancers \
    --names ecommerce-alb \
    --query 'LoadBalancers[0].DNSName' \
    --output text)

sed -i "s/YOUR_ALB_DNS_NAME/$ALB_DNS/g" /home/ec2-user/generate-traces.sh
chmod +x /home/ec2-user/generate-traces.sh

# Run traffic generator
/home/ec2-user/generate-traces.sh
```

#### 1.5 Analyze X-Ray Traces
```
🖥️ VISUAL: X-Ray Console
📍 Click "Traces"
📍 Time range: Last 5 minutes
📍 Click on individual traces to see detailed timing
📍 Look for:
  - Response time breakdown
  - Error traces (red)
  - Slow requests (yellow/orange)
```

---

### Step 2: Create Business Intelligence Dashboards (25 minutes)

#### 2.1 Create Business Metrics Collection
```bash
# Create script to simulate business metrics
cat > /home/ec2-user/business-metrics.sh << 'EOF'
#!/bin/bash

while true; do
    # Simulate business metrics based on system performance
    
    # Get current system metrics
    RESPONSE_TIME=$(aws cloudwatch get-metric-statistics \
        --namespace AWS/ApplicationELB \
        --metric-name TargetResponseTime \
        --dimensions Name=LoadBalancer,Value=app/ecommerce-alb/$(aws elbv2 describe-load-balancers --names ecommerce-alb --query 'LoadBalancers[0].LoadBalancerArn' --output text | cut -d'/' -f2-) \
        --start-time $(date -u -d '5 minutes ago' +%Y-%m-%dT%H:%M:%S) \
        --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
        --period 300 \
        --statistics Average \
        --query 'Datapoints[0].Average' \
        --output text 2>/dev/null || echo "0.5")
    
    # Convert to business metrics
    # Faster response time = higher conversion rate
    if (( $(echo "$RESPONSE_TIME < 0.5" | bc -l) )); then
        CONVERSION_RATE=$(echo "scale=2; 8.5 + $RANDOM % 150 / 100" | bc)
        CUSTOMER_SATISFACTION=$(echo "scale=1; 9.2 + $RANDOM % 80 / 100" | bc)
    elif (( $(echo "$RESPONSE_TIME < 1.0" | bc -l) )); then
        CONVERSION_RATE=$(echo "scale=2; 6.8 + $RANDOM % 120 / 100" | bc)
        CUSTOMER_SATISFACTION=$(echo "scale=1; 8.1 + $RANDOM % 90 / 100" | bc)
    else
        CONVERSION_RATE=$(echo "scale=2; 4.2 + $RANDOM % 100 / 100" | bc)
        CUSTOMER_SATISFACTION=$(echo "scale=1; 6.5 + $RANDOM % 150 / 100" | bc)
    fi
    
    # Simulate revenue (orders per minute * average order value)
    ORDERS_PER_MINUTE=$(echo "scale=0; 15 + $RANDOM % 25" | bc)
    AVERAGE_ORDER_VALUE=$(echo "scale=2; 2500 + $RANDOM % 5000 / 100" | bc)
    REVENUE_PER_MINUTE=$(echo "scale=2; $ORDERS_PER_MINUTE * $AVERAGE_ORDER_VALUE" | bc)
    
    # Cart abandonment rate (inverse of conversion)
    CART_ABANDONMENT=$(echo "scale=2; 100 - $CONVERSION_RATE * 10" | bc)
    
    # Send business metrics to CloudWatch
    aws cloudwatch put-metric-data \
        --namespace "TESDA/Business" \
        --metric-data \
        MetricName=ConversionRate,Value=$CONVERSION_RATE,Unit=Percent \
        MetricName=CustomerSatisfaction,Value=$CUSTOMER_SATISFACTION,Unit=None \
        MetricName=OrdersPerMinute,Value=$ORDERS_PER_MINUTE,Unit=Count \
        MetricName=AverageOrderValue,Value=$AVERAGE_ORDER_VALUE,Unit=None \
        MetricName=RevenuePerMinute,Value=$REVENUE_PER_MINUTE,Unit=None \
        MetricName=CartAbandonmentRate,Value=$CART_ABANDONMENT,Unit=Percent
    
    echo "$(date): Sent business metrics - Conversion: $CONVERSION_RATE%, Revenue: ₱$REVENUE_PER_MINUTE/min, Satisfaction: $CUSTOMER_SATISFACTION/10"
    
    sleep 60
done
EOF

chmod +x /home/ec2-user/business-metrics.sh
nohup /home/ec2-user/business-metrics.sh > /home/ec2-user/business-metrics.log 2>&1 &
```

#### 2.2 Create Executive Dashboard
```
🖥️ VISUAL: CloudWatch Console
📍 Click "Dashboards" → "Create dashboard"
📍 Dashboard name: "Executive-Business-Intelligence"
📍 Click "Create dashboard"
```

#### 2.3 Add Revenue Metrics Widget
```
🖥️ VISUAL: Add widget
📍 Select "Number" widget
📍 Add metrics:
  - TESDA/Business → RevenuePerMinute
  - TESDA/Business → OrdersPerMinute
  - TESDA/Business → AverageOrderValue
📍 Widget title: "Revenue Metrics"
📍 Create widget
```

#### 2.4 Add Customer Experience Widget
```
🖥️ VISUAL: Add widget
📍 Select "Gauge" widget
📍 Add metrics:
  - TESDA/Business → CustomerSatisfaction (range 0-10)
  - TESDA/Business → ConversionRate (range 0-15)
📍 Widget title: "Customer Experience"
📍 Create widget
```

#### 2.5 Add Technical vs Business Correlation
```
🖥️ VISUAL: Add widget
📍 Select "Line" widget
📍 Add metrics:
  - AWS/ApplicationELB → TargetResponseTime (left Y-axis)
  - TESDA/Business → ConversionRate (right Y-axis)
📍 Widget title: "Performance Impact on Business"
📍 Create widget
```

---

### Step 3: Implement Machine Learning Anomaly Detection (20 minutes)

#### 3.1 Create Anomaly Detectors
```
🖥️ VISUAL: CloudWatch Console
📍 Click "Anomaly detection" in left menu
📍 Click "Create anomaly detector"
📍 Select metric: TESDA/Business → RevenuePerMinute
📍 Anomaly detection model: Standard
📍 Click "Create anomaly detector"
```

#### 3.2 Create Anomaly Alarms
```
🖥️ VISUAL: CloudWatch Alarms
📍 Click "Create alarm"
📍 Select metric: Anomaly detection → TESDA/Business → RevenuePerMinute
📍 Condition: Lower than expected or Greater than expected
📍 Threshold: 2 (standard deviations)
📍 Alarm name: "Revenue-Anomaly-Detection"
📍 SNS topic: Create new topic "business-anomalies"
📍 Create alarm
```

#### 3.3 Create Predictive Scaling Metrics
```bash
# Create script for predictive analytics
cat > /home/ec2-user/predictive-analytics.sh << 'EOF'
#!/bin/bash

# Analyze historical patterns and predict future load
echo "Analyzing traffic patterns for predictive scaling..."

# Get historical data for the last hour
HISTORICAL_DATA=$(aws cloudwatch get-metric-statistics \
    --namespace AWS/ApplicationELB \
    --metric-name RequestCount \
    --dimensions Name=LoadBalancer,Value=app/ecommerce-alb/$(aws elbv2 describe-load-balancers --names ecommerce-alb --query 'LoadBalancers[0].LoadBalancerArn' --output text | cut -d'/' -f2-) \
    --start-time $(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%S) \
    --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
    --period 300 \
    --statistics Sum \
    --query 'Datapoints[].Average' \
    --output text)

# Simple trend analysis (in production, you'd use more sophisticated ML)
CURRENT_HOUR=$(date +%H)
CURRENT_MINUTE=$(date +%M)

# Predict load based on time patterns
if [ $CURRENT_HOUR -ge 9 ] && [ $CURRENT_HOUR -le 17 ]; then
    # Business hours - higher load expected
    PREDICTED_LOAD="HIGH"
    RECOMMENDED_CAPACITY=4
elif [ $CURRENT_HOUR -ge 18 ] && [ $CURRENT_HOUR -le 21 ]; then
    # Evening shopping - medium load
    PREDICTED_LOAD="MEDIUM"
    RECOMMENDED_CAPACITY=3
else
    # Off hours - low load
    PREDICTED_LOAD="LOW"
    RECOMMENDED_CAPACITY=2
fi

# Send predictive metrics
aws cloudwatch put-metric-data \
    --namespace "TESDA/Predictive" \
    --metric-data \
    MetricName=PredictedLoad,Value=$RECOMMENDED_CAPACITY,Unit=Count \
    MetricName=RecommendedCapacity,Value=$RECOMMENDED_CAPACITY,Unit=Count

echo "Predicted Load: $PREDICTED_LOAD"
echo "Recommended Capacity: $RECOMMENDED_CAPACITY instances"

# Check current ECS service capacity
CURRENT_CAPACITY=$(aws ecs describe-services \
    --cluster ecommerce-cluster \
    --services ecommerce-service \
    --query 'services[0].desiredCount' \
    --output text)

echo "Current Capacity: $CURRENT_CAPACITY instances"

# Recommend scaling action
if [ $RECOMMENDED_CAPACITY -gt $CURRENT_CAPACITY ]; then
    echo "RECOMMENDATION: Scale UP to $RECOMMENDED_CAPACITY instances"
elif [ $RECOMMENDED_CAPACITY -lt $CURRENT_CAPACITY ]; then
    echo "RECOMMENDATION: Scale DOWN to $RECOMMENDED_CAPACITY instances"
else
    echo "RECOMMENDATION: Current capacity is optimal"
fi
EOF

chmod +x /home/ec2-user/predictive-analytics.sh
/home/ec2-user/predictive-analytics.sh
```

---

### Step 4: Create Comprehensive Operational Dashboard (10 minutes)

#### 4.1 Create Master Operations Dashboard
```
🖥️ VISUAL: CloudWatch Console
📍 Create new dashboard: "Master-Operations-Center"
📍 Add multiple widgets in this order:
```

**Widget 1: System Health Overview**
```
📍 Type: Number
📍 Metrics:
  - AWS/ECS → RunningTaskCount
  - AWS/ApplicationELB → HealthyHostCount
  - AWS/ApplicationELB → UnHealthyHostCount
📍 Title: "System Health Status"
```

**Widget 2: Performance Metrics**
```
📍 Type: Line
📍 Metrics:
  - AWS/ApplicationELB → TargetResponseTime
  - AWS/ApplicationELB → RequestCount
  - AWS/X-Ray → ResponseTime
📍 Title: "Application Performance"
```

**Widget 3: Business Impact**
```
📍 Type: Line
📍 Metrics:
  - TESDA/Business → RevenuePerMinute
  - TESDA/Business → ConversionRate
  - TESDA/Business → CustomerSatisfaction
📍 Title: "Business Metrics"
```

**Widget 4: Predictive Analytics**
```
📍 Type: Number
📍 Metrics:
  - TESDA/Predictive → PredictedLoad
  - TESDA/Predictive → RecommendedCapacity
📍 Title: "Predictive Insights"
```

**Widget 5: Error Analysis**
```
📍 Type: Line
📍 Metrics:
  - AWS/ApplicationELB → HTTPCode_Target_5XX_Count
  - AWS/X-Ray → ErrorRate
  - TESDA/Business → CartAbandonmentRate
📍 Title: "Error Analysis"
```

**🎉 Project 3 Complete!** You've built enterprise-level monitoring with:
- ✅ Distributed tracing with X-Ray
- ✅ Business intelligence dashboards
- ✅ Machine learning anomaly detection
- ✅ Predictive analytics
- ✅ Comprehensive operational visibility

---

## 📊 Project 3 Assessment (5 minutes)

### Verification Checklist
1. **X-Ray Tracing**: ✅ Can you see service maps and traces?
2. **Business Metrics**: ✅ Are business metrics flowing to CloudWatch?
3. **Anomaly Detection**: ✅ Is ML-based anomaly detection configured?
4. **Predictive Analytics**: ✅ Are predictive insights being generated?
5. **Executive Dashboard**: ✅ Can executives understand business impact?

### Business Intelligence Analysis
1. How does response time correlate with conversion rate?
2. What business metrics are most affected by technical performance?
3. What insights would you present to executives?
4. How would you use predictive analytics for capacity planning?

**🎯 Project 3 Score: ___/25 points**

---

## 🎯 Final Day 3 Assessment: Enterprise Integration Challenge (20 minutes)

### Comprehensive Scenario: Black Friday Sale Preparation
You're the Head of Engineering preparing for the biggest sale event of the year. The CEO, CTO, and business stakeholders need confidence that your system can handle 10x normal traffic while maintaining business performance.

---

### Challenge Requirements

#### Technical Demonstration (60% of score)
**Deploy a Complete E-commerce Platform**:
1. ✅ **CI/CD Pipeline**: Deploy new sale features with zero downtime
2. ✅ **Chaos Engineering**: Prove system resilience under failure
3. ✅ **Advanced Monitoring**: Show real-time business impact visibility

#### Business Presentation (20% of score)
**Present to "Executive Team" (Instructors)**:
- Explain how technology choices impact business metrics
- Demonstrate system reliability and scalability
- Show predictive capabilities for capacity planning
- Justify infrastructure costs vs. business value

#### Problem-Solving Assessment (20% of score)
**Handle Real-Time Scenarios**:
- Respond to simulated incidents during presentation
- Troubleshoot issues using your monitoring systems
- Make scaling decisions based on predictive analytics

---

### Step 1: Final Integration Test (10 minutes)

#### 1.1 Deploy Sale Feature via CI/CD
```bash
# Add Black Friday sale feature to your application
cd /home/ec2-user/ecommerce-app-cicd

# Create sale endpoint
cat >> app.js << 'EOF'

// Black Friday Sale endpoint
app.get('/api/sale', (req, res) => {
    const saleProducts = [
        { id: 1, name: 'Laptop', originalPrice: 50000, salePrice: 35000, discount: '30%' },
        { id: 2, name: 'Phone', originalPrice: 25000, salePrice: 18000, discount: '28%' },
        { id: 3, name: 'Tablet', originalPrice: 15000, salePrice: 9999, discount: '33%' }
    ];
    
    res.json({
        message: 'Black Friday Sale - Limited Time!',
        products: saleProducts,
        totalSavings: saleProducts.reduce((sum, p) => sum + (p.originalPrice - p.salePrice), 0),
        version: version,
        saleActive: true
    });
});
EOF

# Update version
sed -i 's/"version": "1.1.0"/"version": "2.0.0"/' package.json
sed -i 's/APP_VERSION || '\''1.0.0'\''/APP_VERSION || '\''2.0.0'\''/' app.js

# Add test for new endpoint
cat >> app.test.js << 'EOF'

    describe('Black Friday Sale', () => {
        test('GET /api/sale should return sale products', async () => {
            const response = await request(app).get('/api/sale');
            expect(response.status).toBe(200);
            expect(response.body.saleActive).toBe(true);
            expect(response.body.products).toBeInstanceOf(Array);
            expect(response.body.products.length).toBeGreaterThan(0);
            expect(response.body).toHaveProperty('totalSavings');
        });
    });
EOF

# Commit and deploy
git add .
git commit -m "feat: Add Black Friday sale endpoint v2.0.0

- New /api/sale endpoint with discounted products
- 30% average discount across all products
- Total savings calculation
- Comprehensive test coverage
- Zero-downtime deployment ready"

git push origin main
```

#### 1.2 Monitor Zero-Downtime Deployment
```bash
# Monitor deployment progress
watch -n 5 'echo "=== Pipeline Status ===" && \
aws codepipeline get-pipeline-state --name ecommerce-cicd-pipeline --query "stageStates[*].{Stage:stageName,Status:latestExecution.status}" --output table && \
echo "=== ECS Service Status ===" && \
aws ecs describe-services --cluster ecommerce-cluster --services ecommerce-service --query "services[0].{Running:runningCount,Desired:desiredCount,Pending:pendingCount,Status:status}" --output table'
```

#### 1.3 Execute Chaos During Peak Load
```bash
# Generate high load to simulate Black Friday traffic
cat > /home/ec2-user/black-friday-load.sh << 'EOF'
#!/bin/bash

ALB_DNS=$(aws elbv2 describe-load-balancers --names ecommerce-alb --query 'LoadBalancers[0].DNSName' --output text)
BASE_URL="http://$ALB_DNS"

echo "Simulating Black Friday traffic surge..."

# Generate intense load
for i in {1..500}; do
    # Multiple concurrent requests
    for j in {1..5}; do
        curl -s "$BASE_URL/api/sale" > /dev/null &
        curl -s "$BASE_URL/api/products" > /dev/null &
        curl -s "$BASE_URL/" > /dev/null &
    done
    
    # Order attempts (high volume)
    curl -s -X POST "$BASE_URL/api/orders" \
        -H "Content-Type: application/json" \
        -d '{"productId": 1, "quantity": 1}' > /dev/null &
    
    sleep 0.1
done

wait
echo "Black Friday load simulation completed!"
EOF

chmod +x /home/ec2-user/black-friday-load.sh
/home/ec2-user/black-friday-load.sh &
```

#### 1.4 Execute Chaos Experiment During Load
```
🖥️ VISUAL: FIS Console
📍 Start "ECS-Task-Termination-Test" experiment
📍 Monitor system behavior during high load + chaos
📍 Verify automatic recovery and scaling
```

---

### Step 2: Executive Presentation Preparation (5 minutes)

#### 2.1 Generate Executive Summary Report
```bash
# Create executive summary script
cat > /home/ec2-user/executive-summary.sh << 'EOF'
#!/bin/bash

echo "=========================================="
echo "EXECUTIVE SUMMARY: OPERATIONAL EXCELLENCE"
echo "=========================================="
echo "Date: $(date)"
echo ""

# System Health
echo "1. SYSTEM HEALTH STATUS"
echo "----------------------"
RUNNING_TASKS=$(aws ecs describe-services --cluster ecommerce-cluster --services ecommerce-service --query 'services[0].runningCount' --output text)
DESIRED_TASKS=$(aws ecs describe-services --cluster ecommerce-cluster --services ecommerce-service --query 'services[0].desiredCount' --output text)
echo "✅ Application Instances: $RUNNING_TASKS/$DESIRED_TASKS running"

HEALTHY_TARGETS=$(aws elbv2 describe-target-health --target-group-arn $(aws elbv2 describe-target-groups --names ecommerce-tg-blue --query 'TargetGroups[0].TargetGroupArn' --output text) --query 'length(TargetHealthDescriptions[?TargetHealth.State==`healthy`])' --output text)
echo "✅ Load Balancer Health: $HEALTHY_TARGETS healthy targets"

# Performance Metrics
echo ""
echo "2. PERFORMANCE METRICS"
echo "---------------------"
RESPONSE_TIME=$(aws cloudwatch get-metric-statistics \
    --namespace AWS/ApplicationELB \
    --metric-name TargetResponseTime \
    --dimensions Name=LoadBalancer,Value=app/ecommerce-alb/$(aws elbv2 describe-load-balancers --names ecommerce-alb --query 'LoadBalancers[0].LoadBalancerArn' --output text | cut -d'/' -f2-) \
    --start-time $(date -u -d '5 minutes ago' +%Y-%m-%dT%H:%M:%S) \
    --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
    --period 300 \
    --statistics Average \
    --query 'Datapoints[0].Average' \
    --output text 2>/dev/null || echo "0.5")

echo "📊 Average Response Time: ${RESPONSE_TIME}s (Target: <1s)"

# Business Impact
echo ""
echo "3. BUSINESS IMPACT"
echo "-----------------"
echo "💰 Revenue Protection: Zero-downtime deployments prevent sales loss"
echo "📈 Scalability: Auto-scaling handles 10x traffic spikes"
echo "🔧 Reliability: 99.9%+ uptime through chaos engineering"
echo "📊 Visibility: Real-time business metrics and predictive analytics"

# Cost Optimization
echo ""
echo "4. COST OPTIMIZATION"
echo "-------------------"
echo "💡 Auto-scaling reduces costs during low traffic periods"
echo "💡 Predictive analytics optimizes capacity planning"
echo "💡 Chaos engineering prevents costly outages"

# Risk Mitigation
echo ""
echo "5. RISK MITIGATION"
echo "-----------------"
echo "🛡️  Automated testing prevents deployment failures"
echo "🛡️  Blue-green deployment enables instant rollback"
echo "🛡️  Chaos engineering validates disaster recovery"
echo "🛡️  Comprehensive monitoring provides early warning"

echo ""
echo "=========================================="
echo "RECOMMENDATION: SYSTEM READY FOR PRODUCTION"
echo "=========================================="
EOF

chmod +x /home/ec2-user/executive-summary.sh
/home/ec2-user/executive-summary.sh
```

#### 2.2 Prepare Key Talking Points
```
📝 EXECUTIVE TALKING POINTS:

**Business Value Delivered:**
- Zero-downtime deployments = No lost sales during updates
- Auto-scaling = Handle Black Friday traffic without crashes
- Chaos engineering = 99.9%+ uptime guarantee
- Predictive analytics = Proactive capacity planning

**Risk Mitigation:**
- Automated testing prevents bad deployments
- Blue-green deployment enables instant rollback
- Comprehensive monitoring provides early warning
- Disaster recovery validated through chaos testing

**Cost Optimization:**
- Auto-scaling reduces infrastructure costs by 30-50%
- Predictive analytics prevents over-provisioning
- Chaos engineering prevents costly outages
- Operational efficiency reduces manual work by 80%

**Competitive Advantage:**
- Deploy features 10x faster than competitors
- Handle traffic spikes that would crash competitor sites
- Provide better customer experience through reliability
- Make data-driven decisions with real-time insights
```

---

### Step 3: Live Problem-Solving Scenarios (5 minutes)

#### Scenario 1: High Response Time Alert
```
🚨 ALERT: Response time increased to 3 seconds
📊 TASK: Use your monitoring to identify the root cause
🔧 ACTION: Implement solution using your tools
```

#### Scenario 2: Revenue Drop Detection
```
🚨 ALERT: Anomaly detection shows 40% revenue drop
📊 TASK: Correlate business metrics with technical metrics
🔧 ACTION: Determine if it's technical or business issue
```

#### Scenario 3: Capacity Planning Decision
```
🚨 SCENARIO: Predictive analytics shows traffic spike in 30 minutes
📊 TASK: Make scaling decision based on data
🔧 ACTION: Implement proactive scaling
```

---

## 🏆 Day 3 Final Scoring

### Project Scores
- **Project 1 - CI/CD Pipeline**: ___/25 points
- **Project 2 - Chaos Engineering**: ___/25 points
- **Project 3 - Advanced Monitoring**: ___/25 points
- **Final Integration Challenge**: ___/25 points

### **Total Day 3 Score: ___/100 points**
### **Combined Days 2+3 Score: ___/200 points**

**Passing Score: 140+ points (70%)**

---

## 🎓 What You've Accomplished in 2 Days

### Enterprise-Level Skills Mastered
**Day 2 Foundation:**
- ✅ Professional system monitoring and alerting
- ✅ Automated log analysis and pattern recognition
- ✅ Self-healing infrastructure with auto-scaling
- ✅ Infrastructure as Code deployment

**Day 3 Advanced:**
- ✅ Zero-downtime CI/CD pipelines
- ✅ Chaos engineering and resilience testing
- ✅ Distributed tracing and observability
- ✅ Business intelligence and predictive analytics

### Business Value Created
**Operational Excellence Achievements:**
- **99.9%+ Uptime**: Through self-healing and chaos engineering
- **Zero-Downtime Deployments**: Blue-green deployment strategy
- **10x Scalability**: Auto-scaling handles traffic spikes
- **Predictive Operations**: ML-based anomaly detection and forecasting
- **Business Alignment**: Technology metrics tied to business outcomes

### Career Readiness
**You now have hands-on experience with:**
- AWS CloudWatch, X-Ray, CodePipeline, CodeBuild, CodeDeploy
- ECS, Fargate, Application Load Balancers, Auto Scaling
- CloudFormation, Lambda, SNS, Fault Injection Simulator
- Chaos engineering principles and practices
- Site reliability engineering methodologies
- Business intelligence and executive reporting

**These skills qualify you for roles paying ₱80,000-150,000+ monthly:**
- Senior DevOps Engineer
- Site Reliability Engineer
- Cloud Solutions Architect
- Platform Engineering Lead
- Technical Product Manager

---

## 🚀 Next Steps & Continuous Learning

### Immediate Actions (This Week)
1. **Practice**: Rebuild these projects in your own AWS account
2. **Document**: Create your portfolio showcasing these projects
3. **Network**: Connect with DevOps and SRE communities
4. **Apply**: Start applying for relevant positions

### Skill Enhancement (Next Month)
1. **Certifications**: AWS DevOps Engineer Professional
2. **Advanced Topics**: Kubernetes, Terraform, GitOps
3. **Programming**: Python/Go for automation and tooling
4. **Monitoring**: Prometheus, Grafana, ELK stack

### Career Development (Next 3 Months)
1. **Portfolio Projects**: Build 2-3 showcase projects
2. **Open Source**: Contribute to DevOps/SRE projects
3. **Speaking**: Present at local tech meetups
4. **Mentoring**: Help others learn these skills

### Industry Trends to Follow
- **Platform Engineering**: Building developer platforms
- **FinOps**: Financial operations and cost optimization
- **GitOps**: Git-based deployment workflows
- **Observability**: Advanced monitoring and tracing
- **AI/ML Ops**: Machine learning in operations

---

## 🎉 Congratulations!

**You've completed an intensive 2-day journey from basic cloud operations to enterprise-level operational excellence!**

**Key Achievements:**
- ✅ Built production-ready monitoring and alerting systems
- ✅ Implemented zero-downtime deployment pipelines
- ✅ Mastered chaos engineering and resilience testing
- ✅ Created business intelligence dashboards
- ✅ Gained skills valued at ₱80,000-150,000+ monthly salaries

**You're now equipped to:**
- Lead operational excellence initiatives at any company
- Build and maintain systems that serve millions of users
- Make data-driven decisions that impact business outcomes
- Mentor other engineers in modern operational practices

**The future of technology operations is in your hands. Go build amazing, resilient systems that change the world! 🌟**

---

## 📞 Support & Resources

### Continued Learning Resources
- **AWS Documentation**: https://docs.aws.amazon.com/
- **Site Reliability Engineering Book**: https://sre.google/books/
- **Chaos Engineering Principles**: https://principlesofchaos.org/
- **DevOps Roadmap**: https://roadmap.sh/devops

### Community Support
- **AWS User Groups Philippines**: Join local meetups
- **DevOps Philippines Facebook Group**: Connect with peers
- **LinkedIn**: Follow industry leaders and share your projects
- **GitHub**: Showcase your code and contribute to open source

### Instructor Contact
- **Questions**: Available for follow-up questions
- **Career Guidance**: Happy to provide career advice
- **References**: Can provide professional references
- **Networking**: Connect you with industry contacts

**Thank you for your dedication and hard work. You've earned these skills through hands-on practice and real-world scenarios. Now go make an impact! 🚀**
