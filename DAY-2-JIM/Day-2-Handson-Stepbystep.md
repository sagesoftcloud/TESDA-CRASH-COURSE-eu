# Day 2: Hands-on Step-by-Step Guide
## Operational Excellence - Monitoring & Automation for TESDA

---

## 🏷️ **CRITICAL: STUDENT NAMING CONVENTIONS**

### **Your Student Number**: _____ (Fill in your assigned number)

**IMPORTANT**: All AWS resources you create today MUST include your student number to avoid confusion.

### **Naming Pattern Examples**:
- EC2 Instance: `ec2-student1`, `ec2-student2`, `ec2-student3`...
- Load Balancer: `alb-student1`, `alb-student2`...
- Dashboard: `dashboard-student1`, `dashboard-student2`...

**Replace the X in all instructions with YOUR assigned student number!**

📋 **See NAMING-CONVENTIONS.md for complete reference**

---

### 🎯 Learning Objectives
By the end of this hands-on session, you will:
- Set up professional monitoring for web applications
- Create automated log analysis systems
- Build self-healing infrastructure
- Understand operational excellence in practice

### ⏰ Time Allocation
- **Project 1**: System Monitoring (80 minutes)
- **Project 2**: Log Analysis (80 minutes)  
- **Project 3**: Self-Healing Infrastructure (80 minutes)
- **Assessment**: Final testing (20 minutes)

---

## 🚀 Project 1: System Monitoring Setup (80 minutes)

### What You'll Build
A complete monitoring system for an e-commerce website that:
- Tracks system performance (CPU, memory, network)
- Monitors application health
- Sends alerts when problems occur
- Displays everything on a visual dashboard

### Real-World Scenario
You're the IT administrator for an online shopping website. During sale events, thousands of customers visit your site. You need to ensure the website stays fast and available, or you'll lose sales and customers.

---

### Step 1: Launch Your Web Server (15 minutes)

#### 1.1 Access AWS Console
```
🖥️ VISUAL: Open your web browser
📍 Go to: https://aws.amazon.com/console/
🔑 Login with your provided credentials
```

#### 1.2 Navigate to EC2 Service
```
🖥️ VISUAL: In the AWS Console
📍 Click "Services" in the top menu
🔍 Search for "EC2" 
📍 Click "EC2" from the results
```

#### 1.3 Launch New Instance
```
🖥️ VISUAL: In EC2 Dashboard
📍 Click the orange "Launch Instance" button
📝 Instance Name: "ec2-studentX" (Replace X with YOUR student number)
   Example: "ec2-student1", "ec2-student2", "ec2-student3"
```

#### 1.4 Choose Operating System
```
🖥️ VISUAL: Application and OS Images section
📍 Select "Amazon Linux 2023 AMI" (should be first option)
✅ This is free tier eligible
```

#### 1.5 Choose Instance Size
```
🖥️ VISUAL: Instance Type section
📍 Select "t3.micro" (free tier eligible)
💡 This gives you 1 CPU and 1GB RAM - perfect for learning
```

#### 1.6 Create Security Group (Firewall Rules)
```
🖥️ VISUAL: Network Settings section
📍 Click "Edit" next to Network settings
📍 Security group name: "WebServer-SG"
📍 Description: "Allow web traffic and SSH"

Add these rules:
Rule 1: SSH (Port 22) - Source: My IP
Rule 2: HTTP (Port 80) - Source: Anywhere
Rule 3: HTTPS (Port 443) - Source: Anywhere
```

#### 1.7 Add User Data Script
```
🖥️ VISUAL: Advanced Details section (scroll down)
📍 Click "Advanced Details" to expand
📍 Scroll to "User Data" text box
📝 Copy and paste this script:
```

```bash
#!/bin/bash
# This script automatically installs and configures a web server

# Update the system
yum update -y

# Install Apache web server
yum install -y httpd

# Start Apache and enable it to start on boot
systemctl start httpd
systemctl enable httpd

# Create a simple website
cat > /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>E-commerce Monitoring Demo</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .header { background-color: #232f3e; color: white; padding: 20px; }
        .status { background-color: #4CAF50; color: white; padding: 10px; margin: 20px 0; }
        .metrics { background-color: #f1f1f1; padding: 20px; margin: 20px 0; }
    </style>
</head>
<body>
    <div class="header">
        <h1>🛒 E-commerce Website</h1>
        <p>Monitoring Demo for TESDA Training</p>
    </div>
    
    <div class="status">
        <h2>✅ System Status: ONLINE</h2>
        <p>Server is running normally</p>
    </div>
    
    <div class="metrics">
        <h3>📊 Current Metrics</h3>
        <p><strong>Server Time:</strong> <span id="time"></span></p>
        <p><strong>Uptime:</strong> <span id="uptime">Loading...</span></p>
        <p><strong>Status:</strong> Healthy</p>
    </div>
    
    <script>
        // Update time every second
        function updateTime() {
            document.getElementById('time').textContent = new Date().toLocaleString();
        }
        setInterval(updateTime, 1000);
        updateTime();
        
        // Simulate uptime counter
        let uptime = 0;
        setInterval(() => {
            uptime++;
            document.getElementById('uptime').textContent = uptime + ' seconds';
        }, 1000);
    </script>
</body>
</html>
EOF

# Create health check endpoint
mkdir -p /var/www/html/api
cat > /var/www/html/api/health << 'EOF'
{
    "status": "healthy",
    "timestamp": "$(date -Iseconds)",
    "server": "WebServer-Monitor"
}
EOF

# Create metrics endpoint
cat > /var/www/html/api/metrics << 'EOF'
{
    "cpu_usage": "25%",
    "memory_usage": "45%",
    "disk_usage": "30%",
    "active_connections": 12,
    "uptime": "$(uptime)"
}
EOF

# Set proper permissions
chmod 644 /var/www/html/api/*
```

#### 1.8 Launch the Instance
```
🖥️ VISUAL: Review and Launch section
📍 Click "Launch Instance" button
⏳ Wait 2-3 minutes for instance to start
✅ You should see "Instance launched successfully"
```

#### 1.9 Test Your Website
```
🖥️ VISUAL: Back in EC2 Dashboard
📍 Click "Instances" in left menu
📍 Find your "WebServer-Monitor" instance
📍 Wait until "Instance State" shows "Running"
📍 Copy the "Public IPv4 address"
📍 Open new browser tab and paste the IP address
✅ You should see your e-commerce website!
```

**🎉 Checkpoint 1 Complete!** You now have a running web server that we'll monitor.

---

### Step 2: Install CloudWatch Agent (20 minutes)

The CloudWatch Agent collects detailed metrics from your server and sends them to AWS CloudWatch for monitoring.

#### 2.1 Connect to Your Server
```
🖥️ VISUAL: In EC2 Console
📍 Select your "WebServer-Monitor" instance
📍 Click "Connect" button at the top
📍 Choose "EC2 Instance Connect" tab
📍 Click "Connect" button
✅ A new browser tab opens with a terminal
```

#### 2.2 Download CloudWatch Agent
```bash
# Download the CloudWatch agent installer
wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm

# Install the agent
sudo rpm -U ./amazon-cloudwatch-agent.rpm
```

