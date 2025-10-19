# Day 2: Hands-on Lab Guide - Operational Excellence

## Pre-Lab Setup (10 minutes)
**Before starting, ensure you have**:
- AWS account with appropriate permissions
- AWS CLI configured
- Text editor ready
- Web browser with AWS Console access

---

## Project 1: CloudWatch Monitoring & Alerting (80 minutes)

### Objective
Build comprehensive monitoring for a web application with automated alerting.

### Scenario
You're monitoring an e-commerce website that needs to maintain 99.9% uptime. Set up monitoring to detect issues before customers are affected.

### Step 1: Launch EC2 Instance with Web Server (15 minutes)

**1.1 Create EC2 Instance**
```bash
# Launch Amazon Linux 2 instance
aws ec2 run-instances \
    --image-id ami-0abcdef1234567890 \
    --instance-type t3.micro \
    --key-name your-key-pair \
    --security-group-ids sg-12345678 \
    --user-data file://web-server-setup.sh \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=WebServer-Monitor}]'
```

**1.2 Web Server Setup Script (web-server-setup.sh)**
```bash
#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

# Create sample web application
cat > /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head><title>E-commerce Site</title></head>
<body>
    <h1>Welcome to Our Store</h1>
    <p>Server Status: <span id="status">Online</span></p>
    <script>
        // Simulate application metrics
        setInterval(() => {
            fetch('/api/health').catch(() => {
                document.getElementById('status').textContent = 'Error';
            });
        }, 30000);
    </script>
</body>
</html>
EOF

# Create health check endpoint
mkdir -p /var/www/html/api
cat > /var/www/html/api/health << 'EOF'
{"status": "healthy", "timestamp": "$(date -Iseconds)"}
EOF
```

### Step 2: Install CloudWatch Agent (20 minutes)

**2.1 Install CloudWatch Agent**
```bash
# Connect to your instance
ssh -i your-key.pem ec2-user@your-instance-ip

# Download and install CloudWatch agent
wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
sudo rpm -U ./amazon-cloudwatch-agent.rpm
```

**2.2 Configure CloudWatch Agent**
```json
# Create /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
{
    "metrics": {
        "namespace": "ECommerce/WebServer",
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
            },
            "netstat": {
                "measurement": ["tcp_established", "tcp_time_wait"],
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
                        "log_group_name": "/aws/ec2/webserver/access",
                        "log_stream_name": "{instance_id}"
                    },
                    {
                        "file_path": "/var/log/httpd/error_log",
                        "log_group_name": "/aws/ec2/webserver/error",
                        "log_stream_name": "{instance_id}"
                    }
                ]
            }
        }
    }
}
```

**2.3 Start CloudWatch Agent**
```bash
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -a fetch-config -m ec2 -s \
    -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
```

### Step 3: Create Custom Metrics (15 minutes)

**3.1 Application Performance Script**
```bash
# Create /home/ec2-user/send-metrics.sh
#!/bin/bash

while true; do
    # Simulate application metrics
    RESPONSE_TIME=$(shuf -i 100-500 -n 1)
    ERROR_RATE=$(shuf -i 0-5 -n 1)
    ACTIVE_USERS=$(shuf -i 50-200 -n 1)
    
    # Send custom metrics to CloudWatch
    aws cloudwatch put-metric-data \
        --namespace "ECommerce/Application" \
        --metric-data \
        MetricName=ResponseTime,Value=$RESPONSE_TIME,Unit=Milliseconds \
        MetricName=ErrorRate,Value=$ERROR_RATE,Unit=Percent \
        MetricName=ActiveUsers,Value=$ACTIVE_USERS,Unit=Count
    
    sleep 60
done
```

**3.2 Make executable and run**
```bash
chmod +x /home/ec2-user/send-metrics.sh
nohup /home/ec2-user/send-metrics.sh &
```

### Step 4: Create CloudWatch Alarms (20 minutes)

