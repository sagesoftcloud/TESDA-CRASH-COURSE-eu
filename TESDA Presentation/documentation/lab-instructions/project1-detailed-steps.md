# Project 1: Detailed Step-by-Step Instructions

## Step 1: Create IAM Role for EC2

### 1.1 Navigate to IAM Console
```bash
# Open AWS Console and go to IAM service
# Or use AWS CLI to create role
aws iam create-role --role-name EC2-S3-Access-Role --assume-role-policy-document file://trust-policy.json
```

### 1.2 Create Trust Policy
Create file: `trust-policy.json`
```json
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
```

### 1.3 Create S3 Access Policy
Create file: `s3-access-policy.json`
```json
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
        "arn:aws:s3:::your-bucket-name",
        "arn:aws:s3:::your-bucket-name/*"
      ]
    }
  ]
}
```

### 1.4 Attach Policy to Role
```bash
aws iam put-role-policy --role-name EC2-S3-Access-Role --policy-name S3AccessPolicy --policy-document file://s3-access-policy.json
```

### 1.5 Create Instance Profile
```bash
aws iam create-instance-profile --instance-profile-name EC2-S3-Profile
aws iam add-role-to-instance-profile --instance-profile-name EC2-S3-Profile --role-name EC2-S3-Access-Role
```

## Step 2: Create S3 Bucket

### 2.1 Create Bucket
```bash
aws s3 mb s3://tesda-lab-bucket-$(date +%s) --region us-east-1
```

### 2.2 Enable Versioning
```bash
aws s3api put-bucket-versioning --bucket tesda-lab-bucket-$(date +%s) --versioning-configuration Status=Enabled
```

### 2.3 Enable Encryption
```bash
aws s3api put-bucket-encryption --bucket tesda-lab-bucket-$(date +%s) --server-side-encryption-configuration '{
  "Rules": [
    {
      "ApplyServerSideEncryptionByDefault": {
        "SSEAlgorithm": "AES256"
      }
    }
  ]
}'
```

## Step 3: Launch EC2 Instance

### 3.1 Create Security Group
```bash
aws ec2 create-security-group --group-name tesda-lab-sg --description "TESDA Lab Security Group"
aws ec2 authorize-security-group-ingress --group-name tesda-lab-sg --protocol tcp --port 22 --cidr 0.0.0.0/0
```

### 3.2 Launch Instance
```bash
aws ec2 run-instances \
  --image-id ami-0abcdef1234567890 \
  --count 1 \
  --instance-type t2.micro \
  --key-name your-key-pair \
  --security-groups tesda-lab-sg \
  --iam-instance-profile Name=EC2-S3-Profile
```

## Step 4: Install and Configure Rclone

### 4.1 Connect to EC2 Instance
```bash
ssh -i your-key.pem ec2-user@your-instance-ip
```

### 4.2 Install Rclone
```bash
sudo yum update -y
curl https://rclone.org/install.sh | sudo bash
```

### 4.3 Configure Rclone
```bash
rclone config
# Choose: n (new remote)
# Name: s3remote
# Type: 4 (Amazon S3)
# Provider: 1 (AWS)
# env_auth: true (use IAM role)
# Region: us-east-1
# Accept defaults for other options
```

### 4.4 Test Configuration
```bash
# List buckets
rclone lsd s3remote:

# Create test file
echo "Hello from EC2" > test-file.txt

# Upload to S3
rclone copy test-file.txt s3remote:your-bucket-name/

# List bucket contents
rclone ls s3remote:your-bucket-name/
```

## Step 5: Testing and Validation

### 5.1 Upload Files
```bash
# Create multiple test files
for i in {1..5}; do
  echo "Test file $i content" > test-file-$i.txt
done

# Sync to S3
rclone sync . s3remote:your-bucket-name/test-folder/
```

### 5.2 Download Files
```bash
# Create new directory
mkdir downloads

# Download from S3
rclone copy s3remote:your-bucket-name/test-folder/ downloads/

# Verify files
ls -la downloads/
```

### 5.3 Verify IAM Role
```bash
# Check instance metadata for role
curl http://169.254.169.254/latest/meta-data/iam/security-credentials/

# Verify no hardcoded credentials
cat ~/.aws/credentials  # Should not exist or be empty
```

## Troubleshooting

### Common Issues
1. **Permission Denied**: Check IAM role attachment
2. **Bucket Access Denied**: Verify bucket policy and IAM permissions
3. **Rclone Config Issues**: Ensure env_auth is set to true

### Verification Commands
```bash
# Check IAM role
aws sts get-caller-identity

# Test S3 access
aws s3 ls s3://your-bucket-name/

# Check instance profile
curl http://169.254.169.254/latest/meta-data/iam/info
```