```
💡 EXPLANATION: 
- wget downloads files from the internet
- rpm installs software packages on Amazon Linux
- The CloudWatch agent will collect system metrics for us
```

#### 2.3 Create IAM Role for CloudWatch
```
🖥️ VISUAL: Open new browser tab
📍 Go to AWS Console → Services → IAM
📍 Click "Roles" in left menu
📍 Click "Create role" button
```

```
🖥️ VISUAL: Create Role Wizard
📍 Select "AWS service"
📍 Choose "EC2" from the list
📍 Click "Next"
```

```
🖥️ VISUAL: Add Permissions
📍 Search for "CloudWatchAgentServerPolicy"
📍 Check the box next to it
📍 Click "Next"
```

```
🖥️ VISUAL: Name and Review
📍 Role name: "CloudWatchAgentServerRole"
📍 Description: "Allows EC2 instances to send metrics to CloudWatch"
📍 Click "Create role"
```

#### 2.4 Attach Role to Instance
```
🖥️ VISUAL: Back to EC2 Console
📍 Select your "WebServer-Monitor" instance
📍 Click "Actions" → "Security" → "Modify IAM role"
📍 Select "CloudWatchAgentServerRole"
📍 Click "Update IAM role"
```

#### 2.5 Configure CloudWatch Agent
```bash
# Create configuration file for CloudWatch agent
sudo cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json << 'EOF'
{
    "metrics": {
        "namespace": "TESDA/ECommerce",
        "metrics_collected": {
            "cpu": {
                "measurement": [
                    "cpu_usage_idle",
                    "cpu_usage_iowait", 
                    "cpu_usage_user",
                    "cpu_usage_system"
                ],
                "metrics_collection_interval": 60,
                "totalcpu": false
            },
            "disk": {
                "measurement": [
                    "used_percent"
                ],
                "metrics_collection_interval": 60,
                "resources": [
                    "*"
                ]
            },
            "mem": {
                "measurement": [
                    "mem_used_percent"
                ],
                "metrics_collection_interval": 60
            },
            "netstat": {
                "measurement": [
                    "tcp_established",
                    "tcp_time_wait"
                ],
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
                        "log_group_name": "/tesda/webserver/access",
                        "log_stream_name": "{instance_id}"
                    },
                    {
                        "file_path": "/var/log/httpd/error_log",
                        "log_group_name": "/tesda/webserver/error",
                        "log_stream_name": "{instance_id}"
                    }
                ]
            }
        }
    }
}
EOF
```

```
💡 EXPLANATION:
- This configuration tells CloudWatch what to monitor
- We're collecting CPU, memory, disk, and network metrics
- We're also collecting web server logs
- Metrics are collected every 60 seconds
- Everything is organized under "TESDA/ECommerce" namespace
```

#### 2.6 Start CloudWatch Agent
```bash
# Start the CloudWatch agent with our configuration
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -a fetch-config -m ec2 -s \
    -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

# Check if agent is running
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json \
    -a query
```

```
✅ SUCCESS INDICATOR: You should see output showing the agent is running
```

**🎉 Checkpoint 2 Complete!** Your server is now sending metrics to CloudWatch.

---

### Step 3: Create Custom Application Metrics (15 minutes)

Now we'll create custom metrics that track business-specific information like response times and user activity.

#### 3.1 Create Metrics Script
```bash
# Create a script that generates custom metrics
cat > /home/ec2-user/send-metrics.sh << 'EOF'
#!/bin/bash

# This script simulates real application metrics
# In a real application, these would come from your actual app

while true; do
    # Simulate response time (100-500 milliseconds)
    RESPONSE_TIME=$(shuf -i 100-500 -n 1)
    
    # Simulate error rate (0-5%)
    ERROR_RATE=$(shuf -i 0-5 -n 1)
    
    # Simulate active users (50-200 users)
    ACTIVE_USERS=$(shuf -i 50-200 -n 1)
    
    # Simulate orders per minute (5-25 orders)
    ORDERS_PER_MINUTE=$(shuf -i 5-25 -n 1)
    
    # Send metrics to CloudWatch
    aws cloudwatch put-metric-data \
        --namespace "TESDA/ECommerce/Application" \
        --metric-data \
        MetricName=ResponseTime,Value=$RESPONSE_TIME,Unit=Milliseconds \
        MetricName=ErrorRate,Value=$ERROR_RATE,Unit=Percent \
        MetricName=ActiveUsers,Value=$ACTIVE_USERS,Unit=Count \
        MetricName=OrdersPerMinute,Value=$ORDERS_PER_MINUTE,Unit=Count
    
    echo "$(date): Sent metrics - Response: ${RESPONSE_TIME}ms, Errors: ${ERROR_RATE}%, Users: ${ACTIVE_USERS}, Orders: ${ORDERS_PER_MINUTE}"
    
    # Wait 60 seconds before sending next batch
    sleep 60
done
EOF

# Make the script executable
chmod +x /home/ec2-user/send-metrics.sh
```

#### 3.2 Run Metrics Script
```bash
# Start the metrics script in the background
nohup /home/ec2-user/send-metrics.sh > /home/ec2-user/metrics.log 2>&1 &

# Check that it's running
ps aux | grep send-metrics

# View the log to see metrics being sent
tail -f /home/ec2-user/metrics.log
```

```
💡 EXPLANATION:
- nohup runs the script even if you close the terminal
- The script runs continuously, sending metrics every 60 seconds
- These metrics simulate real application performance data
- In production, your application would send these metrics directly
```

**🎉 Checkpoint 3 Complete!** Your application is now sending custom business metrics.

---

### Step 4: Create CloudWatch Alarms (15 minutes)

Alarms automatically notify you when something goes wrong with your system.

#### 4.1 Navigate to CloudWatch
```
🖥️ VISUAL: AWS Console
📍 Services → CloudWatch
📍 Click "Alarms" in left menu
📍 Click "Create alarm" button
```

#### 4.2 Create High CPU Alarm
```
🖥️ VISUAL: Create Alarm Wizard
📍 Click "Select metric"
📍 Browse: EC2 → Per-Instance Metrics
📍 Find your instance ID and select "CPUUtilization"
📍 Click "Select metric"
```

```
🖥️ VISUAL: Specify Metric and Conditions
📍 Statistic: Average
📍 Period: 5 minutes
📍 Threshold type: Static
📍 Condition: Greater than 80
📍 Click "Next"
```

```
🖥️ VISUAL: Configure Actions
📍 Alarm state trigger: In alarm
📍 Select an SNS topic: Create new topic
📍 Topic name: "tesda-alerts"
📍 Email: your-email@example.com
📍 Click "Create topic"
📍 Click "Next"
```

```
🖥️ VISUAL: Add Name and Description
📍 Alarm name: "WebServer-HighCPU"
📍 Description: "Alert when CPU usage exceeds 80%"
📍 Click "Next"
📍 Click "Create alarm"
```

#### 4.3 Create High Response Time Alarm
```
🖥️ VISUAL: Create another alarm
📍 Click "Create alarm"
📍 Select metric: TESDA/ECommerce/Application → ResponseTime
📍 Condition: Greater than 400 (milliseconds)
📍 Use same SNS topic: "tesda-alerts"
📍 Name: "WebServer-HighResponseTime"
📍 Create alarm
```

