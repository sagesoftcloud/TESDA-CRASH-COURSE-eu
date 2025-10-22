# 🗄️ AWS RDS Multi-AZ Database High Availability Lab

> **Duration:** 1 hour | **Difficulty:** Intermediate | **Cost:** ~$3-8 USD

## 📋 Prerequisites

- [ ] AWS Account with administrative access
- [ ] Completed Project 1 (Load Balancer + Auto Scaling) or existing web infrastructure
- [ ] Basic understanding of databases and SQL
- [ ] Understanding of RTO/RPO concepts

## 🎯 Learning Objectives

By completing this lab, you will:
- ✅ Create an RDS MySQL database with Multi-AZ deployment
- ✅ Configure automatic backups and point-in-time recovery
- ✅ Set up database security with VPC security groups
- ✅ Test database failover simulation
- ✅ Understand RTO/RPO for database high availability
- ✅ Distinguish between Multi-AZ and Read Replicas

## 🏗️ Architecture Overview

```
Web Tier (Multi-AZ)
       ↓
Application Load Balancer
       ↓
Auto Scaling Group
   ↓       ↓
EC2 Instance  EC2 Instance
       ↓       ↓
    Database Tier
       ↓
RDS Multi-AZ MySQL
├── Primary DB (AZ-1a)
└── Standby DB (AZ-1b) ← Synchronous Replication
```

**Key Concepts:**
- **RTO (Recovery Time Objective):** 1-2 minutes
- **RPO (Recovery Point Objective):** Near zero data loss
- **Availability:** 99.95% SLA

---

## 🗄️ Part 1: Create RDS Multi-AZ Database

### Step 1.1: Navigate to RDS Console

1. **Open AWS Console**
   - Navigate to **RDS Service**
   - Click **Create database**

### Step 1.2: Database Engine Configuration

1. **Creation Method**
   ```
   ✅ Standard create
   ❌ Easy create
   ```

2. **Engine Options**
   | Setting | Value |
   |---------|-------|
   | Engine type | MySQL |
   | Version | MySQL 8.0.35 (latest) |
   | Templates | Production |

### Step 1.3: Database Settings

1. **DB Instance Configuration**
   | Setting | Value |
   |---------|-------|
   | DB instance identifier | `reliability-db` |
   | Master username | `admin` |
   | Master password | `ReliabilityDemo123!` |
   | Confirm password | `ReliabilityDemo123!` |

> **⚠️ Security Note:** Use strong passwords in production environments

### Step 1.4: Instance Configuration

1. **DB Instance Class**
   - **Instance class:** `db.t3.micro` (free tier eligible)
   - **vCPUs:** 2
   - **RAM:** 1 GB

2. **Storage Configuration**
   | Setting | Value |
   |---------|-------|
   | Storage type | General Purpose SSD (gp2) |
   | Allocated storage | 20 GB |
   | Enable storage autoscaling | ✅ Yes |
   | Maximum storage threshold | 100 GB |

### Step 1.5: Availability & Durability (CRITICAL)

> **🔥 This is the most important setting for high availability!**

1. **Multi-AZ Deployment**
   ```
   ✅ Create a standby instance (Recommended for production usage)
   ❌ Do not create a standby instance
   ```

**What this enables:**
- Automatic failover to standby instance
- Synchronous data replication (zero data loss)
- Enhanced availability during maintenance
- Protection against AZ failures

### Step 1.6: Connectivity Configuration

1. **Network Settings**
   | Setting | Value |
   |---------|-------|
   | VPC | Default VPC |
   | DB Subnet Group | default |
   | Public access | No |
   | VPC security groups | Create new |

2. **New Security Group**
   - **Name:** `reliability-db-sg`
   - **Description:** `Security group for reliability database`

3. **Database Port**
   - **Port:** `3306` (MySQL default)

### ✅ Checkpoint 1
- [ ] MySQL 8.0 engine selected
- [ ] Multi-AZ deployment enabled
- [ ] Security group created for database
- [ ] Public access disabled for security

---

## 🔧 Part 2: Configure Database Options

### Step 2.1: Database Authentication

1. **Authentication Options**
   ```
   ✅ Password authentication
   ❌ IAM database authentication
   ❌ Kerberos authentication
   ```

