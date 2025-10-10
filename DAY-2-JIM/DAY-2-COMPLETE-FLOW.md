# 📊 DAY 2 COMPLETE FLOW - Operational Excellence Part 1

## 🏗️ Architecture Overview

### Diagram
```
┌─────────────────────────────────────────────────────────────────┐
│                        AWS CLOUD                               │
│                                                                 │
│  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────┐ │
│  │   EC2 Instance  │    │   EC2 Instance  │    │   Lambda    │ │
│  │                 │    │                 │    │  Function   │ │
│  │ ┌─────────────┐ │    │ ┌─────────────┐ │    │             │ │
│  │ │ CW Agent    │ │    │ │ CW Agent    │ │    │ Log         │ │
│  │ │             │ │    │ │             │ │    │ Analysis    │ │
│  │ └─────────────┘ │    │ └─────────────┘ │    │             │ │
│  │ ┌─────────────┐ │    │ ┌─────────────┐ │    └─────────────┘ │
│  │ │ Apache      │ │    │ │ Nginx       │ │           │        │
│  │ │ Web Server  │ │    │ │ Web Server  │ │           │        │
│  │ └─────────────┘ │    │ └─────────────┘ │           │        │
│  └─────────────────┘    └─────────────────┘           │        │
│           │                       │                   │        │
│           └───────────────────────┼───────────────────┘        │
│                                   │                            │
│  ┌─────────────────────────────────┼─────────────────────────┐  │
│  │              CloudWatch         │                         │  │
│  │                                 │                         │  │
│  │  ┌─────────────┐  ┌─────────────┼─────────────┐          │  │
│  │  │   Metrics   │  │    Logs     │             │          │  │
│  │  │             │  │             │             │          │  │
│  │  │ • CPU       │  │ • Apache    │  ┌─────────┐│          │  │
│  │  │ • Memory    │  │ • System    │  │ Alarms  ││          │  │
│  │  │ • Disk      │  │ • Custom    │  │         ││          │  │
│  │  │ • Network   │  │             │  └─────────┘│          │  │
│  │  └─────────────┘  └─────────────┘             │          │  │
│  │                                                │          │  │
│  │  ┌─────────────────────────────────────────────┼────────┐ │  │
│  │  │              Dashboard                      │        │ │  │
│  │  │                                             │        │ │  │
│  │  │  [CPU Graph] [Memory Graph] [Log Insights] │        │ │  │
│  │  │                                             │        │ │  │
│  │  └─────────────────────────────────────────────┘        │ │  │
│  └─────────────────────────────────────────────────────────┘  │
│                                   │                            │
│  ┌─────────────────────────────────┼─────────────────────────┐  │
│  │                SNS              │                         │  │
│  │                                 │                         │  │
│  │  ┌─────────────┐               │                         │  │
│  │  │   Topic     │◄──────────────┘                         │  │
│  │  │             │                                          │  │
│  │  └─────────────┘                                          │  │
│  │         │                                                 │  │
│  │         ▼                                                 │  │
│  │  ┌─────────────┐                                          │  │
│  │  │   Email     │                                          │  │
│  │  │ Notification│                                          │  │
│  │  └─────────────┘                                          │  │
│  └─────────────────────────────────────────────────────────┘  │
│                                                                 │
│  ┌─────────────────────────────────────────────────────────┐   │
│  │              CloudFormation                             │   │
│  │                                                         │   │
│  │  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐     │   │
│  │  │Infrastructure│  │ Monitoring  │  │ Automation  │     │   │
│  │  │   Template  │  │  Template   │  │  Template   │     │   │
│  │  └─────────────┘  └─────────────┘  └─────────────┘     │   │
│  └─────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────┘
```

### Step by Step Explanation

1. **EC2 Instances Setup**
   - Launch 2 EC2 instances (Web Server 1 & 2)
   - Install CloudWatch Agent on both instances
   - Configure Apache/Nginx web servers
   - Set up log forwarding to CloudWatch

2. **CloudWatch Configuration**
   - Create custom metrics for application performance
   - Set up log groups for system and application logs
   - Configure CloudWatch Insights for log analysis
   - Create alarms for critical thresholds

