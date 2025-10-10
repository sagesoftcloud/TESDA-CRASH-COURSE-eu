# AWS Services Setup Guide
## Detailed Configuration for TESDA Presentation

### 🎯 Primary Demo Account Setup

#### Step 1: Account Foundation
```bash
# Account Setup Checklist
✅ Root account with company email
✅ Root account MFA enabled (Google Authenticator)
✅ Strong root password (stored securely)
✅ Billing information configured
✅ Support plan: Basic (free) minimum
```

#### Step 2: AWS Organizations Configuration
```bash
# Enable Organizations
1. Go to AWS Organizations console
2. Click "Create an organization"
3. Select "Enable all features" (not just billing)
4. Wait for organization creation (2-3 minutes)

# Create Organizational Units
Create these OUs in order:
- Core-OU (Description: "Essential services and security")
- Production-OU (Description: "Live systems serving students")  
- Non-Production-OU (Description: "Development and testing")
- Sandbox-OU (Description: "Learning and experimentation")
```

#### Step 3: Member Accounts Creation
```bash
# Create Demo Member Accounts
Account 1:
- Name: "TESDA-Security-Demo"
- Email: tesda-security-demo@[your-domain].com
- IAM Role: OrganizationAccountAccessRole
- Move to: Core-OU

Account 2:
- Name: "TESDA-LMS-Production-Demo"  
- Email: tesda-lms-prod-demo@[your-domain].com
- IAM Role: OrganizationAccountAccessRole
- Move to: Production-OU

Account 3:
- Name: "TESDA-Development-Demo"
- Email: tesda-dev-demo@[your-domain].com
- IAM Role: OrganizationAccountAccessRole
- Move to: Non-Production-OU
```

#### Step 4: Service Control Policies
```json
// Policy 1: Prevent Account Closure
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PreventAccountClosure",
      "Effect": "Deny",
      "Action": [
        "account:CloseAccount"
      ],
      "Resource": "*"
    }
  ]
}

// Policy 2: Development Account Restrictions
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "RestrictExpensiveServices",
      "Effect": "Deny",
      "Action": [
        "redshift:*",
        "sagemaker:*",
        "databrew:*",
        "emr:*"
      ],
      "Resource": "*"
    },
    {
      "Sid": "RestrictInstanceTypes",
      "Effect": "Deny",
      "Action": [
        "ec2:RunInstances"
      ],
      "Resource": "arn:aws:ec2:*:*:instance/*",
      "Condition": {
        "ForAllValues:StringNotEquals": {
          "ec2:InstanceType": [
            "t3.micro",
            "t3.small",
            "t3.medium"
          ]
        }
      }
    }
  ]
}
```

---

### 🔐 IAM Identity Center Setup

#### Step 1: Enable Identity Center
```bash
# Prerequisites Check
✅ AWS Organizations enabled
✅ Management account access
✅ Region selected: ap-southeast-1 (Singapore)

# Enable Process
1. Go to IAM Identity Center console
2. Click "Enable IAM Identity Center"
3. Choose region: Asia Pacific (Singapore)
4. Wait for setup completion (3-5 minutes)
```

#### Step 2: Configure Identity Source
```bash
# For Demo: Use Built-in Identity Store
1. Go to Settings → Identity source
2. Select "Identity Center directory"
3. Click "Configure"

# Create Demo Users
User 1:
- Username: maria.santos
- Email: maria.santos@tesda-demo.com
- First name: Maria
- Last name: Santos
- Display name: Maria Santos
- Group: TESDA-Curriculum-Staff

User 2:
- Username: john.delacruz
- Email: john.delacruz@tesda-demo.com
- First name: John
- Last name: Dela Cruz
- Display name: John Dela Cruz
- Group: TESDA-IT-Staff

User 3:
- Username: admin.tesda
- Email: admin@tesda-demo.com
- First name: TESDA
- Last name: Administrator
- Display name: TESDA Admin
- Group: TESDA-Administrators
```