### Step 2.2: Additional Configuration

1. **Database Options**
   | Setting | Value |
   |---------|-------|
   | Initial database name | `reliabilitydb` |
   | DB parameter group | default.mysql8.0 |
   | Option group | default:mysql-8-0 |

### Step 2.3: Backup Configuration

1. **Automated Backups**
   | Setting | Value |
   |---------|-------|
   | Enable automatic backups | ✅ Yes |
   | Backup retention period | 7 days |
   | Backup window | No preference |
   | Copy tags to snapshots | ✅ Yes |

2. **Backup Encryption**
   - **Enable encryption:** ❌ No (cost optimization for lab)
   - **Production Note:** Enable encryption for sensitive data

### Step 2.4: Monitoring Configuration

1. **Performance Insights**
   - **Enable Performance Insights:** ❌ No (cost optimization)
   - **Production Note:** Enable for performance monitoring

2. **Enhanced Monitoring**
   - **Enable enhanced monitoring:** ❌ No (cost optimization)
   - **Production Note:** Enable for detailed OS metrics

### Step 2.5: Maintenance Settings

1. **Maintenance Configuration**
   | Setting | Value |
   |---------|-------|
   | Enable auto minor version upgrade | ✅ Yes |
   | Maintenance window | No preference |
   | Enable deletion protection | ❌ No (for easy cleanup) |

### Step 2.6: Create Database

1. **Final Review**
   - ✅ Verify Multi-AZ is enabled
   - ✅ Confirm backup settings (7 days)
   - ✅ Check security group configuration
   - ✅ Validate database name and credentials

2. **Create Database**
   - Click **Create database**
   - ⏳ **Wait time:** 10-15 minutes for Multi-AZ setup

### ✅ Checkpoint 2
- [ ] Database creation initiated
- [ ] Backup retention set to 7 days
- [ ] Auto minor version upgrade enabled
- [ ] Deletion protection disabled for lab cleanup

---

## 🔒 Part 3: Configure Database Security

### Step 3.1: Update Security Group Rules

1. **Navigate to Security Groups**
   - Go to **EC2 Console** → **Security Groups**
   - Find and select `reliability-db-sg`

2. **Edit Inbound Rules**
   - Click **Edit inbound rules**
   - Click **Add rule**

3. **Configure Database Access Rule**
   | Type | Protocol | Port Range | Source | Description |
   |------|----------|------------|--------|-------------|
   | MySQL/Aurora | TCP | 3306 | Custom: `reliability-web-sg` | Allow web servers to access database |

4. **Save Security Group Rules**
   - Click **Save rules**

### Step 3.2: Verify Database Status

1. **Check Database Creation Progress**
   - Go to **RDS** → **Databases**
   - Find `reliability-db`
   - **Status:** Should show "Creating" then "Available"

2. **Verify Multi-AZ Configuration**
   - **Multi-AZ:** Should show "Yes"
   - **Engine:** MySQL 8.0.35
   - **Instance class:** db.t3.micro

3. **Note Connection Details**
   ```
   Endpoint: reliability-db.xxxxxxxxx.us-east-1.rds.amazonaws.com
   Port: 3306
   Database name: reliabilitydb
   Username: admin
   ```

### ✅ Checkpoint 3
- [ ] Database status is "Available"
- [ ] Multi-AZ shows "Yes"
- [ ] Security group allows access from web servers only
- [ ] Database endpoint is accessible

---

## 🧪 Part 4: Test Database Failover

### Step 4.1: Monitor Database Before Failover

1. **Check Current Configuration**
   - Go to **RDS** → **Databases** → `reliability-db`
   - **Configuration tab:** Note the current **Availability Zone**
   - **Multi-AZ:** Confirm it shows "Yes"

2. **Understand Current Setup**
   ```
   Primary Instance: AZ-1a (example)
   Standby Instance: AZ-1b (hidden, managed by AWS)
   Endpoint: Points to primary instance
   ```

### Step 4.2: Initiate Failover Test

1. **Start Failover Process**
   - Select database `reliability-db`
   - **Actions** → **Reboot**
   - ✅ **Check:** "Reboot with failover?"
   - Click **Confirm**

