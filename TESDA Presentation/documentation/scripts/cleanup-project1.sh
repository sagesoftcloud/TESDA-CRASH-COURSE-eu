#!/bin/bash

# Project 1 Cleanup Script
# TESDA AWS Security Training

set -e

echo "Starting Project 1 cleanup..."

# Load configuration if it exists
if [ -f "project1-config.txt" ]; then
    source project1-config.txt
    echo "Loaded configuration from project1-config.txt"
else
    echo "Configuration file not found. Please provide resource names manually."
    read -p "Enter IAM Role Name (default: EC2-S3-Access-Role): " ROLE_NAME
    ROLE_NAME=${ROLE_NAME:-EC2-S3-Access-Role}
    
    read -p "Enter Instance Profile Name (default: EC2-S3-Profile): " INSTANCE_PROFILE_NAME
    INSTANCE_PROFILE_NAME=${INSTANCE_PROFILE_NAME:-EC2-S3-Profile}
    
    read -p "Enter S3 Bucket Name: " BUCKET_NAME
    read -p "Enter Security Group Name (default: tesda-lab-sg): " SG_NAME
    SG_NAME=${SG_NAME:-tesda-lab-sg}
fi

# Function to check if resource exists
check_resource() {
    local resource_type=$1
    local resource_name=$2
    local check_command=$3
    
    if eval $check_command > /dev/null 2>&1; then
        echo "$resource_type '$resource_name' exists"
        return 0
    else
        echo "$resource_type '$resource_name' not found"
        return 1
    fi
}

# Step 1: Terminate EC2 instances using the security group
echo "Checking for EC2 instances to terminate..."
INSTANCE_IDS=$(aws ec2 describe-instances --filters "Name=instance-state-name,Values=running,pending,stopping,stopped" "Name=instance.group-name,Values=$SG_NAME" --query 'Reservations[].Instances[].InstanceId' --output text)

if [ ! -z "$INSTANCE_IDS" ]; then
    echo "Terminating EC2 instances: $INSTANCE_IDS"
    aws ec2 terminate-instances --instance-ids $INSTANCE_IDS
    echo "Waiting for instances to terminate..."
    aws ec2 wait instance-terminated --instance-ids $INSTANCE_IDS
    echo "Instances terminated successfully"
else
    echo "No EC2 instances found to terminate"
fi

# Step 2: Empty and delete S3 bucket
if [ ! -z "$BUCKET_NAME" ]; then
    if check_resource "S3 Bucket" "$BUCKET_NAME" "aws s3 ls s3://$BUCKET_NAME"; then
        echo "Emptying S3 bucket: $BUCKET_NAME"
        aws s3 rm s3://$BUCKET_NAME --recursive
        
        echo "Deleting S3 bucket: $BUCKET_NAME"
        aws s3 rb s3://$BUCKET_NAME
        echo "S3 bucket deleted successfully"
    fi
fi

# Step 3: Delete Security Group
if [ ! -z "$SG_NAME" ]; then
    if check_resource "Security Group" "$SG_NAME" "aws ec2 describe-security-groups --group-names $SG_NAME"; then
        SG_ID=$(aws ec2 describe-security-groups --group-names $SG_NAME --query 'SecurityGroups[0].GroupId' --output text)
        echo "Deleting Security Group: $SG_NAME ($SG_ID)"
        aws ec2 delete-security-group --group-id $SG_ID
        echo "Security Group deleted successfully"
    fi
fi

# Step 4: Remove IAM role from instance profile
if [ ! -z "$INSTANCE_PROFILE_NAME" ] && [ ! -z "$ROLE_NAME" ]; then
    if check_resource "Instance Profile" "$INSTANCE_PROFILE_NAME" "aws iam get-instance-profile --instance-profile-name $INSTANCE_PROFILE_NAME"; then
        echo "Removing role from instance profile..."
        aws iam remove-role-from-instance-profile --instance-profile-name $INSTANCE_PROFILE_NAME --role-name $ROLE_NAME || echo "Role may not be attached to instance profile"
        
        echo "Deleting instance profile: $INSTANCE_PROFILE_NAME"
        aws iam delete-instance-profile --instance-profile-name $INSTANCE_PROFILE_NAME
        echo "Instance profile deleted successfully"
    fi
fi

# Step 5: Delete IAM role and policies
if [ ! -z "$ROLE_NAME" ]; then
    if check_resource "IAM Role" "$ROLE_NAME" "aws iam get-role --role-name $ROLE_NAME"; then
        echo "Deleting IAM role policies..."
        
        # List and delete inline policies
        POLICY_NAMES=$(aws iam list-role-policies --role-name $ROLE_NAME --query 'PolicyNames' --output text)
        for policy in $POLICY_NAMES; do
            if [ "$policy" != "None" ]; then
                echo "Deleting inline policy: $policy"
                aws iam delete-role-policy --role-name $ROLE_NAME --policy-name $policy
            fi
        done
        
        # Detach managed policies
        ATTACHED_POLICIES=$(aws iam list-attached-role-policies --role-name $ROLE_NAME --query 'AttachedPolicies[].PolicyArn' --output text)
        for policy_arn in $ATTACHED_POLICIES; do
            if [ "$policy_arn" != "None" ]; then
                echo "Detaching managed policy: $policy_arn"
                aws iam detach-role-policy --role-name $ROLE_NAME --policy-arn $policy_arn
            fi
        done
        
        echo "Deleting IAM role: $ROLE_NAME"
        aws iam delete-role --role-name $ROLE_NAME
        echo "IAM role deleted successfully"
    fi
fi

# Step 6: Clean up local files
echo "Cleaning up local files..."
rm -rf sample-files/ local-files/ downloads/
rm -f project1-config.txt user-data.sh
rm -f test-*.txt *.log

echo ""
echo "=== Project 1 Cleanup Complete ==="
echo "All AWS resources have been deleted:"
echo "- EC2 instances terminated"
echo "- S3 bucket emptied and deleted"
echo "- Security Group deleted"
echo "- IAM role and instance profile deleted"
echo "- Local files cleaned up"
echo ""
echo "Please verify in the AWS Console that all resources are deleted."
echo "Check your AWS bill to ensure no unexpected charges."
echo ""
echo "Cleanup completed successfully!"