#### Step 3: Create Permission Sets
```json
// Permission Set 1: TESDA-SuperAdmin
{
  "Name": "TESDA-SuperAdmin",
  "Description": "Full administrative access for IT Directors",
  "SessionDuration": "PT4H",
  "ManagedPolicies": [
    "arn:aws:iam::aws:policy/AdministratorAccess"
  ]
}

// Permission Set 2: TESDA-ITAdmin
{
  "Name": "TESDA-ITAdmin", 
  "Description": "Infrastructure management for IT staff",
  "SessionDuration": "PT8H",
  "ManagedPolicies": [
    "arn:aws:iam::aws:policy/PowerUserAccess"
  ],
  "InlinePolicy": {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Deny",
        "Action": [
          "iam:CreateUser",
          "iam:DeleteUser",
          "organizations:*",
          "account:*"
        ],
        "Resource": "*"
      }
    ]
  }
}

// Permission Set 3: TESDA-Developer
{
  "Name": "TESDA-Developer",
  "Description": "Development access for application developers", 
  "SessionDuration": "PT8H",
  "ManagedPolicies": [
    "arn:aws:iam::aws:policy/AmazonEC2FullAccess",
    "arn:aws:iam::aws:policy/AmazonS3FullAccess",
    "arn:aws:iam::aws:policy/AmazonRDSFullAccess"
  ]
}

// Permission Set 4: TESDA-ReadOnly
{
  "Name": "TESDA-ReadOnly",
  "Description": "View-only access for auditors and managers",
  "SessionDuration": "PT12H", 
  "ManagedPolicies": [
    "arn:aws:iam::aws:policy/ReadOnlyAccess"
  ]
}
```

#### Step 4: Account Assignments
```bash
# Assignment Matrix
TESDA-Security-Demo Account:
- TESDA-Administrators group → TESDA-SuperAdmin permission set
- TESDA-IT-Staff group → TESDA-ITAdmin permission set

TESDA-LMS-Production-Demo Account:
- TESDA-Administrators group → TESDA-SuperAdmin permission set
- TESDA-IT-Staff group → TESDA-ReadOnly permission set
- TESDA-Curriculum-Staff group → TESDA-ReadOnly permission set

TESDA-Development-Demo Account:
- TESDA-IT-Staff group → TESDA-Developer permission set
- TESDA-Curriculum-Staff group → TESDA-Developer permission set
```

---

### 🛡️ IAM Configuration for Labs

#### Demo Users for IAM Labs
```bash
# Create these users in main demo account
User 1:
- Username: tesda-pilot-user
- Console access: Yes
- Temporary password: TempPass123!
- Force password change: Yes
- Groups: TESDA-MFA-Required (create this group)

User 2:
- Username: tesda-test-user-2
- Console access: Yes
- Temporary password: TestPass456!
- Force password change: Yes
- Groups: TESDA-MFA-Required
```

#### MFA Enforcement Policy
```json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AllowViewAccountInfo",
            "Effect": "Allow",
            "Action": [
                "iam:GetAccountPasswordPolicy",
                "iam:GetAccountSummary",
                "iam:ListVirtualMFADevices"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowManageOwnPasswords",
            "Effect": "Allow",
            "Action": [
                "iam:ChangePassword",
                "iam:GetUser"
            ],
            "Resource": "arn:aws:iam::*:user/${aws:username}"
        },
        {
            "Sid": "AllowManageOwnMFA",
            "Effect": "Allow",
            "Action": [
                "iam:CreateVirtualMFADevice",
                "iam:DeleteVirtualMFADevice",
                "iam:ListMFADevices",
                "iam:EnableMFADevice",
                "iam:ResyncMFADevice"
            ],
            "Resource": [
                "arn:aws:iam::*:mfa/${aws:username}",
                "arn:aws:iam::*:user/${aws:username}"
            ]
        },
        {
            "Sid": "AllowListActions",
            "Effect": "Allow",
            "Action": [
                "iam:ListUsers",
                "iam:ListVirtualMFADevices"
            ],
            "Resource": "*"
        },
        {
            "Sid": "BlockMostAccessUnlessSignedInWithMFA",
            "Effect": "Deny",
            "NotAction": [
                "iam:CreateVirtualMFADevice",
                "iam:EnableMFADevice",
                "iam:GetUser",
                "iam:ListMFADevices",
                "iam:ListVirtualMFADevices",
                "iam:ResyncMFADevice",
                "sts:GetSessionToken",
                "iam:ChangePassword",
                "iam:GetAccountPasswordPolicy",
                "iam:GetAccountSummary"
            ],
            "Resource": "*",
            "Condition": {
                "BoolIfExists": {
                    "aws:MultiFactorAuthPresent": "false"
                }
            }
        }
    ]
}
```

