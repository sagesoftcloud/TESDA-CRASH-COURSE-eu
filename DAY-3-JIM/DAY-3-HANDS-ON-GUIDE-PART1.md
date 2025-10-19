# Day 3: Hands-on Lab Guide - Advanced Operational Excellence (Part 1)

## Pre-Lab Setup (10 minutes)
**Ensure you have**:
- Completed Day 2 successfully
- AWS CLI configured with appropriate permissions
- Git client installed
- Code editor ready

---

## Project 1: CI/CD Pipeline with Monitoring (80 minutes)

### Objective
Build a complete CI/CD pipeline with blue-green deployment, integrated monitoring, and automated rollback capabilities.

### Scenario
Deploy a Node.js microservice with zero-downtime deployments, comprehensive monitoring, and automatic rollback on performance degradation.

### Step 1: Create Sample Application (15 minutes)

**1.1 Initialize Node.js Application**
```bash
# Create project directory
mkdir microservice-app && cd microservice-app

# Initialize package.json
cat > package.json << 'EOF'
{
  "name": "microservice-app",
  "version": "1.0.0",
  "description": "Sample microservice for CI/CD pipeline",
  "main": "app.js",
  "scripts": {
    "start": "node app.js",
    "test": "jest",
    "health": "curl -f http://localhost:3000/health || exit 1"
  },
  "dependencies": {
    "express": "^4.18.0",
    "aws-xray-sdk": "^3.4.0"
  },
  "devDependencies": {
    "jest": "^29.0.0",
    "supertest": "^6.3.0"
  }
}
EOF
```

**1.2 Create Application Code (app.js)**
```javascript
const express = require('express');
const AWSXRay = require('aws-xray-sdk-core');
const app = express();
const port = process.env.PORT || 3000;

// X-Ray tracing
app.use(AWSXRay.express.openSegment('microservice-app'));

// Middleware
app.use(express.json());

// Health check endpoint
app.get('/health', (req, res) => {
    res.status(200).json({
        status: 'healthy',
        timestamp: new Date().toISOString(),
        version: process.env.APP_VERSION || '1.0.0'
    });
});

// Main API endpoint
app.get('/api/data', (req, res) => {
    const segment = AWSXRay.getSegment();
    const subsegment = segment.addNewSubsegment('data-processing');
    
    try {
        // Simulate data processing
        const data = {
            message: 'Hello from microservice!',
            timestamp: new Date().toISOString(),
            version: process.env.APP_VERSION || '1.0.0',
            environment: process.env.NODE_ENV || 'development'
        };
        
        subsegment.close();
        res.json(data);
    } catch (error) {
        subsegment.close(error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// Metrics endpoint
app.get('/metrics', (req, res) => {
    res.json({
        uptime: process.uptime(),
        memory: process.memoryUsage(),
        timestamp: new Date().toISOString()
    });
});

app.use(AWSXRay.express.closeSegment());

app.listen(port, () => {
    console.log(`Microservice running on port ${port}`);
});

module.exports = app;
```

**1.3 Create Tests (app.test.js)**
```javascript
const request = require('supertest');
const app = require('./app');

describe('Microservice API', () => {
    test('Health check should return 200', async () => {
        const response = await request(app).get('/health');
        expect(response.status).toBe(200);
        expect(response.body.status).toBe('healthy');
    });

    test('API data endpoint should return data', async () => {
        const response = await request(app).get('/api/data');
        expect(response.status).toBe(200);
        expect(response.body.message).toBe('Hello from microservice!');
    });

    test('Metrics endpoint should return system metrics', async () => {
        const response = await request(app).get('/metrics');
        expect(response.status).toBe(200);
        expect(response.body).toHaveProperty('uptime');
        expect(response.body).toHaveProperty('memory');
    });
});
```

### Step 2: Set Up CodeCommit Repository (10 minutes)

**2.1 Create CodeCommit Repository**
```bash
# Create repository
aws codecommit create-repository \
    --repository-name microservice-app \
    --repository-description "Sample microservice for CI/CD pipeline"

# Get clone URL
CLONE_URL=$(aws codecommit get-repository \
    --repository-name microservice-app \
    --query 'repositoryMetadata.cloneUrlHttp' \
    --output text)

echo "Repository URL: $CLONE_URL"
```

