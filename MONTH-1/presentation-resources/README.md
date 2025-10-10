# Presentation Resources & Preparation Guide
## AWS Cloud Fundamentals for TESDA - 3-Hour Session

### 🎯 Overview
This guide details all resources, AWS services, accounts, and materials needed to deliver the TESDA AWS Cloud Fundamentals presentation successfully.

## 📋 Pre-Presentation Checklist (1 Week Before)

### AWS Account Setup
- [ ] **Primary Demo Account** - Clean AWS account for live demonstrations
- [ ] **Backup Demo Account** - Secondary account in case of issues
- [ ] **Participant Sandbox Accounts** - Individual accounts for hands-on labs (optional)
- [ ] **Billing Alerts** configured on all demo accounts
- [ ] **Root account MFA** enabled on all accounts

### Technical Infrastructure
- [ ] **Stable internet connection** (minimum 50 Mbps for screen sharing)
- [ ] **Backup internet** (mobile hotspot or secondary connection)
- [ ] **Projector/screen** tested with laptop
- [ ] **Audio system** tested for room size
- [ ] **Extension cords** and adapters available

### Materials Preparation
- [ ] **Printed handouts** for each participant
- [ ] **USB drives** with offline materials (backup)
- [ ] **Participant feedback forms**
- [ ] **Contact cards** with your information

---

## 📚 Module-by-Module Resource Requirements

### Module 1: AWS Organizations & Multi-Account Strategy (25 min)
**No hands-on lab - Presentation only**

#### AWS Services Needed:
- **AWS Organizations** (for demonstration screenshots)
- **AWS Billing Console** (for consolidated billing examples)

#### Preparation Required:
```
✅ Screenshots of:
   - Organizations console main page
   - Account creation process
   - OU structure examples
   - Consolidated billing dashboard
   - Service Control Policy examples

✅ Demo Materials:
   - TESDA organizational chart
   - Sample account naming conventions
   - Cost allocation examples with peso amounts
```

#### Backup Materials:
- Offline slides with all screenshots
- Printed organizational structure diagrams
- Cost comparison charts

---

### Module 2: Account Setup & Billing (20 min)
**Demonstration-heavy module**

#### AWS Services Needed:
- **AWS Organizations** (enabled and configured)
- **AWS Billing and Cost Management**
- **AWS CloudTrail** (for security demonstration)
- **AWS Config** (for compliance examples)

#### Pre-Setup Required:
```
✅ Primary Demo Account:
   - Organizations enabled with "All Features"
   - At least 2-3 sample OUs created
   - 1-2 member accounts created
   - Consolidated billing active
   - Sample budget alerts configured

✅ Screenshots/Recordings:
   - Step-by-step account creation process
   - MFA setup process
   - OU creation and management
   - Budget alert configuration
   - CloudTrail setup process
```

#### Demo Script Preparation:
- Practice account creation flow (5+ times)
- Prepare unique email addresses for demos
- Test MFA setup with authenticator app
- Verify all console navigation paths

---

### Module 3: Hands-On Lab - Multi-Account Setup (15 min)
**Interactive lab requiring participant access**

#### AWS Services Needed:
- **AWS Organizations** (participants will enable)
- **AWS IAM** (for basic policy creation)

#### Participant Account Options:

**Option A: Individual Sandbox Accounts (Recommended)**
```
✅ Setup Requirements:
   - 1 AWS account per participant (or per pair)
   - Accounts pre-configured with:
     * Administrative access for participants
     * Billing alerts set to low thresholds
     * Basic cost controls enabled
   - Unique email addresses prepared
   - Account credentials distributed securely

✅ Cost Control:
   - Service Control Policies to prevent expensive services
   - Budget alerts at ₱1,000, ₱2,000, ₱5,000
   - Auto-shutdown policies for unused resources
```

**Option B: Shared Demo Account (Alternative)**
```
✅ Setup Requirements:
   - 1 shared AWS account with multiple IAM users
   - Each participant gets individual IAM user
   - Limited permissions for lab exercises only
   - Screen sharing for those without access

✅ Limitations:
   - Not all participants can do hands-on simultaneously
   - Less realistic experience
   - Requires more instructor support
```