**4.1 High CPU Alarm**
```bash
aws cloudwatch put-metric-alarm \
    --alarm-name "WebServer-HighCPU" \
    --alarm-description "Alert when CPU exceeds 80%" \
    --metric-name CPUUtilization \
    --namespace AWS/EC2 \
    --statistic Average \
    --period 300 \
    --threshold 80 \
    --comparison-operator GreaterThanThreshold \
    --evaluation-periods 2 \
    --alarm-actions arn:aws:sns:region:account:alert-topic \
    --dimensions Name=InstanceId,Value=i-1234567890abcdef0
```

**4.2 High Response Time Alarm**
```bash
aws cloudwatch put-metric-alarm \
    --alarm-name "WebServer-HighResponseTime" \
    --alarm-description "Alert when response time exceeds 400ms" \
    --metric-name ResponseTime \
    --namespace ECommerce/Application \
    --statistic Average \
    --period 300 \
    --threshold 400 \
    --comparison-operator GreaterThanThreshold \
    --evaluation-periods 1 \
    --alarm-actions arn:aws:sns:region:account:alert-topic
```

**4.3 Error Rate Alarm**
```bash
aws cloudwatch put-metric-alarm \
    --alarm-name "WebServer-HighErrorRate" \
    --alarm-description "Alert when error rate exceeds 3%" \
    --metric-name ErrorRate \
    --namespace ECommerce/Application \
    --statistic Average \
    --period 300 \
    --threshold 3 \
    --comparison-operator GreaterThanThreshold \
    --evaluation-periods 1 \
    --alarm-actions arn:aws:sns:region:account:alert-topic
```

### Step 5: Create Dashboard (10 minutes)

**5.1 Dashboard JSON Configuration**
```json
{
    "widgets": [
        {
            "type": "metric",
            "properties": {
                "metrics": [
                    ["AWS/EC2", "CPUUtilization", "InstanceId", "i-1234567890abcdef0"],
                    ["ECommerce/Application", "ResponseTime"],
                    [".", "ErrorRate"],
                    [".", "ActiveUsers"]
                ],
                "period": 300,
                "stat": "Average",
                "region": "us-east-1",
                "title": "Web Server Performance"
            }
        }
    ]
}
```

**5.2 Create Dashboard**
```bash
aws cloudwatch put-dashboard \
    --dashboard-name "ECommerce-WebServer" \
    --dashboard-body file://dashboard.json
```

---

## Project 2: Centralized Logging & Analysis (80 minutes)

### Objective
Implement centralized logging with automated analysis and alerting for application errors.

### Scenario
Your application generates various logs that need to be analyzed for errors, performance issues, and security threats.

### Step 1: Set Up Log Groups (10 minutes)

**1.1 Create Log Groups**
```bash
# Create log groups
aws logs create-log-group --log-group-name /aws/ec2/webserver/access
aws logs create-log-group --log-group-name /aws/ec2/webserver/error
aws logs create-log-group --log-group-name /aws/ec2/webserver/application

# Set retention policy
aws logs put-retention-policy \
    --log-group-name /aws/ec2/webserver/access \
    --retention-in-days 30
```

### Step 2: Generate Sample Logs (15 minutes)

**2.1 Log Generation Script**
```bash
# Create /home/ec2-user/generate-logs.sh
#!/bin/bash

LOG_FILE="/var/log/application.log"

while true; do
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Generate different types of log entries
    RAND=$(shuf -i 1-100 -n 1)
    
    if [ $RAND -le 70 ]; then
        # Normal log entry
        echo "[$TIMESTAMP] INFO: User session started for user_$(shuf -i 1000-9999 -n 1)" >> $LOG_FILE
    elif [ $RAND -le 85 ]; then
        # Warning log entry
        echo "[$TIMESTAMP] WARN: High response time detected: $(shuf -i 400-800 -n 1)ms" >> $LOG_FILE
    elif [ $RAND -le 95 ]; then
        # Error log entry
        echo "[$TIMESTAMP] ERROR: Database connection failed for user_$(shuf -i 1000-9999 -n 1)" >> $LOG_FILE
    else
        # Critical error
        echo "[$TIMESTAMP] CRITICAL: Payment processing failed - transaction_$(shuf -i 10000-99999 -n 1)" >> $LOG_FILE
    fi
    
    sleep 10
done
```