> **📝 Note:** This simulates a primary instance failure

### Step 4.3: Monitor Failover Process

1. **Watch Events Tab**
   - Click on database name → **Events** tab
   - Monitor events in real-time:
     ```
     Multi-AZ instance failover started
     Multi-AZ instance failover completed
     DB instance restarted
     ```

2. **Monitor Status Changes**
   | Phase | Status | Duration |
   |-------|--------|----------|
   | Initial | Available | - |
   | Failover Start | Rebooting | 30 seconds |
   | Failover Process | Rebooting | 60-90 seconds |
   | Completion | Available | - |

### Step 4.4: Verify Failover Results

1. **Check New Configuration**
   - **Availability Zone:** Should be different from original
   - **Endpoint:** Remains exactly the same ✅
   - **Status:** Should return to "Available"

2. **Understand What Happened**
   ```
   Before Failover:
   Primary: AZ-1a ← Application connects here
   Standby: AZ-1b (hidden)
   
   After Failover:
   Primary: AZ-1b ← Application connects here (same endpoint!)
   Standby: AZ-1a (hidden)
   ```

3. **Key Benefits Demonstrated**
   - ✅ **Zero data loss** (synchronous replication)
   - ✅ **Minimal downtime** (1-2 minutes)
   - ✅ **Transparent to applications** (same endpoint)
   - ✅ **Automatic process** (no manual intervention)

### ✅ Checkpoint 4
- [ ] Failover completed successfully
- [ ] Database is in different AZ than before
- [ ] Endpoint remains unchanged
- [ ] Status returned to "Available"

---

## 🔌 Part 5: Connect Database to Web Application (Optional)

### Step 5.1: Install Database Client

1. **SSH into Web Server**
   ```bash
   ssh -i reliability-key.pem ec2-user@[instance-public-ip]
   ```

2. **Install MySQL Client**
   ```bash
   sudo yum update -y
   sudo yum install -y mysql
   ```

### Step 5.2: Test Database Connection

1. **Connect to Database**
   ```bash
   mysql -h [database-endpoint] -u admin -p reliabilitydb
   # Enter password: ReliabilityDemo123!
   ```

2. **Create Test Schema**
   ```sql
   -- Create a simple health check table
   CREATE TABLE health_check (
       id INT AUTO_INCREMENT PRIMARY KEY,
       server_id VARCHAR(50),
       check_time DATETIME DEFAULT CURRENT_TIMESTAMP,
       status VARCHAR(20) DEFAULT 'healthy'
   );
   
   -- Insert test data
   INSERT INTO health_check (server_id) VALUES ('web-server-1');
   INSERT INTO health_check (server_id) VALUES ('web-server-2');
   
   -- Verify data
   SELECT * FROM health_check;
   ```

3. **Test Data Persistence**
   ```sql
   -- Add more test data
   INSERT INTO health_check (server_id, status) 
   VALUES ('load-balancer', 'active');
   
   -- Count records
   SELECT COUNT(*) as total_checks FROM health_check;
   
   -- Exit MySQL
   EXIT;
   ```

### Step 5.3: Update Web Application (Advanced)

Create a simple PHP script to display database connectivity:

```bash
# Install PHP and MySQL extension
sudo yum install -y php php-mysqlnd

# Create database test page
sudo tee /var/www/html/db-test.php << 'EOF'
<?php
$servername = "YOUR_DATABASE_ENDPOINT";
$username = "admin";
$password = "ReliabilityDemo123!";
$dbname = "reliabilitydb";

try {
    $pdo = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    // Get server info
    $stmt = $pdo->query("SELECT COUNT(*) as total FROM health_check");
    $result = $stmt->fetch();
    
    echo "<h2>Database Connection: ✅ SUCCESS</h2>";
    echo "<p>Total health checks: " . $result['total'] . "</p>";
    echo "<p>Database endpoint: $servername</p>";
    echo "<p>Connection time: " . date('Y-m-d H:i:s') . "</p>";
    
} catch(PDOException $e) {
    echo "<h2>Database Connection: ❌ FAILED</h2>";
    echo "<p>Error: " . $e->getMessage() . "</p>";
}
?>
EOF

# Test the page
curl http://localhost/db-test.php
```