3. **Automated Analysis**
   - Deploy Lambda function for log pattern analysis
   - Set up automated alerting based on log patterns
   - Configure SNS for notification delivery
   - Create dashboard for real-time monitoring

4. **Infrastructure as Code**
   - Create CloudFormation templates
   - Integrate monitoring into infrastructure code
   - Set up automated deployment pipeline
   - Configure self-healing mechanisms

### AWS Services We Will Use

| Service | Purpose | Project |
|---------|---------|---------|
| **EC2** | Web server hosting | All Projects |
| **CloudWatch** | Metrics, logs, alarms, dashboards | All Projects |
| **CloudWatch Agent** | Custom metrics collection | Project 1 |
| **CloudWatch Logs** | Centralized logging | Project 2 |
| **CloudWatch Insights** | Log querying and analysis | Project 2 |
| **Lambda** | Automated log analysis | Project 2 |
| **SNS** | Notification delivery | All Projects |
| **CloudFormation** | Infrastructure as Code | Project 3 |
| **IAM** | Permissions and roles | All Projects |
| **Systems Manager** | Parameter storage | Project 3 |

---

## 🚀 Deployment Stage - Hands On

### Pre-requisites for Deployment

#### AWS Account Requirements
- [ ] AWS Account with administrative access
- [ ] AWS CLI installed and configured
- [ ] EC2 key pair created
- [ ] Default VPC available
- [ ] Sufficient service limits (2 EC2 instances minimum)

#### Local Environment
- [ ] Git installed
- [ ] Text editor (VS Code recommended)
- [ ] SSH client
- [ ] Web browser for AWS Console

#### Knowledge Prerequisites
- [ ] Basic Linux command line
- [ ] Understanding of JSON/YAML
- [ ] Basic networking concepts
- [ ] AWS Console navigation

### Repository Structure
```
DAY-2-JIM/
├── scripts/
│   ├── install-cloudwatch-agent.sh
│   ├── configure-apache.sh
│   ├── setup-logging.sh
│   └── lambda-log-analysis.py
├── templates/
│   ├── ec2-with-monitoring.yaml
│   ├── cloudwatch-dashboard.json
│   └── complete-infrastructure.yaml
├── configs/
│   ├── cloudwatch-agent-config.json
│   ├── apache-log-config.conf
│   └── alarm-definitions.json
└── docs/
    ├── troubleshooting.md
    └── best-practices.md
```

### Step by Step Deployment

#### Project 1: CloudWatch Monitoring Setup (90 minutes)

**Step 1: Launch EC2 Instances (15 minutes)**
```bash
# Create security group
aws ec2 create-security-group \
    --group-name day2-web-servers \
    --description "Security group for Day 2 web servers"

# Add HTTP and SSH rules
aws ec2 authorize-security-group-ingress \
    --group-name day2-web-servers \
    --protocol tcp \
    --port 80 \
    --cidr 0.0.0.0/0

aws ec2 authorize-security-group-ingress \
    --group-name day2-web-servers \
    --protocol tcp \
    --port 22 \
    --cidr 0.0.0.0/0

# Launch instances
aws ec2 run-instances \
    --image-id ami-0abcdef1234567890 \
    --count 2 \
    --instance-type t3.micro \
    --key-name your-key-pair \
    --security-groups day2-web-servers \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=WebServer1},{Key=Project,Value=Day2-Monitoring}]'
```

**Step 2: Install CloudWatch Agent (20 minutes)**
```bash
#!/bin/bash
# install-cloudwatch-agent.sh

# Download and install CloudWatch Agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
sudo rpm -U ./amazon-cloudwatch-agent.rpm

# Create CloudWatch Agent configuration
sudo tee /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json > /dev/null <<EOF
{
    "metrics": {
        "namespace": "Day2/WebServers",
        "metrics_collected": {
            "cpu": {
                "measurement": ["cpu_usage_idle", "cpu_usage_iowait", "cpu_usage_user", "cpu_usage_system"],
                "metrics_collection_interval": 60
            },
            "disk": {
                "measurement": ["used_percent"],
                "metrics_collection_interval": 60,
                "resources": ["*"]
            },
            "mem": {
                "measurement": ["mem_used_percent"],
                "metrics_collection_interval": 60
            }
        }
    },
    "logs": {
        "logs_collected": {
            "files": {
                "collect_list": [
                    {
                        "file_path": "/var/log/httpd/access_log",
                        "log_group_name": "day2-apache-access",
                        "log_stream_name": "{instance_id}"
                    },
                    {
                        "file_path": "/var/log/httpd/error_log",
                        "log_group_name": "day2-apache-error",
                        "log_stream_name": "{instance_id}"
                    }
                ]
            }
        }
    }
}
EOF

# Start CloudWatch Agent
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -a fetch-config \
    -m ec2 \
    -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
    -s
```