#### 4.4 Create High Error Rate Alarm
```
🖥️ VISUAL: Create third alarm
📍 Select metric: TESDA/ECommerce/Application → ErrorRate
📍 Condition: Greater than 3 (percent)
📍 Use same SNS topic: "tesda-alerts"
📍 Name: "WebServer-HighErrorRate"
📍 Create alarm
```

**🎉 Checkpoint 4 Complete!** You now have automated alerts for system problems.

---

### Step 5: Create Monitoring Dashboard (15 minutes)

A dashboard gives you a visual overview of your entire system's health.

#### 5.1 Create New Dashboard
```
🖥️ VISUAL: CloudWatch Console
📍 Click "Dashboards" in left menu
📍 Click "Create dashboard"
📍 Dashboard name: "dashboard-studentX" (Replace X with YOUR student number)
   Example: "dashboard-student1", "dashboard-student2"
📍 Click "Create dashboard"
```

#### 5.2 Add System Metrics Widget
```
🖥️ VISUAL: Add Widget Dialog
📍 Select "Line" widget type
📍 Click "Configure"
📍 Add these metrics:
  - EC2 → Per-Instance Metrics → CPUUtilization (your instance)
  - TESDA/ECommerce → mem_used_percent (your instance)
  - TESDA/ECommerce → disk_used_percent (your instance)
📍 Widget title: "System Performance"
📍 Click "Create widget"
```

#### 5.3 Add Application Metrics Widget
```
🖥️ VISUAL: Click "Add widget"
📍 Select "Line" widget type
📍 Add these metrics:
  - TESDA/ECommerce/Application → ResponseTime
  - TESDA/ECommerce/Application → ErrorRate
  - TESDA/ECommerce/Application → ActiveUsers
📍 Widget title: "Application Performance"
📍 Click "Create widget"
```

#### 5.4 Add Business Metrics Widget
```
🖥️ VISUAL: Click "Add widget"
📍 Select "Number" widget type
📍 Add metric: TESDA/ECommerce/Application → OrdersPerMinute
📍 Widget title: "Orders Per Minute"
📍 Click "Create widget"
```

#### 5.5 Save Dashboard
```
🖥️ VISUAL: Top of dashboard
📍 Click "Save dashboard"
✅ Your dashboard is now saved and updating automatically
```

**🎉 Project 1 Complete!** You've built a complete monitoring system with:
- ✅ System performance monitoring (CPU, memory, disk)
- ✅ Application performance tracking (response time, errors)
- ✅ Business metrics monitoring (users, orders)
- ✅ Automated alerts for problems
- ✅ Visual dashboard for overview

---

## 📊 Project 1 Assessment (5 minutes)

### Verification Checklist
Test each component to ensure it's working:

1. **Website is running**: ✅ Can you access your website?
2. **Metrics are flowing**: ✅ Do you see data in CloudWatch?
3. **Alarms are configured**: ✅ Are your 3 alarms created?
4. **Dashboard is displaying**: ✅ Does your dashboard show live data?

### Understanding Check
Answer these questions:
1. What happens if CPU usage goes above 80%?
2. How often are metrics collected?
3. What business metrics are you tracking?
4. How would you add a new metric?

**🎯 Project 1 Score: ___/25 points**

---

## 📋 Project 2: Automated Log Analysis (80 minutes)

### What You'll Build
An intelligent log analysis system that:
- Collects logs from multiple sources
- Automatically identifies error patterns
- Sends alerts for critical issues
- Provides searchable log insights

### Real-World Scenario
Your e-commerce website generates thousands of log entries every hour. Manually reading through them is impossible. You need an automated system that can find problems, security threats, and performance issues automatically.

---

### Step 1: Set Up Log Groups (10 minutes)

#### 1.1 Create Log Groups in CloudWatch
```
🖥️ VISUAL: CloudWatch Console
📍 Click "Log groups" in left menu
📍 Click "Create log group"
📍 Log group name: "/tesda/webserver/access"
📍 Retention: 30 days
📍 Click "Create"
```

```
🖥️ VISUAL: Create second log group
📍 Click "Create log group" again
📍 Log group name: "/tesda/webserver/error"
📍 Retention: 30 days
📍 Click "Create"
```

```
🖥️ VISUAL: Create third log group
📍 Log group name: "/tesda/webserver/application"
📍 Retention: 30 days
📍 Click "Create"
```

```
💡 EXPLANATION:
- Log groups organize different types of logs
- Access logs show who visited your website
- Error logs show system problems
- Application logs show business events
- 30-day retention saves storage costs
```

---

### Step 2: Generate Sample Application Logs (15 minutes)

#### 2.1 Create Log Generator Script
```bash
# Connect back to your EC2 instance terminal
# Create a script that generates realistic application logs

cat > /home/ec2-user/generate-logs.sh << 'EOF'
#!/bin/bash

# This script generates realistic e-commerce application logs
LOG_FILE="/var/log/application.log"

# Create log file if it doesn't exist
sudo touch $LOG_FILE
sudo chmod 666 $LOG_FILE

while true; do
    TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
    
    # Generate different types of log entries based on probability
    RAND=$(shuf -i 1-100 -n 1)
    
    if [ $RAND -le 60 ]; then
        # Normal successful operations (60% of logs)
        USER_ID=$(shuf -i 1000-9999 -n 1)
        ACTIONS=("login" "view_product" "add_to_cart" "checkout" "payment_success")
        ACTION=${ACTIONS[$RANDOM % ${#ACTIONS[@]}]}
        echo "[$TIMESTAMP] INFO: User $USER_ID performed $ACTION successfully" >> $LOG_FILE
        
    elif [ $RAND -le 80 ]; then
        # Warning messages (20% of logs)
        WARNINGS=("slow_database_query" "high_memory_usage" "cache_miss" "external_api_timeout")
        WARNING=${WARNINGS[$RANDOM % ${#WARNINGS[@]}]}
        DURATION=$(shuf -i 500-2000 -n 1)
        echo "[$TIMESTAMP] WARN: $WARNING detected, duration: ${DURATION}ms" >> $LOG_FILE
        
    elif [ $RAND -le 95 ]; then
        # Error messages (15% of logs)
        USER_ID=$(shuf -i 1000-9999 -n 1)
        ERRORS=("database_connection_failed" "payment_processing_error" "inventory_check_failed" "user_authentication_failed")
        ERROR=${ERRORS[$RANDOM % ${#ERRORS[@]}]}
        echo "[$TIMESTAMP] ERROR: $ERROR for user $USER_ID" >> $LOG_FILE
        
    else
        # Critical errors (5% of logs)
        TRANSACTION_ID=$(shuf -i 10000-99999 -n 1)
        CRITICAL_ERRORS=("payment_gateway_down" "database_server_unreachable" "security_breach_detected" "system_out_of_memory")
        CRITICAL=${CRITICAL_ERRORS[$RANDOM % ${#CRITICAL_ERRORS[@]}]}
        echo "[$TIMESTAMP] CRITICAL: $CRITICAL - transaction_id: $TRANSACTION_ID" >> $LOG_FILE
    fi
    
    # Wait 5-15 seconds between log entries
    sleep $(shuf -i 5-15 -n 1)
done
EOF

# Make script executable
chmod +x /home/ec2-user/generate-logs.sh
```

