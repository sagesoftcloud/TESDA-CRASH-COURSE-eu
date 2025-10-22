# Project 2: Detailed Step-by-Step Instructions

## Step 1: VPC Configuration

### 1.1 Create VPC
```bash
aws ec2 create-vpc --cidr-block 10.0.0.0/16 --tag-specifications 'ResourceType=vpc,Tags=[{Key=Name,Value=TESDA-VPC}]'
```

### 1.2 Create Subnets
```bash
# Public Subnets
aws ec2 create-subnet --vpc-id vpc-xxxxxxxxx --cidr-block 10.0.1.0/24 --availability-zone us-east-1a --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=Public-Subnet-1}]'
aws ec2 create-subnet --vpc-id vpc-xxxxxxxxx --cidr-block 10.0.2.0/24 --availability-zone us-east-1b --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=Public-Subnet-2}]'

# Private Subnets
aws ec2 create-subnet --vpc-id vpc-xxxxxxxxx --cidr-block 10.0.3.0/24 --availability-zone us-east-1a --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=Private-Subnet-1}]'
aws ec2 create-subnet --vpc-id vpc-xxxxxxxxx --cidr-block 10.0.4.0/24 --availability-zone us-east-1b --tag-specifications 'ResourceType=subnet,Tags=[{Key=Name,Value=Private-Subnet-2}]'
```

### 1.3 Create and Attach Internet Gateway
```bash
aws ec2 create-internet-gateway --tag-specifications 'ResourceType=internet-gateway,Tags=[{Key=Name,Value=TESDA-IGW}]'
aws ec2 attach-internet-gateway --vpc-id vpc-xxxxxxxxx --internet-gateway-id igw-xxxxxxxxx
```

### 1.4 Create NAT Gateway
```bash
# Allocate Elastic IP
aws ec2 allocate-address --domain vpc

# Create NAT Gateway
aws ec2 create-nat-gateway --subnet-id subnet-xxxxxxxxx --allocation-id eipalloc-xxxxxxxxx --tag-specifications 'ResourceType=nat-gateway,Tags=[{Key=Name,Value=TESDA-NAT}]'
```

### 1.5 Configure Route Tables
```bash
# Create route table for public subnets
aws ec2 create-route-table --vpc-id vpc-xxxxxxxxx --tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=Public-RT}]'
aws ec2 create-route --route-table-id rtb-xxxxxxxxx --destination-cidr-block 0.0.0.0/0 --gateway-id igw-xxxxxxxxx

# Associate public subnets
aws ec2 associate-route-table --subnet-id subnet-xxxxxxxxx --route-table-id rtb-xxxxxxxxx

# Create route table for private subnets
aws ec2 create-route-table --vpc-id vpc-xxxxxxxxx --tag-specifications 'ResourceType=route-table,Tags=[{Key=Name,Value=Private-RT}]'
aws ec2 create-route --route-table-id rtb-yyyyyyyyy --destination-cidr-block 0.0.0.0/0 --nat-gateway-id nat-xxxxxxxxx
```

## Step 2: Security Groups Setup

### 2.1 Load Balancer Security Group
```bash
aws ec2 create-security-group --group-name ALB-SG --description "Application Load Balancer Security Group" --vpc-id vpc-xxxxxxxxx
aws ec2 authorize-security-group-ingress --group-id sg-xxxxxxxxx --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id sg-xxxxxxxxx --protocol tcp --port 443 --cidr 0.0.0.0/0
```

### 2.2 Web Server Security Group
```bash
aws ec2 create-security-group --group-name WebServer-SG --description "Web Server Security Group" --vpc-id vpc-xxxxxxxxx
aws ec2 authorize-security-group-ingress --group-id sg-yyyyyyyyy --protocol tcp --port 80 --source-group sg-xxxxxxxxx
```

### 2.3 Database Security Group
```bash
aws ec2 create-security-group --group-name Database-SG --description "Database Security Group" --vpc-id vpc-xxxxxxxxx
aws ec2 authorize-security-group-ingress --group-id sg-zzzzzzzzz --protocol tcp --port 3306 --source-group sg-yyyyyyyyy
```

## Step 3: SSL/TLS Certificate

### 3.1 Request Certificate
```bash
aws acm request-certificate --domain-name example.com --validation-method DNS --subject-alternative-names *.example.com
```

### 3.2 Validate Certificate
```bash
# Get validation records
aws acm describe-certificate --certificate-arn arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012

# Add DNS records to your domain (manual step)
# Wait for validation
aws acm describe-certificate --certificate-arn arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012
```

## Step 4: RDS MySQL Configuration

### 4.1 Create DB Subnet Group
```bash
aws rds create-db-subnet-group --db-subnet-group-name tesda-db-subnet-group --db-subnet-group-description "TESDA Database Subnet Group" --subnet-ids subnet-xxxxxxxxx subnet-yyyyyyyyy
```

### 4.2 Launch RDS Instance
```bash
aws rds create-db-instance \
  --db-instance-identifier tesda-mysql-db \
  --db-instance-class db.t3.micro \
  --engine mysql \
  --master-username admin \
  --master-user-password SecurePassword123! \
  --allocated-storage 20 \
  --vpc-security-group-ids sg-zzzzzzzzz \
  --db-subnet-group-name tesda-db-subnet-group \
  --storage-encrypted \
  --backup-retention-period 7 \
  --multi-az
```

## Step 5: EC2 Web Server Deployment