**Step 3: Configure Apache Web Server (15 minutes)**
```bash
#!/bin/bash
# configure-apache.sh

# Install Apache
sudo yum update -y
sudo yum install -y httpd

# Create custom index page
sudo tee /var/www/html/index.html > /dev/null <<EOF
<!DOCTYPE html>
<html>
<head>
    <title>Day 2 - Web Server Monitoring</title>
</head>
<body>
    <h1>Welcome to Day 2 Monitoring Lab</h1>
    <p>Server: $(hostname)</p>
    <p>Time: $(date)</p>
    <script>
        // Generate some load for monitoring
        setInterval(function() {
            fetch('/health-check')
                .then(response => console.log('Health check:', response.status))
                .catch(error => console.error('Error:', error));
        }, 30000);
    </script>
</body>
</html>
EOF

# Configure Apache logging
sudo tee -a /etc/httpd/conf/httpd.conf > /dev/null <<EOF
# Custom log format for better monitoring
LogFormat "%h %l %u %t \"%r\" %>s %O \"%{Referer}i\" \"%{User-Agent}i\" %D" combined_with_time
CustomLog logs/access_log combined_with_time
EOF

# Start Apache
sudo systemctl start httpd
sudo systemctl enable httpd
```

**Step 4: Create CloudWatch Dashboard (20 minutes)**
```json
{
    "widgets": [
        {
            "type": "metric",
            "properties": {
                "metrics": [
                    ["Day2/WebServers", "cpu_usage_active", "InstanceId", "i-1234567890abcdef0"],
                    [".", ".", ".", "i-0987654321fedcba0"]
                ],
                "period": 300,
                "stat": "Average",
                "region": "us-east-1",
                "title": "CPU Utilization"
            }
        },
        {
            "type": "metric",
            "properties": {
                "metrics": [
                    ["Day2/WebServers", "mem_used_percent", "InstanceId", "i-1234567890abcdef0"],
                    [".", ".", ".", "i-0987654321fedcba0"]
                ],
                "period": 300,
                "stat": "Average",
                "region": "us-east-1",
                "title": "Memory Utilization"
            }
        },
        {
            "type": "log",
            "properties": {
                "query": "SOURCE 'day2-apache-access'\n| fields @timestamp, @message\n| filter @message like /ERROR/\n| sort @timestamp desc\n| limit 20",
                "region": "us-east-1",
                "title": "Recent Apache Errors"
            }
        }
    ]
}
```

**Step 5: Set Up Alarms (20 minutes)**
```bash
# Create CPU alarm
aws cloudwatch put-metric-alarm \
    --alarm-name "Day2-HighCPU" \
    --alarm-description "Alarm when CPU exceeds 70%" \
    --metric-name cpu_usage_active \
    --namespace Day2/WebServers \
    --statistic Average \
    --period 300 \
    --threshold 70 \
    --comparison-operator GreaterThanThreshold \
    --evaluation-periods 2

# Create memory alarm
aws cloudwatch put-metric-alarm \
    --alarm-name "Day2-HighMemory" \
    --alarm-description "Alarm when memory exceeds 80%" \
    --metric-name mem_used_percent \
    --namespace Day2/WebServers \
    --statistic Average \
    --period 300 \
    --threshold 80 \
    --comparison-operator GreaterThanThreshold \
    --evaluation-periods 2
```

#### Project 2: Automated Log Analysis (90 minutes)