#### 2.2 Start Log Generation
```bash
# Start generating logs in background
nohup /home/ec2-user/generate-logs.sh > /dev/null 2>&1 &

# Check that it's running
ps aux | grep generate-logs

# View the logs being generated
tail -f /var/log/application.log
```

```
💡 EXPLANATION:
- This script creates realistic e-commerce logs
- 60% normal operations, 20% warnings, 15% errors, 5% critical
- Logs include timestamps, severity levels, and relevant details
- In production, your application would generate these logs naturally
```

#### 2.3 Configure CloudWatch Agent for Application Logs
```bash
# Update CloudWatch agent configuration to include application logs
sudo cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json << 'EOF'
{
    "metrics": {
        "namespace": "TESDA/ECommerce",
        "metrics_collected": {
            "cpu": {
                "measurement": ["cpu_usage_idle", "cpu_usage_user", "cpu_usage_system"],
                "metrics_collection_interval": 60
            },
            "mem": {
                "measurement": ["mem_used_percent"],
                "metrics_collection_interval": 60
            },
            "disk": {
                "measurement": ["used_percent"],
                "metrics_collection_interval": 60,
                "resources": ["*"]
            }
        }
    },
    "logs": {
        "logs_collected": {
            "files": {
                "collect_list": [
                    {
                        "file_path": "/var/log/httpd/access_log",
                        "log_group_name": "/tesda/webserver/access",
                        "log_stream_name": "{instance_id}"
                    },
                    {
                        "file_path": "/var/log/httpd/error_log",
                        "log_group_name": "/tesda/webserver/error",
                        "log_stream_name": "{instance_id}"
                    },
                    {
                        "file_path": "/var/log/application.log",
                        "log_group_name": "/tesda/webserver/application",
                        "log_stream_name": "{instance_id}"
                    }
                ]
            }
        }
    }
}
EOF

# Restart CloudWatch agent with new configuration
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -a fetch-config -m ec2 -s \
    -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
```

---

### Step 3: Create Automated Log Analysis (25 minutes)

#### 3.1 Create Lambda Function for Log Analysis
```
🖥️ VISUAL: AWS Console
📍 Services → Lambda
📍 Click "Create function"
📍 Choose "Author from scratch"
📍 Function name: "LogAnalyzer"
📍 Runtime: Python 3.9
📍 Click "Create function"
```

#### 3.2 Add Lambda Function Code
```
🖥️ VISUAL: Lambda Function Console
📍 Scroll down to "Code source" section
📍 Replace the default code with this:
```

```python
import json
import boto3
import gzip
import base64
import re
from datetime import datetime

def lambda_handler(event, context):
    # Initialize AWS services
    sns = boto3.client('sns')
    cloudwatch = boto3.client('cloudwatch')
    
    # Decode CloudWatch Logs data
    cw_data = event['awslogs']['data']
    compressed_payload = base64.b64decode(cw_data)
    uncompressed_payload = gzip.decompress(compressed_payload)
    log_data = json.loads(uncompressed_payload)
    
    # Initialize counters
    error_count = 0
    critical_count = 0
    warning_count = 0
    
    # Analyze each log entry
    for log_event in log_data['logEvents']:
        message = log_event['message']
        timestamp = log_event['timestamp']
        
        # Count different types of messages
        if 'ERROR' in message:
            error_count += 1
            
            # Check for specific critical errors
            if 'database_connection_failed' in message:
                send_alert(sns, 'Database Connection Error', message, 'HIGH')
            elif 'payment_processing_error' in message:
                send_alert(sns, 'Payment System Error', message, 'HIGH')
                
        elif 'CRITICAL' in message:
            critical_count += 1
            
            # All critical messages get immediate alerts
            if 'payment_gateway_down' in message:
                send_alert(sns, 'CRITICAL: Payment Gateway Down', message, 'CRITICAL')
            elif 'security_breach_detected' in message:
                send_alert(sns, 'CRITICAL: Security Breach', message, 'CRITICAL')
            else:
                send_alert(sns, 'Critical System Error', message, 'CRITICAL')
                
        elif 'WARN' in message:
            warning_count += 1
    
    # Send metrics to CloudWatch
    if error_count > 0:
        cloudwatch.put_metric_data(
            Namespace='TESDA/ECommerce/Logs',
            MetricData=[
                {
                    'MetricName': 'ErrorCount',
                    'Value': error_count,
                    'Unit': 'Count',
                    'Timestamp': datetime.utcnow()
                }
            ]
        )
    
    if critical_count > 0:
        cloudwatch.put_metric_data(
            Namespace='TESDA/ECommerce/Logs',
            MetricData=[
                {
                    'MetricName': 'CriticalErrorCount',
                    'Value': critical_count,
                    'Unit': 'Count',
                    'Timestamp': datetime.utcnow()
                }
            ]
        )
    
    if warning_count > 0:
        cloudwatch.put_metric_data(
            Namespace='TESDA/ECommerce/Logs',
            MetricData=[
                {
                    'MetricName': 'WarningCount',
                    'Value': warning_count,
                    'Unit': 'Count',
                    'Timestamp': datetime.utcnow()
                }
            ]
        )
    
    return {
        'statusCode': 200,
        'body': json.dumps({
            'processed_events': len(log_data['logEvents']),
            'errors_found': error_count,
            'critical_found': critical_count,
            'warnings_found': warning_count
        })
    }

def send_alert(sns_client, subject, message, priority):
    """Send alert notification via SNS"""
    try:
        sns_client.publish(
            TopicArn='arn:aws:sns:us-east-1:YOUR_ACCOUNT_ID:tesda-alerts',
            Subject=f'[{priority}] {subject}',
            Message=f'Alert Details:\n\n{message}\n\nTime: {datetime.utcnow()}\nPriority: {priority}'
        )
    except Exception as e:
        print(f'Failed to send alert: {e}')
```

```
📍 Click "Deploy" to save the function
```

#### 3.3 Configure Lambda Permissions
```
🖥️ VISUAL: Lambda Function Console
📍 Click "Configuration" tab
📍 Click "Permissions" in left menu
📍 Click on the execution role name (opens IAM)
```

```
🖥️ VISUAL: IAM Role Console
📍 Click "Add permissions" → "Attach policies"
📍 Search and select these policies:
  - CloudWatchFullAccess
  - AmazonSNSFullAccess
📍 Click "Add permissions"
```

#### 3.4 Set Up Log Trigger
```
🖥️ VISUAL: Back to Lambda Function
📍 Click "Add trigger"
📍 Select "CloudWatch Logs"
📍 Log group: "/tesda/webserver/application"
📍 Filter name: "ErrorFilter"
📍 Filter pattern: [timestamp, level="ERROR" || level="CRITICAL"]
📍 Click "Add"
```

---

### Step 4: Create Log Insights Queries (15 minutes)

#### 4.1 Access CloudWatch Logs Insights
```
🖥️ VISUAL: CloudWatch Console
📍 Click "Logs Insights" in left menu
📍 Select log group: "/tesda/webserver/application"
📍 Time range: Last 1 hour
```

