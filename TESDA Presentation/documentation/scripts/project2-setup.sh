#!/bin/bash

# Project 2: Secure AWS Architecture Deployment Setup Script
# TESDA AWS Security Training

set -e

# Variables
VPC_NAME="TESDA-VPC"
VPC_CIDR="10.0.0.0/16"
REGION="us-east-1"
AZ1="${REGION}a"
AZ2="${REGION}b"

echo "Starting Project 2 Setup..."

# Step 1: Create VPC
echo "Creating VPC..."
VPC_ID=$(aws ec2 create-vpc --cidr-block $VPC_CIDR --tag-specifications "ResourceType=vpc,Tags=[{Key=Name,Value=$VPC_NAME}]" --query 'Vpc.VpcId' --output text)
echo "VPC created: $VPC_ID"

# Enable DNS hostnames
aws ec2 modify-vpc-attribute --vpc-id $VPC_ID --enable-dns-hostnames

# Step 2: Create Subnets
echo "Creating subnets..."

# Public Subnets
PUBLIC_SUBNET_1=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.1.0/24 --availability-zone $AZ1 --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=Public-Subnet-1}]" --query 'Subnet.SubnetId' --output text)
PUBLIC_SUBNET_2=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.2.0/24 --availability-zone $AZ2 --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=Public-Subnet-2}]" --query 'Subnet.SubnetId' --output text)

# Private Subnets
PRIVATE_SUBNET_1=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.3.0/24 --availability-zone $AZ1 --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=Private-Subnet-1}]" --query 'Subnet.SubnetId' --output text)
PRIVATE_SUBNET_2=$(aws ec2 create-subnet --vpc-id $VPC_ID --cidr-block 10.0.4.0/24 --availability-zone $AZ2 --tag-specifications "ResourceType=subnet,Tags=[{Key=Name,Value=Private-Subnet-2}]" --query 'Subnet.SubnetId' --output text)

echo "Subnets created:"
echo "  Public Subnet 1: $PUBLIC_SUBNET_1"
echo "  Public Subnet 2: $PUBLIC_SUBNET_2"
echo "  Private Subnet 1: $PRIVATE_SUBNET_1"
echo "  Private Subnet 2: $PRIVATE_SUBNET_2"

# Step 3: Create and attach Internet Gateway
echo "Creating Internet Gateway..."
IGW_ID=$(aws ec2 create-internet-gateway --tag-specifications "ResourceType=internet-gateway,Tags=[{Key=Name,Value=TESDA-IGW}]" --query 'InternetGateway.InternetGatewayId' --output text)
aws ec2 attach-internet-gateway --vpc-id $VPC_ID --internet-gateway-id $IGW_ID
echo "Internet Gateway created and attached: $IGW_ID"

# Step 4: Create NAT Gateway
echo "Creating NAT Gateway..."
EIP_ALLOC=$(aws ec2 allocate-address --domain vpc --query 'AllocationId' --output text)
NAT_GW_ID=$(aws ec2 create-nat-gateway --subnet-id $PUBLIC_SUBNET_1 --allocation-id $EIP_ALLOC --tag-specifications "ResourceType=nat-gateway,Tags=[{Key=Name,Value=TESDA-NAT}]" --query 'NatGateway.NatGatewayId' --output text)
echo "NAT Gateway created: $NAT_GW_ID"

# Wait for NAT Gateway to be available
echo "Waiting for NAT Gateway to be available..."
aws ec2 wait nat-gateway-available --nat-gateway-ids $NAT_GW_ID

# Step 5: Create Route Tables
echo "Creating route tables..."

# Public Route Table
PUBLIC_RT=$(aws ec2 create-route-table --vpc-id $VPC_ID --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=Public-RT}]" --query 'RouteTable.RouteTableId' --output text)
aws ec2 create-route --route-table-id $PUBLIC_RT --destination-cidr-block 0.0.0.0/0 --gateway-id $IGW_ID

# Associate public subnets
aws ec2 associate-route-table --subnet-id $PUBLIC_SUBNET_1 --route-table-id $PUBLIC_RT
aws ec2 associate-route-table --subnet-id $PUBLIC_SUBNET_2 --route-table-id $PUBLIC_RT