### ✅ Checkpoint 5
- [ ] Successfully connected to database from web server
- [ ] Created test tables and inserted data
- [ ] Verified data persistence across connections
- [ ] Optional: Web application displays database connectivity

---

## ✅ Verification Checklist

### Database Configuration
- [ ] RDS database status is **Available**
- [ ] Multi-AZ deployment shows **Yes**
- [ ] Automatic backups configured (7-day retention)
- [ ] Security group allows access from web servers only

### High Availability Testing
- [ ] Failover test completed successfully
- [ ] Database switched to different AZ
- [ ] Endpoint remained consistent after failover
- [ ] Downtime was minimal (1-2 minutes)

### Security Verification
- [ ] Database is not publicly accessible
- [ ] Security group restricts access to web tier only
- [ ] Strong password configured for master user
- [ ] Database encrypted in transit (SSL/TLS)

---

## 📊 Understanding Multi-AZ vs Read Replicas

### Multi-AZ Deployment (What We Built)

| Feature | Multi-AZ |
|---------|----------|
| **Purpose** | High availability & disaster recovery |
| **Replication** | Synchronous (zero data loss) |
| **Failover** | Automatic (1-2 minutes) |
| **Endpoint** | Single endpoint, AWS handles routing |
| **Use Case** | Production databases requiring HA |
| **Cost** | ~2x instance cost |
| **Read Traffic** | Primary only |

### Read Replicas (Different Concept)

| Feature | Read Replicas |
|---------|---------------|
| **Purpose** | Read scaling & performance |
| **Replication** | Asynchronous (eventual consistency) |
| **Failover** | Manual promotion required |
| **Endpoint** | Separate read endpoint |
| **Use Case** | Read-heavy workloads, analytics |
| **Cost** | Additional instance cost |
| **Read Traffic** | Can serve read queries |

### When to Use Each

**Use Multi-AZ for:**
- ✅ Production databases requiring high availability
- ✅ Applications that cannot tolerate data loss
- ✅ Compliance requirements for disaster recovery
- ✅ Databases with write-heavy workloads

**Use Read Replicas for:**
- ✅ Read-heavy applications (reporting, analytics)
- ✅ Scaling read performance across regions
- ✅ Offloading read traffic from primary database
- ✅ Creating development/testing environments

---

## 🚨 Troubleshooting Guide

### Issue: Database Creation Fails

**Symptoms:** Database stuck in "Creating" status or fails to create

**Solutions:**
1. **Check RDS Quotas:**
   ```bash
   # Check service quotas in AWS Console
   Service Quotas → Amazon Relational Database Service
   ```

2. **Verify VPC Configuration:**
   - Ensure VPC has subnets in at least 2 AZs
   - Check that subnets have available IP addresses
   - Verify internet gateway is attached to VPC

3. **Instance Type Availability:**
   - Confirm db.t3.micro is available in your region
   - Try different instance type if needed

### Issue: Security Group Connection Problems

**Symptoms:** Cannot connect to database from web servers

**Solutions:**
1. **Verify Security Group Rules:**
   ```bash
   # Check inbound rules allow MySQL (3306) from web security group
   aws ec2 describe-security-groups --group-ids sg-xxxxxxxxx
   ```

2. **Test Network Connectivity:**
   ```bash
   # From web server, test port connectivity
   telnet [database-endpoint] 3306
   ```

3. **Check VPC Configuration:**
   - Ensure database and web servers are in same VPC
   - Verify route tables allow internal communication

### Issue: Failover Not Working

**Symptoms:** Reboot with failover option not available or fails

**Solutions:**
1. **Verify Multi-AZ is Enabled:**
   - Check database configuration shows Multi-AZ: Yes
   - Ensure database is not in maintenance window

2. **Check Database Status:**
   - Database must be in "Available" status
   - Wait for any pending modifications to complete

3. **Permissions:**
   - Verify IAM user has rds:RebootDBInstance permission

### Issue: Connection Timeouts

**Symptoms:** Applications cannot connect to database

**Solutions:**
1. **Database Status Check:**
   ```bash
   # Verify database is available
   aws rds describe-db-instances --db-instance-identifier reliability-db
   ```