### 5.1 Create Launch Template
Create file: `user-data.sh`
```bash
#!/bin/bash
yum update -y
yum install -y httpd mysql
systemctl start httpd
systemctl enable httpd
echo "<h1>TESDA Secure Web Server</h1>" > /var/www/html/index.html
echo "<p>Server: $(hostname)</p>" >> /var/www/html/index.html
```

```bash
aws ec2 create-launch-template \
  --launch-template-name tesda-web-template \
  --launch-template-data '{
    "ImageId": "ami-0abcdef1234567890",
    "InstanceType": "t2.micro",
    "KeyName": "your-key-pair",
    "SecurityGroupIds": ["sg-yyyyyyyyy"],
    "UserData": "'$(base64 -w 0 user-data.sh)'",
    "IamInstanceProfile": {"Name": "EC2-WebServer-Profile"}
  }'
```

### 5.2 Create Auto Scaling Group
```bash
aws autoscaling create-auto-scaling-group \
  --auto-scaling-group-name tesda-asg \
  --launch-template LaunchTemplateName=tesda-web-template,Version=1 \
  --min-size 2 \
  --max-size 4 \
  --desired-capacity 2 \
  --vpc-zone-identifier "subnet-xxxxxxxxx,subnet-yyyyyyyyy" \
  --health-check-type ELB \
  --health-check-grace-period 300
```

## Step 6: Load Balancer Setup

### 6.1 Create Application Load Balancer
```bash
aws elbv2 create-load-balancer \
  --name tesda-alb \
  --subnets subnet-xxxxxxxxx subnet-yyyyyyyyy \
  --security-groups sg-xxxxxxxxx \
  --scheme internet-facing \
  --type application \
  --ip-address-type ipv4
```

### 6.2 Create Target Group
```bash
aws elbv2 create-target-group \
  --name tesda-web-targets \
  --protocol HTTP \
  --port 80 \
  --vpc-id vpc-xxxxxxxxx \
  --health-check-path / \
  --health-check-interval-seconds 30 \
  --health-check-timeout-seconds 5 \
  --healthy-threshold-count 2 \
  --unhealthy-threshold-count 3
```

### 6.3 Create Listeners
```bash
# HTTP Listener (redirect to HTTPS)
aws elbv2 create-listener \
  --load-balancer-arn arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/tesda-alb/1234567890123456 \
  --protocol HTTP \
  --port 80 \
  --default-actions Type=redirect,RedirectConfig='{Protocol=HTTPS,Port=443,StatusCode=HTTP_301}'

# HTTPS Listener
aws elbv2 create-listener \
  --load-balancer-arn arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/tesda-alb/1234567890123456 \
  --protocol HTTPS \
  --port 443 \
  --certificates CertificateArn=arn:aws:acm:us-east-1:123456789012:certificate/12345678-1234-1234-1234-123456789012 \
  --default-actions Type=forward,TargetGroupArn=arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/tesda-web-targets/1234567890123456
```

### 6.4 Attach Auto Scaling Group to Target Group
```bash
aws autoscaling attach-load-balancer-target-groups \
  --auto-scaling-group-name tesda-asg \
  --target-group-arns arn:aws:elasticloadbalancing:us-east-1:123456789012:targetgroup/tesda-web-targets/1234567890123456
```

## Step 7: AWS WAF Configuration

### 7.1 Create Web ACL
```bash
aws wafv2 create-web-acl \
  --name tesda-web-acl \
  --scope REGIONAL \
  --default-action Allow={} \
  --rules file://waf-rules.json
```

Create file: `waf-rules.json`
```json
[
  {
    "Name": "RateLimitRule",
    "Priority": 1,
    "Statement": {
      "RateBasedStatement": {
        "Limit": 2000,
        "AggregateKeyType": "IP"
      }
    },
    "Action": {
      "Block": {}
    },
    "VisibilityConfig": {
      "SampledRequestsEnabled": true,
      "CloudWatchMetricsEnabled": true,
      "MetricName": "RateLimitRule"
    }
  }
]
```

### 7.2 Associate WAF with Load Balancer
```bash
aws wafv2 associate-web-acl \
  --web-acl-arn arn:aws:wafv2:us-east-1:123456789012:regional/webacl/tesda-web-acl/12345678-1234-1234-1234-123456789012 \
  --resource-arn arn:aws:elasticloadbalancing:us-east-1:123456789012:loadbalancer/app/tesda-alb/1234567890123456
```

## Step 8: Security Hub Integration

### 8.1 Enable Security Hub
```bash
aws securityhub enable-security-hub --enable-default-standards
```

### 8.2 Enable Standards
```bash
aws securityhub batch-enable-standards --standards-subscription-requests StandardsArn=arn:aws:securityhub:::ruleset/finding-format/aws-foundational-security-standard/v/1.0.0,StandardsArn=arn:aws:securityhub:us-east-1::standard/cis-aws-foundations-benchmark/v/1.2.0
```

## Testing and Validation

### Test Application Access
```bash
# Test HTTP redirect
curl -I http://your-alb-dns-name.us-east-1.elb.amazonaws.com

# Test HTTPS access
curl -I https://your-domain.com

# Test WAF rate limiting
for i in {1..100}; do curl https://your-domain.com; done
```

### Verify Security Configuration
```bash
# Check Security Hub findings
aws securityhub get-findings --max-items 10

# Verify SSL certificate
openssl s_client -connect your-domain.com:443 -servername your-domain.com

# Test database connectivity from web server
mysql -h your-rds-endpoint.us-east-1.rds.amazonaws.com -u admin -p
```