#### 4.2 Query 1: Find All Errors
```sql
fields @timestamp, @message
| filter @message like /ERROR/
| sort @timestamp desc
| limit 50
```

```
📍 Click "Run query"
💡 This shows all error messages in chronological order
```

#### 4.3 Query 2: Count Errors by Type
```sql
fields @timestamp, @message
| filter @message like /ERROR/
| parse @message "ERROR: * for" as error_type
| stats count() by error_type
| sort count desc
```

```
📍 Click "Run query"
💡 This shows which types of errors occur most frequently
```

#### 4.4 Query 3: Critical Events Timeline
```sql
fields @timestamp, @message
| filter @message like /CRITICAL/
| sort @timestamp desc
| limit 20
```

```
📍 Click "Run query"
💡 This shows all critical events that need immediate attention
```

#### 4.5 Query 4: User Activity Analysis
```sql
fields @timestamp, @message
| filter @message like /User/
| parse @message "User * performed" as user_id
| stats count() by user_id
| sort count desc
| limit 10
```

```
📍 Click "Run query"
💡 This shows which users are most active on your system
```

---

### Step 5: Create Log-Based Alarms (15 minutes)

#### 5.1 Create Metric Filter for Errors
```
🖥️ VISUAL: CloudWatch Console
📍 Click "Log groups" in left menu
📍 Click "/tesda/webserver/application"
📍 Click "Metric filters" tab
📍 Click "Create metric filter"
```

```
🖥️ VISUAL: Define Filter Pattern
📍 Filter pattern: [timestamp, level="ERROR"]
📍 Test pattern with sample data
📍 Click "Next"
```

```
🖥️ VISUAL: Assign Metric
📍 Filter name: "ApplicationErrors"
📍 Metric namespace: "TESDA/ECommerce/Logs"
📍 Metric name: "ErrorCount"
📍 Metric value: 1
📍 Click "Next"
📍 Click "Create metric filter"
```

#### 5.2 Create Alarm from Log Metrics
```
🖥️ VISUAL: CloudWatch Alarms
📍 Click "Alarms" in left menu
📍 Click "Create alarm"
📍 Select metric: TESDA/ECommerce/Logs → ErrorCount
📍 Condition: Greater than 5 (errors in 5 minutes)
📍 Use existing SNS topic: "tesda-alerts"
📍 Alarm name: "HighErrorRate-FromLogs"
📍 Create alarm
```

#### 5.3 Create Critical Error Filter
```
🖥️ VISUAL: Back to Log Groups
📍 Create another metric filter
📍 Filter pattern: [timestamp, level="CRITICAL"]
📍 Metric name: "CriticalErrorCount"
📍 Create alarm: Greater than 1 (any critical error)
📍 Alarm name: "CriticalErrors-Immediate"
```

**🎉 Project 2 Complete!** You've built an intelligent log analysis system with:
- ✅ Automated log collection from multiple sources
- ✅ Smart pattern recognition for errors and critical events
- ✅ Real-time alerts for important issues
- ✅ Searchable log insights with custom queries
- ✅ Metric-based alarms from log data

---

## 📊 Project 2 Assessment (5 minutes)

### Verification Checklist
1. **Logs are flowing**: ✅ Can you see logs in CloudWatch Log Groups?
2. **Lambda is processing**: ✅ Is the Lambda function being triggered?
3. **Queries work**: ✅ Do your Log Insights queries return results?
4. **Alarms are active**: ✅ Are log-based alarms created?

### Understanding Check
1. What happens when a CRITICAL error occurs?
2. How can you find the most common error types?
3. What's the difference between metric filters and Log Insights?
4. How would you add monitoring for a new log pattern?

**🎯 Project 2 Score: ___/25 points**

---

## 🏗️ Project 3: Self-Healing Infrastructure (80 minutes)

### What You'll Build
A complete self-healing infrastructure that:
- Automatically deploys using code templates
- Scales up when traffic increases
- Scales down when traffic decreases
- Replaces failed servers automatically
- Includes built-in monitoring

### Real-World Scenario
Your e-commerce website experiences traffic spikes during sales events (like 11.11 or 12.12). You need infrastructure that can handle 10x normal traffic automatically, then scale back down to save costs when the event ends.

---

### Step 1: Create CloudFormation Template (25 minutes)

CloudFormation lets you define your entire infrastructure as code - like a blueprint for building your system.