2. **Security Group Verification:**
   - Confirm port 3306 is open from web security group
   - Check that source security group ID is correct

3. **Network ACLs:**
   - Verify VPC network ACLs allow database traffic
   - Check subnet associations

---

## 🧹 Cleanup Instructions

> **⚠️ Important:** Clean up resources to avoid ongoing charges

### Step 1: Delete RDS Database

1. **Navigate to RDS Console**
   - Go to **Databases** → Select `reliability-db`
   - **Actions** → **Delete**

2. **Configure Deletion Options**
   - ❌ **Create final snapshot:** No
   - ❌ **Retain automated backups:** No
   - ✅ **I acknowledge:** Check the box
   - Type `delete me` to confirm

3. **Delete Database**
   - Click **Delete**
   - ⏳ Wait 5-10 minutes for deletion

### Step 2: Clean Up Security Groups

1. **Delete Database Security Group**
   - Go to **EC2** → **Security Groups**
   - Select `reliability-db-sg`
   - **Actions** → **Delete security group**

### Step 3: Verify Cleanup

- [ ] Database no longer appears in RDS console
- [ ] Security group deleted successfully
- [ ] No automated backups remaining
- [ ] No manual snapshots created

---

## 🎓 Key Takeaways

### What You Built

**Enterprise-Grade Database Infrastructure:**
- ✅ **Multi-AZ Deployment:** Automatic failover with 99.95% availability
- ✅ **Zero Data Loss:** Synchronous replication protects against corruption
- ✅ **Automated Backups:** 7-day retention with point-in-time recovery
- ✅ **Security:** Database isolated with restricted network access
- ✅ **Monitoring:** Health checks and automatic failure detection

### Business Benefits

| Benefit | Impact |
|---------|--------|
| **High Availability** | 99.95% uptime SLA |
| **Data Protection** | Zero data loss during failures |
| **Automatic Recovery** | No manual intervention required |
| **Cost Effective** | Only ~2x cost for enterprise-grade HA |
| **Compliance Ready** | Meets regulatory backup requirements |

### Real-World Applications

**E-commerce Platforms:**
- Order processing during payment failures
- Inventory management during traffic spikes
- Customer data protection during outages

**Financial Services:**
- Transaction processing continuity
- Account balance consistency
- Regulatory compliance for data retention

**Healthcare Systems:**
- Patient record availability
- Medical device data integrity
- HIPAA compliance for data protection

**Gaming Platforms:**
- Player progress preservation
- Leaderboard consistency
- In-game purchase processing

### Production Considerations

**Enhanced Security:**
- Enable encryption at rest and in transit
- Use IAM database authentication
- Implement database activity monitoring
- Regular security patching

**Performance Optimization:**
- Monitor CloudWatch metrics
- Optimize database parameters
- Implement connection pooling
- Use Performance Insights

**Backup Strategy:**
- Cross-region backup replication
- Test restore procedures regularly
- Document recovery processes
- Automate backup verification

**Monitoring & Alerting:**
- CloudWatch alarms for key metrics
- SNS notifications for failover events
- Database performance monitoring
- Automated health checks

---

## 🏆 Congratulations!

You've successfully implemented enterprise-grade database high availability that provides:

- ✅ **99.95% Availability** with automatic failover
- ✅ **Zero Data Loss** through synchronous replication  
- ✅ **1-2 Minute Recovery** time during failures
- ✅ **Transparent Failover** with consistent endpoints
- ✅ **Automated Backups** with point-in-time recovery

This database infrastructure can handle real-world production workloads and meets enterprise requirements for data protection and availability!

---

## 📚 Next Steps

1. **Advanced Features:**
   - Cross-region read replicas
   - Database parameter optimization
   - Performance Insights analysis

2. **Integration:**
   - Connect to web application from Project 1
   - Implement database connection pooling
   - Add application-level health checks

3. **Monitoring:**
   - CloudWatch dashboard creation
   - Custom metric alarms
   - Automated backup verification

4. **Security Enhancement:**
   - Enable encryption at rest
   - Implement IAM database authentication
   - Set up database activity monitoring