**Step 1: Lambda Function for Log Analysis (30 minutes)**
```python
# lambda-log-analysis.py
import json
import boto3
import re
from datetime import datetime

def lambda_handler(event, context):
    """
    Analyze CloudWatch Logs for patterns and anomalies
    """
    
    # Initialize clients
    logs_client = boto3.client('logs')
    sns_client = boto3.client('sns')
    
    # Configuration
    LOG_GROUP = 'day2-apache-access'
    SNS_TOPIC_ARN = 'arn:aws:sns:us-east-1:123456789012:day2-alerts'
    
    try:
        # Query logs for error patterns
        query = """
        fields @timestamp, @message
        | filter @message like /ERROR/ or @message like /5\d\d/
        | stats count() by bin(5m)
        """
        
        # Start query
        start_query_response = logs_client.start_query(
            logGroupName=LOG_GROUP,
            startTime=int((datetime.now().timestamp() - 3600) * 1000),  # Last hour
            endTime=int(datetime.now().timestamp() * 1000),
            queryString=query
        )
        
        query_id = start_query_response['queryId']
        
        # Wait for query completion (simplified)
        import time
        time.sleep(10)
        
        # Get results
        results = logs_client.get_query_results(queryId=query_id)
        
        # Analyze results
        error_count = 0
        for result in results['results']:
            for field in result:
                if field['field'] == 'count' and int(field['value']) > 10:
                    error_count += int(field['value'])
        
        # Send alert if threshold exceeded
        if error_count > 50:
            message = f"High error rate detected: {error_count} errors in the last hour"
            
            sns_client.publish(
                TopicArn=SNS_TOPIC_ARN,
                Message=message,
                Subject="Day 2 - High Error Rate Alert"
            )
            
            return {
                'statusCode': 200,
                'body': json.dumps(f'Alert sent: {message}')
            }
        
        return {
            'statusCode': 200,
            'body': json.dumps(f'Analysis complete. Error count: {error_count}')
        }
        
    except Exception as e:
        print(f"Error: {str(e)}")
        return {
            'statusCode': 500,
            'body': json.dumps(f'Error: {str(e)}')
        }
```

**Step 2: CloudWatch Insights Queries (30 minutes)**
```sql
-- Query 1: Top 10 IP addresses by request count
fields @timestamp, @message
| filter @message like /\d+\.\d+\.\d+\.\d+/
| parse @message /^(?<ip>\d+\.\d+\.\d+\.\d+)/
| stats count() as request_count by ip
| sort request_count desc
| limit 10

-- Query 2: Response time analysis
fields @timestamp, @message
| filter @message like /\d+$/
| parse @message /(?<response_time>\d+)$/
| stats avg(response_time), max(response_time), min(response_time) by bin(5m)

-- Query 3: Error rate over time
fields @timestamp, @message
| filter @message like /HTTP\/1\.[01]" [45]\d\d/
| stats count() as error_count by bin(5m)
| sort @timestamp desc
```

**Step 3: Automated Alerting Setup (30 minutes)**
```bash
# Create SNS topic
aws sns create-topic --name day2-alerts

# Subscribe email to topic
aws sns subscribe \
    --topic-arn arn:aws:sns:us-east-1:123456789012:day2-alerts \
    --protocol email \
    --notification-endpoint your-email@example.com

# Create EventBridge rule for log analysis
aws events put-rule \
    --name day2-log-analysis \
    --schedule-expression "rate(5 minutes)"

# Add Lambda target to rule
aws events put-targets \
    --rule day2-log-analysis \
    --targets "Id"="1","Arn"="arn:aws:lambda:us-east-1:123456789012:function:day2-log-analyzer"
```

#### Project 3: Infrastructure as Code (90 minutes)

