# 📊 DAY 3 COMPLETE FLOW - Operational Excellence Part 2

## 🏗️ Architecture Overview

### Diagram
```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              AWS CLOUD                                     │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                        CI/CD Pipeline                              │   │
│  │                                                                     │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐  ┌───────────┐ │   │
│  │  │ CodeCommit  │→ │ CodeBuild   │→ │CodePipeline │→ │CloudForm. │ │   │
│  │  │             │  │             │  │             │  │           │ │   │
│  │  │ Source Code │  │ Build &     │  │ Orchestrate │  │ Deploy    │ │   │
│  │  │ Repository  │  │ Test        │  │ Pipeline    │  │ Infra     │ │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘  └───────────┘ │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                   │                                         │
│                                   ▼                                         │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                    Auto Scaling Group                              │   │
│  │                                                                     │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐                │   │
│  │  │   EC2       │  │   EC2       │  │   EC2       │                │   │
│  │  │ Instance 1  │  │ Instance 2  │  │ Instance 3  │                │   │
│  │  │             │  │             │  │             │                │   │
│  │  │ ┌─────────┐ │  │ ┌─────────┐ │  │ ┌─────────┐ │                │   │
│  │  │ │SSM Agent│ │  │ │SSM Agent│ │  │ │SSM Agent│ │                │   │
│  │  │ └─────────┘ │  │ └─────────┘ │  │ └─────────┘ │                │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘                │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                   │                                         │
│                                   ▼                                         │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │                  Systems Manager                                   │   │
│  │                                                                     │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐                │   │
│  │  │ Automation  │  │ Patch       │  │ Parameter   │                │   │
│  │  │ Documents   │  │ Manager     │  │ Store       │                │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘                │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
│                                   │                                         │
│                                   ▼                                         │
│  ┌─────────────────────────────────────────────────────────────────────┐   │
│  │              Chaos Engineering & Self-Healing                      │   │
│  │                                                                     │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐                │   │
│  │  │AWS Fault    │  │ Lambda      │  │ CloudWatch  │                │   │
│  │  │Injection    │→ │ Recovery    │← │ Alarms      │                │   │
│  │  │Simulator    │  │ Functions   │  │             │                │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘                │   │
│  └─────────────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Step by Step Explanation

1. **CI/CD Pipeline Setup**
   - CodeCommit repository for source code
   - CodeBuild for automated testing and building
   - CodePipeline for orchestrating deployment
   - CloudFormation for infrastructure deployment

2. **Systems Manager Automation**
   - Automated patch management across instances
   - Parameter Store for configuration management
   - Automation documents for operational tasks
   - Session Manager for secure access

3. **Chaos Engineering Implementation**
   - AWS Fault Injection Simulator for controlled failures
   - Lambda functions for automated recovery
   - CloudWatch alarms for failure detection
   - Self-healing mechanisms

### AWS Services We Will Use

| Service | Purpose | Project |
|---------|---------|---------|
| **Systems Manager** | Automation, patching, parameters | Project 1 |
| **CodeCommit** | Source code repository | Project 2 |
| **CodeBuild** | Build and test automation | Project 2 |
| **CodePipeline** | CI/CD orchestration | Project 2 |
| **Auto Scaling** | Dynamic scaling | All Projects |
| **AWS FIS** | Fault injection testing | Project 3 |
| **Lambda** | Automated recovery functions | Project 3 |
| **CloudWatch** | Monitoring and alerting | All Projects |
| **CloudFormation** | Infrastructure as Code | All Projects |

---

## 🚀 Deployment Stage - Hands On

### Pre-requisites for Deployment

#### AWS Account Requirements
- [ ] Day 2 infrastructure still running
- [ ] Systems Manager permissions
- [ ] CodeCommit, CodeBuild, CodePipeline access
- [ ] AWS Fault Injection Simulator permissions
- [ ] Auto Scaling Group permissions

#### Repository Structure
```
DAY-3-JIM/
├── scripts/
│   ├── setup-systems-manager.sh
│   ├── create-automation-document.sh
│   ├── chaos-recovery-lambda.py
│   └── self-healing-setup.sh
├── templates/
│   ├── cicd-pipeline.yaml
│   ├── auto-scaling-group.yaml
│   └── chaos-engineering.yaml
├── configs/
│   ├── patch-baseline.json
│   ├── automation-document.yaml
│   └── fis-experiment.json
└── buildspec.yml
```

### Step by Step Deployment

#### Project 1: Systems Manager Automation (90 minutes)

**Step 1: Setup Automation Documents (30 minutes)**
```yaml
# automation-document.yaml
schemaVersion: '0.3'
description: Automated patch management and system maintenance
assumeRole: '{{ AutomationAssumeRole }}'
parameters:
  InstanceIds:
    type: StringList
    description: EC2 Instance IDs to patch
  AutomationAssumeRole:
    type: String
    description: IAM role for automation
