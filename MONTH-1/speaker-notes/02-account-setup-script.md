# Module 2 Speaker Script: Account Setup & Billing Consolidation
**Duration:** 20 minutes  
**Style:** Practical, step-by-step, hands-on focused

## 🎯 Module Opening (1 minute)
**Script:**
"Excellent! Now that you understand WHY we need multiple accounts, let's learn HOW to set them up properly. This is where theory meets practice.

In the next 20 minutes, I'm going to walk you through the exact process TESDA would use to create a secure, well-organized multi-account structure. Everything I show you today can be implemented in your real environment."

**Delivery Notes:**
- Transition smoothly from previous module
- Emphasize the practical nature
- Build anticipation for hands-on learning

## 🔧 What is an AWS Account? (2 minutes)

**Script:**
"Before we dive into setup, let's make sure everyone understands what an AWS account actually is.

An AWS account is like your personal workspace in the cloud. Think of it like having your own office building - you have your own entrance, your own security system, your own resources, and your own bills.

Each account has a unique 12-digit number - kind of like a social security number for cloud resources. When you create resources in one account, they're completely invisible to other accounts unless you specifically allow sharing."

**Delivery Notes:**
- Use the office building analogy consistently
- Show the 12-digit account number on screen
- Emphasize the isolation aspect

## 📋 Step-by-Step Account Creation Process (8 minutes)

### Step 1: Root Account Setup
**Script:**
"Let's start with the most critical step - setting up your root account properly. This is like choosing the location and foundation for your entire building.

[Show slide] First, use a company email, not a personal one. I see this mistake all the time - someone uses john.doe@gmail.com and then John leaves the company. Suddenly, no one can access the root account!

For TESDA, use something like tesda-aws-root@tesda.gov.ph. This ensures institutional control.

Next, create a strong password. I'm talking 12+ characters with numbers, symbols, and mixed case. This account has 'super admin' powers - it can do anything, including close your entire organization. Treat it like the master key to your entire digital infrastructure."

**Delivery Notes:**
- Use a real example they can relate to
- Emphasize the consequences of poor choices
- Show urgency about security

### Step 2: Enable MFA Immediately
**Script:**
"Now, here's something I cannot stress enough - enable MFA immediately. Not tomorrow, not next week, right now.

MFA stands for Multi-Factor Authentication. Think of it like having two locks on your door. A password is something you know. MFA adds something you have - like your phone.

[Show statistics slide] Here's a sobering statistic: 99.9% of account compromises could be prevented with MFA. For a government agency handling student data, this isn't optional - it's essential.

I recommend Google Authenticator or Microsoft Authenticator. Both are free and work reliably."

**Delivery Notes:**
- Use strong, urgent language
- Show the 99.9% statistic prominently
- Mention government responsibility

### Step 3: Create Organizational Units
**Script:**
"Next, we create Organizational Units - or OUs. Think of these as folders for organizing your accounts.

[Show diagram] For TESDA, I recommend starting with this structure:
- Core-OU for essential services
- Production-OU for live systems
- Non-Production-OU for development and testing
- Sandbox-OU for learning and experimentation

The beauty of OUs is that you can apply policies to an entire folder at once. Want to restrict all development accounts from using expensive services? Apply one policy to the Non-Production-OU and it affects all accounts inside."

**Delivery Notes:**
- Point to each OU on the diagram
- Explain the folder analogy clearly
- Give concrete policy examples

### Step 4: Create/Invite Member Accounts
**Script:**
"Now we create the actual accounts. You have two options here:

Option 1: Create new accounts. AWS will create them for you and automatically add them to your organization.

Option 2: Invite existing accounts. If TESDA already has AWS accounts, you can invite them to join your organization.

[Show naming convention] Here's a critical best practice - use a consistent naming convention. I recommend:
- tesda-security-prod
- tesda-lms-prod  
- tesda-lms-dev
- tesda-shared-services

This makes it immediately clear what each account is for."

**Delivery Notes:**
- Explain both options clearly
- Emphasize the importance of naming conventions
- Show examples on screen

### Step 5: Configure Consolidated Billing
**Script:**
"Finally, we set up consolidated billing. This happens automatically when you create an organization, but let me explain what it means.

[Show billing diagram] Instead of getting five separate bills, you get one bill that shows usage from all accounts. Even better, you get volume discounts across all accounts.

For example, if Account A uses 100 hours of compute and Account B uses 200 hours, you get the discount rate for 300 hours total. This can save TESDA thousands of pesos per month."

**Delivery Notes:**
- Show the billing consolidation visually
- Use specific examples with peso amounts
- Emphasize cost savings

## 💰 Billing Best Practices (4 minutes)

### Cost Allocation Tags
**Script:**
"Let me share a powerful feature that most organizations don't use properly - cost allocation tags.

Tags are like labels you put on resources. [Show example] You might tag a server with:
- Department: Curriculum-Development
- Project: LMS-Upgrade  
- Environment: Production
- CostCenter: TESDA-IT-001

With proper tagging, you can answer questions like 'How much did the LMS upgrade cost?' or 'What's our monthly spending per department?' This is gold for budget planning and accountability."