#### 1.1 Create Template File
```bash
# In your EC2 terminal, create a CloudFormation template
cat > /home/ec2-user/self-healing-infrastructure.yaml << 'EOF'
AWSTemplateFormatVersion: '2010-09-09'
Description: 'Self-healing e-commerce infrastructure for TESDA training'

Parameters:
  KeyName:
    Type: String
    Default: 'your-key-pair'
    Description: 'EC2 Key Pair for SSH access'

Resources:
  # VPC - Your private network in the cloud
  VPC:
    Type: AWS::EC2::VPC
    Properties:
      CidrBlock: 10.0.0.0/16
      EnableDnsHostnames: true
      EnableDnsSupport: true
      Tags:
        - Key: Name
          Value: TESDA-ECommerce-VPC

  # Internet Gateway - Connects your VPC to the internet
  InternetGateway:
    Type: AWS::EC2::InternetGateway
    Properties:
      Tags:
        - Key: Name
          Value: TESDA-IGW

  # Attach Internet Gateway to VPC
  AttachGateway:
    Type: AWS::EC2::VPCGatewayAttachment
    Properties:
      VpcId: !Ref VPC
      InternetGatewayId: !Ref InternetGateway

  # Public Subnet 1 - Where your servers will live
  PublicSubnet1:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref VPC
      CidrBlock: 10.0.1.0/24
      AvailabilityZone: !Select [0, !GetAZs '']
      MapPublicIpOnLaunch: true
      Tags:
        - Key: Name
          Value: TESDA-Public-Subnet-1

  # Public Subnet 2 - For high availability
  PublicSubnet2:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref VPC
      CidrBlock: 10.0.2.0/24
      AvailabilityZone: !Select [1, !GetAZs '']
      MapPublicIpOnLaunch: true
      Tags:
        - Key: Name
          Value: TESDA-Public-Subnet-2

  # Route Table - Defines how traffic flows
  PublicRouteTable:
    Type: AWS::EC2::RouteTable
    Properties:
      VpcId: !Ref VPC
      Tags:
        - Key: Name
          Value: TESDA-Public-Routes

  # Route to Internet
  PublicRoute:
    Type: AWS::EC2::Route
    DependsOn: AttachGateway
    Properties:
      RouteTableId: !Ref PublicRouteTable
      DestinationCidrBlock: 0.0.0.0/0
      GatewayId: !Ref InternetGateway

  # Associate Route Table with Subnets
  PublicSubnetRouteTableAssociation1:
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      SubnetId: !Ref PublicSubnet1
      RouteTableId: !Ref PublicRouteTable

  PublicSubnetRouteTableAssociation2:
    Type: AWS::EC2::SubnetRouteTableAssociation
    Properties:
      SubnetId: !Ref PublicSubnet2
      RouteTableId: !Ref PublicRouteTable

  # Security Group - Firewall rules
  WebServerSecurityGroup:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: 'Security group for web servers'
      VpcId: !Ref VPC
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 80
          ToPort: 80
          CidrIp: 0.0.0.0/0
          Description: 'HTTP access from anywhere'
        - IpProtocol: tcp
          FromPort: 443
          ToPort: 443
          CidrIp: 0.0.0.0/0
          Description: 'HTTPS access from anywhere'
        - IpProtocol: tcp
          FromPort: 22
          ToPort: 22
          CidrIp: 0.0.0.0/0
          Description: 'SSH access'
      Tags:
        - Key: Name
          Value: TESDA-WebServer-SG

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

  # Instance Profile
  EC2InstanceProfile:
    Type: AWS::IAM::InstanceProfile
    Properties:
      Roles:
        - !Ref EC2Role

  # Launch Template - Blueprint for new servers
  LaunchTemplate:
    Type: AWS::EC2::LaunchTemplate
    Properties:
      LaunchTemplateName: TESDA-WebServer-Template
      LaunchTemplateData:
        ImageId: ami-0abcdef1234567890  # Amazon Linux 2023
        InstanceType: t3.micro
        KeyName: !Ref KeyName
        SecurityGroupIds:
          - !Ref WebServerSecurityGroup
        IamInstanceProfile:
          Arn: !GetAtt EC2InstanceProfile.Arn
        UserData:
          Fn::Base64: !Sub |
            #!/bin/bash
            # Install and configure web server with monitoring
            yum update -y
            yum install -y httpd
            systemctl start httpd
            systemctl enable httpd
            
            # Install CloudWatch agent
            wget https://s3.amazonaws.com/amazoncloudwatch-agent/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
            rpm -U ./amazon-cloudwatch-agent.rpm
            
            # Create enhanced website
            cat > /var/www/html/index.html << 'HTML'
            <!DOCTYPE html>
            <html>
            <head>
                <title>Self-Healing E-commerce Site</title>
                <style>
                    body { font-family: Arial, sans-serif; margin: 40px; background: #f5f5f5; }
                    .container { max-width: 800px; margin: 0 auto; background: white; padding: 30px; border-radius: 10px; }
                    .header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 20px; border-radius: 5px; }
                    .status { background: #4CAF50; color: white; padding: 15px; margin: 20px 0; border-radius: 5px; }
                    .metrics { background: #e3f2fd; padding: 20px; margin: 20px 0; border-radius: 5px; }
                    .server-info { background: #fff3e0; padding: 15px; margin: 20px 0; border-radius: 5px; }
                </style>
            </head>
            <body>
                <div class="container">
                    <div class="header">
                        <h1>🛒 Self-Healing E-commerce Platform</h1>
                        <p>TESDA Operational Excellence Demo</p>
                    </div>
                    
                    <div class="status">
                        <h2>✅ System Status: ONLINE & AUTO-SCALING</h2>
                        <p>This server was automatically created and configured!</p>
                    </div>
                    
                    <div class="server-info">
                        <h3>🖥️ Server Information</h3>
                        <p><strong>Instance ID:</strong> <span id="instance-id">Loading...</span></p>
                        <p><strong>Availability Zone:</strong> <span id="az">Loading...</span></p>
                        <p><strong>Launch Time:</strong> <span id="launch-time">Loading...</span></p>
                    </div>
                    
                    <div class="metrics">
                        <h3>📊 Real-time Metrics</h3>
                        <p><strong>Current Time:</strong> <span id="time"></span></p>
                        <p><strong>Uptime:</strong> <span id="uptime">0 seconds</span></p>
                        <p><strong>Page Views:</strong> <span id="views">1</span></p>
                        <p><strong>Load Status:</strong> <span id="load">Normal</span></p>
                    </div>
                </div>
                
                <script>
                    // Get instance metadata
                    fetch('http://169.254.169.254/latest/meta-data/instance-id')
                        .then(response => response.text())
                        .then(data => document.getElementById('instance-id').textContent = data);
                    
                    fetch('http://169.254.169.254/latest/meta-data/placement/availability-zone')
                        .then(response => response.text())
                        .then(data => document.getElementById('az').textContent = data);
                    
                    // Update time and uptime
                    let uptime = 0;
                    let views = 1;
                    
                    function updateMetrics() {
                        document.getElementById('time').textContent = new Date().toLocaleString();
                        uptime++;
                        document.getElementById('uptime').textContent = uptime + ' seconds';
                        
                        // Simulate load status
                        const loadStates = ['Normal', 'Busy', 'High Load'];
                        const randomLoad = loadStates[Math.floor(Math.random() * loadStates.length)];
                        document.getElementById('load').textContent = randomLoad;
                    }
                    
                    setInterval(updateMetrics, 1000);
                    updateMetrics();
                    
                    // Track page views
                    setInterval(() => {
                        views++;
                        document.getElementById('views').textContent = views;
                    }, 5000);
                </script>
            </body>
            </html>
            HTML
            
            # Configure CloudWatch agent
            cat > /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json << 'JSON'
            {
                "metrics": {
                    "namespace": "TESDA/SelfHealing",
                    "metrics_collected": {
                        "cpu": {
                            "measurement": ["cpu_usage_idle", "cpu_usage_user"],
                            "metrics_collection_interval": 60
                        },
                        "mem": {
                            "measurement": ["mem_used_percent"],
                            "metrics_collection_interval": 60
                        }
                    }
                }
            }
            JSON
            
            # Start CloudWatch agent
            /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
                -a fetch-config -m ec2 -s \
                -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json

  # Application Load Balancer
  ApplicationLoadBalancer:
    Type: AWS::ElasticLoadBalancingV2::LoadBalancer
    Properties:
      Name: TESDA-SelfHealing-ALB
      Type: application
      Scheme: internet-facing
      Subnets:
        - !Ref PublicSubnet1
        - !Ref PublicSubnet2
      SecurityGroups:
        - !Ref WebServerSecurityGroup
      Tags:
        - Key: Name
          Value: TESDA-SelfHealing-ALB

  # Target Group for Load Balancer
  TargetGroup:
    Type: AWS::ElasticLoadBalancingV2::TargetGroup
    Properties:
      Name: TESDA-WebServers
      Port: 80
      Protocol: HTTP
      VpcId: !Ref VPC
      HealthCheckPath: /
      HealthCheckIntervalSeconds: 30
      HealthyThresholdCount: 2
      UnhealthyThresholdCount: 3
      TargetType: instance

  # Load Balancer Listener
  Listener:
    Type: AWS::ElasticLoadBalancingV2::Listener
    Properties:
      DefaultActions:
        - Type: forward
          TargetGroupArn: !Ref TargetGroup
      LoadBalancerArn: !Ref ApplicationLoadBalancer
      Port: 80
      Protocol: HTTP

  # Auto Scaling Group - The self-healing magic!
  AutoScalingGroup:
    Type: AWS::AutoScaling::AutoScalingGroup
    Properties:
      AutoScalingGroupName: TESDA-SelfHealing-ASG
      VPCZoneIdentifier:
        - !Ref PublicSubnet1
        - !Ref PublicSubnet2
      LaunchTemplate:
        LaunchTemplateId: !Ref LaunchTemplate
        Version: !GetAtt LaunchTemplate.LatestVersionNumber
      MinSize: 2
      MaxSize: 6
      DesiredCapacity: 2
      TargetGroupARNs:
        - !Ref TargetGroup
      HealthCheckType: ELB
      HealthCheckGracePeriod: 300
      Tags:
        - Key: Name
          Value: TESDA-SelfHealing-Server
          PropagateAtLaunch: true

  # Auto Scaling Policies
  ScaleUpPolicy:
    Type: AWS::AutoScaling::ScalingPolicy
    Properties:
      AdjustmentType: ChangeInCapacity
      AutoScalingGroupName: !Ref AutoScalingGroup
      Cooldown: 300
      ScalingAdjustment: 1
      PolicyType: SimpleScaling

  ScaleDownPolicy:
    Type: AWS::AutoScaling::ScalingPolicy
    Properties:
      AdjustmentType: ChangeInCapacity
      AutoScalingGroupName: !Ref AutoScalingGroup
      Cooldown: 300
      ScalingAdjustment: -1
      PolicyType: SimpleScaling

  # CloudWatch Alarms for Auto Scaling
  HighCPUAlarm:
    Type: AWS::CloudWatch::Alarm
    Properties:
      AlarmName: TESDA-HighCPU-ScaleUp
      AlarmDescription: 'Scale up when CPU is high'
      MetricName: CPUUtilization
      Namespace: AWS/EC2
      Statistic: Average
      Period: 300
      EvaluationPeriods: 2
      Threshold: 70
      ComparisonOperator: GreaterThanThreshold
      AlarmActions:
        - !Ref ScaleUpPolicy
      Dimensions:
        - Name: AutoScalingGroupName
          Value: !Ref AutoScalingGroup

  LowCPUAlarm:
    Type: AWS::CloudWatch::Alarm
    Properties:
      AlarmName: TESDA-LowCPU-ScaleDown
      AlarmDescription: 'Scale down when CPU is low'
      MetricName: CPUUtilization
      Namespace: AWS/EC2
      Statistic: Average
      Period: 300
      EvaluationPeriods: 2
      Threshold: 20
      ComparisonOperator: LessThanThreshold
      AlarmActions:
        - !Ref ScaleDownPolicy
      Dimensions:
        - Name: AutoScalingGroupName
          Value: !Ref AutoScalingGroup

Outputs:
  LoadBalancerURL:
    Description: 'URL of the load balancer'
    Value: !Sub 'http://${ApplicationLoadBalancer.DNSName}'
    Export:
      Name: TESDA-LoadBalancer-URL
  
  AutoScalingGroupName:
    Description: 'Name of the Auto Scaling Group'
    Value: !Ref AutoScalingGroup
    Export:
      Name: TESDA-ASG-Name
EOF
```

