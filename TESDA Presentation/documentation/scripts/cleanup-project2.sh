#!/bin/bash

# Project 2 Cleanup Script
# TESDA AWS Security Training

set -e

echo "Starting Project 2 cleanup..."

# Load configuration if it exists
if [ -f "project2-config.txt" ]; then
    source project2-config.txt
    echo "Loaded configuration from project2-config.txt"
else
    echo "Configuration file not found. Manual cleanup required."
    echo "Please provide resource IDs manually or check AWS Console."
    exit 1
fi

# Function to check if resource exists
check_resource() {
    local resource_type=$1
    local resource_id=$2
    local check_command=$3
    
    if eval $check_command > /dev/null 2>&1; then
        echo "$resource_type '$resource_id' exists"
        return 0
    else
        echo "$resource_type '$resource_id' not found or already deleted"
        return 1
    fi
}

# Step 1: Delete Auto Scaling Group and Launch Template
echo "Cleaning up Auto Scaling resources..."

# Delete Auto Scaling Group
ASG_NAME="tesda-asg"
if check_resource "Auto Scaling Group" "$ASG_NAME" "aws autoscaling describe-auto-scaling-groups --auto-scaling-group-names $ASG_NAME"; then
    echo "Updating Auto Scaling Group to 0 instances..."
    aws autoscaling update-auto-scaling-group --auto-scaling-group-name $ASG_NAME --min-size 0 --max-size 0 --desired-capacity 0
    
    echo "Waiting for instances to terminate..."
    sleep 30
    
    echo "Deleting Auto Scaling Group: $ASG_NAME"
    aws autoscaling delete-auto-scaling-group --auto-scaling-group-name $ASG_NAME --force-delete
fi

# Delete Launch Template
LAUNCH_TEMPLATE_NAME="tesda-web-template"
if check_resource "Launch Template" "$LAUNCH_TEMPLATE_NAME" "aws ec2 describe-launch-templates --launch-template-names $LAUNCH_TEMPLATE_NAME"; then
    echo "Deleting Launch Template: $LAUNCH_TEMPLATE_NAME"
    aws ec2 delete-launch-template --launch-template-name $LAUNCH_TEMPLATE_NAME
fi

# Step 2: Delete Load Balancer and Target Groups
echo "Cleaning up Load Balancer resources..."

# Get Load Balancer ARN
ALB_NAME="tesda-alb"
ALB_ARN=$(aws elbv2 describe-load-balancers --names $ALB_NAME --query 'LoadBalancers[0].LoadBalancerArn' --output text 2>/dev/null || echo "None")

if [ "$ALB_ARN" != "None" ] && [ "$ALB_ARN" != "" ]; then
    echo "Deleting Load Balancer: $ALB_NAME"
    aws elbv2 delete-load-balancer --load-balancer-arn $ALB_ARN
    
    echo "Waiting for Load Balancer to be deleted..."
    aws elbv2 wait load-balancer-not-exists --load-balancer-arns $ALB_ARN
fi

# Delete Target Group
TG_NAME="tesda-web-targets"
TG_ARN=$(aws elbv2 describe-target-groups --names $TG_NAME --query 'TargetGroups[0].TargetGroupArn' --output text 2>/dev/null || echo "None")

if [ "$TG_ARN" != "None" ] && [ "$TG_ARN" != "" ]; then
    echo "Deleting Target Group: $TG_NAME"
    aws elbv2 delete-target-group --target-group-arn $TG_ARN
fi

# Step 3: Delete RDS Instance and DB Subnet Group
echo "Cleaning up RDS resources..."

DB_INSTANCE_ID="tesda-mysql-db"
if check_resource "RDS Instance" "$DB_INSTANCE_ID" "aws rds describe-db-instances --db-instance-identifier $DB_INSTANCE_ID"; then
    echo "Deleting RDS instance: $DB_INSTANCE_ID"
    aws rds delete-db-instance --db-instance-identifier $DB_INSTANCE_ID --skip-final-snapshot --delete-automated-backups
    
    echo "Waiting for RDS instance to be deleted..."
    aws rds wait db-instance-deleted --db-instance-identifier $DB_INSTANCE_ID
fi

# Delete DB Subnet Group
DB_SUBNET_GROUP="tesda-db-subnet-group"
if check_resource "DB Subnet Group" "$DB_SUBNET_GROUP" "aws rds describe-db-subnet-groups --db-subnet-group-name $DB_SUBNET_GROUP"; then
    echo "Deleting DB Subnet Group: $DB_SUBNET_GROUP"
    aws rds delete-db-subnet-group --db-subnet-group-name $DB_SUBNET_GROUP
fi

# Step 4: Delete WAF Web ACL
echo "Cleaning up WAF resources..."

WEB_ACL_NAME="tesda-web-acl"
WEB_ACL_ID=$(aws wafv2 list-web-acls --scope REGIONAL --query "WebACLs[?Name=='$WEB_ACL_NAME'].Id" --output text 2>/dev/null || echo "None")