**Delivery Notes:**
- Show real tag examples
- Explain the business value
- Connect to budget accountability

### Budget Alerts
**Script:**
"Here's another feature that can save you from nasty surprises - budget alerts.

[Show setup process] You can set up alerts that email you when spending reaches certain thresholds. I recommend:
- 80% of budget: Warning email
- 90% of budget: Urgent email to IT manager
- 100% of budget: Emergency email to finance director

This prevents the dreaded surprise bill at the end of the month."

**Delivery Notes:**
- Show the actual setup process
- Use specific percentage thresholds
- Emphasize prevention of surprises

### Reserved Instance Sharing
**Script:**
"For organizations with predictable workloads, Reserved Instances can save 30-60% on compute costs.

The beautiful thing about consolidated billing is that these discounts automatically apply across all accounts in your organization. Buy reserved capacity in one account, and it benefits all accounts. This is like buying in bulk and sharing the savings."

**Delivery Notes:**
- Mention specific savings percentages
- Use the bulk buying analogy
- Keep this brief - it's an advanced topic

## 🔒 Security Controls (4 minutes)

### Service Control Policies (SCPs)
**Script:**
"Now let's talk about Service Control Policies - your safety net against expensive mistakes.

[Show policy example] Here's a real policy I implemented for a government agency. It prevents anyone from closing AWS accounts accidentally. Imagine if someone clicked the wrong button and closed your production account - this policy makes that impossible.

You can create policies that:
- Prevent expensive services in development accounts
- Require all data to stay in specific regions
- Block certain actions during business hours
- Enforce encryption on all storage"

**Delivery Notes:**
- Show a real, simple policy example
- Use scary scenarios they can relate to
- List practical policy ideas

### Cross-Account Roles
**Script:**
"Cross-account roles solve a common problem: How do you give your security team access to monitor all accounts without giving them admin rights in each account?

[Show diagram] You create a role in each account that the security team can 'assume' when needed. It's like having a temporary badge that gives you access to specific areas when you need them, but expires when you're done."

**Delivery Notes:**
- Use the temporary badge analogy
- Show the role assumption process visually
- Emphasize the temporary nature

### CloudTrail and Config
**Script:**
"Finally, let me mention two services that are essential for government compliance:

CloudTrail records every action taken in your AWS accounts. Who did what, when, and from where. It's like a security camera system for your cloud infrastructure.

Config continuously monitors your resources and alerts you when something doesn't match your security standards. Think of it as an automated compliance officer."

**Delivery Notes:**
- Use security camera analogy for CloudTrail
- Use compliance officer analogy for Config
- Emphasize government compliance needs

## ✅ Key Takeaways & Transition (1 minute)

**Script:**
"Let me quickly summarize what we've covered:

First, proper account setup starts with strong security - company email, strong password, immediate MFA.

Second, good organization structure with OUs and naming conventions saves time and prevents mistakes.

Third, consolidated billing and proper tagging give you cost control and visibility.

Fourth, security controls like SCPs and CloudTrail are essential for government compliance.

Any questions before we put this into practice? [Pause for questions]

Perfect! Now let's actually build this structure together in our hands-on lab."

**Delivery Notes:**
- Speak clearly for the summary
- Pause genuinely for questions
- Build excitement for the lab
- Transition with energy

## 🎤 Delivery Tips for This Module

### Pacing
- **Minutes 0-3:** Quick setup and context
- **Minutes 3-11:** Detailed step-by-step process
- **Minutes 11-15:** Practical best practices
- **Minutes 15-19:** Security and compliance
- **Minutes 19-20:** Summary and transition

### Visual Aids
- **Show actual AWS console** screenshots
- **Use diagrams** for complex concepts
- **Highlight important** settings and options
- **Point to specific** buttons and fields

### Audience Engagement
- **Ask about current practices** - "How do you currently manage IT budgets?"
- **Check understanding** - "Does the tagging concept make sense?"
- **Relate to their experience** - "You probably do this with your current systems"
- **Encourage questions** - "Stop me if anything is unclear"

### Common Questions & Responses

**Q: "What if we already have AWS accounts?"**
**A:** "Great question! You can invite existing accounts to join your organization. We'll cover the exact process in the lab."

**Q: "How much does consolidated billing cost?"**
**A:** "Consolidated billing is completely free. In fact, it usually saves money through volume discounts."

**Q: "What happens if someone leaves and they set up the root account?"**
**A:** "This is exactly why we use institutional email addresses. If someone used personal email, you'd need to contact AWS support to transfer ownership."

**Q: "Can we change the account structure later?"**
**A:** "Yes, you can move accounts between OUs and create new OUs anytime. It's easier to start simple and grow than to reorganize later."

### Technical Preparation
- **Have screenshots ready** for each step
- **Prepare backup slides** in case of connectivity issues
- **Know the exact button names** and menu locations
- **Practice the demo flow** beforehand

### Energy Management
- **Start with urgency** about security
- **Maintain steady pace** through technical details
- **Build excitement** about cost savings
- **End with anticipation** for hands-on practice

---
**Next Module:** [Hands-On Lab Script](./03-hands-on-lab-script.md)
