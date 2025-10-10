# Module 6 Speaker Script: Hands-On Lab - User/Role Creation & MFA
**Duration:** 10 minutes  
**Style:** Fast-paced, hands-on, security-focused

## 🎯 Lab Introduction & Urgency (1 minute)
**Script:**
"Alright everyone, this is our most critical lab! We're going to implement bulletproof authentication that will make your AWS environment virtually unbreachable.

In just 10 minutes, we're going to:
- Create users with mandatory MFA
- Build cross-account access roles
- Implement a policy that forces everyone to use MFA
- Test everything to make sure it works

This isn't theoretical - this is production-ready security you can deploy immediately. Everyone ready to build something that will impress government auditors? Let's go!"

**Delivery Notes:**
- Speak with high energy and urgency
- Emphasize the production-ready nature
- Build excitement about impressing auditors
- Get verbal confirmation of readiness

## 🔐 Exercise 1: Create IAM User with MFA (3 minutes)

### Quick User Creation
**Script:**
"First, let's create a test user. Everyone follow along:

**Step 1:** Go to IAM Console - search 'IAM' and click the service.

**Step 2:** Click 'Users' in the left menu, then 'Create user.'

**Step 3:** Username: 'tesda-pilot-user' - T-E-S-D-A hyphen pilot hyphen user.

**Step 4:** Check 'Provide user access to AWS Management Console.'

**Step 5:** Select 'I want to create an IAM user' - not Identity Center for this demo.

**Step 6:** Set temporary password: 'TempPass123!' - write this down.

**Step 7:** Check 'User must create new password at next sign-in.'

**Step 8:** Click 'Next' and skip permissions for now. Click 'Create user.'

[Walk around checking progress] Everyone got their user created? Great!"

**Delivery Notes:**
- Spell out usernames clearly
- Give exact text to type
- Walk around helping individuals
- Keep energy high with quick pace

### MFA Setup Process
**Script:**
"Now the critical part - MFA setup:

**Step 1:** Copy the console sign-in URL from the success page.

**Step 2:** Open a private/incognito browser window.

**Step 3:** Log in as 'tesda-pilot-user' with password 'TempPass123!'

**Step 4:** Set a new password when prompted - make it strong!

**Step 5:** Once logged in, go to IAM → Users → tesda-pilot-user → Security credentials tab.

**Step 6:** Click 'Assign MFA device.'

**Step 7:** Choose 'Virtual MFA device.'

**Step 8:** Use Google Authenticator on your phone to scan the QR code.

**Step 9:** Enter two consecutive MFA codes and click 'Assign MFA.'

[Check progress] Who successfully set up MFA? Excellent! You've just implemented government-grade authentication."

**Delivery Notes:**
- Emphasize the private browser window
- Help with MFA app setup
- Celebrate successful MFA setup
- Use "government-grade" for impact

## 🔄 Exercise 2: Cross-Account Role Creation (2 minutes)

### Quick Role Setup
**Script:**
"Now let's create a cross-account role for secure monitoring:

**Step 1:** Go to IAM → Roles → Create role.

**Step 2:** Select 'AWS account' as the trusted entity.

**Step 3:** Enter your own account ID (find it in the top-right corner).

**Step 4:** Check 'Require MFA' - this is critical for security.

**Step 5:** Click 'Next.'

**Step 6:** Search for 'ReadOnlyAccess' and select it.

**Step 7:** Click 'Next.'

**Step 8:** Role name: 'TESDA-CrossAccount-Monitor'

**Step 9:** Description: 'Secure monitoring role with MFA requirement'

**Step 10:** Click 'Create role.'

Perfect! You've created a role that requires MFA for cross-account access. This is exactly what enterprise security teams use."

**Delivery Notes:**
- Keep pace quick but clear
- Help people find their account ID
- Emphasize the MFA requirement
- Connect to enterprise practices

## 🛡️ Exercise 3: MFA Enforcement Policy (3 minutes)

### The Smart Policy Implementation
**Script:**
"Now for the masterpiece - a policy that forces MFA without locking people out during setup.

**Step 1:** Go to IAM → Policies → Create policy.

**Step 2:** Click the 'JSON' tab.

**Step 3:** I'm going to show you the policy on screen. Don't type it - I'll provide this in your materials.

[Show policy on screen]

This policy is brilliant. It says: 'You can log in and set up MFA, but you can't do anything else until MFA is configured.'

**Step 4:** Copy this policy from your materials and paste it in.