#### Cross-Account Roles
```json
// Role: TESDA-CrossAccount-Monitor
// Trust Policy:
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::MANAGEMENT-ACCOUNT-ID:root"
      },
      "Action": "sts:AssumeRole",
      "Condition": {
        "Bool": {
          "aws:MultiFactorAuthPresent": "true"
        }
      }
    }
  ]
}

// Permission Policy:
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "cloudtrail:LookupEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams",
        "cloudwatch:GetMetricStatistics",
        "cloudwatch:ListMetrics"
      ],
      "Resource": "*"
    }
  ]
}
```

---

### 📊 Monitoring & Compliance Setup

#### CloudTrail Configuration
```bash
# Create Organization Trail
1. Go to CloudTrail console in Security account
2. Click "Create trail"
3. Trail name: "TESDA-Organization-Trail"
4. Apply to organization: Yes
5. S3 bucket: Create new bucket "tesda-cloudtrail-logs-[random]"
6. Log file validation: Enabled
7. SNS notification: Optional
8. CloudWatch Logs: Enabled (create new log group)
```

#### Config Setup
```bash
# Enable Config in Security Account
1. Go to AWS Config console
2. Click "Get started"
3. Resource types: All resources
4. S3 bucket: Create new "tesda-config-[random]"
5. SNS topic: Create new "tesda-config-notifications"
6. Service role: Create new role

# Essential Config Rules to Enable:
- iam-user-mfa-enabled
- root-access-key-check
- s3-bucket-public-read-prohibited
- s3-bucket-public-write-prohibited
- encrypted-volumes
```

#### Budget Alerts
```bash
# Create Budgets for Each Account
Budget 1 - Management Account:
- Name: "TESDA-Management-Monthly"
- Amount: $100 USD
- Alerts: 80%, 90%, 100%
- Email: your-email@company.com

Budget 2 - Demo Accounts:
- Name: "TESDA-Demo-Monthly" 
- Amount: $50 USD
- Alerts: 80%, 90%, 100%
- Email: your-email@company.com
```

---

### 🧪 Participant Sandbox Setup (Optional)

#### Sandbox Account Template
```bash
# For each participant account:
Account Setup:
- Unique email: participant-N@[domain].com
- Account name: "TESDA-Sandbox-[N]"
- Administrative IAM user for participant
- Billing alerts at $10, $25, $50

# Apply Restrictive SCPs:
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "RestrictRegions",
      "Effect": "Deny",
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "StringNotEquals": {
          "aws:RequestedRegion": [
            "ap-southeast-1",
            "ap-southeast-2"
          ]
        }
      }
    },
    {
      "Sid": "RestrictExpensiveServices",
      "Effect": "Deny",
      "Action": [
        "redshift:*",
        "sagemaker:*",
        "emr:*",
        "databrew:*",
        "es:*",
        "elasticache:*"
      ],
      "Resource": "*"
    }
  ]
}
```

#### Automated Cleanup Lambda
```python
# Lambda function to clean up unused resources
import boto3
import json

def lambda_handler(event, context):
    ec2 = boto3.client('ec2')
    
    # Stop running instances older than 4 hours
    instances = ec2.describe_instances(
        Filters=[
            {'Name': 'instance-state-name', 'Values': ['running']},
            {'Name': 'launch-time', 'Values': ['< 4 hours ago']}
        ]
    )
    
    for reservation in instances['Reservations']:
        for instance in reservation['Instances']:
            ec2.stop_instances(InstanceIds=[instance['InstanceId']])
    
    return {
        'statusCode': 200,
        'body': json.dumps('Cleanup completed')
    }
```

---

### ✅ Pre-Presentation Testing Checklist

#### 1 Week Before:
- [ ] All AWS accounts created and accessible
- [ ] Organizations structure complete
- [ ] Identity Center fully configured
- [ ] All demo users can log in successfully
- [ ] MFA setup tested with multiple devices
- [ ] All policies created and tested
- [ ] Cross-account roles working
- [ ] Budget alerts configured and tested

#### 3 Days Before:
- [ ] Complete end-to-end lab walkthrough
- [ ] All screenshots current and accurate
- [ ] Backup materials prepared
- [ ] Participant credentials generated
- [ ] Technical assistants briefed
- [ ] Equipment tested at venue

#### Day Of:
- [ ] All accounts accessible
- [ ] Internet connectivity confirmed
- [ ] Demo flows tested
- [ ] Participant materials distributed
- [ ] Emergency contacts available

**Your AWS environment is now ready for a successful TESDA presentation!**