mainSteps:
  - name: PatchInstances
    action: 'aws:runCommand'
    inputs:
      DocumentName: AWS-RunPatchBaseline
      InstanceIds: '{{ InstanceIds }}'
      Parameters:
        Operation: Install
  - name: RebootInstances
    action: 'aws:runCommand'
    inputs:
      DocumentName: AWS-RebootEC2Instance
      InstanceIds: '{{ InstanceIds }}'
  - name: VerifyPatching
    action: 'aws:runCommand'
    inputs:
      DocumentName: AWS-RunShellScript
      InstanceIds: '{{ InstanceIds }}'
      Parameters:
        commands:
          - yum list installed | grep -i security
          - systemctl status httpd
```

**Step 2: Configure Patch Management (30 minutes)**
```bash
#!/bin/bash
# setup-systems-manager.sh

# Create patch baseline
aws ssm create-patch-baseline \
    --name "Day3-PatchBaseline" \
    --operating-system "AMAZON_LINUX_2" \
    --approval-rules 'PatchRules=[{PatchFilterGroup={PatchFilters=[{Key=CLASSIFICATION,Values=[Security,Bugfix,Critical]}]},ApproveAfterDays=0}]' \
    --description "Day 3 patch baseline for security and critical updates"

# Create patch group
aws ssm register-patch-baseline-for-patch-group \
    --baseline-id pb-1234567890abcdef0 \
    --patch-group "Day3-WebServers"

# Create maintenance window
aws ssm create-maintenance-window \
    --name "Day3-MaintenanceWindow" \
    --description "Automated patching window" \
    --duration 4 \
    --cutoff 1 \
    --schedule "cron(0 2 ? * SUN *)" \
    --allow-unassociated-targets

# Register targets
aws ssm register-target-with-maintenance-window \
    --window-id mw-1234567890abcdef0 \
    --target-type "Instance" \
    --targets "Key=tag:PatchGroup,Values=Day3-WebServers"
```

**Step 3: Parameter Store Configuration (30 minutes)**
```bash
# Store configuration parameters
aws ssm put-parameter \
    --name "/day3/app/database-url" \
    --value "mysql://localhost:3306/app" \
    --type "String" \
    --description "Application database URL"

aws ssm put-parameter \
    --name "/day3/app/api-key" \
    --value "your-secret-api-key" \
    --type "SecureString" \
    --description "Application API key"

# Create automation document
aws ssm create-document \
    --content file://automation-document.yaml \
    --name "Day3-AutomatedMaintenance" \
    --document-type "Automation" \
    --document-format "YAML"
```

#### Project 2: CI/CD Pipeline with Monitoring (90 minutes)

**Step 1: Create CodeCommit Repository (15 minutes)**
```bash
# Create repository
aws codecommit create-repository \
    --repository-name day3-webapp \
    --repository-description "Day 3 web application"

# Clone and setup
git clone https://git-codecommit.us-east-1.amazonaws.com/v1/repos/day3-webapp
cd day3-webapp

# Create sample application
cat > index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Day 3 - CI/CD Pipeline</title>
</head>
<body>
    <h1>Automated Deployment Success!</h1>
    <p>Version: 1.0.0</p>
    <p>Deployed: $(date)</p>
</body>
</html>
EOF
```

**Step 2: Create Build Specification (15 minutes)**
```yaml
# buildspec.yml
version: 0.2
phases:
  install:
    runtime-versions:
      nodejs: 14
  pre_build:
    commands:
      - echo Logging in to Amazon ECR...
      - aws --version
  build:
    commands:
      - echo Build started on `date`
      - echo Running tests...
      - # Add your test commands here
      - echo Build completed on `date`
  post_build:
    commands:
      - echo Build completed on `date`
      - echo Preparing artifacts...
artifacts:
  files:
    - '**/*'
  name: day3-webapp-$(date +%Y-%m-%d)
```

**Step 3: Create CI/CD Pipeline (60 minutes)**
```yaml
# cicd-pipeline.yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: 'Day 3 - CI/CD Pipeline with monitoring'