**2.2 Configure Log Shipping**
```bash
# Update CloudWatch agent config to include application logs
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -a append-config -m ec2 -s \
    -c file:/opt/aws/amazon-cloudwatch-agent/etc/application-logs.json
```

### Step 3: Create Log Analysis Lambda (25 minutes)

**3.1 Lambda Function Code (log-analyzer.py)**
```python
import json
import boto3
import gzip
import base64
import re
from datetime import datetime

def lambda_handler(event, context):
    # Decode CloudWatch Logs data
    cw_data = event['awslogs']['data']
    compressed_payload = base64.b64decode(cw_data)
    uncompressed_payload = gzip.decompress(compressed_payload)
    log_data = json.loads(uncompressed_payload)
    
    sns = boto3.client('sns')
    cloudwatch = boto3.client('cloudwatch')
    
    error_count = 0
    critical_count = 0
    
    for log_event in log_data['logEvents']:
        message = log_event['message']
        
        # Analyze log patterns
        if 'ERROR' in message:
            error_count += 1
            
            # Check for specific error patterns
            if 'Database connection failed' in message:
                send_alert(sns, 'Database Connection Error', message)
                
        elif 'CRITICAL' in message:
            critical_count += 1
            
            # Immediate alert for critical errors
            if 'Payment processing failed' in message:
                send_alert(sns, 'CRITICAL: Payment System Down', message)
    
    # Send metrics to CloudWatch
    if error_count > 0:
        cloudwatch.put_metric_data(
            Namespace='ECommerce/Logs',
            MetricData=[
                {
                    'MetricName': 'ErrorCount',
                    'Value': error_count,
                    'Unit': 'Count'
                }
            ]
        )
    
    if critical_count > 0:
        cloudwatch.put_metric_data(
            Namespace='ECommerce/Logs',
            MetricData=[
                {
                    'MetricName': 'CriticalErrorCount',
                    'Value': critical_count,
                    'Unit': 'Count'
                }
            ]
        )
    
    return {
        'statusCode': 200,
        'body': json.dumps(f'Processed {len(log_data["logEvents"])} log events')
    }

def send_alert(sns_client, subject, message):
    sns_client.publish(
        TopicArn='arn:aws:sns:region:account:log-alerts',
        Subject=subject,
        Message=message
    )
```

**3.2 Deploy Lambda Function**
```bash
# Create deployment package
zip function.zip log-analyzer.py

# Create Lambda function
aws lambda create-function \
    --function-name log-analyzer \
    --runtime python3.9 \
    --role arn:aws:iam::account:role/lambda-execution-role \
    --handler log-analyzer.lambda_handler \
    --zip-file fileb://function.zip
```

### Step 4: Set Up Log Insights Queries (15 minutes)

**4.1 Common Query Patterns**
```sql
-- Find all errors in the last hour
fields @timestamp, @message
| filter @message like /ERROR/
| sort @timestamp desc
| limit 100

-- Count errors by type
fields @timestamp, @message
| filter @message like /ERROR/
| stats count() by bin(5m)

-- Find slow response times
fields @timestamp, @message
| filter @message like /response time/
| parse @message "response time: * ms" as response_time
| filter response_time > 400
| sort @timestamp desc

-- Security analysis - failed login attempts
fields @timestamp, @message
| filter @message like /login failed/
| stats count() by bin(1h)
```

### Step 5: Create Log-based Alarms (15 minutes)