#### Lab Materials Needed:
- **Printed lab guides** with step-by-step instructions
- **Account information sheets** with login details
- **Troubleshooting guide** for common issues
- **Sample JSON policies** for copy/paste

#### Technical Support:
- **2-3 technical assistants** to help participants
- **Backup laptops** for participants without computers
- **Mobile hotspot** for connectivity issues

---

### Module 4: IAM Advanced Concepts (25 min)
**Demonstration-heavy with examples**

#### AWS Services Needed:
- **AWS IAM** (fully configured)
- **AWS Access Analyzer** (enabled)
- **AWS STS** (for role assumption demos)

#### Pre-Setup Required:
```
✅ IAM Configuration:
   - Sample users with different permission levels
   - Various policy types (AWS managed, customer managed, inline)
   - Permission boundaries examples
   - Cross-account roles configured
   - Access Analyzer enabled and configured

✅ Demo Scenarios:
   - User vs Role comparison examples
   - Policy variable demonstrations
   - Condition key examples with real IP addresses
   - Cross-account access flow
```

#### Code Examples Prepared:
```json
// Sample policies ready for demonstration
- MFA enforcement policy
- IP address restriction policy
- Time-based access policy
- Resource-specific access policy
- Permission boundary example
```

---

### Module 5: AWS IAM Identity Center (25 min)
**Complex setup requiring advance preparation**

#### AWS Services Needed:
- **AWS IAM Identity Center** (enabled in demo account)
- **AWS Organizations** (prerequisite)
- **Active Directory simulation** (or actual AD connection)

#### Pre-Setup Required:
```
✅ Identity Center Configuration:
   - Identity Center enabled in management account
   - Identity source configured (built-in directory for demo)
   - Sample permission sets created:
     * TESDA-SuperAdmin
     * TESDA-ITAdmin
     * TESDA-Developer
     * TESDA-ReadOnly
     * TESDA-LMS-Manager
   - Sample users and groups created
   - Account assignments configured
   - MFA requirements set up

✅ Demo Users:
   - maria.santos@tesda-demo.com (Curriculum Developer)
   - john.delacruz@tesda-demo.com (IT Manager)
   - admin@tesda-demo.com (Super Admin)
   - Each with different permission sets assigned
```

#### Integration Demonstration:
- **Mock Active Directory** setup or screenshots
- **SAML federation** examples
- **User provisioning** workflow demonstration
- **Access portal** screenshots and navigation

---

### Module 6: IAM Lab - MFA Enforcement (10 min)
**Hands-on lab requiring participant access**

#### AWS Services Needed:
- **AWS IAM** (for user and policy creation)
- **AWS STS** (for MFA token validation)

#### Participant Requirements:
```
✅ Each participant needs:
   - AWS account access (same as Module 3)
   - Mobile phone with authenticator app
   - Google Authenticator or Microsoft Authenticator installed
   - Basic familiarity with IAM console

✅ Pre-prepared Materials:
   - MFA enforcement policy JSON (printed and digital)
   - Step-by-step lab guide with screenshots
   - Troubleshooting guide for MFA setup issues
   - QR code backup options for scanning problems
```

#### Technical Preparation:
- **Test MFA setup** with multiple authenticator apps
- **Prepare backup authentication methods**
- **Have technical assistants** ready to help with phone setup
- **Screenshot all steps** for visual guidance

---

### Module 7: Security Architecture Principles (15 min)
**Presentation-only module**

#### AWS Services for Examples:
- **AWS VPC** (for network security examples)
- **AWS CloudTrail** (for audit trail examples)
- **AWS Config** (for compliance examples)
- **AWS Security Hub** (for security posture examples)

#### Visual Materials Needed:
```
✅ Diagrams and Charts:
   - Defense in Depth layered security diagram
   - Zero Trust architecture comparison
   - TESDA-specific security architecture
   - Compliance framework flowchart
   - Government security requirements checklist
```

#### No hands-on setup required - focus on high-quality visuals and examples.

---

### Module 8: TESDA Requirements Analysis (20 min)
**Interactive discussion module**

