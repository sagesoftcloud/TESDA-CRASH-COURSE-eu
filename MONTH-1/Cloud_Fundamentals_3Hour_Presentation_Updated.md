# AWS Account Setup & IAM Deep Dive (SSO Implementation)
## 3-Hour Intensive Session

---

## Slide 1: Welcome & Session Overview

### AWS Account Setup & IAM Deep Dive (SSO Implementation)
**3-Hour Intensive Session**

- **Duration:** 3 Hours
- **Target:** TESDA Participants (Cloud Practitioner Level)
- **Focus:** Multi-Account Strategy & Identity Management
- **Outcome:** TESDA's Secure Architecture Foundation

**Today's Goal:** Master AWS account organization and identity management for enterprise-scale deployment

---

## Slide 2: Session Timeline

### 3-Hour Schedule

**Hour 1: AWS Account Foundation (60 min)**
- AWS Organizations & Multi-Account Strategy (25 min)
- Account Setup & Billing Consolidation (20 min)
- Lab: Multi-account organization setup (15 min)

**Hour 2: IAM Deep Dive & SSO (60 min)**
- IAM Advanced Concepts & Best Practices (25 min)
- AWS IAM Identity Center Implementation & Configuration (25 min)
- Hands-on: User/role creation, MFA enforcement (10 min)

**Hour 3: TESDA Architecture Design (60 min)**
- Security Architecture Principles (15 min)
- TESDA Requirements Analysis (20 min)
- Project Start: Design TESDA's selected system architecture (25 min)

---

## Slide 3: AWS Organizations & Multi-Account Strategy (25 min)

### What is AWS Organizations? (For Beginners)

**Simple Definition:**
AWS Organizations is like having a "master control panel" for multiple AWS accounts. Think of it as managing multiple bank accounts from one central dashboard.

**Why Do We Need Multiple AWS Accounts?**
- **Separation:** Keep production systems separate from testing
- **Security:** If one account gets compromised, others remain safe
- **Cost Control:** Track spending per department/project
- **Compliance:** Meet government requirements for data isolation

**AWS Organizations Benefits:**
- **Centralized Billing:** One bill for all accounts (like family phone plan)
- **Service Control Policies (SCPs):** Set rules for what each account can do
- **Account Isolation:** Each account is completely separate
- **Resource Sharing:** Share common services across accounts

**Real-World Example for TESDA:**
```
TESDA Main Organization
├── Security Account (All logs and monitoring)
├── Production Account (Live LMS for students)
├── Staging Account (Testing new features)
├── Development Account (Developers work here)
└── Shared Services Account (Common tools like DNS)
```

**Key Concepts Explained:**
- **Root Account:** The main account that controls everything
- **Member Accounts:** Individual accounts for different purposes
- **Organizational Units (OUs):** Groups of accounts (like folders)

---

## Slide 4: Account Setup & Billing Consolidation (20 min)

### Step-by-Step Account Management (Beginner-Friendly)

**What is an AWS Account?**
An AWS account is like your personal workspace in the cloud. Each account has its own resources, users, and billing.

**Account Creation Process (Detailed Steps):**
1. **Root Account Setup:**
   - Use a company email (not personal)
   - Create a strong password (12+ characters)
   - This account has "super admin" powers

2. **Enable MFA Immediately:**
   - MFA = Multi-Factor Authentication
   - Like having two locks on your door
   - Use Google Authenticator or similar app

3. **Create Organizational Units (OUs):**
   - Think of OUs as folders for organizing accounts
   - Example: "Production-OU", "Development-OU"

4. **Create/Invite Member Accounts:**
   - Each department gets their own account
   - Accounts are isolated from each other

5. **Configure Consolidated Billing:**
   - All accounts share one payment method
   - Get volume discounts across all accounts

**Billing Best Practices Explained:**
- **Cost Allocation Tags:** Label resources by department/project
- **Budget Alerts:** Get notified before overspending
- **Reserved Instance Sharing:** Save money on long-term usage
- **Detailed Billing Reports:** See exactly where money is spent

**Security Controls (What They Do):**
- **Service Control Policies (SCPs):** Rules that prevent dangerous actions
- **Cross-Account Roles:** Safe way to access other accounts
- **CloudTrail:** Records every action taken (audit log)
- **Config Rules:** Automatically check if settings are correct

