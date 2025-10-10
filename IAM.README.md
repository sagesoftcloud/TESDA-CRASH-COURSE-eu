
# AWS IAM Hands-On Session - Cross-Account Access
**Date:**  
**Focus:** Multi-Account IAM Architecture with Cross-Account Role Assumption

## Architecture Overview
This session implements a two-account setup:
- **Development Account**: Contains developers and initial resources
- **Production Account**: Contains production resources accessed via cross-account roles

<img width="1441" height="711" alt="image" src="https://github.com/user-attachments/assets/48d4f555-a471-4154-9bf4-ee7fb672cb36" />


## Prerequisites
- Two AWS accounts (Development and Production)
- Administrative access to both accounts
- AWS Management Console access

## Session Objectives
1. Set up IAM users in Development account
2. Create cross-account roles in Production account
3. Configure trust relationships for secure access
4. Test cross-account role assumption
5. Implement least privilege access patterns

---

## Part 1: Development Account Setup

### Step 1: Create IAM Users
1. **Navigate to IAM Console**
   - Sign in to Development Account
   - Go to Services → IAM → Users

2. **Create Developer Users**
   - Click "Add users"
   - Username: `dev-user-1`
   - Access type: ☑️ AWS Management Console access
   - Console password: Custom password
   - ☑️ Require password reset
   - Click "Next: Permissions"

3. **Attach Policies**
   - Select "Attach existing policies directly"
   - Search and select: `PowerUserAccess`
   - Click "Next: Tags" → "Next: Review" → "Create user"

4. **Repeat for Additional Users**
   - Create `dev-user-2` and `dev-user-3` with same permissions

### Step 2: Create Cross-Account Assume Role Policy
1. **Navigate to Policies**
   - IAM Console → Policies → Create policy

2. **JSON Policy Editor**
   - Click "JSON" tab
   - Paste policy from `dev-assume-role-policy.json`

3. **Review and Create**
   - Name: `AssumeProductionRoles`
   - Description: `Allows assuming roles in Production account`
   - Click "Create policy"

### Step 3: Create IAM Group
1. **Navigate to Groups**
   - IAM Console → User groups → Create group

2. **Group Configuration**
   - Group name: `DevelopmentTeam`
   - Attach policies:
     - `PowerUserAccess`
     - `AssumeProductionRoles`

3. **Add Users to Group**
   - Select all created dev users
   - Click "Create group"

---

## Part 2: Production Account Setup

### Step 1: Create Cross-Account Roles

#### Production Read-Only Role
1. **Navigate to Roles**
   - Sign in to Production Account
   - IAM Console → Roles → Create role

2. **Select Trusted Entity**
   - Choose "AWS account"
   - Account ID: `[DEVELOPMENT-ACCOUNT-ID]`
   - ☑️ Require external ID: `prod-readonly-2025`
   - Click "Next"

3. **Attach Permissions**
   - Search and select: `ReadOnlyAccess`
   - Click "Next"

4. **Role Details**
   - Role name: `ProductionReadOnlyRole`
   - Description: `Read-only access to Production resources`
   - Click "Create role"

#### Production Admin Role
1. **Create Second Role**
   - Repeat steps above with:
   - Account ID: `[DEVELOPMENT-ACCOUNT-ID]`
   - External ID: `prod-admin-2025`
   - Permissions: `PowerUserAccess`
   - Role name: `ProductionAdminRole`

### Step 2: Create Custom Resource Policies
1. **S3 Bucket Policy**
   - Navigate to S3 → Select bucket → Permissions
   - Bucket policy: Use `s3-cross-account-policy.json`

2. **EC2 Resource Tags**
   - Navigate to EC2 → Instances
   - Add tags for role-based access control

---

## Part 3: Testing Cross-Account Access

### Step 1: Assume Role via Console
1. **Switch Role**
   - Sign in as `dev-user-1` in Development account
   - Click account dropdown → "Switch Role"

2. **Role Information**
   - Account: `[PRODUCTION-ACCOUNT-ID]`
   - Role: `ProductionReadOnlyRole`
   - Display Name: `Prod-ReadOnly`
   - Color: Blue

3. **Verify Access**
   - Navigate to S3, EC2, RDS
   - Confirm read-only permissions
   - Test write operations (should fail)

### Step 2: Test Admin Role
1. **Switch to Admin Role**
   - Switch Role → `ProductionAdminRole`
   - Display Name: `Prod-Admin`
   - Color: Red

2. **Verify Permissions**
   - Test resource creation
   - Verify elevated access

---

## Part 4: Security Best Practices

### Step 1: Enable CloudTrail
1. **Development Account**
   - CloudTrail → Create trail
   - Trail name: `dev-account-audit`
   - S3 bucket: Create new bucket
   - ☑️ Log file SSE-KMS encryption

2. **Production Account**
   - Repeat with trail name: `prod-account-audit`

### Step 2: Configure MFA
1. **For Admin Role**
   - Edit `ProductionAdminRole`
   - Add condition for MFA in trust policy
   - Use `mfa-trust-policy.json`

### Step 3: Set Up Access Analyzer
1. **Enable in Both Accounts**
   - IAM Console → Access Analyzer
   - Create analyzer
   - Review findings and recommendations

---

## Part 5: Monitoring and Compliance

### Step 1: CloudWatch Monitoring
1. **Create Custom Metrics**
   - Monitor role assumption events
   - Set up alarms for unusual activity

2. **Dashboard Creation**
   - Create IAM activity dashboard
   - Include cross-account access metrics

### Step 2: AWS Config Rules
1. **Enable Config**
   - Both accounts
   - Monitor IAM compliance

2. **Custom Rules**
   - MFA enforcement
   - Role usage patterns

---

## Cleanup Instructions

### Development Account
1. Remove users from groups
2. Delete IAM users
3. Delete custom policies
4. Delete user groups

### Production Account
1. Delete cross-account roles
2. Remove bucket policies
3. Delete CloudTrail trails
4. Disable Config rules

---

## Key Takeaways
- Cross-account roles provide secure access without permanent credentials
- External IDs add additional security layer
- Least privilege principle enforced through role separation
- Monitoring and auditing essential for security
- MFA requirements enhance security posture

## Next Steps
- Implement automated role rotation
- Set up AWS Organizations for centralized management
- Configure AWS SSO for enhanced user experience
- Implement Infrastructure as Code using CloudFormation
