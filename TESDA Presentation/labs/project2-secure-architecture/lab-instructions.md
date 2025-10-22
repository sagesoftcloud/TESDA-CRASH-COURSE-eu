# Project 2: Secure AWS Architecture Deployment

## Objective
Deploy a complete secure web application architecture with multiple layers of security controls.

## Architecture Overview
- VPC with public/private subnets
- Application Load Balancer with SSL/TLS
- Auto Scaling Group with web servers
- RDS MySQL in private subnet
- AWS WAF for application protection
- Security Hub for compliance monitoring

## Lab Steps

### Step 1: VPC Configuration
1. Create VPC with CIDR block 10.0.0.0/16
2. Create public subnets (10.0.1.0/24, 10.0.2.0/24)
3. Create private subnets (10.0.3.0/24, 10.0.4.0/24)
4. Configure Internet Gateway and NAT Gateway
5. Set up route tables

### Step 2: Security Groups Setup
1. **Load Balancer SG**: HTTP/HTTPS from internet
2. **Web Server SG**: HTTP from Load Balancer only
3. **Database SG**: MySQL from Web Server SG only
4. **Bastion SG**: SSH from specific IP ranges

### Step 3: SSL/TLS Certificate
1. Request certificate from AWS Certificate Manager
2. Validate domain ownership
3. Configure certificate for Load Balancer

### Step 4: RDS MySQL Configuration
1. Create DB subnet group in private subnets
2. Launch RDS MySQL instance
3. Configure security group for database access
4. Enable encryption at rest
5. Configure automated backups

### Step 5: EC2 Web Server Deployment
1. Create Launch Template with user data script
2. Configure Auto Scaling Group
3. Set up health checks
4. Install and configure web application

### Step 6: Load Balancer Setup
1. Create Application Load Balancer
2. Configure target groups
3. Set up health checks
4. Configure SSL/TLS termination
5. Set up HTTP to HTTPS redirect

### Step 7: AWS WAF Configuration
1. Create Web ACL
2. Configure rate limiting rules
3. Set up IP blocking rules
4. Configure SQL injection protection
5. Associate WAF with Load Balancer

### Step 8: Security Hub Integration
1. Enable AWS Security Hub
2. Configure compliance standards
3. Review security findings
4. Set up automated remediation

## Testing and Validation
1. Test application accessibility
2. Verify SSL/TLS configuration
3. Test WAF rules
4. Review Security Hub findings
5. Validate network isolation

## Expected Outcomes
- Complete secure architecture deployment
- Understanding of defense in depth
- Experience with AWS security services
- Knowledge of compliance monitoring
