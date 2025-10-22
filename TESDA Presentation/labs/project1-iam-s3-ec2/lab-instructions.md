# Project 1: AWS IAM, S3, and EC2 Integration

## Objective
Learn IAM fundamentals by creating secure connections between S3 and EC2 using IAM roles and policies.

## Prerequisites
- AWS Account with appropriate permissions
- AWS CLI installed and configured
- Basic understanding of Linux commands

## Lab Steps

### Step 1: Create IAM Role for EC2
1. Navigate to IAM Console
2. Create new role for EC2 service
3. Attach S3 access policy
4. Name the role: `EC2-S3-Access-Role`

### Step 2: Create S3 Bucket
1. Create S3 bucket with unique name
2. Configure bucket policy for secure access
3. Enable versioning and encryption
4. Upload sample files for testing

### Step 3: Launch EC2 Instance
1. Launch Amazon Linux 2 instance
2. Attach the IAM role created in Step 1
3. Configure security group for SSH access
4. Connect to instance via SSH

### Step 4: Install and Configure Rclone
1. Install Rclone on EC2 instance
2. Configure Rclone for S3 access using IAM role
3. Test file synchronization
4. Verify secure access without hardcoded credentials

### Step 5: Testing and Validation
1. Upload files from EC2 to S3
2. Download files from S3 to EC2
3. Verify IAM role permissions
4. Test access restrictions

## Expected Outcomes
- Understanding of IAM roles vs users
- Secure EC2-S3 integration without access keys
- Practical experience with Rclone
- Knowledge of least privilege principle
