# AWS Services Reference Guide
## Day 2 & Day 3 TESDA Crash Course

---

## 📊 DAY 2: OPERATIONAL EXCELLENCE - MONITORING & AUTOMATION

### Core Monitoring Services

**Amazon CloudWatch**
- **Use Case**: Central monitoring service for metrics, logs, and alarms
- **What Students Do**: Create custom dashboards, set up alarms, monitor system performance
- **Key Features**: Metrics collection, log aggregation, alarm notifications
- **Video Focus**: Dashboard creation, alarm configuration, metric interpretation

**CloudWatch Agent**
- **Use Case**: Detailed system-level monitoring (CPU, memory, disk, network)
- **What Students Do**: Install on EC2 instances, configure custom metrics collection
- **Key Features**: System metrics, application logs, custom namespace organization
- **Video Focus**: Installation process, configuration file setup, metric verification

**CloudWatch Logs**
- **Use Case**: Centralized log management and analysis
- **What Students Do**: Collect application logs, create log groups, set retention policies
- **Key Features**: Log streaming, log insights queries, metric filters
- **Video Focus**: Log group creation, log streaming setup, query examples

**CloudWatch Logs Insights**
- **Use Case**: Interactive log analysis and querying
- **What Students Do**: Write queries to find errors, analyze patterns, troubleshoot issues
- **Key Features**: SQL-like queries, pattern matching, trend analysis
- **Video Focus**: Query syntax, common patterns, troubleshooting techniques

### Compute & Infrastructure Services

**Amazon EC2 (Elastic Compute Cloud)**
- **Use Case**: Virtual servers for hosting web applications
- **What Students Do**: Launch instances, configure security groups, install applications
- **Key Features**: Instance types, security groups, key pairs, user data scripts
- **Video Focus**: Instance launch, security configuration, SSH connection

**Auto Scaling Groups**
- **Use Case**: Automatic scaling based on demand and health checks
- **What Students Do**: Create scaling policies, configure health checks, test scaling
- **Key Features**: Dynamic scaling, health checks, launch templates
- **Video Focus**: Scaling policies, health check configuration, scaling events

**Application Load Balancer (ALB)**
- **Use Case**: Distribute traffic across multiple servers with health checks
- **What Students Do**: Create load balancer, configure target groups, set up health checks
- **Key Features**: Traffic distribution, health monitoring, SSL termination
- **Video Focus**: Load balancer setup, target group configuration, health check validation

### Serverless & Automation Services

**AWS Lambda**
- **Use Case**: Serverless log analysis and automated responses
- **What Students Do**: Create functions for log processing, set up triggers, handle alerts
- **Key Features**: Event-driven execution, automatic scaling, pay-per-use
- **Video Focus**: Function creation, trigger configuration, log processing examples

**Amazon SNS (Simple Notification Service)**
- **Use Case**: Send alerts and notifications via email, SMS, or other endpoints
- **What Students Do**: Create topics, subscribe endpoints, configure alarm notifications
- **Key Features**: Multi-protocol messaging, topic-based pub/sub, mobile push
- **Video Focus**: Topic creation, subscription management, notification testing

### Infrastructure as Code

**AWS CloudFormation**
- **Use Case**: Deploy infrastructure using code templates
- **What Students Do**: Write YAML templates, deploy stacks, manage infrastructure lifecycle
- **Key Features**: Template-based deployment, stack management, rollback capabilities
- **Video Focus**: Template structure, parameter usage, stack deployment process

**AWS Systems Manager**
- **Use Case**: Operational data collection and automation
- **What Students Do**: Create automation documents, manage configurations, run commands
- **Key Features**: Run Command, Parameter Store, Automation documents
- **Video Focus**: Document creation, command execution, parameter management

### Security & Access Management

**AWS IAM (Identity and Access Management)**
- **Use Case**: Manage permissions for AWS services and resources
- **What Students Do**: Create roles, attach policies, configure service permissions
- **Key Features**: Roles, policies, service-linked roles, least privilege access
- **Video Focus**: Role creation, policy attachment, permission troubleshooting

---

## 🚀 DAY 3: ADVANCED OPERATIONAL EXCELLENCE - CI/CD & CHAOS ENGINEERING

### CI/CD Pipeline Services

**AWS CodeCommit**
- **Use Case**: Git-based source code repository
- **What Students Do**: Create repositories, push code, manage branches
- **Key Features**: Git compatibility, branch protection, integration with CI/CD
- **Video Focus**: Repository creation, Git operations, branch management

**AWS CodeBuild**
- **Use Case**: Automated building and testing of applications
- **What Students Do**: Create build projects, configure buildspec.yml, run tests
- **Key Features**: Managed build environment, custom build specifications, artifact generation
- **Video Focus**: Project setup, buildspec configuration, build execution monitoring

**AWS CodeDeploy**
- **Use Case**: Automated application deployment with blue-green strategy
- **What Students Do**: Configure deployment groups, set up blue-green deployments, manage rollbacks
- **Key Features**: Blue-green deployment, automatic rollback, deployment monitoring
- **Video Focus**: Deployment group setup, blue-green configuration, rollback procedures

**AWS CodePipeline**
- **Use Case**: Orchestrate the complete CI/CD workflow
- **What Students Do**: Create pipelines, configure stages, monitor deployments
- **Key Features**: Multi-stage pipelines, integration with other AWS services, visual workflow
- **Video Focus**: Pipeline creation, stage configuration, execution monitoring

### Container Services

**Amazon ECR (Elastic Container Registry)**
- **Use Case**: Store and manage Docker container images
- **What Students Do**: Create repositories, push/pull images, configure security scanning
- **Key Features**: Private registries, image scanning, lifecycle policies
- **Video Focus**: Repository creation, image push/pull, security scanning