**5.1 Error Rate Alarm from Logs**
```bash
aws logs put-metric-filter \
    --log-group-name /aws/ec2/webserver/application \
    --filter-name ErrorFilter \
    --filter-pattern "ERROR" \
    --metric-transformations \
        metricName=ApplicationErrors,metricNamespace=ECommerce/Logs,metricValue=1

# Create alarm based on log metrics
aws cloudwatch put-metric-alarm \
    --alarm-name "Application-HighErrorRate" \
    --alarm-description "Alert when application error rate is high" \
    --metric-name ApplicationErrors \
    --namespace ECommerce/Logs \
    --statistic Sum \
    --period 300 \
    --threshold 5 \
    --comparison-operator GreaterThanThreshold \
    --evaluation-periods 1
```

---

## Project 3: Infrastructure as Code with Monitoring (80 minutes)

### Objective
Deploy a complete monitored infrastructure using CloudFormation with self-healing capabilities.

### Scenario
Deploy a resilient web application that automatically scales, monitors itself, and recovers from failures.

### Step 1: Create CloudFormation Template (30 minutes)

**3.1 Main Template (monitored-infrastructure.yaml)**
```yaml
AWSTemplateFormatVersion: '2010-09-09'
Description: 'Self-healing web application with comprehensive monitoring'

Parameters:
  KeyName:
    Type: AWS::EC2::KeyPair::KeyName
    Description: EC2 Key Pair for SSH access
  
  InstanceType:
    Type: String
    Default: t3.micro
    AllowedValues: [t3.micro, t3.small, t3.medium]

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
          Value: MonitoredApp-VPC

  PublicSubnet1:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref VPC
      CidrBlock: 10.0.1.0/24
      AvailabilityZone: !Select [0, !GetAZs '']
      MapPublicIpOnLaunch: true

  PublicSubnet2:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref VPC
      CidrBlock: 10.0.2.0/24
      AvailabilityZone: !Select [1, !GetAZs '']
      MapPublicIpOnLaunch: true

  InternetGateway:
    Type: AWS::EC2::InternetGateway

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

  # IAM Role for EC2 instances
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
        - PolicyName: CustomMetricsPolicy
          PolicyDocument:
            Version: '2012-10-17'
            Statement:
              - Effect: Allow
                Action:
                  - cloudwatch:PutMetricData
                  - logs:CreateLogGroup
                  - logs:CreateLogStream
                  - logs:PutLogEvents
                Resource: '*'

  EC2InstanceProfile:
    Type: AWS::IAM::InstanceProfile
    Properties:
      Roles:
        - !Ref EC2Role

  # Launch Template
  LaunchTemplate:
    Type: AWS::EC2::LaunchTemplate
    Properties:
      LaunchTemplateName: MonitoredWebServer
      LaunchTemplateData:
        ImageId: ami-0abcdef1234567890  # Amazon Linux 2
        InstanceType: !Ref InstanceType
        KeyName: !Ref KeyName
        SecurityGroupIds:
          - !Ref WebServerSecurityGroup
        IamInstanceProfile:
          Arn: !GetAtt EC2InstanceProfile.Arn
        UserData:
          Fn::Base64: !Sub |
            #!/bin/bash
            yum update -y
            yum install -y httpd
            systemctl start httpd
            systemctl enable httpd
            
            # Install CloudWatch agent
            wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
            rpm -U ./amazon-cloudwatch-agent.rpm
            
            # Create web application
            cat > /var/www/html/index.html << 'EOF'
            <!DOCTYPE html>
            <html>
            <head><title>Self-Healing App</title></head>
            <body>
                <h1>Self-Healing Web Application</h1>
                <p>Instance ID: $(curl -s http://169.254.169.254/latest/meta-data/instance-id)</p>
                <p>Status: <span id="status">Healthy</span></p>
            </body>
            </html>
            EOF
            
            # Configure CloudWatch agent
            cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json << 'EOF'
            {
                "metrics": {
                    "namespace": "SelfHealing/WebApp",
                    "metrics_collected": {
                        "cpu": {"measurement": ["cpu_usage_idle"], "metrics_collection_interval": 60},
                        "mem": {"measurement": ["mem_used_percent"], "metrics_collection_interval": 60}
                    }
                }
            }
            EOF
            
            # Start CloudWatch agent
            /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
                -a fetch-config -m ec2 -s \
                -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

  # Auto Scaling Group
  AutoScalingGroup:
    Type: AWS::AutoScaling::AutoScalingGroup
    Properties:
      VPCZoneIdentifier:
        - !Ref PublicSubnet1
        - !Ref PublicSubnet2
      LaunchTemplate:
        LaunchTemplateId: !Ref LaunchTemplate
        Version: !GetAtt LaunchTemplate.LatestVersionNumber
      MinSize: 2
      MaxSize: 6
      DesiredCapacity: 2
      HealthCheckType: ELB
      HealthCheckGracePeriod: 300
      Tags:
        - Key: Name
          Value: MonitoredWebServer
          PropagateAtLaunch: true

  # Application Load Balancer
  ApplicationLoadBalancer:
    Type: AWS::ElasticLoadBalancingV2::LoadBalancer
    Properties:
      Type: application
      Scheme: internet-facing
      Subnets:
        - !Ref PublicSubnet1
        - !Ref PublicSubnet2
      SecurityGroups:
        - !Ref WebServerSecurityGroup

  TargetGroup:
    Type: AWS::ElasticLoadBalancingV2::TargetGroup
    Properties:
      Port: 80
      Protocol: HTTP
      VpcId: !Ref VPC
      HealthCheckPath: /
      HealthCheckIntervalSeconds: 30
      HealthyThresholdCount: 2
      UnhealthyThresholdCount: 3

  Listener:
    Type: AWS::ElasticLoadBalancingV2::Listener
    Properties:
      DefaultActions:
        - Type: forward
          TargetGroupArn: !Ref TargetGroup
      LoadBalancerArn: !Ref ApplicationLoadBalancer
      Port: 80
      Protocol: HTTP

  # Auto Scaling Policies
  ScaleUpPolicy:
    Type: AWS::AutoScaling::ScalingPolicy
    Properties:
      AdjustmentType: ChangeInCapacity
      AutoScalingGroupName: !Ref AutoScalingGroup
      Cooldown: 300
      ScalingAdjustment: 1

  ScaleDownPolicy:
    Type: AWS::AutoScaling::ScalingPolicy
    Properties:
      AdjustmentType: ChangeInCapacity
      AutoScalingGroupName: !Ref AutoScalingGroup
      Cooldown: 300
      ScalingAdjustment: -1

  # CloudWatch Alarms for Auto Scaling
  HighCPUAlarm:
    Type: AWS::CloudWatch::Alarm
    Properties:
      AlarmDescription: Scale up on high CPU
      MetricName: CPUUtilization
      Namespace: AWS/EC2
      Statistic: Average
      Period: 300
      EvaluationPeriods: 2
      Threshold: 70
      ComparisonOperator: GreaterThanThreshold
      AlarmActions:
        - !Ref ScaleUpPolicy

  LowCPUAlarm:
    Type: AWS::CloudWatch::Alarm
    Properties:
      AlarmDescription: Scale down on low CPU
      MetricName: CPUUtilization
      Namespace: AWS/EC2
      Statistic: Average
      Period: 300
      EvaluationPeriods: 2
      Threshold: 20
      ComparisonOperator: LessThanThreshold
      AlarmActions:
        - !Ref ScaleDownPolicy

Outputs:
  LoadBalancerDNS:
    Description: DNS name of the load balancer
    Value: !GetAtt ApplicationLoadBalancer.DNSName
```