# Private Route Table
PRIVATE_RT=$(aws ec2 create-route-table --vpc-id $VPC_ID --tag-specifications "ResourceType=route-table,Tags=[{Key=Name,Value=Private-RT}]" --query 'RouteTable.RouteTableId' --output text)
aws ec2 create-route --route-table-id $PRIVATE_RT --destination-cidr-block 0.0.0.0/0 --nat-gateway-id $NAT_GW_ID

# Associate private subnets
aws ec2 associate-route-table --subnet-id $PRIVATE_SUBNET_1 --route-table-id $PRIVATE_RT
aws ec2 associate-route-table --subnet-id $PRIVATE_SUBNET_2 --route-table-id $PRIVATE_RT

echo "Route tables created and configured"

# Step 6: Create Security Groups
echo "Creating security groups..."

# Load Balancer Security Group
ALB_SG=$(aws ec2 create-security-group --group-name ALB-SG --description "Application Load Balancer Security Group" --vpc-id $VPC_ID --query 'GroupId' --output text)
aws ec2 authorize-security-group-ingress --group-id $ALB_SG --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $ALB_SG --protocol tcp --port 443 --cidr 0.0.0.0/0

# Web Server Security Group
WEB_SG=$(aws ec2 create-security-group --group-name WebServer-SG --description "Web Server Security Group" --vpc-id $VPC_ID --query 'GroupId' --output text)
aws ec2 authorize-security-group-ingress --group-id $WEB_SG --protocol tcp --port 80 --source-group $ALB_SG

# Database Security Group
DB_SG=$(aws ec2 create-security-group --group-name Database-SG --description "Database Security Group" --vpc-id $VPC_ID --query 'GroupId' --output text)
aws ec2 authorize-security-group-ingress --group-id $DB_SG --protocol tcp --port 3306 --source-group $WEB_SG

echo "Security groups created:"
echo "  Load Balancer SG: $ALB_SG"
echo "  Web Server SG: $WEB_SG"
echo "  Database SG: $DB_SG"

# Step 7: Create DB Subnet Group
echo "Creating DB subnet group..."
aws rds create-db-subnet-group --db-subnet-group-name tesda-db-subnet-group --db-subnet-group-description "TESDA Database Subnet Group" --subnet-ids $PRIVATE_SUBNET_1 $PRIVATE_SUBNET_2

# Step 8: Create User Data Script for Web Servers
cat > user-data.sh << 'EOF'
#!/bin/bash
yum update -y
yum install -y httpd mysql
systemctl start httpd
systemctl enable httpd
echo "<h1>TESDA Secure Web Server</h1>" > /var/www/html/index.html
echo "<p>Server: $(hostname)</p>" >> /var/www/html/index.html
echo "<p>Timestamp: $(date)</p>" >> /var/www/html/index.html
EOF

echo "User data script created"

# Save configuration
cat > project2-config.txt << EOF
VPC_ID=$VPC_ID
PUBLIC_SUBNET_1=$PUBLIC_SUBNET_1
PUBLIC_SUBNET_2=$PUBLIC_SUBNET_2
PRIVATE_SUBNET_1=$PRIVATE_SUBNET_1
PRIVATE_SUBNET_2=$PRIVATE_SUBNET_2
IGW_ID=$IGW_ID
NAT_GW_ID=$NAT_GW_ID
PUBLIC_RT=$PUBLIC_RT
PRIVATE_RT=$PRIVATE_RT
ALB_SG=$ALB_SG
WEB_SG=$WEB_SG
DB_SG=$DB_SG
EIP_ALLOC=$EIP_ALLOC
REGION=$REGION
AZ1=$AZ1
AZ2=$AZ2
EOF

echo ""
echo "=== Project 2 Infrastructure Setup Complete ==="
echo "VPC ID: $VPC_ID"
echo "Public Subnets: $PUBLIC_SUBNET_1, $PUBLIC_SUBNET_2"
echo "Private Subnets: $PRIVATE_SUBNET_1, $PRIVATE_SUBNET_2"
echo "Security Groups: ALB($ALB_SG), Web($WEB_SG), DB($DB_SG)"
echo ""
echo "Configuration saved to project2-config.txt"
echo ""
echo "Next steps:"
echo "1. Request SSL certificate from ACM"
echo "2. Create RDS MySQL instance"
echo "3. Create Launch Template and Auto Scaling Group"
echo "4. Create Application Load Balancer"
echo "5. Configure AWS WAF"
echo "6. Enable Security Hub"
echo ""
echo "Infrastructure setup completed successfully!"