**Step 1: Complete Infrastructure Template (45 minutes)**
```yaml
# complete-infrastructure.yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: 'Day 2 - Complete monitoring infrastructure'

Parameters:
  KeyPairName:
    Type: AWS::EC2::KeyPair::KeyName
    Description: EC2 Key Pair for SSH access
  
  NotificationEmail:
    Type: String
    Description: Email for alerts
    Default: admin@example.com

Resources:
  # VPC and Networking
  VPC:
    Type: AWS::EC2::VPC
    Properties:
      CidrBlock: 10.0.0.0/16
      EnableDnsHostnames: true
      EnableDnsSupport: true
      Tags:
        - Key: Name
          Value: Day2-VPC

  PublicSubnet:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref VPC
      CidrBlock: 10.0.1.0/24
      AvailabilityZone: !Select [0, !GetAZs '']
      MapPublicIpOnLaunch: true
      Tags:
        - Key: Name
          Value: Day2-PublicSubnet

  InternetGateway:
    Type: AWS::EC2::InternetGateway
    Properties:
      Tags:
        - Key: Name
          Value: Day2-IGW

  AttachGateway:
    Type: AWS::EC2::VPCGatewayAttachment
    Properties:
      VpcId: !Ref VPC
      InternetGatewayId: !Ref InternetGateway

  # Security Group
  WebServerSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Security group for web servers
      VpcId: !Ref VPC
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 80
          ToPort: 80
          CidrIp: 0.0.0.0/0
        - IpProtocol: tcp
          FromPort: 22
          ToPort: 22
          CidrIp: 0.0.0.0/0

  # IAM Role for EC2
  EC2Role:
    Type: AWS::IAM::Role
    Properties:
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: ec2.amazonaws.com
            Action: sts:AssumeRole
      ManagedPolicyArns:
        - arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy
      Policies:
        - PolicyName: LogsAccess
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
              - Effect: Allow
                Action:
                  - logs:CreateLogGroup
                  - logs:CreateLogStream
                  - logs:PutLogEvents
                Resource: '*'

  EC2InstanceProfile:
    Type: AWS::IAM::InstanceProfile
    Properties:
      Roles:
        - !Ref EC2Role

  # EC2 Instances
  WebServer1:
    Type: AWS::EC2::Instance
    Properties:
      ImageId: ami-0abcdef1234567890
      InstanceType: t3.micro
      KeyName: !Ref KeyPairName
      SecurityGroupIds:
        - !Ref WebServerSecurityGroup
      SubnetId: !Ref PublicSubnet
      IamInstanceProfile: !Ref EC2InstanceProfile
      UserData:
        Fn::Base64: !Sub |
          #!/bin/bash
          yum update -y
          yum install -y httpd
          systemctl start httpd
          systemctl enable httpd
          
          # Install CloudWatch Agent
          wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
          rpm -U ./amazon-cloudwatch-agent.rpm
          
          # Configure and start agent
          /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
            -a fetch-config \
            -m ec2 \
            -c ssm:${CloudWatchAgentConfig} \
            -s
      Tags:
        - Key: Name
          Value: Day2-WebServer1

  # SNS Topic for Alerts
  AlertTopic:
    Type: AWS::SNS::Topic
    Properties:
      TopicName: day2-alerts
      Subscription:
        - Protocol: email
          Endpoint: !Ref NotificationEmail

  # CloudWatch Alarms
  HighCPUAlarm:
    Type: AWS::CloudWatch::Alarm
    Properties:
      AlarmName: Day2-HighCPU
      AlarmDescription: Alarm when CPU exceeds 70%
      MetricName: CPUUtilization
      Namespace: AWS/EC2
      Statistic: Average
      Period: 300
      EvaluationPeriods: 2
      Threshold: 70
      ComparisonOperator: GreaterThanThreshold
      Dimensions:
        - Name: InstanceId
          Value: !Ref WebServer1
      AlarmActions:
        - !Ref AlertTopic

Outputs:
  WebServer1PublicIP:
    Description: Public IP of Web Server 1
    Value: !GetAtt WebServer1.PublicIp
  
  DashboardURL:
    Description: CloudWatch Dashboard URL
    Value: !Sub 'https://console.aws.amazon.com/cloudwatch/home?region=${AWS::Region}#dashboards:name=Day2-Dashboard'
```

**Step 2: Deploy and Test (45 minutes)**
```bash
# Deploy the stack
aws cloudformation create-stack \
    --stack-name day2-monitoring-stack \
    --template-body file://complete-infrastructure.yaml \
    --parameters ParameterKey=KeyPairName,ParameterValue=your-key-pair \
                 ParameterKey=NotificationEmail,ParameterValue=your-email@example.com \
    --capabilities CAPABILITY_IAM

# Wait for stack completion
aws cloudformation wait stack-create-complete \
    --stack-name day2-monitoring-stack

# Test the deployment
curl http://$(aws cloudformation describe-stacks \
    --stack-name day2-monitoring-stack \
    --query 'Stacks[0].Outputs[?OutputKey==`WebServer1PublicIP`].OutputValue' \
    --output text)
```