**2.2 Initialize Git and Push Code**
```bash
# Initialize git repository
git init
git add .
git commit -m "Initial commit: Node.js microservice"

# Add remote and push
git remote add origin $CLONE_URL
git push -u origin main
```

### Step 3: Create Build Specification (10 minutes)

**3.1 Create buildspec.yml**
```yaml
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

  build:
    commands:
      - echo Build started on `date`
      - echo Building the Docker image...
      - docker build -t $IMAGE_REPO_NAME:$IMAGE_TAG .
      - docker tag $IMAGE_REPO_NAME:$IMAGE_TAG $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$IMAGE_TAG

  post_build:
    commands:
      - echo Build completed on `date`
      - echo Pushing the Docker image...
      - docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$IMAGE_TAG
      - echo Writing image definitions file...
      - printf '[{"name":"microservice-app","imageUri":"%s"}]' $AWS_ACCOUNT_ID.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com/$IMAGE_REPO_NAME:$IMAGE_TAG > imagedefinitions.json

artifacts:
  files:
    - imagedefinitions.json
    - appspec.yml
    - scripts/*
```

**3.2 Create Dockerfile**
```dockerfile
FROM node:18-alpine

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm ci --only=production

# Copy application code
COPY . .

# Expose port
EXPOSE 3000

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD node -e "require('http').get('http://localhost:3000/health', (res) => { process.exit(res.statusCode === 200 ? 0 : 1) })"

# Start application
CMD ["npm", "start"]
```

### Step 4: Create CodeBuild Project (15 minutes)

**4.1 Create Build Project**
```bash
# Create service role for CodeBuild
aws iam create-role \
    --role-name CodeBuildServiceRole \
    --assume-role-policy-document '{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Service": "codebuild.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    }'

# Attach policies
aws iam attach-role-policy \
    --role-name CodeBuildServiceRole \
    --policy-arn arn:aws:iam::aws:policy/CloudWatchLogsFullAccess

aws iam attach-role-policy \
    --role-name CodeBuildServiceRole \
    --policy-arn arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser

# Create CodeBuild project
aws codebuild create-project \
    --name microservice-build \
    --source '{
        "type": "CODECOMMIT",
        "location": "'$CLONE_URL'"
    }' \
    --artifacts '{
        "type": "S3",
        "location": "your-artifacts-bucket/builds"
    }' \
    --environment '{
        "type": "LINUX_CONTAINER",
        "image": "aws/codebuild/amazonlinux2-x86_64-standard:4.0",
        "computeType": "BUILD_GENERAL1_MEDIUM",
        "privilegedMode": true,
        "environmentVariables": [
            {
                "name": "AWS_DEFAULT_REGION",
                "value": "us-east-1"
            },
            {
                "name": "AWS_ACCOUNT_ID",
                "value": "'$(aws sts get-caller-identity --query Account --output text)'"
            },
            {
                "name": "IMAGE_REPO_NAME",
                "value": "microservice-app"
            },
            {
                "name": "IMAGE_TAG",
                "value": "latest"
            }
        ]
    }' \
    --service-role arn:aws:iam::$(aws sts get-caller-identity --query Account --output text):role/CodeBuildServiceRole
```

### Step 5: Create ECS Cluster and Service (20 minutes)

**5.1 Create ECS Cluster**
```bash
# Create ECS cluster
aws ecs create-cluster --cluster-name microservice-cluster

# Create ECR repository
aws ecr create-repository --repository-name microservice-app
```