Resources:
  # S3 Bucket for artifacts
  ArtifactsBucket:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: !Sub 'day3-pipeline-artifacts-${AWS::AccountId}'
      VersioningConfiguration:
        Status: Enabled

  # CodeBuild Project
  BuildProject:
    Type: AWS::CodeBuild::Project
    Properties:
      Name: day3-webapp-build
      ServiceRole: !GetAtt CodeBuildRole.Arn
      Artifacts:
        Type: CODEPIPELINE
      Environment:
        Type: LINUX_CONTAINER
        ComputeType: BUILD_GENERAL1_SMALL
        Image: aws/codebuild/amazonlinux2-x86_64-standard:3.0
      Source:
        Type: CODEPIPELINE
        BuildSpec: |
          version: 0.2
          phases:
            install:
              runtime-versions:
                nodejs: 14
            pre_build:
              commands:
                - echo Logging in to Amazon ECR...
            build:
              commands:
                - echo Build started on `date`
                - echo Running tests...
                - npm test || echo "No tests found"
            post_build:
              commands:
                - echo Build completed on `date`
          artifacts:
            files:
              - '**/*'

  # CodePipeline
  Pipeline:
    Type: AWS::CodePipeline::Pipeline
    Properties:
      Name: day3-webapp-pipeline
      RoleArn: !GetAtt CodePipelineRole.Arn
      ArtifactStore:
        Type: S3
        Location: !Ref ArtifactsBucket
      Stages:
        - Name: Source
          Actions:
            - Name: SourceAction
              ActionTypeId:
                Category: Source
                Owner: AWS
                Provider: CodeCommit
                Version: '1'
              Configuration:
                RepositoryName: day3-webapp
                BranchName: main
              OutputArtifacts:
                - Name: SourceOutput
        - Name: Build
          Actions:
            - Name: BuildAction
              ActionTypeId:
                Category: Build
                Owner: AWS
                Provider: CodeBuild
                Version: '1'
              Configuration:
                ProjectName: !Ref BuildProject
              InputArtifacts:
                - Name: SourceOutput
              OutputArtifacts:
                - Name: BuildOutput
        - Name: Deploy
          Actions:
            - Name: DeployAction
              ActionTypeId:
                Category: Deploy
                Owner: AWS
                Provider: CloudFormation
                Version: '1'
              Configuration:
                ActionMode: CREATE_UPDATE
                StackName: day3-webapp-stack
                TemplatePath: BuildOutput::infrastructure.yaml
                Capabilities: CAPABILITY_IAM
                RoleArn: !GetAtt CloudFormationRole.Arn
              InputArtifacts:
                - Name: BuildOutput

  # IAM Roles (simplified)
  CodeBuildRole:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: codebuild.amazonaws.com
            Action: sts:AssumeRole
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/CloudWatchLogsFullAccess
        - arn:aws:iam::aws:policy/AmazonS3FullAccess
```

#### Project 3: Chaos Engineering & Self-Healing (90 minutes)

**Step 1: Setup Fault Injection Simulator (30 minutes)**
```json
{
  "description": "Day 3 - EC2 instance failure simulation",
  "targets": {
    "ec2-instances": {
      "resourceType": "aws:ec2:instance",
      "resourceTags": {
        "Project": "Day3-ChaosEngineering"
      },
      "selectionMode": "PERCENT(50)"
    }
  },
  "actions": {
    "stop-instances": {
      "actionId": "aws:ec2:stop-instances",
      "parameters": {
        "startInstancesAfterDuration": "PT10M"
      },
      "targets": {
        "Instances": "ec2-instances"
      }
    }
  },
  "stopConditions": [
    {
      "source": "aws:cloudwatch:alarm",
      "value": "arn:aws:cloudwatch:us-east-1:123456789012:alarm:Day3-HighErrorRate"
    }
  ],
  "roleArn": "arn:aws:iam::123456789012:role/FISRole"
}
```

**Step 2: Create Self-Healing Lambda (30 minutes)**
```python
# chaos-recovery-lambda.py
import json
import boto3
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    """
    Automated recovery function for chaos engineering
    """
    
    # Initialize AWS clients
    ec2 = boto3.client('ec2')
    autoscaling = boto3.client('autoscaling')
    cloudwatch = boto3.client('cloudwatch')
    
    try:
        # Parse CloudWatch alarm event
        message = json.loads(event['Records'][0]['Sns']['Message'])
        alarm_name = message['AlarmName']
        
        logger.info(f"Processing alarm: {alarm_name}")
        
        if 'HighCPU' in alarm_name:
            # Scale out Auto Scaling Group
            response = autoscaling.set_desired_capacity(
                AutoScalingGroupName='day3-webapp-asg',
                DesiredCapacity=4,
                HonorCooldown=False
            )
            logger.info("Scaled out ASG due to high CPU")
            
        elif 'InstanceFailure' in alarm_name:
            # Replace failed instances
            response = autoscaling.set_desired_capacity(
                AutoScalingGroupName='day3-webapp-asg',
                DesiredCapacity=3,
                HonorCooldown=False
            )
            logger.info("Replaced failed instances")
            
        elif 'HighErrorRate' in alarm_name:
            # Trigger deployment rollback
            codedeploy = boto3.client('codedeploy')
            response = codedeploy.stop_deployment(
                deploymentId='d-1234567890',
                autoRollbackEnabled=True
            )
            logger.info("Triggered deployment rollback")
        
        # Send success metric
        cloudwatch.put_metric_data(
            Namespace='Day3/SelfHealing',
            MetricData=[
                {
                    'MetricName': 'RecoveryActions',
                    'Value': 1,
                    'Unit': 'Count'
                }
            ]
        )
        
        return {
            'statusCode': 200,
            'body': json.dumps('Recovery action completed successfully')
        }
        
    except Exception as e:
        logger.error(f"Recovery failed: {str(e)}")
        
        # Send failure metric
        cloudwatch.put_metric_data(
            Namespace='Day3/SelfHealing',
            MetricData=[
                {
                    'MetricName': 'RecoveryFailures',
                    'Value': 1,
                    'Unit': 'Count'
                }
            ]
        )
        
        return {
            'statusCode': 500,
            'body': json.dumps(f'Recovery failed: {str(e)}')
        }
