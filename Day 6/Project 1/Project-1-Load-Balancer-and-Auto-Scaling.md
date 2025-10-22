# 🚀 AWS Load Balancer + Auto Scaling Lab Guide

> **Duration:** 2-3 hours | **Difficulty:** Intermediate | **Cost:** ~$2-5 USD

## 📋 Prerequisites

- [ ] AWS Account with administrative access
- [ ] Basic understanding of EC2 and VPC concepts
- [ ] Web browser and SSH client

## 🎯 Learning Objectives

By completing this lab, you will:
- ✅ Create an Application Load Balancer with health checks
- ✅ Build a launch template for stateless web servers  
- ✅ Configure an Auto Scaling Group with dynamic scaling
- ✅ Test high availability and automatic failover
- ✅ Understand stateless vs stateful architecture

## 🏗️ Architecture Overview

```
Internet Gateway
       ↓
Application Load Balancer (Multi-AZ)
       ↓
Auto Scaling Group
   ↓       ↓
EC2 Instance  EC2 Instance
(AZ-1a)      (AZ-1b)
```

---

## 🔧 Part 1: Create Application Load Balancer

### Step 1.1: Navigate to Load Balancer Console

1. **Open AWS Console**
   - Sign in to AWS Management Console
   - Navigate to **EC2 Service**

2. **Access Load Balancers**
   - In the left sidebar, click **Load Balancers**
   - Click **Create Load Balancer**

### Step 1.2: Configure Load Balancer

1. **Select Load Balancer Type**
   ```
   ✅ Application Load Balancer
   ❌ Network Load Balancer
   ❌ Gateway Load Balancer
   ```
   - Click **Create** under Application Load Balancer

2. **Basic Configuration**
   - **Load balancer name:** `reliability-alb`
   - **Scheme:** `Internet-facing`
   - **IP address type:** `IPv4`