#### Materials Needed:
```
✅ Interactive Tools:
   - Whiteboard or flip chart paper
   - Colored markers
   - Sticky notes for brainstorming
   - Printed requirement templates
   - TESDA organizational chart (if available)

✅ Reference Materials:
   - Current TESDA system inventory (research beforehand)
   - Government compliance requirements
   - Sample architecture patterns
   - Cost estimation worksheets
```

#### No AWS services required - focus on facilitation materials.

---

### Module 9: Architecture Workshop (25 min)
**Collaborative design session**

#### Materials Needed:
```
✅ Design Materials:
   - AWS architecture icon stickers/templates
   - Large format paper (A3 or flip chart)
   - Colored pens and markers
   - Ruler and drawing tools
   - Architecture template printouts

✅ Reference Materials:
   - AWS Well-Architected Framework summary
   - Government compliance checklist
   - Cost optimization guidelines
   - Security best practices reference
```

#### Digital Tools (Optional):
- **Lucidchart** or **Draw.io** accounts for digital design
- **Tablets** with stylus for digital drawing
- **Projector** for sharing digital designs

---

## 💰 Cost Estimation & Budget Planning

### AWS Service Costs (Per Demo Account)
```
Estimated Monthly Costs:
- AWS Organizations: Free
- IAM Identity Center: Free (up to 5 users)
- Basic IAM usage: Free
- CloudTrail: ~$2-5/month
- Config: ~$10-20/month
- Small EC2 instances for demos: ~$20-50/month
- S3 storage for examples: ~$1-5/month

Total per demo account: ~$35-80/month
```

### Participant Sandbox Costs (If Provided)
```
Per participant account (with controls):
- Basic services usage: ~$5-15/month
- With proper SCPs and budgets: Risk limited to $50/account
- For 20 participants: ~$100-300/month maximum
```

### Cost Control Measures:
```
✅ Service Control Policies:
   - Block expensive services (Redshift, SageMaker, etc.)
   - Limit instance types to t3.micro and t3.small
   - Restrict regions to Asia Pacific only
   - Prevent Reserved Instance purchases

✅ Budget Alerts:
   - $10 warning alert
   - $25 urgent alert  
   - $50 maximum spending alert
   - Daily spending notifications

✅ Automated Cleanup:
   - Lambda functions to stop unused instances
   - Lifecycle policies for S3 cleanup
   - Automated resource tagging for tracking
```

---

## 🛠️ Technical Setup Timeline

### 1 Week Before Presentation:
- [ ] Set up all AWS demo accounts
- [ ] Configure Organizations and Identity Center
- [ ] Create all demo users and policies
- [ ] Test all lab exercises end-to-end
- [ ] Prepare all screenshots and backup materials

### 3 Days Before:
- [ ] Final test of all demos and labs
- [ ] Print all participant materials
- [ ] Prepare participant account credentials
- [ ] Test presentation equipment
- [ ] Confirm internet connectivity at venue

### Day of Presentation:
- [ ] Arrive 1 hour early for setup
- [ ] Test all equipment and connectivity
- [ ] Verify all AWS accounts are accessible
- [ ] Distribute participant materials
- [ ] Brief any technical assistants

---

## 📞 Emergency Contacts & Support

### AWS Support:
- **Account Issues:** AWS Support (if you have support plan)
- **Technical Questions:** AWS Documentation and forums
- **Billing Issues:** AWS Billing Support

### Backup Plans:
- **Internet Failure:** Offline slides and printed materials
- **AWS Console Issues:** Pre-recorded demos and screenshots
- **Participant Access Issues:** Shared screen demonstrations
- **Technical Problems:** Have technical assistants ready

---

## 📋 Final Checklist

### Materials Ready:
- [ ] All AWS accounts configured and tested
- [ ] Participant handouts printed and organized
- [ ] Technical equipment tested and working
- [ ] Backup materials prepared
- [ ] Emergency contacts available

### Presentation Ready:
- [ ] All demos practiced and working
- [ ] Screenshots current and accurate
- [ ] Lab guides tested with real participants
- [ ] Timing verified for each module
- [ ] Q&A responses prepared

### Support Ready:
- [ ] Technical assistants briefed
- [ ] Troubleshooting guides available
- [ ] Backup equipment available
- [ ] Emergency procedures documented

**You're ready to deliver an exceptional TESDA AWS training experience!**
