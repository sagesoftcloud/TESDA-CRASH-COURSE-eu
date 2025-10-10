# Module 3 Speaker Script: Hands-On Lab - Multi-Account Setup
**Duration:** 15 minutes  
**Style:** Interactive, guided practice, supportive

## 🎯 Lab Introduction (1 minute)
**Script:**
"Alright everyone, this is where the rubber meets the road! For the next 15 minutes, we're going to build a real AWS Organization structure together.

I want everyone to follow along on their computers. Don't worry if you get stuck - I'll be walking around to help, and we'll go step by step together.

By the end of this lab, you'll have created something you can actually use in TESDA's production environment. This isn't just practice - this is the real thing."

**Delivery Notes:**
- Stand up and move around the room
- Make eye contact with participants
- Project confidence and excitement
- Encourage participation

## 🏗️ Lab Setup & Expectations (1 minute)

**Script:**
"Before we start, let me set expectations:

First, if you don't have an AWS account yet, that's okay - just follow along and take notes. You can do this later.

Second, if you get an error or something looks different, raise your hand immediately. Don't struggle in silence.

Third, we're building the TESDA structure we discussed - this will be your template for real implementation.

Everyone ready? Let's build something amazing together!"

**Delivery Notes:**
- Address different skill levels
- Encourage questions and help-seeking
- Build team spirit ("together")
- Check for readiness before starting

## 🚀 Exercise 1: Create AWS Organization (3 minutes)

### Step-by-Step Guidance
**Script:**
"Let's start by creating our AWS Organization. Everyone, please:

**Step 1:** Log into your AWS Console. If you see the main dashboard, you're in the right place.

**Step 2:** In the search bar at the top, type 'Organizations' - O-R-G-A-N-I-Z-A-T-I-O-N-S. Click on the service when it appears.

[Pause and look around] Is everyone finding the Organizations service? Great!

**Step 3:** You should see a button that says 'Create an organization.' Click that button.

**Step 4:** Very important - select 'Enable all features,' not just billing. We want the full power of Organizations.

[Walk around the room] How's everyone doing? Anyone seeing something different?

**Step 5:** Click 'Create organization' and wait for it to complete. This usually takes about 30 seconds."

**Delivery Notes:**
- Spell out service names clearly
- Pause between steps to let people catch up
- Walk around to help individuals
- Address issues immediately

### Verification
**Script:**
"Perfect! Now let's verify this worked. You should see:

- An Organization ID that starts with 'o-' followed by numbers and letters
- Your current account listed as the 'management account'
- A message saying 'Consolidated billing is enabled'

If you see all three of these, congratulations! You've just created your first AWS Organization. Give yourselves a round of applause!"

**Delivery Notes:**
- Be specific about what they should see
- Celebrate small wins
- Encourage applause - builds energy

## 🗂️ Exercise 2: Create Organizational Units (4 minutes)

### Creating the Structure
**Script:**
"Now let's create our folder structure - the Organizational Units. We're going to create the TESDA structure we designed earlier.

**Step 1:** Look for a button or link that says 'Organize accounts' or 'Create organizational unit.' Click it.

**Step 2:** Let's create our first OU. Click 'Create organizational unit.'

**Step 3:** For the name, type exactly: 'Core-OU' - C-O-R-E hyphen O-U.

**Step 4:** For description, type: 'Essential services and security'

**Step 5:** Click 'Create organizational unit.'

[Check progress] Everyone got their first OU created? Excellent!

Now let's create the second one:

**Step 6:** Click 'Create organizational unit' again.

**Step 7:** Name: 'Production-OU'

**Step 8:** Description: 'Live systems serving students'

**Step 9:** Click 'Create organizational unit.'

One more:

**Step 10:** Name: 'Non-Production-OU'

**Step 11:** Description: 'Development and testing environments'

**Step 12:** Click 'Create organizational unit.'"

**Delivery Notes:**
- Spell out names clearly
- Give exact text to type
- Check progress frequently
- Help struggling participants

### Structure Verification
**Script:**
"Fantastic! Now let's see what we've built. You should see a structure that looks like this:

- Root (that's your main organization)
  - Core-OU
  - Production-OU  
  - Non-Production-OU

If you see this structure, you've successfully organized your AWS environment. This is exactly what major enterprises use!"

**Delivery Notes:**
- Show the structure visually
- Compare to enterprise practices
- Build confidence in their achievement

## 🏢 Exercise 3: Create Member Accounts (4 minutes)

### Account Creation Process
**Script:**
"Now comes the exciting part - creating our member accounts. In a real environment, you'd create accounts for each purpose, but today we'll create one example account.

**Step 1:** Look for 'Add an AWS account' or similar button. Click it.

**Step 2:** Select 'Create an AWS account' (not invite existing).

**Step 3:** For account name, type: 'TESDA-Security-Demo'

**Step 4:** For email, this is tricky. You need a unique email address. Try: tesda-security-demo-[your-initials]@[your-domain].com

For example, if your name is Maria Santos, use: tesda-security-demo-ms@tesda.gov.ph

**Step 5:** For IAM role name, use: 'OrganizationAccountAccessRole' - this is the standard name.

**Step 6:** Click 'Create AWS account.'

[Walk around helping with email addresses] This step takes about 2-3 minutes, so be patient."

**Delivery Notes:**
- Help with unique email addresses
- Explain the waiting time
- Walk around providing individual help
- Address email uniqueness issues

### Moving Accounts to OUs
**Script:**
"Once your account is created, let's organize it properly:

**Step 1:** Find your new 'TESDA-Security-Demo' account in the list.

**Step 2:** Select it by clicking the checkbox next to it.

**Step 3:** Look for a 'Move' button or 'Actions' menu.

**Step 4:** Select 'Move' and choose 'Core-OU' as the destination.

**Step 5:** Confirm the move.

Perfect! You've just created and organized your first member account!"

**Delivery Notes:**
- Be patient with the interface
- Help find the right buttons
- Celebrate the completion

## 🔒 Exercise 4: Basic Security Policy (2 minutes)

### Simple SCP Implementation
**Script:**
"Let's add one basic security policy to protect our organization:

**Step 1:** Go to 'Policies' in the left navigation.

**Step 2:** Click 'Create policy.'

**Step 3:** For policy name, type: 'PreventAccountClosure'

**Step 4:** I'm going to show you the policy content on screen. Don't worry about typing it all - I'll provide this in your materials.

[Show policy on screen]

**Step 5:** Copy this policy and paste it into the policy document area.

**Step 6:** Click 'Create policy.'

**Step 7:** Now attach this policy to your Root OU to protect all accounts.

This policy prevents anyone from accidentally closing AWS accounts - a common and expensive mistake!"

**Delivery Notes:**
- Provide the policy text clearly
- Don't expect them to type complex JSON
- Explain what the policy does
- Emphasize the protection benefit

## ✅ Lab Verification & Celebration (1 minute)

### Success Check
**Script:**
"Let's do a final check of what we've accomplished together:

Raise your hand if you:
- Created an AWS Organization ✋
- Created three Organizational Units ✋  
- Created at least one member account ✋
- Applied a security policy ✋

Look around the room - look at what we've accomplished in just 15 minutes! You've built the foundation of an enterprise-grade AWS architecture.

This exact structure can handle thousands of users and hundreds of applications. You've just learned skills that major corporations pay consultants thousands of dollars to implement."

**Delivery Notes:**
- Use the hand-raising to build energy
- Look around the room with pride
- Emphasize the value of what they've learned
- Build confidence for the next module

### Troubleshooting Common Issues
**Script:**
"Before we move on, let me address the most common issues I see:

**If account creation failed:** Usually it's because the email address is already in use. Try adding numbers or your initials to make it unique.

**If you can't find a button:** AWS sometimes updates their interface. Look for similar words or ask me - I'll help you find it.

**If something looks different:** That's normal! AWS accounts can have different views based on your permissions and region.

The important thing is that you understand the concepts. The exact clicks might change, but the principles remain the same."

**Delivery Notes:**
- Address common issues proactively
- Reassure about interface differences
- Emphasize concepts over clicks
- Maintain supportive tone

## 🎤 Delivery Tips for This Lab

### Pacing Management
- **Go slower than you think** - people need time to find buttons
- **Check progress frequently** - "Is everyone with me?"
- **Be flexible with timing** - better to finish properly than rush
- **Have backup plans** - screenshots if live demo fails

### Individual Support
- **Walk around constantly** - don't stay at the front
- **Help individuals quietly** - don't announce their struggles
- **Pair up participants** - experienced can help beginners
- **Have assistants** if possible for large groups

### Managing Different Skill Levels
- **For beginners:** Provide extra guidance and reassurance
- **For experienced:** Give them advanced tips while others catch up
- **For everyone:** Focus on the learning, not perfect execution

### Technical Preparation
- **Test everything beforehand** - know exactly where each button is
- **Have backup accounts** - in case of demo failures
- **Prepare screenshots** - for offline backup
- **Know common error messages** - and how to fix them

### Energy Management
- **Start with excitement** - "Let's build something amazing!"
- **Maintain encouragement** - "You're doing great!"
- **Celebrate milestones** - applause for each completed step
- **End with pride** - "Look what you've accomplished!"

### Common Issues & Solutions

**Issue: "I can't find the Organizations service"**
**Solution:** "Try typing just 'org' in the search box, or look under 'Management & Governance' in the services menu."

**Issue: "My email address is already in use"**
**Solution:** "Add your initials and today's date to make it unique, like tesda-security-demo-ms-0910@tesda.gov.ph"

**Issue: "The interface looks different"**
**Solution:** "That's normal! AWS updates their interface regularly. Look for similar words or buttons that do the same thing."

**Issue: "I'm getting an error message"**
**Solution:** "Raise your hand and I'll come help you. Error messages usually have simple solutions."

---
**Next Module:** [IAM Concepts Script](./04-iam-concepts-script.md)