**5.2 Create Task Definition**
```json
{
    "family": "microservice-app",
    "networkMode": "awsvpc",
    "requiresCompatibilities": ["FARGATE"],
    "cpu": "256",
    "memory": "512",
    "executionRoleArn": "arn:aws:iam::ACCOUNT:role/ecsTaskExecutionRole",
    "taskRoleArn": "arn:aws:iam::ACCOUNT:role/ecsTaskRole",
    "containerDefinitions": [
        {
            "name": "microservice-app",
            "image": "ACCOUNT.dkr.ecr.REGION.amazonaws.com/microservice-app:latest",
            "portMappings": [
                {
                    "containerPort": 3000,
                    "protocol": "tcp"
                }
            ],
            "essential": true,
            "logConfiguration": {
                "logDriver": "awslogs",
                "options": {
                    "awslogs-group": "/ecs/microservice-app",
                    "awslogs-region": "us-east-1",
                    "awslogs-stream-prefix": "ecs"
                }
            },
            "healthCheck": {
                "command": ["CMD-SHELL", "curl -f http://localhost:3000/health || exit 1"],
                "interval": 30,
                "timeout": 5,
                "retries": 3,
                "startPeriod": 60
            },
            "environment": [
                {
                    "name": "NODE_ENV",
                    "value": "production"
                },
                {
                    "name": "APP_VERSION",
                    "value": "1.0.0"
                }
            ]
        }
    ]
}
```

### Step 6: Create CodeDeploy Application (10 minutes)

**6.1 Create CodeDeploy Application**
```bash
# Create CodeDeploy application
aws deploy create-application \
    --application-name microservice-app \
    --compute-platform ECS

# Create deployment group
aws deploy create-deployment-group \
    --application-name microservice-app \
    --deployment-group-name microservice-deployment-group \
    --service-role-arn arn:aws:iam::$(aws sts get-caller-identity --query Account --output text):role/CodeDeployServiceRole \
    --ecs-services clusterName=microservice-cluster,serviceName=microservice-service \
    --load-balancer-info targetGroupInfoList='[{
        "name": "microservice-tg"
    }]' \
    --blue-green-deployment-configuration '{
        "terminateBlueInstancesOnDeploymentSuccess": {
            "action": "TERMINATE",
            "terminationWaitTimeInMinutes": 5
        },
        "deploymentReadyOption": {
            "actionOnTimeout": "CONTINUE_DEPLOYMENT"
        },
        "greenFleetProvisioningOption": {
            "action": "COPY_AUTO_SCALING_GROUP"
        }
    }'
```

---

## Project 2: Chaos Engineering & Resilience Testing (80 minutes)

### Objective
Implement chaos engineering practices using AWS Fault Injection Simulator to test system resilience and validate recovery procedures.

### Scenario
Test the resilience of your microservice deployment by injecting various types of failures and validating that the system recovers automatically.

### Step 1: Set Up Fault Injection Simulator (20 minutes)

**1.1 Create FIS Service Role**
```bash
# Create FIS service role
aws iam create-role \
    --role-name FISServiceRole \
    --assume-role-policy-document '{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": {
                    "Service": "fis.amazonaws.com"
                },
                "Action": "sts:AssumeRole"
            }
        ]
    }'

# Create custom policy for FIS
cat > fis-policy.json << 'EOF'
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ec2:DescribeInstances",
                "ec2:StopInstances",
                "ec2:StartInstances",
                "ec2:RebootInstances",
                "ecs:DescribeServices",
                "ecs:UpdateService",
                "ecs:DescribeTasks",
                "ecs:StopTask",
                "cloudwatch:PutMetricData",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "*"
        }
    ]
}
EOF

aws iam put-role-policy \
    --role-name FISServiceRole \
    --policy-name FISExecutionPolicy \
    --policy-document file://fis-policy.json
```

### Step 2: Create Chaos Experiments (25 minutes)

**2.1 Experiment 1: ECS Task Termination**
```json
{
    "description": "Test ECS service resilience by stopping tasks",
    "roleArn": "arn:aws:iam::ACCOUNT:role/FISServiceRole",
    "actions": {
        "StopECSTasks": {
            "actionId": "aws:ecs:stop-task",
            "parameters": {
                "clusterArn": "arn:aws:ecs:REGION:ACCOUNT:cluster/microservice-cluster"
            },
            "targets": {
                "Tasks": "ECSTasks"
            }
        }
    },
    "targets": {
        "ECSTasks": {
            "resourceType": "aws:ecs:task",
            "resourceArns": [
                "arn:aws:ecs:REGION:ACCOUNT:task/microservice-cluster/*"
            ],
            "selectionMode": "PERCENT(50)"
        }
    },
    "stopConditions": [
        {
            "source": "aws:cloudwatch:alarm",
            "value": "arn:aws:cloudwatch:REGION:ACCOUNT:alarm:HighErrorRate"
        }
    ],
    "tags": {
        "Name": "ECS-Task-Termination-Test",
        "Environment": "Testing"
    }
}
```

