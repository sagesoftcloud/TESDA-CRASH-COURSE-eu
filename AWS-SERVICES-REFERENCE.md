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
- **📚 AWS Documentation**: https://docs.aws.amazon.com/cloudwatch/
- **🎥 AWS YouTube**: [Amazon CloudWatch Overview](https://www.youtube.com/watch?v=a4dhoTQCyRA)
- **🎥 Tutorial Video**: [CloudWatch Dashboards and Alarms](https://www.youtube.com/watch?v=IJ3pomeNgtM)

**CloudWatch Agent**
- **Use Case**: Detailed system-level monitoring (CPU, memory, disk, network)
- **What Students Do**: Install on EC2 instances, configure custom metrics collection
- **Key Features**: System metrics, application logs, custom namespace organization
- **Video Focus**: Installation process, configuration file setup, metric verification
- **📚 AWS Documentation**: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/Install-CloudWatch-Agent.html
- **🎥 AWS YouTube**: [Installing CloudWatch Agent](https://www.youtube.com/watch?v=vAnIhIwE5hY)
- **🎥 Tutorial Video**: [CloudWatch Agent Configuration](https://www.youtube.com/watch?v=TC1j_pLGbKE)

**CloudWatch Logs**
- **Use Case**: Centralized log management and analysis
- **What Students Do**: Collect application logs, create log groups, set retention policies
- **Key Features**: Log streaming, log insights queries, metric filters
- **Video Focus**: Log group creation, log streaming setup, query examples
- **📚 AWS Documentation**: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/
- **🎥 AWS YouTube**: [CloudWatch Logs Overview](https://www.youtube.com/watch?v=RBHkxOtBkMg)
- **🎥 Tutorial Video**: [CloudWatch Logs Setup and Analysis](https://www.youtube.com/watch?v=jiS5dHdyHjE)

**CloudWatch Logs Insights**
- **Use Case**: Interactive log analysis and querying
- **What Students Do**: Write queries to find errors, analyze patterns, troubleshoot issues
- **Key Features**: SQL-like queries, pattern matching, trend analysis
- **Video Focus**: Query syntax, common patterns, troubleshooting techniques
- **📚 AWS Documentation**: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/AnalyzingLogData.html
- **🎥 AWS YouTube**: [CloudWatch Logs Insights](https://www.youtube.com/watch?v=2s2xcwm8QrM)
- **🎥 Tutorial Video**: [Log Insights Query Examples](https://www.youtube.com/watch?v=vONjqKyYeAg)

### Compute & Infrastructure Services

**Amazon EC2 (Elastic Compute Cloud)**
- **Use Case**: Virtual servers for hosting web applications
- **What Students Do**: Launch instances, configure security groups, install applications
- **Key Features**: Instance types, security groups, key pairs, user data scripts
- **Video Focus**: Instance launch, security configuration, SSH connection
- **📚 AWS Documentation**: https://docs.aws.amazon.com/ec2/
- **🎥 AWS YouTube**: [Amazon EC2 Basics](https://www.youtube.com/watch?v=TsRBftzZsQo)
- **🎥 Tutorial Video**: [EC2 Instance Launch and Configuration](https://www.youtube.com/watch?v=8TlukLu11Yo)

**Auto Scaling Groups**
- **Use Case**: Automatic scaling based on demand and health checks
- **What Students Do**: Create scaling policies, configure health checks, test scaling
- **Key Features**: Dynamic scaling, health checks, launch templates
- **Video Focus**: Scaling policies, health check configuration, scaling events
- **📚 AWS Documentation**: https://docs.aws.amazon.com/autoscaling/ec2/userguide/
- **🎥 AWS YouTube**: [Auto Scaling Groups Overview](https://www.youtube.com/watch?v=4EOaAkY4pNE)
- **🎥 Tutorial Video**: [Auto Scaling Configuration](https://www.youtube.com/watch?v=zcWxNfW_AuE)

**Application Load Balancer (ALB)**
- **Use Case**: Distribute traffic across multiple servers with health checks
- **What Students Do**: Create load balancer, configure target groups, set up health checks
- **Key Features**: Traffic distribution, health monitoring, SSL termination
- **Video Focus**: Load balancer setup, target group configuration, health check validation
- **📚 AWS Documentation**: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/
- **🎥 AWS YouTube**: [Application Load Balancer Overview](https://www.youtube.com/watch?v=VIgAT7vjol8)
- **🎥 Tutorial Video**: [ALB Setup and Configuration](https://www.youtube.com/watch?v=HKh54iqeuuM)

### Serverless & Automation Services

**AWS Lambda**
- **Use Case**: Serverless log analysis and automated responses
- **What Students Do**: Create functions for log processing, set up triggers, handle alerts
- **Key Features**: Event-driven execution, automatic scaling, pay-per-use
- **Video Focus**: Function creation, trigger configuration, log processing examples
- **📚 AWS Documentation**: https://docs.aws.amazon.com/lambda/
- **🎥 AWS YouTube**: [AWS Lambda Overview](https://www.youtube.com/watch?v=eOBq__h4OJ4)
- **🎥 Tutorial Video**: [Lambda for Log Processing](https://www.youtube.com/watch?v=BsObG_6-2Ik)

**Amazon SNS (Simple Notification Service)**
- **Use Case**: Send alerts and notifications via email, SMS, or other endpoints
- **What Students Do**: Create topics, subscribe endpoints, configure alarm notifications
- **Key Features**: Multi-protocol messaging, topic-based pub/sub, mobile push
- **Video Focus**: Topic creation, subscription management, notification testing
- **📚 AWS Documentation**: https://docs.aws.amazon.com/sns/
- **🎥 AWS YouTube**: [Amazon SNS Overview](https://www.youtube.com/watch?v=UesxWuZMZqI)
- **🎥 Tutorial Video**: [SNS Setup for CloudWatch Alarms](https://www.youtube.com/watch?v=jdWBmOlb_2Q)

### Infrastructure as Code

**AWS CloudFormation**
- **Use Case**: Deploy infrastructure using code templates
- **What Students Do**: Write YAML templates, deploy stacks, manage infrastructure lifecycle
- **Key Features**: Template-based deployment, stack management, rollback capabilities
- **Video Focus**: Template structure, parameter usage, stack deployment process
- **📚 AWS Documentation**: https://docs.aws.amazon.com/cloudformation/
- **🎥 AWS YouTube**: [AWS CloudFormation Overview](https://www.youtube.com/watch?v=Omppm_YUG2g)
- **🎥 Tutorial Video**: [CloudFormation Templates for Auto Scaling](https://www.youtube.com/watch?v=6R44BADNJA8)

**AWS Systems Manager**
- **Use Case**: Operational data collection and automation
- **What Students Do**: Create automation documents, manage configurations, run commands
- **Key Features**: Run Command, Parameter Store, Automation documents
- **Video Focus**: Document creation, command execution, parameter management
- **📚 AWS Documentation**: https://docs.aws.amazon.com/systems-manager/
- **🎥 AWS YouTube**: [AWS Systems Manager Overview](https://www.youtube.com/watch?v=zwRvwL3n_jY)
- **🎥 Tutorial Video**: [Systems Manager Automation](https://www.youtube.com/watch?v=DlgK_3gLhxA)

### Security & Access Management

**AWS IAM (Identity and Access Management)**
- **Use Case**: Manage permissions for AWS services and resources
- **What Students Do**: Create roles, attach policies, configure service permissions
- **Key Features**: Roles, policies, service-linked roles, least privilege access
- **Video Focus**: Role creation, policy attachment, permission troubleshooting
- **📚 AWS Documentation**: https://docs.aws.amazon.com/iam/
- **🎥 AWS YouTube**: [AWS IAM Overview](https://www.youtube.com/watch?v=Ul6FW4UANGc)
- **🎥 Tutorial Video**: [IAM Roles for AWS Services](https://www.youtube.com/watch?v=rvJeOOB7lGg)

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

---

## 🚀 DAY 3: ADVANCED OPERATIONAL EXCELLENCE - CI/CD & CHAOS ENGINEERING

### CI/CD Pipeline Services

**AWS CodeCommit**
- **Use Case**: Git-based source code repository
- **What Students Do**: Create repositories, push code, manage branches
- **Key Features**: Git compatibility, branch protection, integration with CI/CD
- **Video Focus**: Repository creation, Git operations, branch management
- **📚 AWS Documentation**: https://docs.aws.amazon.com/codecommit/
- **🎥 AWS YouTube**: [AWS CodeCommit Overview](https://www.youtube.com/watch?v=46PRLMW8otg)
- **🎥 Tutorial Video**: [CodeCommit Repository Setup](https://www.youtube.com/watch?v=oHHbQCKbJOE)

**AWS CodeBuild**
- **Use Case**: Automated building and testing of applications
- **What Students Do**: Create build projects, configure buildspec.yml, run tests
- **Key Features**: Managed build environment, custom build specifications, artifact generation
- **Video Focus**: Project setup, buildspec configuration, build execution monitoring
- **📚 AWS Documentation**: https://docs.aws.amazon.com/codebuild/
- **🎥 AWS YouTube**: [AWS CodeBuild Overview](https://www.youtube.com/watch?v=dYOR0Jj0l1E)
- **🎥 Tutorial Video**: [CodeBuild with Docker and ECR](https://www.youtube.com/watch?v=MrwxhGoFbNA)

**AWS CodeDeploy**
- **Use Case**: Automated application deployment with blue-green strategy
- **What Students Do**: Configure deployment groups, set up blue-green deployments, manage rollbacks
- **Key Features**: Blue-green deployment, automatic rollback, deployment monitoring
- **Video Focus**: Deployment group setup, blue-green configuration, rollback procedures
- **📚 AWS Documentation**: https://docs.aws.amazon.com/codedeploy/
- **🎥 AWS YouTube**: [AWS CodeDeploy Overview](https://www.youtube.com/watch?v=Wx-ain8UryM)
- **🎥 Tutorial Video**: [Blue-Green Deployment with CodeDeploy](https://www.youtube.com/watch?v=A8vTqHZ86sg)

**AWS CodePipeline**
- **Use Case**: Orchestrate the complete CI/CD workflow
- **What Students Do**: Create pipelines, configure stages, monitor deployments
- **Key Features**: Multi-stage pipelines, integration with other AWS services, visual workflow
- **Video Focus**: Pipeline creation, stage configuration, execution monitoring
- **📚 AWS Documentation**: https://docs.aws.amazon.com/codepipeline/
- **🎥 AWS YouTube**: [AWS CodePipeline Overview](https://www.youtube.com/watch?v=YxcIj_SLflw)
- **🎥 Tutorial Video**: [Complete CI/CD Pipeline Setup](https://www.youtube.com/watch?v=NwzJCSPSPZs)

### Container Services

**Amazon ECR (Elastic Container Registry)**
- **Use Case**: Store and manage Docker container images
- **What Students Do**: Create repositories, push/pull images, configure security scanning
- **Key Features**: Private registries, image scanning, lifecycle policies
- **Video Focus**: Repository creation, image push/pull, security scanning
- **📚 AWS Documentation**: https://docs.aws.amazon.com/ecr/
- **🎥 AWS YouTube**: [Amazon ECR Overview](https://www.youtube.com/watch?v=8VL9LzMjzv4)
- **🎥 Tutorial Video**: [ECR with Docker Images](https://www.youtube.com/watch?v=3xbmJ_gCjmU)

**Amazon ECS (Elastic Container Service)**
- **Use Case**: Run and manage containerized applications
- **What Students Do**: Create clusters, define tasks, configure services
- **Key Features**: Fargate serverless containers, service discovery, load balancer integration
- **Video Focus**: Cluster setup, task definition, service configuration
- **📚 AWS Documentation**: https://docs.aws.amazon.com/ecs/
- **🎥 AWS YouTube**: [Amazon ECS Overview](https://www.youtube.com/watch?v=I9VAMGEjW-Q)
- **🎥 Tutorial Video**: [ECS with Fargate Deployment](https://www.youtube.com/watch?v=esISkPlnxL0)

**AWS Fargate**
- **Use Case**: Serverless container execution
- **What Students Do**: Run containers without managing servers
- **Key Features**: Serverless compute, automatic scaling, pay-per-use
- **Video Focus**: Fargate vs EC2 comparison, task configuration, cost optimization
- **📚 AWS Documentation**: https://docs.aws.amazon.com/AmazonECS/latest/userguide/what-is-fargate.html
- **🎥 AWS YouTube**: [AWS Fargate Overview](https://www.youtube.com/watch?v=DVrGXjjkpig)
- **🎥 Tutorial Video**: [Fargate Container Deployment](https://www.youtube.com/watch?v=o7s-eigrMAI)

### Chaos Engineering & Testing

**AWS Fault Injection Simulator (FIS)**
- **Use Case**: Controlled chaos engineering experiments
- **What Students Do**: Create experiment templates, inject faults, measure system resilience
- **Key Features**: Controlled fault injection, experiment templates, safety mechanisms
- **Video Focus**: Experiment design, fault injection types, safety configurations
- **📚 AWS Documentation**: https://docs.aws.amazon.com/fis/
- **🎥 AWS YouTube**: [AWS Fault Injection Simulator](https://www.youtube.com/watch?v=4qkSjSgW_9k)
- **🎥 Tutorial Video**: [Chaos Engineering with FIS](https://www.youtube.com/watch?v=gHJGGas_aaI)

**AWS Systems Manager - Run Command**
- **Use Case**: Execute commands across multiple instances for chaos testing
- **What Students Do**: Run network latency injection, stress testing, system manipulation
- **Key Features**: Remote command execution, document-based automation, multi-instance targeting
- **Video Focus**: Command execution, document creation, targeting strategies
- **📚 AWS Documentation**: https://docs.aws.amazon.com/systems-manager/latest/userguide/execute-remote-commands.html
- **🎥 AWS YouTube**: [Systems Manager Run Command](https://www.youtube.com/watch?v=JibXQmkJlb8)
- **🎥 Tutorial Video**: [Remote Command Execution](https://www.youtube.com/watch?v=qmtDiGFjbU4)

### Advanced Monitoring & Observability

**AWS X-Ray**
- **Use Case**: Distributed tracing and application performance monitoring
- **What Students Do**: Instrument applications, analyze traces, identify bottlenecks
- **Key Features**: Service maps, trace analysis, performance insights
- **Video Focus**: Service map interpretation, trace analysis, performance optimization
- **📚 AWS Documentation**: https://docs.aws.amazon.com/xray/
- **🎥 AWS YouTube**: [AWS X-Ray Overview](https://www.youtube.com/watch?v=n-RgqYer1L4)
- **🎥 Tutorial Video**: [X-Ray Distributed Tracing](https://www.youtube.com/watch?v=S3VudxZ3KcI)

**CloudWatch Anomaly Detection**
- **Use Case**: Machine learning-based anomaly detection
- **What Students Do**: Configure anomaly detectors, set up ML-based alarms
- **Key Features**: Automatic baseline learning, anomaly detection, predictive alerting
- **Video Focus**: Detector configuration, anomaly interpretation, alert tuning
- **📚 AWS Documentation**: https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/CloudWatch_Anomaly_Detection.html
- **🎥 AWS YouTube**: [CloudWatch Anomaly Detection](https://www.youtube.com/watch?v=AcxTbdQGKQE)
- **🎥 Tutorial Video**: [ML-based Monitoring Setup](https://www.youtube.com/watch?v=TZ3gX7gkfdI)

**CloudWatch Insights (Advanced)**
- **Use Case**: Advanced log analysis and correlation
- **What Students Do**: Create complex queries, correlate metrics with logs
- **Key Features**: Advanced querying, log correlation, pattern analysis
- **Video Focus**: Advanced query techniques, correlation analysis, pattern recognition
- **📚 AWS Documentation**: https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/AnalyzingLogData.html
- **🎥 AWS YouTube**: [Advanced CloudWatch Insights](https://www.youtube.com/watch?v=2s2xcwm8QrM)
- **🎥 Tutorial Video**: [Complex Log Analysis Queries](https://www.youtube.com/watch?v=vONjqKyYeAg)

### Load Balancing & Traffic Management

**Application Load Balancer (Advanced)**
- **Use Case**: Advanced traffic routing for blue-green deployments
- **What Students Do**: Configure multiple target groups, implement traffic shifting
- **Key Features**: Target group management, traffic routing rules, health checks
- **Video Focus**: Blue-green setup, traffic shifting, health check configuration
- **📚 AWS Documentation**: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html
- **🎥 AWS YouTube**: [Advanced ALB Features](https://www.youtube.com/watch?v=VIgAT7vjol8)
- **🎥 Tutorial Video**: [Blue-Green with Target Groups](https://www.youtube.com/watch?v=HKh54iqeuuM)

**Target Groups**
- **Use Case**: Manage application targets for load balancing
- **What Students Do**: Create blue/green target groups, configure health checks
- **Key Features**: Health monitoring, target registration, traffic distribution
- **Video Focus**: Target group creation, health check tuning, traffic management
- **📚 AWS Documentation**: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-target-groups.html
- **🎥 AWS YouTube**: [Target Groups Configuration](https://www.youtube.com/watch?v=VIgAT7vjol8)
- **🎥 Tutorial Video**: [Target Group Health Checks](https://www.youtube.com/watch?v=HKh54iqeuuM)

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

---

## 🔗 ADDITIONAL LEARNING RESOURCES

### AWS Official Resources
- **AWS Well-Architected Framework**: https://aws.amazon.com/architecture/well-architected/
- **AWS Architecture Center**: https://aws.amazon.com/architecture/
- **AWS Whitepapers**: https://aws.amazon.com/whitepapers/
- **AWS Training and Certification**: https://aws.amazon.com/training/

### Community Resources
- **AWS Samples GitHub**: https://github.com/aws-samples
- **AWS Solutions Library**: https://aws.amazon.com/solutions/
- **AWS Blogs**: https://aws.amazon.com/blogs/
- **AWS re:Invent Videos**: https://www.youtube.com/user/AmazonWebServices

This comprehensive list covers all AWS services used in both days with specific use cases, official documentation links, and curated YouTube videos for your video preparation and reference materials.