### Step 2: Deploy Infrastructure (20 minutes)

**2.1 Deploy CloudFormation Stack**
```bash
# Deploy the stack
aws cloudformation create-stack \
    --stack-name monitored-web-app \
    --template-body file://monitored-infrastructure.yaml \
    --parameters ParameterKey=KeyName,ParameterValue=your-key-pair \
    --capabilities CAPABILITY_IAM

# Monitor deployment
aws cloudformation describe-stacks \
    --stack-name monitored-web-app \
    --query 'Stacks[0].StackStatus'
```

### Step 3: Test Self-Healing Capabilities (15 minutes)

**3.1 Load Testing Script**
```bash
# Create load-test.sh
#!/bin/bash

LOAD_BALANCER_DNS="your-load-balancer-dns"

echo "Starting load test..."
for i in {1..1000}; do
    curl -s http://$LOAD_BALANCER_DNS > /dev/null &
    if [ $((i % 10)) -eq 0 ]; then
        echo "Sent $i requests"
        sleep 1
    fi
done

wait
echo "Load test completed"
```

**3.2 Chaos Testing**
```bash
# Terminate an instance to test auto-healing
INSTANCE_ID=$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=MonitoredWebServer" \
    --query 'Reservations[0].Instances[0].InstanceId' \
    --output text)

echo "Terminating instance: $INSTANCE_ID"
aws ec2 terminate-instances --instance-ids $INSTANCE_ID

# Watch auto scaling group replace the instance
aws autoscaling describe-auto-scaling-groups \
    --auto-scaling-group-names your-asg-name
```