3. **Network Mapping**
   - **VPC:** Select `Default VPC`
   - **Mappings:** Select **at least 2 Availability Zones**
     - ✅ `us-east-1a` (or your region's first AZ)
     - ✅ `us-east-1b` (or your region's second AZ)

### Step 1.3: Create Security Group for Load Balancer

1. **Create New Security Group**
   - Click **Create new security group**
   - **Security group name:** `reliability-alb-sg`
   - **Description:** `Security group for reliability ALB`

2. **Configure Inbound Rules**
   | Type | Protocol | Port Range | Source | Description |
   |------|----------|------------|--------|-------------|
   | HTTP | TCP | 80 | 0.0.0.0/0 | Allow HTTP from internet |
   | HTTPS | TCP | 443 | 0.0.0.0/0 | Allow HTTPS from internet |

3. **Outbound Rules**
   - Keep default (All traffic to 0.0.0.0/0)

### Step 1.4: Create Target Group

1. **Target Group Configuration**
   - **Target type:** `Instances`
   - **Target group name:** `reliability-targets`
   - **Protocol:** `HTTP`
   - **Port:** `80`
   - **VPC:** `Default VPC`

2. **Health Check Settings**
   | Setting | Value |
   |---------|-------|
   | Protocol | HTTP |
   | Path | `/` |
   | Port | Traffic port |
   | Healthy threshold | 2 |
   | Unhealthy threshold | 2 |
   | Timeout | 5 seconds |
   | Interval | 30 seconds |
   | Success codes | 200 |

3. **Register Targets**
   - **Skip this step** - Auto Scaling will register instances automatically
   - Click **Next** → **Create target group**

4. **Complete Load Balancer**
   - Select the target group you just created
   - Click **Create load balancer**
   - ⏳ Wait for status to become **Active** (2-3 minutes)

### ✅ Checkpoint 1
- [ ] Load balancer status is **Active**
- [ ] Target group is created but shows 0 healthy targets
- [ ] Security group allows HTTP/HTTPS traffic

---

## 🖥️ Part 2: Create Launch Template

### Step 2.1: Navigate to Launch Templates

1. **Access Launch Templates**
   - In EC2 Console, click **Launch Templates** (left sidebar)
   - Click **Create launch template**

### Step 2.2: Template Configuration

1. **Template Details**
   - **Launch template name:** `reliability-template`
   - **Template version description:** `Template for auto-scaling web servers`

2. **Template Tags**
   - **Key:** `Project` **Value:** `reliability-demo`
   - **Key:** `Environment` **Value:** `lab`

### Step 2.3: Application and OS Images

1. **AMI Selection**
   - **AMI:** `Amazon Linux 2023 AMI`
   - **Architecture:** `x86_64`
   - Click **Select** on the free tier eligible AMI

### Step 2.4: Instance Configuration

1. **Instance Type**
   - **Instance type:** `t3.micro` (free tier eligible)

2. **Key Pair**
   - **Key pair name:** Create new or select existing
   - If creating new: **Name:** `reliability-key`
   - **Download** the key pair file (.pem)

### Step 2.5: Network Settings

1. **Create Security Group for Web Servers**
   - **Create security group:** `reliability-web-sg`
   - **Description:** `Security group for web servers`

2. **Inbound Rules**
   | Type | Protocol | Port | Source | Description |
   |------|----------|------|--------|-------------|
   | HTTP | TCP | 80 | Custom: `reliability-alb-sg` | Allow HTTP from ALB |
   | SSH | TCP | 22 | My IP | Allow SSH access |

### Step 2.6: User Data Script

In **Advanced details** → **User data**, paste this script:

```bash
#!/bin/bash
# Update system
yum update -y
yum install -y httpd

# Start and enable Apache
systemctl start httpd
systemctl enable httpd

# Get instance metadata
INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

# Create dynamic web page
cat > /var/www/html/index.html << EOF
<!DOCTYPE html>
<html>
<head>
    <title>High Availability Demo</title>
    <meta http-equiv="refresh" content="30">
    <style>
        body { 
            font-family: Arial, sans-serif; 
            text-align: center; 
            margin: 0;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
        }
        .container { 
            background: rgba(255,255,255,0.1); 
            padding: 40px; 
            border-radius: 20px; 
            backdrop-filter: blur(10px);
            box-shadow: 0 8px 32px rgba(0,0,0,0.3);
            max-width: 600px;
        }
        .instance-info { 
            color: #ffeb3b; 
            font-weight: bold; 
            font-size: 20px;
            margin: 10px 0;
        }
        .status { 
            color: #4caf50; 
            font-size: 24px; 
            margin: 20px 0;
        }
        .refresh-note {
            font-size: 14px;
            opacity: 0.8;
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 High Availability Demo</h1>
        <div class="instance-info">Instance ID: $INSTANCE_ID</div>
        <div class="instance-info">Availability Zone: $AZ</div>
        <div class="instance-info">Server Time: <span id="time"></span></div>
        <div class="status">✅ Server is Healthy</div>
        <div class="refresh-note">
            Page refreshes every 30 seconds<br>
            Refresh manually to see load balancing!
        </div>
    </div>
    
    <script>
        function updateTime() {
            document.getElementById('time').textContent = new Date().toLocaleString();
        }
        updateTime();
        setInterval(updateTime, 1000);
    </script>
</body>
</html>
EOF

# Create health check endpoint
echo "OK" > /var/www/html/health

# Set proper permissions
chown -R apache:apache /var/www/html
chmod -R 755 /var/www/html
```

### Step 2.7: Create Launch Template

1. **Review Configuration**
   - Verify all settings are correct
   - Click **Create launch template**

### ✅ Checkpoint 2
- [ ] Launch template created successfully
- [ ] Security group allows HTTP from ALB and SSH from your IP
- [ ] User data script is properly configured

---

## 📈 Part 3: Create Auto Scaling Group

### Step 3.1: Navigate to Auto Scaling Groups

1. **Access Auto Scaling**
   - In EC2 Console, click **Auto Scaling Groups**
   - Click **Create Auto Scaling Group**

### Step 3.2: Choose Launch Template

1. **Auto Scaling Group Configuration**
   - **Auto Scaling group name:** `reliability-asg`
   - **Launch template:** Select `reliability-template`
   - **Version:** `Latest ($Latest)`
   - Click **Next**

### Step 3.3: Network Configuration

1. **Instance Launch Options**
   - **VPC:** `Default VPC`
   - **Availability Zones and subnets:** 
     - ✅ Select same AZs as your load balancer
     - ✅ Choose **public subnets** in each AZ

2. **Instance Type Requirements**
   - Keep default settings
   - Click **Next**

### Step 3.4: Load Balancer Integration

1. **Load Balancing**
   - ✅ **Attach to an existing load balancer**
   - **Choose from your load balancer target groups**
   - **Existing load balancer target groups:** `reliability-targets`

2. **Health Checks**
   - **Health check type:** `ELB` (not EC2)
   - **Health check grace period:** `300 seconds`
   - ✅ **Enable group metrics collection in CloudWatch**

3. **Additional Settings**
   - ✅ **Enable default instance warmup**
   - **Default instance warmup:** `300 seconds`
   - Click **Next**

### Step 3.5: Configure Group Size and Scaling

1. **Group Size**
   | Setting | Value |
   |---------|-------|
   | Desired capacity | 2 |
   | Minimum capacity | 1 |
   | Maximum capacity | 6 |

2. **Scaling Policies**
   - ✅ **Target tracking scaling policy**
   - **Scaling policy name:** `cpu-scaling-policy`
   - **Metric type:** `Average CPU Utilization`
   - **Target value:** `70`
   - **Instance warmup:** `300 seconds`

3. **Instance Scale-in Protection**
   - Leave unchecked for this lab
   - Click **Next**

### Step 3.6: Add Notifications (Optional)

- **Skip this step** for the lab
- Click **Next**

### Step 3.7: Add Tags

Add these tags to identify your instances:

| Key | Value | Tag new instances |
|-----|-------|-------------------|
| Name | reliability-web-server | ✅ |
| Project | reliability-demo | ✅ |
| Environment | lab | ✅ |

### Step 3.8: Review and Create

1. **Review Configuration**
   - Verify all settings are correct
   - Click **Create Auto Scaling Group**

### ✅ Checkpoint 3
- [ ] Auto Scaling Group created successfully
- [ ] Instances are launching (check Activity tab)
- [ ] Target group shows instances registering

---

## 🧪 Part 4: Test High Availability

### Step 4.1: Monitor Instance Launch

1. **Check Auto Scaling Group Status**
   - Go to **Auto Scaling Groups** → `reliability-asg`
   - **Activity tab:** Should show "Launching a new EC2 instance"
   - **Instance management tab:** Should show 2 instances
   - ⏳ Wait for instances to show **InService** status (5-10 minutes)

2. **Verify Load Balancer Targets**
   - Go to **Load Balancers** → `reliability-alb`
   - Click **Target groups** tab → `reliability-targets`
   - Should show **2 healthy targets**

### Step 4.2: Test Load Balancing

1. **Get Load Balancer URL**
   - Copy the **DNS name** from load balancer details
   - Example: `reliability-alb-1234567890.us-east-1.elb.amazonaws.com`

2. **Access Website**
   ```
   http://[your-load-balancer-dns-name]
   ```
   - Should see the high availability demo page
   - Note the **Instance ID** and **Availability Zone**

3. **Verify Load Distribution**
   - **Refresh the page 5-10 times**
   - **Instance ID should change** between refreshes
   - This proves traffic is being distributed across instances

### Step 4.3: Test High Availability (Instance Failure)

1. **Simulate Instance Failure**
   - Go to **EC2** → **Instances**
   - Select one of your web server instances
   - **Actions** → **Instance State** → **Terminate Instance**
   - Confirm termination

2. **Monitor Auto Scaling Response**
   - Go back to **Auto Scaling Groups** → `reliability-asg`
   - **Activity tab:** Should show new instance launching
   - **Refresh your website** - should continue working
   - ⏳ Wait for replacement instance (3-5 minutes)

3. **Verify Recovery**
   - New instance should appear in target group
   - Website should remain accessible throughout
   - Load balancing should resume with 2 healthy instances

### ✅ Checkpoint 4
- [ ] Website loads successfully via load balancer
- [ ] Instance ID changes when refreshing (load balancing works)
- [ ] Terminating instance triggers automatic replacement
- [ ] Website remains available during instance replacement

---

## 🔍 Part 5: Test Auto Scaling (Optional)

### Step 5.1: Generate CPU Load

> **Note:** This step requires SSH access to instances

1. **Connect to Instance**
   ```bash
   ssh -i reliability-key.pem ec2-user@[instance-public-ip]
   ```

2. **Install Stress Tool**
   ```bash
   sudo yum install -y stress
   ```

3. **Generate CPU Load**
   ```bash
   # Generate high CPU load for 5 minutes
   stress --cpu 2 --timeout 300s
   ```

### Step 5.2: Monitor Scaling

1. **Watch CloudWatch Metrics**
   - Go to **Auto Scaling Groups** → `reliability-asg`
   - **Monitoring tab:** Watch CPU utilization
   - Should see CPU spike above 70%

2. **Observe Scale-Out**
   - **Activity tab:** Should show new instances launching
   - **Instance management:** Should show more than 2 instances
   - ⏳ Wait for new instances to become healthy

3. **Verify Scale-In**
   - After stress test ends, CPU should drop
   - Auto Scaling should terminate excess instances
   - Should return to 2 instances after cooldown period

---

## ✅ Verification Checklist

### Architecture Verification
- [ ] Load balancer is **Active** and accessible
- [ ] Auto Scaling Group has **2 healthy instances**
- [ ] Instances are in **different availability zones**
- [ ] Target group shows **2 healthy targets**

### Functionality Testing
- [ ] Website loads via load balancer DNS name
- [ ] **Instance ID changes** when refreshing page
- [ ] Terminating instance triggers **automatic replacement**
- [ ] Website remains **available during failures**
- [ ] Health checks are **passing**

### Security Verification
- [ ] Load balancer security group allows HTTP/HTTPS from internet
- [ ] Instance security group allows HTTP only from load balancer
- [ ] SSH access restricted to your IP address

---

## 🚨 Troubleshooting Guide

### Issue: Load Balancer Shows 503 Error

**Symptoms:** Browser shows "503 Service Temporarily Unavailable"

**Solutions:**
1. Check if instances are registered in target group
2. Verify instances are healthy in target group
3. Confirm security groups allow traffic from ALB to instances
4. Wait for instances to complete health checks (up to 10 minutes)

### Issue: Instances Not Launching

**Symptoms:** Auto Scaling Group shows failed launch attempts

**Solutions:**
1. Check Auto Scaling Group **Activity tab** for error messages
2. Verify launch template has correct AMI ID
3. Ensure subnets have available IP addresses
4. Check service limits for EC2 instances

### Issue: Health Checks Failing

**Symptoms:** Target group shows instances as unhealthy

**Solutions:**
1. SSH to instance and check if httpd is running:
   ```bash
   sudo systemctl status httpd
   ```
2. Verify security group allows HTTP on port 80
3. Test health check endpoint:
   ```bash
   curl http://localhost/
   ```
4. Check instance logs:
   ```bash
   sudo tail -f /var/log/httpd/error_log
   ```

### Issue: Auto Scaling Not Triggering

**Symptoms:** High CPU but no new instances launching

**Solutions:**
1. Verify CloudWatch metrics are being collected
2. Check scaling policy configuration
3. Ensure cooldown periods have elapsed
4. Verify maximum capacity not reached

---

## 🧹 Cleanup Instructions

> **Important:** Clean up resources to avoid charges

### Step 1: Delete Auto Scaling Group
1. Go to **Auto Scaling Groups** → `reliability-asg`
2. **Actions** → **Delete**
3. Type `delete` to confirm
4. This will terminate all instances

### Step 2: Delete Load Balancer
1. Go to **Load Balancers** → `reliability-alb`
2. **Actions** → **Delete**
3. Confirm deletion

### Step 3: Delete Target Group
1. Go to **Target Groups** → `reliability-targets`
2. **Actions** → **Delete**
3. Confirm deletion

### Step 4: Delete Launch Template
1. Go to **Launch Templates** → `reliability-template`
2. **Actions** → **Delete template**
3. Confirm deletion

### Step 5: Delete Security Groups
1. Go to **Security Groups**
2. Delete `reliability-alb-sg`
3. Delete `reliability-web-sg`
4. **Note:** Delete only after all resources using them are deleted

---

## 🎓 Key Takeaways

### What You Built
- **Multi-AZ High Availability:** Instances distributed across availability zones
- **Automatic Load Balancing:** Traffic distributed evenly across healthy instances
- **Auto Scaling:** Dynamic capacity adjustment based on demand
- **Health Monitoring:** Automatic detection and replacement of failed instances
- **Stateless Architecture:** Servers can be replaced without data loss

### Real-World Applications
- **E-commerce Websites:** Handle Black Friday traffic spikes
- **Media Streaming:** Scale based on viewer demand
- **SaaS Applications:** Maintain performance during peak usage
- **API Services:** Ensure consistent response times under load

### Business Benefits
- **Cost Optimization:** Pay only for resources you need
- **High Availability:** 99.99% uptime with automatic failover
- **Performance:** Consistent response times under varying load
- **Scalability:** Handle 10x traffic increases automatically
- **Operational Excellence:** Reduced manual intervention

### Architecture Principles Demonstrated
- **Stateless Design:** No server-specific data stored locally
- **Horizontal Scaling:** Add more servers instead of bigger servers
- **Health Monitoring:** Continuous health checks and automatic remediation
- **Multi-AZ Deployment:** Protection against availability zone failures
- **Elastic Capacity:** Automatic scaling based on demand

---

## 🏆 Congratulations!

You've successfully built an enterprise-grade, highly available web application infrastructure that can:
- ✅ Handle traffic spikes automatically
- ✅ Recover from instance failures in minutes
- ✅ Distribute load across multiple availability zones
- ✅ Scale based on real-time demand
- ✅ Maintain 99.99% availability

This architecture forms the foundation for production-ready applications serving millions of users worldwide!

---

## 📚 Next Steps

1. **Explore Advanced Features:**
   - Application Load Balancer path-based routing
   - Auto Scaling scheduled scaling
   - CloudWatch custom metrics

2. **Add Monitoring:**
   - CloudWatch dashboards
   - SNS notifications for scaling events
   - Application performance monitoring

3. **Enhance Security:**
   - WAF (Web Application Firewall)
   - SSL/TLS certificates
   - VPC with private subnets

4. **Database Integration:**
   - RDS Multi-AZ for database high availability
   - ElastiCache for session management
   - Database connection pooling