**Step 5:** Click 'Next: Tags' (skip tags).

**Step 6:** Click 'Next: Review.'

**Step 7:** Policy name: 'TESDA-Force-MFA-Policy'

**Step 8:** Description: 'Enforces MFA for all user actions'

**Step 9:** Click 'Create policy.'"

**Delivery Notes:**
- Don't expect them to type complex JSON
- Explain what the policy does conceptually
- Provide the policy text separately
- Emphasize the brilliance of the approach

### Policy Testing
**Script:**
"Let's test this policy:

**Step 1:** Create a user group: IAM → User groups → Create group.

**Step 2:** Group name: 'TESDA-MFA-Required'

**Step 3:** Attach the 'TESDA-Force-MFA-Policy' we just created.

**Step 4:** Add your test user to this group.

**Step 5:** Create another test user without MFA and add them to the group.

**Step 6:** Try to access EC2 with the non-MFA user - it should be blocked!

**Step 7:** Try to set up MFA - it should work!

This policy protects your entire AWS environment while still allowing users to secure themselves."

**Delivery Notes:**
- Show the blocking behavior
- Demonstrate that MFA setup still works
- Emphasize the protection aspect
- Build confidence in the solution

## ✅ Lab Verification & Success Celebration (1 minute)

### Quick Success Check
**Script:**
"Let's verify what we've accomplished in just 10 minutes:

Raise your hand if you:
- Created a user with MFA ✋
- Set up a cross-account role with MFA requirement ✋
- Implemented the MFA enforcement policy ✋
- Tested that it actually works ✋

Look around this room! You've just implemented enterprise-grade security that most companies pay consultants thousands of dollars to set up.

This exact configuration protects government agencies, banks, and major corporations. You now have the skills to secure TESDA's entire AWS environment."

**Delivery Notes:**
- Use hand-raising for energy
- Look around the room with pride
- Compare to expensive consultants
- Build confidence in their abilities

### Real-World Impact
**Script:**
"What you've built today will:
- Prevent 99.9% of account compromises
- Meet government compliance requirements
- Protect student data and academic records
- Give you complete audit trails
- Scale to thousands of users

This isn't just a lab exercise - this is production-ready security you can implement immediately at TESDA."

**Delivery Notes:**
- Use specific statistics (99.9%)
- Connect to TESDA's mission
- Emphasize immediate applicability
- Build pride in their achievement

## 🎤 Delivery Tips for This Lab

### Pacing Management
- **Move quickly** but ensure everyone keeps up
- **Check progress frequently** - "Everyone with me?"
- **Help struggling participants** without slowing the group
- **Celebrate milestones** to maintain energy

### Technical Support
- **Walk around constantly** during hands-on portions
- **Have assistants** if possible for large groups
- **Prepare for common errors** and quick solutions
- **Keep backup screenshots** ready

### Energy Maintenance
- **Start with high energy** and urgency
- **Maintain excitement** throughout technical steps
- **Celebrate each success** - "Perfect! You got it!"
- **End with pride** in their accomplishments

### Common Issues & Quick Solutions

**Issue: "I can't find the MFA setup option"**
**Solution:** "Look for 'Security credentials' tab in the user details page, then scroll down to find 'Assign MFA device.'"

**Issue: "The QR code won't scan"**
**Solution:** "Try the manual entry option instead - click 'Show secret key' and type it into your authenticator app."

**Issue: "The policy is giving me errors"**
**Solution:** "Make sure you copied the entire JSON policy and that all brackets are matched. I'll come help you."

**Issue: "I can't test the policy blocking"**
**Solution:** "Make sure the user is in the group with the policy attached, and try accessing a service like EC2 or S3."

### Audience Engagement
- **Encourage peer help** - "If you finish early, help your neighbor"
- **Ask for volunteers** - "Who wants to demonstrate their MFA setup?"
- **Share success stories** - "Maria just got her MFA working perfectly!"
- **Build team spirit** - "We're all learning this together"

### Technical Preparation
- **Test all steps beforehand** in a clean AWS account
- **Have the MFA policy ready** to copy/paste
- **Know common error messages** and solutions
- **Prepare backup accounts** in case of issues

### Success Metrics
- **Participation rate** - Are people following along?
- **Completion rate** - How many finish each exercise?
- **Understanding level** - Do they grasp what they built?
- **Confidence level** - Do they feel ready to implement this?

---
**Next Module:** [Security Architecture Script](./07-security-architecture-script.md)