---

## 📝 Knowledge Check - Day 2 (10 Questions)

### Question 1: CloudWatch Fundamentals
**What is the difference between CloudWatch Metrics and CloudWatch Logs?**

A) Metrics are for numerical data, Logs are for text-based data  
B) Metrics are free, Logs cost money  
C) Metrics are real-time, Logs are batch processed  
D) There is no difference  

**Answer: A** - Metrics collect numerical data points over time, while Logs collect text-based log entries.

### Question 2: CloudWatch Agent
**Which of the following metrics can the CloudWatch Agent collect that are NOT available by default?**

A) CPU Utilization  
B) Memory Utilization  
C) Network In/Out  
D) Disk Read/Write Operations  

**Answer: B** - Memory utilization requires the CloudWatch Agent; CPU and network metrics are available by default.

### Question 3: CloudWatch Alarms
**What happens when a CloudWatch Alarm enters the ALARM state?**

A) The monitored resource is automatically stopped  
B) An email is sent to all AWS account users  
C) The configured alarm actions are triggered  
D) The alarm is automatically deleted  

**Answer: C** - Alarm actions (like SNS notifications) are triggered when an alarm enters the ALARM state.

### Question 4: Log Insights
**Which CloudWatch Logs Insights query would find all ERROR entries in the last hour?**

A) `fields @timestamp | filter @message = "ERROR"`  
B) `fields @timestamp, @message | filter @message like /ERROR/`  
C) `SELECT * FROM logs WHERE message CONTAINS "ERROR"`  
D) `grep ERROR @message`  

**Answer: B** - CloudWatch Logs Insights uses a specific query syntax with `filter` and `like` operators.

### Question 5: Infrastructure as Code
**In CloudFormation, what is the purpose of the UserData property in an EC2 instance?**

A) To specify the user who owns the instance  
B) To provide scripts that run when the instance starts  
C) To set the instance's metadata  
D) To configure the instance's security groups  

**Answer: B** - UserData contains scripts or commands that execute during instance initialization.

### Question 6: SNS Integration
**How do you configure CloudWatch Alarms to send notifications via email?**

A) Add email addresses directly to the alarm configuration  
B) Create an SNS topic, subscribe email to it, then reference the topic in the alarm  
C) Use CloudWatch Events to trigger email notifications  
D) Configure SMTP settings in CloudWatch  

**Answer: B** - SNS topics act as intermediaries between alarms and notification endpoints like email.

### Question 7: Custom Metrics
**What is the correct namespace format for custom CloudWatch metrics?**

A) `custom/application/metric`  
B) `Custom-Application-Metric`  
C) `Application/Metric`  
D) `aws:custom:application:metric`  

**Answer: C** - Custom namespaces should not start with "AWS/" and typically use forward slashes as separators.

### Question 8: Lambda Integration
**Which AWS service would you use to automatically trigger a Lambda function when specific log patterns are detected?**

A) CloudWatch Events  
B) CloudWatch Logs Subscription Filters  
C) SNS  
D) SQS  

**Answer: B** - CloudWatch Logs Subscription Filters can trigger Lambda functions based on log patterns.

### Question 9: Monitoring Best Practices
**What is the recommended approach for monitoring application performance?**

A) Monitor only infrastructure metrics  
B) Monitor only application-specific metrics  
C) Monitor both infrastructure and application metrics  
D) Monitor only when problems occur  

**Answer: C** - Comprehensive monitoring includes both infrastructure (CPU, memory) and application-specific metrics.

### Question 10: Cost Optimization
**Which of the following helps reduce CloudWatch costs?**

A) Increasing metric resolution to 1-second intervals  
B) Storing logs indefinitely  
C) Setting appropriate log retention periods  
D) Creating more detailed custom metrics  

**Answer: C** - Setting appropriate log retention periods prevents indefinite storage costs while maintaining necessary data.

---

**Scoring:**
- 9-10 correct: Excellent understanding of operational excellence concepts
- 7-8 correct: Good grasp, review specific areas
- 5-6 correct: Adequate, additional study recommended
- Below 5: Review Day 2 materials and repeat hands-on exercises