```
💡 EXPLANATION:
This template creates:
- VPC: Your private network in AWS
- Subnets: Different zones for high availability
- Security Groups: Firewall rules
- Load Balancer: Distributes traffic across servers
- Auto Scaling Group: Automatically adds/removes servers
- CloudWatch Alarms: Triggers scaling based on CPU usage
```

---

### Step 2: Deploy Self-Healing Infrastructure (20 minutes)

#### 2.1 Create CloudFormation Stack
```
🖥️ VISUAL: AWS Console
📍 Services → CloudFormation
📍 Click "Create stack" → "With new resources"
📍 Choose "Upload a template file"
📍 Click "Choose file" and upload your template
📍 Click "Next"
```

```
🖥️ VISUAL: Specify Stack Details
📍 Stack name: "TESDA-SelfHealing-Infrastructure"
📍 KeyName: (leave default or specify your key pair)
📍 Click "Next"
```

```
🖥️ VISUAL: Configure Stack Options
📍 Leave all defaults
📍 Click "Next"
```

```
🖥️ VISUAL: Review
📍 Check "I acknowledge that AWS CloudFormation might create IAM resources"
📍 Click "Create stack"
```

```
⏳ WAIT: Stack creation takes 5-10 minutes
📍 Watch the "Events" tab to see progress
✅ Status should change to "CREATE_COMPLETE"
```

#### 2.2 Get Load Balancer URL
```
🖥️ VISUAL: CloudFormation Console
📍 Click "Outputs" tab
📍 Copy the "LoadBalancerURL" value
📍 Open in new browser tab
✅ You should see your self-healing website!
```

---

### Step 3: Test Self-Healing Capabilities (20 minutes)

#### 3.1 View Current Infrastructure
```
🖥️ VISUAL: EC2 Console
📍 Click "Instances" in left menu
📍 You should see 2 instances named "TESDA-SelfHealing-Server"
📍 Both should be "Running"
```

```
🖥️ VISUAL: Auto Scaling Groups
📍 Click "Auto Scaling Groups" in left menu
📍 Click "TESDA-SelfHealing-ASG"
📍 See current capacity: 2 instances
```

#### 3.2 Test Automatic Healing
```
🖥️ VISUAL: Simulate server failure
📍 In EC2 Instances, select one "TESDA-SelfHealing-Server"
📍 Click "Instance state" → "Terminate instance"
📍 Click "Terminate"
```

```
⏳ WATCH: Auto-healing in action
📍 Refresh the instances page every 30 seconds
📍 You'll see the terminated instance disappear
📍 A new instance will automatically launch
📍 Total instances will return to 2
⏱️ This takes about 3-5 minutes
```

#### 3.3 Test Load Balancer
```
🖥️ VISUAL: Test high availability
📍 Keep refreshing your load balancer URL
📍 Notice the "Instance ID" changes between servers
📍 Even during server replacement, website stays online
✅ This proves your infrastructure is self-healing!
```

#### 3.4 Generate Load to Test Auto Scaling
```bash
# In your original EC2 terminal, create a load testing script
cat > /home/ec2-user/load-test.sh << 'EOF'
#!/bin/bash

# Replace with your actual load balancer URL
LOAD_BALANCER_URL="http://YOUR-LOAD-BALANCER-URL"

echo "Starting load test to trigger auto scaling..."
echo "This will generate high CPU usage to test scaling"

# Generate load for 10 minutes
for i in {1..600}; do
    # Send 10 concurrent requests
    for j in {1..10}; do
        curl -s $LOAD_BALANCER_URL > /dev/null &
    done
    
    if [ $((i % 30)) -eq 0 ]; then
        echo "Sent $((i * 10)) requests so far..."
    fi
    
    sleep 1
done

wait
echo "Load test completed!"
EOF

chmod +x /home/ec2-user/load-test.sh
```

```bash
# Update the script with your actual load balancer URL
# Get the URL from CloudFormation outputs
LOAD_BALANCER_URL=$(aws cloudformation describe-stacks \
    --stack-name TESDA-SelfHealing-Infrastructure \
    --query 'Stacks[0].Outputs[?OutputKey==`LoadBalancerURL`].OutputValue' \
    --output text)

echo "Load Balancer URL: $LOAD_BALANCER_URL"

# Update the script
sed -i "s|YOUR-LOAD-BALANCER-URL|$LOAD_BALANCER_URL|g" /home/ec2-user/load-test.sh

# Run the load test
/home/ec2-user/load-test.sh
```