---

## Slide 5: Lab: Multi-Account Organization Setup (15 min)

### Hands-On Exercise (Step-by-Step Guide)

**What We'll Build Together:**
A complete multi-account structure for TESDA that you can use in real projects.

**Lab Objectives (What You'll Learn):**
1. **Create AWS Organization** - Set up the master control panel
2. **Set up OUs for TESDA** - Create organized folders for accounts
3. **Create Member Accounts** - Add accounts for different purposes
4. **Configure Basic SCPs** - Set up safety rules
5. **Enable Consolidated Billing** - Combine all bills into one

**TESDA Structure We'll Create:**
```
TESDA-Root (Main Organization)
├── Core-OU (Essential Services)
│   ├── Security-Account (All security tools)
│   └── Shared-Services-Account (Common resources)
├── Production-OU (Live Systems)
│   ├── LMS-Production (Student learning platform)
│   └── Assessment-Production (Testing and certification)
└── Non-Production-OU (Development & Testing)
    ├── Development-Account (Developers work here)
    └── Testing-Account (Test new features safely)
```

**During This Lab You Will:**
- Navigate the AWS Organizations console
- Create your first organizational unit
- Understand account isolation
- See how billing consolidation works
- Apply basic security policies

**Real-World Application:**
This structure can be used for any educational institution or government agency needing secure, organized cloud infrastructure.

---

## Slide 6: IAM Advanced Concepts & Best Practices (25 min)

### Understanding Identity and Access Management (IAM) - Simplified

**What is IAM? (Simple Explanation)**
IAM is like a security system for your office building. It controls:
- **Who** can enter (authentication)
- **What** they can do once inside (authorization)
- **When** they can access resources (conditions)

**IAM Components Explained for Beginners:**

**1. Users vs Roles - When to Use Each:**
- **IAM Users:** Real people who need long-term access
  - Example: John from IT department
  - Has permanent credentials (username/password)
- **IAM Roles:** Temporary access for services or short-term needs
  - Example: EC2 server needs to access S3 bucket
  - No permanent credentials, assumes role when needed

**2. Policy Types Made Simple:**
- **AWS Managed Policies:** Pre-built by AWS (like templates)
  - Example: "ReadOnlyAccess" - can view everything, change nothing
- **Customer Managed Policies:** Custom policies you create
  - Example: "TESDA-LMS-Access" - specific to your needs
- **Inline Policies:** Attached directly to one user/role
  - Use sparingly, harder to manage

**3. Permission Boundaries (Advanced Safety Net):**
- Sets maximum permissions a user can have
- Like a speed limit - even if you have a fast car, you can't exceed it
- Useful for delegating admin tasks safely

**4. Access Analyzer (Your Security Assistant):**
- Finds unused permissions
- Identifies overly broad access
- Suggests improvements

**Advanced IAM Features Explained:**

**Condition Keys (Smart Access Control):**
```json
"Condition": {
    "IpAddress": {
        "aws:SourceIp": "203.0.113.0/24"
    },
    "DateGreaterThan": {
        "aws:CurrentTime": "2024-01-01T00:00:00Z"
    }
}
```
Translation: "Only allow access from office IP address and only after January 1, 2024"

**Policy Variables (Dynamic Permissions):**
```json
"Resource": "arn:aws:s3:::tesda-bucket/${aws:username}/*"
```
Translation: "Each user can only access their own folder in the bucket"

**Security Best Practices for TESDA:**
- **Principle of Least Privilege:** Give minimum access needed
- **Regular Access Reviews:** Check who has access quarterly
- **Automated Compliance:** Use tools to check policy compliance
- **Centralized Identity:** Connect to existing Active Directory

---

## Slide 7: AWS IAM Identity Center Implementation & Configuration (25 min)

### Single Sign-On Made Simple for TESDA

**What is Single Sign-On (SSO)?**
Imagine having one key that opens all doors in your building. SSO is like that - one login for all AWS accounts and applications.

**Why Does TESDA Need SSO?**
- **User Convenience:** Staff login once, access everything
- **Better Security:** Centralized control of who has access
- **Easier Management:** Add/remove access from one place
- **Compliance:** Meet government audit requirements

**AWS IAM Identity Center Architecture (Visual Explanation):**
```
TESDA Active Directory (Your existing user database)
           ↓ (Connects to)
    AWS IAM Identity Center (The bridge)
           ↓ (Provides access to)
Multiple AWS Accounts (All your cloud resources)
```

**Step-by-Step Implementation for TESDA:**

**Step 1: Enable AWS IAM Identity Center**
- Go to AWS Console → Search "IAM Identity Center"
- Click "Enable" (only done once in management account)
- Choose your region (recommend Asia Pacific - Singapore)

**Step 2: Configure Identity Source**
- **Option A:** Use Identity Center's built-in directory (simple start)
- **Option B:** Connect to TESDA's existing Active Directory (recommended)
- **Option C:** Connect to external provider (Google, Microsoft)

**Step 3: Create Permission Sets (Role Templates)**
Permission sets are like job descriptions that define what people can do:

**TESDA Permission Sets Examples:**
- **TESDA-Administrator:**
  - Full access to all AWS services
  - For IT managers and senior staff
  
- **TESDA-Developer:**
  - Access to EC2, S3, RDS, Lambda
  - Can create and modify applications
  - Cannot delete production resources
  
- **TESDA-ReadOnly:**
  - View-only access to all resources
  - For auditors and reporting staff
  
- **TESDA-LMS-Manager:**
  - Full access to LMS-related resources
  - Limited access to other systems

**Step 4: Assign Users/Groups to Accounts**
- Create groups based on TESDA departments
- Assign permission sets to groups
- Users inherit permissions from their groups

**Step 5: Configure MFA Requirements**
- Require MFA for all users
- Support multiple MFA methods
- Set up emergency access procedures

**TESDA Integration Benefits:**
- **Existing AD Integration:** Use current usernames/passwords
- **Department-Based Access:** Automatic access based on job role
- **Audit Logging:** Track who accessed what and when
- **Compliance Ready:** Meets government security requirements

**Real-World Scenario:**
When Maria from the Curriculum Development team logs in:
1. She enters her TESDA username/password
2. Identity Center checks her department and role
3. She automatically gets access to development accounts
4. She cannot access production systems (safety)
5. All her actions are logged for compliance

---

## Slide 8: Hands-On: User/Role Creation & MFA Enforcement (10 min)

### Practical IAM Configuration (Guided Exercise)

**What We'll Do Together:**
Create a complete security setup that TESDA can use immediately.

**Exercise 1: Create IAM Users with MFA (Step-by-Step)**

**Why MFA is Critical:**
- Password alone = 1 factor (something you know)
- MFA = Password + Phone/App = 2 factors (something you know + something you have)
- Reduces security breaches by 99.9%

**Steps We'll Follow:**
1. **Create a Test User:**
   - Go to IAM Console → Users → Create User
   - Username: "tesda-test-user"
   - Enable console access
   - Create temporary password

2. **Set Up Virtual MFA Device:**
   - User logs in with temporary password
   - Goes to Security Credentials tab
   - Clicks "Assign MFA Device"
   - Scans QR code with Google Authenticator
   - Enters two consecutive codes

3. **Test MFA Login:**
   - User logs out and back in
   - Must enter MFA code to access console

**Exercise 2: Role Creation and Assumption**

**What are Roles? (Simple Explanation)**
Roles are like temporary badges. Instead of giving permanent access, you "assume" a role when needed.

**Practical Examples:**
- **EC2 Instance Role:** Server needs to read from S3 bucket
- **Cross-Account Role:** Developer in Dev account needs to check Production logs
- **Lambda Execution Role:** Function needs to write to database

**We'll Create:**
1. **TESDA-EC2-S3-Role:** Allows EC2 to access S3
2. **TESDA-CrossAccount-ReadOnly:** Safe access between accounts

**Exercise 3: MFA Enforcement Policy Implementation**

**The Challenge:**
How do we force ALL users to use MFA without locking them out?

**Our Solution - Smart Policy:**
The policy we'll implement does this:
- ✅ Allows users to log in without MFA initially
- ✅ Allows users to set up their MFA device
- ❌ Blocks all other actions until MFA is configured
- ✅ Full access once MFA is active

**Policy Walkthrough (We'll Explain Each Part):**
```json
{
    "Version": "2012-10-17",
    "Statement": [
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
                "iam:ChangePassword"
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

**What This Policy Means in Plain English:**
"If you haven't used MFA to log in, you can ONLY set up MFA or change your password. Everything else is blocked."

**Implementation Steps We'll Practice:**
1. Create the policy in IAM
2. Attach it to a test group
3. Test with our test user
4. Verify MFA enforcement works
5. Confirm full access after MFA setup

**Real-World Application:**
This exact setup can be deployed in TESDA's production environment to ensure all staff use MFA.

### MFA Enforcement Policy - Force MFA for All Users

**Policy Name:** `Force-MFA-Policy`

```json
{
    "Statement": [
        {
            "Condition": {
                "BoolIfExists": {
                    "aws:MultiFactorAuthPresent": "false",
                    "aws:ViaAWSService": "false"
                }
            },
            "Effect": "Deny",
            "NotAction": [
                "iam:CreateVirtualMFADevice",
                "iam:DeleteVirtualMFADevice",
                "iam:ListVirtualMFADevices",
                "iam:EnableMFADevice",
                "iam:ResyncMFADevice",
                "iam:ListAccountAliases",
                "iam:ListUsers",
                "iam:ListSSHPublicKeys",
                "iam:ListAccessKeys",
                "iam:ListServiceSpecificCredentials",
                "iam:ListMFADevices",
                "iam:GetAccountSummary",
                "sts:GetSessionToken",
                "iam:GetAccountPasswordPolicy",
                "iam:ChangePassword"
            ],
            "Resource": "*",
            "Sid": "BlockMostAccessUnlessSignedInWithMFA"
        },
        {
            "Action": [
                "iam:CreateVirtualMFADevice"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:iam::*:mfa/*",
            "Sid": "AllowManageOwnVirtualMFADevice"
        },
        {
            "Action": [
                "iam:DeactivateMFADevice",
                "iam:EnableMFADevice",
                "iam:ListMFADevices",
                "iam:ResyncMFADevice"
            ],
            "Effect": "Allow",
            "Resource": "arn:aws:iam::*:user/${aws:username}",
            "Sid": "EnforceIAMMFA"
        }
    ],
    "Version": "2012-10-17"
}
```

### Implementation Steps via AWS Console

**Step 1: Create the MFA Policy**
1. Go to **IAM Console** → **Policies** → **Create Policy**
2. Click **JSON** tab
3. Copy and paste the Force-MFA-Policy JSON above
4. Click **Next: Tags** → **Next: Review**
5. Name: `Force-MFA-Policy`
6. Description: `Enforces MFA for all user actions`
7. Click **Create Policy**

**Step 2: Attach Policy to Users/Groups**
1. Go to **IAM Console** → **Groups** (recommended) or **Users**
2. Select target group (e.g., "AllUsers")
3. Click **Permissions** tab → **Attach Policies**
4. Search for `Force-MFA-Policy`
5. Select and click **Attach Policy**

**Step 3: User MFA Setup Process**
1. User logs into AWS Console (limited access)
2. User goes to **IAM** → **Users** → **[Username]** → **Security Credentials**
3. Click **Assign MFA Device**
4. Choose **Virtual MFA Device**
5. Scan QR code with authenticator app (Google Authenticator, Authy)
6. Enter two consecutive MFA codes
7. Click **Assign MFA**
8. User now has full access after MFA authentication

**Policy Explanation:**
- **Denies all actions** except MFA setup when MFA is not present
- **Allows MFA management** so users can set up their devices
- **Uses condition keys** to check MFA authentication status
- **Prevents bypass** through AWS service calls

---

## Slide 9: Security Architecture Principles (15 min)

### Building Secure Systems - TESDA's Foundation

**What is Security Architecture? (Simple Definition)**
Security architecture is like designing a secure building. You plan multiple layers of protection before you start building.

**Defense in Depth (Multiple Security Layers)**
Think of this like protecting a valuable treasure:

**Layer 1: Physical Security**
- Data centers with guards and biometric access
- AWS handles this for you

**Layer 2: Network Security**
- Virtual Private Cloud (VPC) - your private network in the cloud
- Security Groups - like firewalls for each server
- Network ACLs - additional network-level protection

**Layer 3: Identity Security**
- IAM users, roles, and policies
- Multi-factor authentication
- Regular access reviews

**Layer 4: Application Security**
- Secure coding practices
- Input validation
- Regular security updates

**Layer 5: Data Security**
- Encryption at rest (data stored on disk)
- Encryption in transit (data moving over network)
- Data backup and recovery

**Zero Trust Architecture (Never Trust, Always Verify)**

**Traditional Security Model:**
"If you're inside the network, you're trusted"
- Problem: Once hackers get in, they have access to everything

**Zero Trust Model:**
"Trust no one, verify everyone and everything"
- Every request is verified, even from inside the network
- Principle of least privilege - minimum access needed
- Continuous monitoring and validation

**Zero Trust in Practice for TESDA:**
- Staff must authenticate for each system
- Access is based on current job needs
- All actions are logged and monitored
- Regular verification of access rights

**Compliance Framework for Government Organizations**

**Why Compliance Matters for TESDA:**
- Legal requirement for government agencies
- Protects student and staff data
- Maintains public trust
- Enables secure partnerships

**Key Compliance Areas:**
- **Data Privacy:** Protect personal information
- **Audit Trails:** Record all system access and changes
- **Access Controls:** Ensure only authorized access
- **Incident Response:** Plan for security breaches

**TESDA-Specific Security Considerations:**

**1. Student Data Protection:**
- Personal information (names, addresses, contact details)
- Academic records and certifications
- Assessment results and progress tracking
- Employment and training history

**2. Multi-Tenant Architecture Security:**
- Different training centers using same system
- Isolation between different programs
- Secure data sharing when needed
- Separate billing and reporting

**3. Integration Security:**
- Secure connections to existing TESDA systems
- API security for third-party integrations
- Data synchronization security
- Legacy system protection

**4. Disaster Recovery Requirements:**
- Business continuity planning
- Data backup and restoration
- Alternative access methods
- Communication during outages

**Security Checklist for TESDA:**
- ✅ All data encrypted
- ✅ Regular security assessments
- ✅ Staff security training
- ✅ Incident response plan
- ✅ Regular backups tested
- ✅ Access reviews quarterly
- ✅ Security monitoring 24/7

---

## Slide 10: TESDA Requirements Analysis (20 min)

### Understanding TESDA's Needs

**Current State Assessment:**
- Existing identity management systems
- Current security posture and gaps
- Compliance and regulatory requirements
- Integration points and dependencies

**Target Architecture Goals:**
- Centralized identity management
- Scalable multi-account structure
- Enhanced security controls
- Cost-effective resource utilization

**Key Requirements:**
- **Learning Management System (LMS)**
- **Assessment and Certification Platform**
- **Student Information System**
- **Administrative Portals**
- **Reporting and Analytics**

**Technical Constraints:**
- Government network connectivity
- Data residency requirements
- Budget limitations
- Timeline considerations

---

## Slide 11: Project Start: Design TESDA's Architecture (25 min)

### Collaborative Design Workshop

**Design Challenge:**
Create a comprehensive AWS architecture for TESDA's digital transformation

**Architecture Components:**
1. **Multi-Account Structure:**
   - Production, staging, development separation
   - Security and shared services accounts
   - Department-specific account isolation

2. **Identity and Access Management:**
   - AWS IAM Identity Center with AD integration
   - Role-based access control
   - MFA enforcement across all accounts

3. **Core Services Architecture:**
   - Web application hosting (ECS/EKS)
   - Database services (RDS Multi-AZ)
   - File storage and CDN (S3/CloudFront)
   - Load balancing and auto-scaling

4. **Security and Compliance:**
   - VPC design with private subnets
   - WAF and DDoS protection
   - Encryption at rest and in transit
   - Comprehensive logging and monitoring

**Deliverables:**
- High-level architecture diagram
- Account structure definition
- IAM strategy document
- Security control matrix

---

## Slide 12: Architecture Design Groups

### Collaborative Workshop Format

**Group Formation:**
- 4-5 participants per group
- Mix of technical and functional expertise
- Assign group facilitators

**Design Areas:**
- **Group 1:** Account structure and governance
- **Group 2:** Identity management and SSO
- **Group 3:** Application architecture and services
- **Group 4:** Security and compliance controls

**Design Process:**
1. Requirements review (5 min)
2. Architecture design (15 min)
3. Documentation preparation (5 min)

**Tools Provided:**
- AWS architecture icons
- Template diagrams
- Best practice checklists

---

## Slide 13: Architecture Presentations & Review

### Solution Showcase

**Presentation Format:**
- 4 minutes per group
- Focus on key architectural decisions
- Highlight security and compliance features
- Explain cost and operational considerations

**Evaluation Criteria:**
- Alignment with TESDA requirements
- Security best practices implementation
- Scalability and reliability design
- Cost optimization strategies
- Operational excellence considerations

**Expert Feedback:**
- Architecture review and recommendations
- Alternative approaches discussion
- Risk assessment and mitigation
- Implementation roadmap suggestions

---

## Slide 14: Implementation Roadmap

### Next Steps for TESDA

**Phase 1: Foundation (Weeks 1-4)**
- AWS Organizations setup
- Multi-account structure creation
- AWS IAM Identity Center implementation
- Basic security controls deployment

**Phase 2: Core Services (Weeks 5-12)**
- VPC and networking setup
- Application infrastructure deployment
- Database and storage configuration
- Monitoring and logging implementation

**Phase 3: Applications (Weeks 13-24)**
- LMS platform migration/deployment
- Assessment system implementation
- Integration with existing systems
- User acceptance testing

**Phase 4: Optimization (Weeks 25-28)**
- Performance tuning
- Cost optimization
- Security hardening
- Documentation and training

---

## Slide 15: Security and Compliance Checklist

### Essential Controls for TESDA

**Identity and Access Management:**
- ✅ MFA enabled for all users
- ✅ Role-based access control implemented
- ✅ Regular access reviews scheduled
- ✅ Privileged access monitoring

**Data Protection:**
- ✅ Encryption at rest and in transit
- ✅ Data classification and handling procedures
- ✅ Backup and recovery processes
- ✅ Data retention policies

**Network Security:**
- ✅ VPC with private subnets
- ✅ Security groups and NACLs configured
- ✅ WAF and DDoS protection enabled
- ✅ Network monitoring and alerting

**Compliance and Auditing:**
- ✅ CloudTrail logging enabled
- ✅ Config rules for compliance checking
- ✅ Regular security assessments
- ✅ Incident response procedures

---

## Slide 16: Cost Management Strategy

### Optimizing TESDA's AWS Investment

**Cost Control Mechanisms:**
- **Budgets and Alerts:** Account-level spending limits
- **Reserved Instances:** Long-term capacity planning
- **Spot Instances:** Cost-effective compute for non-critical workloads
- **S3 Lifecycle Policies:** Automated storage optimization

**Monitoring and Optimization:**
- Cost Explorer for usage analysis
- Trusted Advisor recommendations
- Resource tagging for cost allocation
- Regular cost review meetings

**TESDA-Specific Considerations:**
- Government procurement processes
- Multi-year budget planning
- Cost allocation by department/program
- ROI measurement and reporting

---

## Slide 17: Q&A & Next Steps

### Wrapping Up and Moving Forward

**Key Takeaways:**
- Multi-account strategy provides security and governance
- AWS IAM Identity Center enables centralized identity management
- Security must be built into the foundation
- Proper planning reduces implementation risks

**Immediate Actions:**
1. Finalize TESDA architecture design
2. Create detailed implementation plan
3. Identify required AWS training
4. Establish project governance structure

**Support Available:**
- Architecture review sessions
- Implementation guidance
- Technical mentoring
- Best practices workshops

**Success Metrics:**
- Improved security posture
- Reduced operational overhead
- Enhanced user experience
- Cost optimization achievements

---

## Thank You!
### Building TESDA's Secure Cloud Foundation

**Remember:** Today's foundation in multi-account strategy and IAM will enable TESDA's successful digital transformation.

**Contact Information:**
- Email: solutions.architect@company.com
- Phone: +63-XXX-XXX-XXXX
- LinkedIn: linkedin.com/in/solutions-architect

**Let's transform TESDA with secure, scalable AWS architecture!**

---

## Appendix: Additional Resources

### Reference Materials

**AWS Documentation:**
- AWS Organizations User Guide
- AWS IAM Identity Center Administration Guide
- IAM Best Practices Guide
- Well-Architected Framework

**Training Resources:**
- AWS Skill Builder (free training)
- AWS Certified Solutions Architect path
- Security specialty certification
- Hands-on labs and workshops

**TESDA-Specific Resources:**
- Government cloud adoption framework
- Compliance and security guidelines
- Data privacy requirements
- Integration best practices