if [ "$WEB_ACL_ID" != "None" ] && [ "$WEB_ACL_ID" != "" ]; then
    echo "Deleting WAF Web ACL: $WEB_ACL_NAME"
    aws wafv2 delete-web-acl --scope REGIONAL --id $WEB_ACL_ID --lock-token $(aws wafv2 get-web-acl --scope REGIONAL --id $WEB_ACL_ID --query 'LockToken' --output text)
fi

# Step 5: Delete NAT Gateway and release Elastic IP
echo "Cleaning up NAT Gateway and Elastic IP..."

if [ ! -z "$NAT_GW_ID" ]; then
    if check_resource "NAT Gateway" "$NAT_GW_ID" "aws ec2 describe-nat-gateways --nat-gateway-ids $NAT_GW_ID"; then
        echo "Deleting NAT Gateway: $NAT_GW_ID"
        aws ec2 delete-nat-gateway --nat-gateway-id $NAT_GW_ID
        
        echo "Waiting for NAT Gateway to be deleted..."
        aws ec2 wait nat-gateway-deleted --nat-gateway-ids $NAT_GW_ID
    fi
fi

if [ ! -z "$EIP_ALLOC" ]; then
    if check_resource "Elastic IP" "$EIP_ALLOC" "aws ec2 describe-addresses --allocation-ids $EIP_ALLOC"; then
        echo "Releasing Elastic IP: $EIP_ALLOC"
        aws ec2 release-address --allocation-id $EIP_ALLOC
    fi
fi

# Step 6: Delete Security Groups
echo "Cleaning up Security Groups..."

for sg_id in $DB_SG $WEB_SG $ALB_SG; do
    if [ ! -z "$sg_id" ]; then
        if check_resource "Security Group" "$sg_id" "aws ec2 describe-security-groups --group-ids $sg_id"; then
            echo "Deleting Security Group: $sg_id"
            aws ec2 delete-security-group --group-id $sg_id
        fi
    fi
done

# Step 7: Detach and delete Internet Gateway
echo "Cleaning up Internet Gateway..."

if [ ! -z "$IGW_ID" ]; then
    if check_resource "Internet Gateway" "$IGW_ID" "aws ec2 describe-internet-gateways --internet-gateway-ids $IGW_ID"; then
        echo "Detaching Internet Gateway: $IGW_ID"
        aws ec2 detach-internet-gateway --internet-gateway-id $IGW_ID --vpc-id $VPC_ID || echo "IGW may already be detached"
        
        echo "Deleting Internet Gateway: $IGW_ID"
        aws ec2 delete-internet-gateway --internet-gateway-id $IGW_ID
    fi
fi

# Step 8: Delete Route Tables (except default)
echo "Cleaning up Route Tables..."

for rt_id in $PUBLIC_RT $PRIVATE_RT; do
    if [ ! -z "$rt_id" ]; then
        if check_resource "Route Table" "$rt_id" "aws ec2 describe-route-tables --route-table-ids $rt_id"; then
            echo "Deleting Route Table: $rt_id"
            aws ec2 delete-route-table --route-table-id $rt_id
        fi
    fi
done

# Step 9: Delete Subnets
echo "Cleaning up Subnets..."

for subnet_id in $PUBLIC_SUBNET_1 $PUBLIC_SUBNET_2 $PRIVATE_SUBNET_1 $PRIVATE_SUBNET_2; do
    if [ ! -z "$subnet_id" ]; then
        if check_resource "Subnet" "$subnet_id" "aws ec2 describe-subnets --subnet-ids $subnet_id"; then
            echo "Deleting Subnet: $subnet_id"
            aws ec2 delete-subnet --subnet-id $subnet_id
        fi
    fi
done

# Step 10: Delete VPC
echo "Cleaning up VPC..."

if [ ! -z "$VPC_ID" ]; then
    if check_resource "VPC" "$VPC_ID" "aws ec2 describe-vpcs --vpc-ids $VPC_ID"; then
        echo "Deleting VPC: $VPC_ID"
        aws ec2 delete-vpc --vpc-id $VPC_ID
    fi
fi

# Step 11: Disable Security Hub (optional)
echo "Disabling Security Hub..."
aws securityhub disable-security-hub 2>/dev/null || echo "Security Hub may not be enabled or already disabled"

# Step 12: Clean up local files
echo "Cleaning up local files..."
rm -f project2-config.txt user-data.sh waf-rules.json
rm -f *.log *.json

echo ""
echo "=== Project 2 Cleanup Complete ==="
echo "All AWS resources have been deleted:"
echo "- Auto Scaling Group and Launch Template"
echo "- Application Load Balancer and Target Groups"
echo "- RDS MySQL instance and DB Subnet Group"
echo "- WAF Web ACL"
echo "- NAT Gateway and Elastic IP"
echo "- Security Groups"
echo "- Internet Gateway"
echo "- Route Tables"
echo "- Subnets"
echo "- VPC"
echo "- Security Hub disabled"
echo "- Local files cleaned up"
echo ""
echo "Please verify in the AWS Console that all resources are deleted."
echo "Check your AWS bill to ensure no unexpected charges."
echo ""
echo "Note: SSL certificates in ACM are not deleted automatically."
echo "If you created certificates for this lab, delete them manually from ACM."
echo ""
echo "Cleanup completed successfully!"