### Step 4: Monitoring Dashboard (15 minutes)

**4.1 Create Comprehensive Dashboard**
```json
{
    "widgets": [
        {
            "type": "metric",
            "properties": {
                "metrics": [
                    ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", "your-load-balancer"],
                    [".", "TargetResponseTime", ".", "."],
                    ["AWS/AutoScaling", "GroupDesiredCapacity", "AutoScalingGroupName", "your-asg"]
                ],
                "period": 300,
                "stat": "Average",
                "region": "us-east-1",
                "title": "Application Performance"
            }
        },
        {
            "type": "metric",
            "properties": {
                "metrics": [
                    ["SelfHealing/WebApp", "CPUUtilization"],
                    [".", "MemoryUtilization"]
                ],
                "period": 300,
                "stat": "Average",
                "region": "us-east-1",
                "title": "Infrastructure Health"
            }
        }
    ]
}
```

---

## Assessment & Wrap-up (20 minutes)

### Knowledge Check Quiz
1. What are the three pillars of observability?
2. How does Infrastructure as Code improve operational excellence?
3. What triggers auto-scaling in our deployed application?
4. How do CloudWatch Logs help with troubleshooting?
5. What makes our infrastructure "self-healing"?

### Project Validation Checklist
- [ ] **Project 1**: Monitoring detects system issues and sends alerts
- [ ] **Project 2**: Log analysis automatically identifies error patterns
- [ ] **Project 3**: Infrastructure scales and heals automatically
- [ ] **Integration**: All systems work together seamlessly

### Next Steps
- Review CloudWatch best practices
- Explore advanced monitoring patterns
- Prepare for Day 3: CI/CD and Chaos Engineering

---

## Troubleshooting Guide

### Common Issues
1. **CloudWatch Agent Not Starting**
   - Check IAM permissions
   - Verify configuration file syntax
   - Review agent logs: `/opt/aws/amazon-cloudwatch-agent/logs/`

2. **Alarms Not Triggering**
   - Verify metric names and namespaces
   - Check alarm thresholds and evaluation periods
   - Ensure SNS topic exists and has permissions

3. **Lambda Function Errors**
   - Check CloudWatch Logs for function execution logs
   - Verify IAM permissions for SNS and CloudWatch
   - Test function with sample events

4. **Auto Scaling Not Working**
   - Check CloudWatch alarms status
   - Verify scaling policies are attached
   - Review Auto Scaling group health checks

### Support Resources
- AWS Documentation: https://docs.aws.amazon.com/
- CloudWatch User Guide: https://docs.aws.amazon.com/cloudwatch/
- Instructor support: Available throughout the session