**Amazon ECS (Elastic Container Service)**
- **Use Case**: Run and manage containerized applications
- **What Students Do**: Create clusters, define tasks, configure services
- **Key Features**: Fargate serverless containers, service discovery, load balancer integration
- **Video Focus**: Cluster setup, task definition, service configuration

**AWS Fargate**
- **Use Case**: Serverless container execution
- **What Students Do**: Run containers without managing servers
- **Key Features**: Serverless compute, automatic scaling, pay-per-use
- **Video Focus**: Fargate vs EC2 comparison, task configuration, cost optimization

### Chaos Engineering & Testing

**AWS Fault Injection Simulator (FIS)**
- **Use Case**: Controlled chaos engineering experiments
- **What Students Do**: Create experiment templates, inject faults, measure system resilience
- **Key Features**: Controlled fault injection, experiment templates, safety mechanisms
- **Video Focus**: Experiment design, fault injection types, safety configurations

**AWS Systems Manager - Run Command**
- **Use Case**: Execute commands across multiple instances for chaos testing
- **What Students Do**: Run network latency injection, stress testing, system manipulation
- **Key Features**: Remote command execution, document-based automation, multi-instance targeting
- **Video Focus**: Command execution, document creation, targeting strategies

### Advanced Monitoring & Observability

**AWS X-Ray**
- **Use Case**: Distributed tracing and application performance monitoring
- **What Students Do**: Instrument applications, analyze traces, identify bottlenecks
- **Key Features**: Service maps, trace analysis, performance insights
- **Video Focus**: Service map interpretation, trace analysis, performance optimization

**CloudWatch Anomaly Detection**
- **Use Case**: Machine learning-based anomaly detection
- **What Students Do**: Configure anomaly detectors, set up ML-based alarms
- **Key Features**: Automatic baseline learning, anomaly detection, predictive alerting
- **Video Focus**: Detector configuration, anomaly interpretation, alert tuning

**CloudWatch Insights**
- **Use Case**: Advanced log analysis and correlation
- **What Students Do**: Create complex queries, correlate metrics with logs
- **Key Features**: Advanced querying, log correlation, pattern analysis
- **Video Focus**: Advanced query techniques, correlation analysis, pattern recognition

### Load Balancing & Traffic Management

**Application Load Balancer (Advanced)**
- **Use Case**: Advanced traffic routing for blue-green deployments
- **What Students Do**: Configure multiple target groups, implement traffic shifting
- **Key Features**: Target group management, traffic routing rules, health checks
- **Video Focus**: Blue-green setup, traffic shifting, health check configuration

**Target Groups**
- **Use Case**: Manage application targets for load balancing
- **What Students Do**: Create blue/green target groups, configure health checks
- **Key Features**: Health monitoring, target registration, traffic distribution
- **Video Focus**: Target group creation, health check tuning, traffic management

---

## 📚 RECOMMENDED VIDEO PREPARATION TOPICS

### Day 2 Priority Videos
1. **CloudWatch Dashboard Creation** - Step-by-step dashboard building
2. **CloudWatch Agent Installation** - Complete setup process
3. **Lambda Function for Log Analysis** - Code walkthrough and deployment
4. **CloudFormation Template Deployment** - Stack creation and management
5. **Auto Scaling Configuration** - Scaling policies and testing

### Day 3 Priority Videos
1. **CodePipeline Setup** - Complete CI/CD pipeline creation
2. **Blue-Green Deployment with CodeDeploy** - Zero-downtime deployment demo
3. **ECS Fargate Service Creation** - Containerized application deployment
4. **Fault Injection Simulator** - Chaos engineering experiment setup
5. **X-Ray Service Map Analysis** - Distributed tracing interpretation

### Common Troubleshooting Topics
1. **IAM Permission Issues** - Common errors and solutions
2. **Security Group Configuration** - Network access troubleshooting
3. **CloudWatch Agent Troubleshooting** - Common installation issues
4. **Pipeline Failure Debugging** - CI/CD troubleshooting techniques
5. **Container Deployment Issues** - ECS/Fargate common problems

---

## 🎯 SERVICE INTEGRATION PATTERNS

### Day 2 Integration Flow
```
EC2 → CloudWatch Agent → CloudWatch Metrics → Alarms → SNS → Email
EC2 → Application Logs → CloudWatch Logs → Lambda → Analysis → Alerts
CloudFormation → Auto Scaling Group → Load Balancer → Target Health
```

### Day 3 Integration Flow
```
CodeCommit → CodeBuild → ECR → CodeDeploy → ECS/Fargate → ALB
FIS → EC2/ECS → CloudWatch → Metrics → Recovery Actions
X-Ray → Application Traces → Service Map → Performance Insights
```

---

## 💡 VIDEO CONTENT SUGGESTIONS

### For Each Service, Include:
1. **Service Overview** - What it does and why it's important
2. **Console Walkthrough** - Step-by-step GUI navigation
3. **Configuration Examples** - Real-world settings and parameters
4. **Common Use Cases** - When and how to use the service
5. **Troubleshooting Tips** - Common issues and solutions
6. **Best Practices** - Security, cost optimization, performance
7. **Integration Points** - How it connects with other services

### Video Length Recommendations:
- **Core Services** (CloudWatch, EC2, Lambda): 10-15 minutes each
- **CI/CD Services** (CodePipeline, CodeBuild, CodeDeploy): 8-12 minutes each
- **Advanced Services** (X-Ray, FIS): 5-8 minutes each
- **Quick Reference** (IAM, SNS, ECR): 3-5 minutes each

This comprehensive list covers all AWS services used in both days with specific use cases for your video preparation and reference materials.