```
⏳ WATCH: Auto scaling in action (5-10 minutes)
📍 Monitor EC2 instances - you should see new ones launching
📍 Check Auto Scaling Group - capacity should increase to 3-4 instances
📍 After load test ends, instances will scale back down
```

---

### Step 4: Monitor Self-Healing Infrastructure (15 minutes)

#### 4.1 Create Infrastructure Dashboard
```
🖥️ VISUAL: CloudWatch Console
📍 Click "Dashboards" → "Create dashboard"
📍 Dashboard name: "selfhealing-studentX" (Replace X with YOUR student number)
   Example: "selfhealing-student1", "selfhealing-student2"
📍 Click "Create dashboard"
```

#### 4.2 Add Auto Scaling Metrics
```
🖥️ VISUAL: Add Widget
📍 Select "Line" widget
📍 Add metrics:
  - AWS/AutoScaling → GroupDesiredCapacity
  - AWS/AutoScaling → GroupInServiceInstances
  - AWS/AutoScaling → GroupTotalInstances
📍 Widget title: "Auto Scaling Status"
📍 Create widget
```

#### 4.3 Add Load Balancer Metrics
```
🖥️ VISUAL: Add another widget
📍 Select "Line" widget
📍 Add metrics:
  - AWS/ApplicationELB → RequestCount
  - AWS/ApplicationELB → TargetResponseTime
  - AWS/ApplicationELB → HTTPCode_Target_2XX_Count
📍 Widget title: "Load Balancer Performance"
📍 Create widget
```

#### 4.4 Add System Health Metrics
```
🖥️ VISUAL: Add third widget
📍 Select "Line" widget
📍 Add metrics:
  - TESDA/SelfHealing → CPUUtilization
  - TESDA/SelfHealing → MemoryUtilization
📍 Widget title: "System Health"
📍 Create widget
```

```
📍 Save dashboard
✅ You now have complete visibility into your self-healing infrastructure!
```

**🎉 Project 3 Complete!** You've built a complete self-healing infrastructure with:
- ✅ Infrastructure as Code deployment
- ✅ Automatic server replacement when failures occur
- ✅ Auto scaling based on demand
- ✅ Load balancing for high availability
- ✅ Comprehensive monitoring and alerting

---

## 📊 Project 3 Assessment (5 minutes)

### Verification Checklist
1. **Infrastructure deployed**: ✅ CloudFormation stack created successfully?
2. **Load balancer working**: ✅ Can you access the website via load balancer?
3. **Auto healing tested**: ✅ Did new server launch when you terminated one?
4. **Auto scaling working**: ✅ Did additional servers launch during load test?
5. **Monitoring active**: ✅ Dashboard showing real-time metrics?

### Understanding Check
1. What happens when you terminate a server in the Auto Scaling Group?
2. What triggers the system to add more servers?
3. How does the load balancer ensure high availability?
4. What's the difference between desired, minimum, and maximum capacity?

**🎯 Project 3 Score: ___/25 points**

---

## 🎯 Final Day 2 Assessment (20 minutes)

### Comprehensive Integration Test

#### Test Scenario: Black Friday Sale Event
Your e-commerce website is having a Black Friday sale. Simulate this scenario:

1. **Normal Operations** (5 minutes)
   - Website accessible via load balancer ✅
   - Monitoring shows normal metrics ✅
   - All alarms in OK state ✅

2. **Traffic Spike** (10 minutes)
   - Run load test to simulate high traffic
   - Verify auto scaling adds servers ✅
   - Confirm website remains responsive ✅
   - Check that alerts are sent appropriately ✅

3. **Server Failure During Peak** (5 minutes)
   - Terminate one server during load test
   - Verify automatic replacement ✅
   - Confirm no service interruption ✅
   - Validate monitoring captures the event ✅

### Knowledge Assessment Quiz

**Question 1**: What are the three main components of observability?
- A) Metrics, Logs, Traces
- B) CPU, Memory, Disk
- C) Alarms, Dashboards, Notifications
- D) Monitoring, Alerting, Automation

**Question 2**: What triggers auto scaling in your infrastructure?
- A) Time-based schedules
- B) CloudWatch alarms based on CPU usage
- C) Manual intervention
- D) Load balancer health checks

**Question 3**: How does Infrastructure as Code improve operational excellence?
- A) It's faster than manual setup
- B) It ensures consistent, repeatable deployments
- C) It reduces costs
- D) It improves security

**Question 4**: What happens when CloudWatch detects a critical error in logs?
- A) It automatically fixes the error
- B) It sends an alert via SNS
- C) It restarts the application
- D) It scales up the infrastructure

**Question 5**: What makes your infrastructure "self-healing"?
- A) It never breaks
- B) It automatically replaces failed components
- C) It prevents all errors
- D) It runs faster than normal infrastructure

### Answers:
1. A, 2. B, 3. B, 4. B, 5. B

---

## 🏆 Day 2 Final Scores

### Project Scores
- **Project 1 - System Monitoring**: ___/25 points
- **Project 2 - Log Analysis**: ___/25 points  
- **Project 3 - Self-Healing Infrastructure**: ___/25 points
- **Knowledge Assessment**: ___/25 points

### **Total Day 2 Score: ___/100 points**

**Passing Score: 70+ points**

---

## 🎓 What You've Accomplished Today

### Technical Skills Gained
- ✅ **Professional Monitoring**: Set up enterprise-grade system monitoring
- ✅ **Automated Log Analysis**: Built intelligent log processing systems
- ✅ **Self-Healing Infrastructure**: Created systems that fix themselves
- ✅ **Infrastructure as Code**: Deployed infrastructure using code templates
- ✅ **Auto Scaling**: Implemented automatic capacity management

### Business Value Created
- **99.9% Uptime**: Your systems can now maintain high availability
- **Cost Optimization**: Auto scaling saves money by adjusting capacity
- **Faster Problem Resolution**: Automated alerts reduce response time
- **Scalability**: Handle traffic spikes without manual intervention
- **Reliability**: Self-healing prevents extended outages

### Career Readiness
You now have hands-on experience with:
- Amazon CloudWatch (monitoring and alerting)
- AWS Lambda (serverless computing)
- CloudFormation (infrastructure as code)
- Auto Scaling Groups (automatic capacity management)
- Application Load Balancers (high availability)
- Log analysis and pattern recognition

**These skills are directly applicable to roles like:**
- Cloud Operations Engineer (₱50,000-80,000/month)
- DevOps Engineer (₱60,000-100,000/month)
- Site Reliability Engineer (₱70,000-120,000/month)
- AWS Solutions Architect (₱80,000-150,000/month)

---

## 🚀 Preparation for Day 3

Tomorrow we'll advance to:
- **CI/CD Pipelines**: Automated code deployment
- **Chaos Engineering**: Testing system resilience
- **Advanced Observability**: Distributed tracing and business metrics

**Homework** (Optional):
1. Explore your CloudWatch dashboards
2. Try creating custom Log Insights queries
3. Experiment with different auto scaling thresholds

**Great job completing Day 2! You're well on your way to becoming an operational excellence expert! 🎉**