**2.2 Create the Experiment**
```bash
# Create ECS task termination experiment
aws fis create-experiment-template \
    --cli-input-json file://ecs-task-termination.json
```

**2.3 Experiment 2: Network Latency Injection**
```json
{
    "description": "Test application performance under network latency",
    "roleArn": "arn:aws:iam::ACCOUNT:role/FISServiceRole",
    "actions": {
        "InjectLatency": {
            "actionId": "aws:ec2:send-spot-instance-interruptions",
            "parameters": {
                "durationMinutes": "10"
            },
            "targets": {
                "Instances": "EC2Instances"
            }
        }
    },
    "targets": {
        "EC2Instances": {
            "resourceType": "aws:ec2:instance",
            "resourceTags": {
                "Environment": "Testing"
            },
            "selectionMode": "PERCENT(25)"
        }
    },
    "stopConditions": [
        {
            "source": "aws:cloudwatch:alarm",
            "value": "arn:aws:cloudwatch:REGION:ACCOUNT:alarm:HighLatency"
        }
    ]
}
```

### Step 3: Create Monitoring for Experiments (15 minutes)

**3.1 Create CloudWatch Alarms for Stop Conditions**
```bash
# High error rate alarm
aws cloudwatch put-metric-alarm \
    --alarm-name "HighErrorRate" \
    --alarm-description "Stop chaos experiment if error rate exceeds 10%" \
    --metric-name "ErrorRate" \
    --namespace "ECommerce/Application" \
    --statistic Average \
    --period 60 \
    --threshold 10 \
    --comparison-operator GreaterThanThreshold \
    --evaluation-periods 2

# High latency alarm
aws cloudwatch put-metric-alarm \
    --alarm-name "HighLatency" \
    --alarm-description "Stop chaos experiment if latency exceeds 1000ms" \
    --metric-name "ResponseTime" \
    --namespace "ECommerce/Application" \
    --statistic Average \
    --period 60 \
    --threshold 1000 \
    --comparison-operator GreaterThanThreshold \
    --evaluation-periods 2
```

**3.2 Create Experiment Monitoring Dashboard**
```json
{
    "widgets": [
        {
            "type": "metric",
            "properties": {
                "metrics": [
                    ["AWS/ECS", "CPUUtilization", "ServiceName", "microservice-service"],
                    [".", "MemoryUtilization", ".", "."],
                    ["AWS/ApplicationELB", "TargetResponseTime", "LoadBalancer", "microservice-alb"],
                    [".", "HTTPCode_Target_5XX_Count", ".", "."]
                ],
                "period": 60,
                "stat": "Average",
                "region": "us-east-1",
                "title": "Chaos Experiment Monitoring"
            }
        }
    ]
}
```

### Step 4: Execute Chaos Experiments (20 minutes)

**4.1 Run ECS Task Termination Experiment**
```bash
# Get experiment template ID
EXPERIMENT_ID=$(aws fis list-experiment-templates \
    --query 'experimentTemplates[?description==`Test ECS service resilience by stopping tasks`].id' \
    --output text)

# Start experiment
aws fis start-experiment \
    --experiment-template-id $EXPERIMENT_ID \
    --tags Name=ECS-Resilience-Test-$(date +%Y%m%d-%H%M%S)

# Monitor experiment
aws fis get-experiment --id $EXPERIMENT_ID
```

**4.2 Validate System Recovery**
```bash
# Monitor ECS service during experiment
watch -n 5 'aws ecs describe-services \
    --cluster microservice-cluster \
    --services microservice-service \
    --query "services[0].{RunningCount:runningCount,DesiredCount:desiredCount,Status:status}"'

# Check application health
while true; do
    curl -s http://your-load-balancer/health | jq .
    sleep 5
done
```

This completes Part 1 of the Day 3 hands-on guide. The remaining Project 3 (Advanced Monitoring & Observability) will be in Part 2.
