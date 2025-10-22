#!/bin/bash

# Project 1: AWS IAM, S3, and EC2 Integration Setup Script
# TESDA AWS Security Training

set -e

# Variables
ROLE_NAME="EC2-S3-Access-Role"
INSTANCE_PROFILE_NAME="EC2-S3-Profile"
BUCKET_NAME="tesda-lab-bucket-$(date +%s)"
SG_NAME="tesda-lab-sg"
REGION="us-east-1"

echo "Starting Project 1 Setup..."

# Step 1: Create IAM Role and Policies
echo "Creating IAM role and policies..."

# Create trust policy
cat > trust-policy.json << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

# Create IAM role
aws iam create-role --role-name $ROLE_NAME --assume-role-policy-document file://trust-policy.json

# Create S3 access policy
cat > s3-access-policy.json << EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject",
        "s3:DeleteObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::$BUCKET_NAME",
        "arn:aws:s3:::$BUCKET_NAME/*"
      ]
    }
  ]
}
EOF

# Attach policy to role
aws iam put-role-policy --role-name $ROLE_NAME --policy-name S3AccessPolicy --policy-document file://s3-access-policy.json

# Create instance profile
aws iam create-instance-profile --instance-profile-name $INSTANCE_PROFILE_NAME
aws iam add-role-to-instance-profile --instance-profile-name $INSTANCE_PROFILE_NAME --role-name $ROLE_NAME

echo "IAM role and policies created successfully."

# Step 2: Create S3 Bucket
echo "Creating S3 bucket..."

aws s3 mb s3://$BUCKET_NAME --region $REGION

# Enable versioning
aws s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration Status=Enabled

# Enable encryption
aws s3api put-bucket-encryption --bucket $BUCKET_NAME --server-side-encryption-configuration '{
  "Rules": [
    {
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }
  ]
}'

echo "S3 bucket $BUCKET_NAME created and configured."

# Step 3: Create Security Group
echo "Creating security group..."

SG_ID=$(aws ec2 create-security-group --group-name $SG_NAME --description "TESDA Lab Security Group" --query 'GroupId' --output text)
aws ec2 authorize-security-group-ingress --group-id $SG_ID --protocol tcp --port 22 --cidr 0.0.0.0/0

echo "Security group $SG_NAME created with ID: $SG_ID"

# Step 4: Create sample files for testing
echo "Creating sample files..."
mkdir -p sample-files
for i in {1..5}; do
  echo "Sample file $i - Created on $(date)" > sample-files/sample-$i.txt
done

echo "Sample files created in sample-files/ directory"

# Output important information
echo ""
echo "=== Project 1 Setup Complete ==="
echo "IAM Role: $ROLE_NAME"
echo "Instance Profile: $INSTANCE_PROFILE_NAME"
echo "S3 Bucket: $BUCKET_NAME"
echo "Security Group: $SG_NAME ($SG_ID)"
echo ""
echo "Next steps:"
echo "1. Launch EC2 instance with instance profile: $INSTANCE_PROFILE_NAME"
echo "2. Use security group: $SG_ID"
echo "3. Install and configure Rclone on the instance"
echo "4. Test S3 access using the bucket: $BUCKET_NAME"
echo ""

# Save configuration for later use
cat > project1-config.txt << EOF
ROLE_NAME=$ROLE_NAME
INSTANCE_PROFILE_NAME=$INSTANCE_PROFILE_NAME
BUCKET_NAME=$BUCKET_NAME
SG_NAME=$SG_NAME
SG_ID=$SG_ID
REGION=$REGION
EOF

echo "Configuration saved to project1-config.txt"

# Cleanup temporary files
rm -f trust-policy.json s3-access-policy.json

echo "Setup script completed successfully!"