```

**Step 3: Execute Chaos Experiments (30 minutes)**
```bash
# Create FIS experiment
aws fis create-experiment-template \
    --cli-input-json file://fis-experiment.json

# Start experiment
EXPERIMENT_ID=$(aws fis start-experiment \
    --experiment-template-id EXT1234567890abcdef0 \
    --query 'experiment.id' \
    --output text)

echo "Started chaos experiment: $EXPERIMENT_ID"

# Monitor experiment
aws fis get-experiment --id $EXPERIMENT_ID

# Check self-healing metrics
aws cloudwatch get-metric-statistics \
    --namespace Day3/SelfHealing \
    --metric-name RecoveryActions \
    --start-time $(date -u -d '1 hour ago' +%Y-%m-%dT%H:%M:%S) \
    --end-time $(date -u +%Y-%m-%dT%H:%M:%S) \
    --period 300 \
    --statistics Sum
```

---

## 📝 Knowledge Check - Day 3 (10 Questions)

### Question 1: Systems Manager
**What is the primary purpose of AWS Systems Manager Automation Documents?**

A) To store application configuration  
B) To automate operational tasks across AWS resources  
C) To monitor system performance  
D) To manage user access  

**Answer: B**

### Question 2: CI/CD Pipeline
**In a CodePipeline, what is the correct order of stages?**

A) Build → Source → Deploy  
B) Source → Deploy → Build  
C) Source → Build → Deploy  
D) Deploy → Build → Source  

**Answer: C**

### Question 3: Chaos Engineering
**What is the main goal of chaos engineering?**

A) To break production systems  
B) To test system resilience by introducing controlled failures  
C) To reduce system costs  
D) To improve system performance  

**Answer: B**

### Question 4: Auto Scaling
**Which metric would trigger scaling out in an Auto Scaling Group?**

A) Low CPU utilization  
B) High CPU utilization  
C) Low network traffic  
D) High available memory  

**Answer: B**

### Question 5: Parameter Store
**What type of parameter should you use for storing sensitive data like API keys?**

A) String  
B) StringList  
C) SecureString  
D) Binary  

**Answer: C**

### Question 6: Fault Injection Simulator
**What is a stop condition in AWS FIS?**

A) A condition that starts the experiment  
B) A condition that automatically stops the experiment if met  
C) A condition that pauses the experiment  
D) A condition that restarts the experiment  

**Answer: B**

### Question 7: Self-Healing Systems
**Which AWS service is commonly used to implement automated recovery actions?**

A) EC2  
B) S3  
C) Lambda  
D) RDS  

**Answer: C**

### Question 8: Infrastructure as Code
**What is the benefit of including monitoring in CloudFormation templates?**

A) Reduces costs  
B) Improves performance  
C) Ensures consistent monitoring across deployments  
D) Simplifies user management  

**Answer: C**

### Question 9: Patch Management
**How often should security patches be applied in a production environment?**

A) Monthly  
B) Quarterly  
C) As soon as possible after testing  
D) Only when systems fail  

**Answer: C**

### Question 10: Operational Excellence
**What is the key principle of operational excellence in the cloud?**

A) Minimize costs at all times  
B) Continuously improve processes and procedures  
C) Use only managed services  
D) Avoid automation  

**Answer: B**

---

**Scoring:**
- 9-10 correct: Excellent mastery of advanced operational excellence
- 7-8 correct: Good understanding, minor review needed
- 5-6 correct: Adequate, focus on weak areas
- Below 5: Review Day 3 materials and repeat exercises
