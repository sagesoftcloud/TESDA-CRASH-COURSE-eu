# Module 9 Speaker Script: Architecture Design Workshop
**Duration:** 25 minutes  
**Style:** Collaborative, creative, solution-focused

## 🎯 Workshop Introduction & Challenge (3 minutes)
**Script:**
"This is it - the moment everything comes together! For the next 25 minutes, we're going to design TESDA's complete AWS architecture collaboratively.

Here's the challenge: Create a comprehensive cloud architecture that addresses every requirement we've discussed, works within your constraints, and can be implemented in the real world.

[Show challenge slide] You're not just learning about AWS anymore - you're architecting TESDA's digital future. The solution you create today could serve thousands of students and hundreds of staff members for years to come.

I'm going to divide you into teams, give you specific design areas, and then we'll combine your work into one unified architecture. Each team becomes the expert on their area, and together we'll build something amazing.

Ready to design the future? Let's create something extraordinary!"

**Delivery Notes:**
- Build excitement and energy
- Emphasize real-world impact
- Position them as architects, not students
- Use "we" language to show collaboration

## 👥 Team Formation & Design Areas (3 minutes)

### Strategic Team Division
**Script:**
"Let's form our architecture teams. I want a mix of technical and functional expertise in each group.

**Team 1: Foundation Architecture** (4-5 people)
Your focus: Multi-account structure, AWS Organizations, billing, and governance. You're designing the foundation everything else builds on.

**Team 2: Identity & Security** (4-5 people)  
Your focus: IAM Identity Center, MFA, cross-account access, and security policies. You're the guardians of TESDA's digital security.

**Team 3: Application Services** (4-5 people)
Your focus: LMS hosting, databases, storage, and application integration. You're designing the systems students and staff use daily.

**Team 4: Compliance & Operations** (4-5 people)
Your focus: Monitoring, logging, backup, disaster recovery, and government compliance. You ensure everything runs smoothly and meets regulations.

[Facilitate team formation] Take 2 minutes to form your teams. Mix departments if possible - we want different perspectives in each group."

**Delivery Notes:**
- Clearly define each team's scope
- Encourage cross-departmental mixing
- Give them time to self-organize
- Move around to help with team formation

### Design Process & Tools
**Script:**
"Each team gets:
- **Architecture templates** with AWS service icons
- **Requirements checklist** specific to your area
- **Constraint guidelines** you must work within
- **Best practices reference** for your domain

**Your 15-minute design process:**
1. **Requirements review** (3 minutes) - Make sure you understand what you're solving
2. **Architecture design** (10 minutes) - Create your solution using the templates
3. **Presentation prep** (2 minutes) - Prepare to explain your design to other teams

**Key rule:** Everything must be implementable in the real world. No theoretical solutions - only practical architectures TESDA can actually deploy."

**Delivery Notes:**
- Show the materials they'll receive
- Give clear time allocations
- Emphasize practical, implementable solutions
- Set expectations for the process

## 🏗️ Collaborative Design Session (15 minutes)

### Team 1: Foundation Architecture Guidance
**Script (to Team 1):**
"Foundation team, you're designing the backbone of everything. Focus on:

**Account Structure:**
- How many accounts does TESDA need?
- How should they be organized in OUs?
- What's the naming convention?

**Billing & Governance:**
- How will you track costs by department?
- What Service Control Policies are essential?
- How will you handle budget alerts?

**Key Questions to Answer:**
- How does a new training center get added to the structure?
- How do you prevent expensive mistakes?
- How do you scale from 5 accounts to 50 accounts?

Remember: This foundation must support TESDA for the next 5-10 years. Think big, but start simple."

**Delivery Notes:**
- Visit Team 1 specifically with this guidance
- Help them think about scalability
- Encourage long-term thinking
- Provide specific questions to guide their work

### Team 2: Identity & Security Guidance
**Script (to Team 2):**
"Security team, you're protecting TESDA's most valuable asset - student data. Focus on:

**Identity Management:**
- How does Identity Center integrate with existing AD?
- What permission sets do you need for different roles?
- How do you handle contractors and temporary access?

**Security Controls:**
- What MFA requirements make sense for TESDA?
- How do you implement Zero Trust principles?
- What automated security monitoring do you need?

**Key Questions to Answer:**
- How does a new employee get appropriate access on day one?
- How do you handle emergency access during incidents?
- How do you prove compliance to government auditors?

Remember: Security must be strong but not interfere with TESDA's educational mission."

**Delivery Notes:**
- Visit Team 2 with security-focused guidance
- Help them balance security with usability
- Emphasize compliance requirements
- Guide them toward practical solutions

### Team 3: Application Services Guidance
**Script (to Team 3):**
"Application team, you're designing the systems that directly serve students and staff. Focus on:

**Core Applications:**
- How will you host the LMS in AWS?
- What database architecture supports thousands of students?
- How do you handle file storage for course materials?

**Integration & Performance:**
- How do applications connect securely?
- How do you handle traffic spikes during enrollment?
- How do you ensure fast access from all regions?

**Key Questions to Answer:**
- How do you handle 10,000 students taking exams simultaneously?
- How do you integrate with existing TESDA systems?
- How do you ensure 99.9% uptime during critical periods?

Remember: Students and staff must have a seamless, fast experience regardless of their location."

**Delivery Notes:**
- Visit Team 3 with application-focused guidance
- Help them think about scale and performance
- Emphasize user experience
- Guide toward high-availability solutions

### Team 4: Compliance & Operations Guidance
**Script (to Team 4):**
"Operations team, you ensure everything runs smoothly and meets government requirements. Focus on:

**Monitoring & Logging:**
- What monitoring do you need for government compliance?
- How do you track all system access and changes?
- What alerts are critical for TESDA operations?

**Backup & Recovery:**
- How do you protect against data loss?
- What's your disaster recovery strategy?
- How do you test that backups actually work?

**Key Questions to Answer:**
- How do you prove to auditors that student data is protected?
- How quickly can you recover from a major system failure?
- How do you handle compliance across multiple AWS accounts?

Remember: Government agencies can't afford downtime or data loss. Plan for the worst-case scenarios."

**Delivery Notes:**
- Visit Team 4 with operations-focused guidance
- Help them think about compliance requirements
- Emphasize disaster recovery planning
- Guide toward comprehensive monitoring solutions

### Facilitator Role During Design
**Script (general facilitation):**
"I'm walking around to each team to provide guidance and answer questions. Don't hesitate to call me over if you need help.

**Common questions I'm hearing:**
- 'Is this service appropriate for government use?' - Yes, if it meets your security requirements.
- 'How much will this cost?' - Focus on the architecture first, we'll optimize costs later.
- 'What if we can't implement everything at once?' - Design the end state, then we'll plan phases.

**Time check:** You have [X] minutes remaining. Focus on your core architecture first, then add details if time permits."

**Delivery Notes:**
- Move constantly between teams
- Answer questions quickly and practically
- Keep teams focused on their core responsibilities
- Provide time updates regularly

## 🎤 Architecture Presentations (4 minutes)

### Presentation Format
**Script:**
"Time's up! Now each team presents their architecture to the group. You have exactly 3 minutes per team - focus on your key decisions and how they solve TESDA's requirements.

**Presentation order:**
1. **Foundation team** - Set the stage with account structure
2. **Identity & Security team** - Show how users and security work
3. **Application Services team** - Demonstrate the student/staff experience  
4. **Compliance & Operations team** - Explain monitoring and compliance

**Audience:** Ask questions and provide feedback. We're building one unified architecture together.

Foundation team, you're up first! Show us TESDA's new foundation."

**Delivery Notes:**
- Keep strict time limits
- Encourage questions from other teams
- Take notes on key decisions
- Build excitement about the combined solution

### Integration Discussion
**Script:**
"Excellent presentations! Now let's see how these pieces fit together.

[Show combined architecture diagram] Here's what you've collectively designed:

- A scalable foundation that can grow with TESDA
- Secure identity management integrated with existing systems
- High-performance applications that serve students effectively
- Comprehensive monitoring and compliance capabilities

**Integration points to highlight:**
- How identity flows from Team 2's design to Team 3's applications
- How Team 1's account structure supports Team 4's compliance monitoring
- How all teams addressed TESDA's specific constraints

**Quick validation:** Does this combined architecture solve the problems we identified in requirements analysis? [Get group confirmation]"

**Delivery Notes:**
- Show how all pieces connect
- Highlight successful integration points
- Validate against original requirements
- Get group buy-in on the solution

## ✅ Solution Validation & Next Steps (1 minute)

**Script:**
"Look what you've accomplished in just 25 minutes! You've designed a comprehensive AWS architecture that:

✅ Addresses all of TESDA's requirements
✅ Works within government constraints  
✅ Scales from current needs to future growth
✅ Meets security and compliance standards
✅ Can be implemented in phases

This isn't just a training exercise - this is a blueprint TESDA can actually use. You've created something that could transform how TESDA delivers education technology.

**Your next steps:**
1. Document this architecture in detail
2. Create an implementation roadmap
3. Identify pilot programs for initial deployment
4. Plan staff training and change management

Congratulations - you've just architected TESDA's digital future!"

**Delivery Notes:**
- Celebrate their achievement enthusiastically
- Emphasize the practical value of their work
- Provide clear next steps
- End with pride and accomplishment

## 🎤 Delivery Tips for This Workshop

### Facilitation Excellence
- **Move constantly** between teams during design phase
- **Ask probing questions** to guide their thinking
- **Provide just-in-time guidance** when teams get stuck
- **Keep energy high** throughout the collaborative process

### Time Management
- **Use visible timers** so teams can self-manage
- **Give regular time updates** - "5 minutes remaining"
- **Be strict about presentation times** to maintain energy
- **Have backup activities** if teams finish early

### Team Dynamics
- **Encourage equal participation** within teams
- **Help quiet members contribute** their expertise
- **Manage dominant personalities** who might take over
- **Celebrate diverse perspectives** and creative solutions

### Technical Guidance
- **Provide architecture templates** with AWS service icons
- **Have reference materials** readily available
- **Answer technical questions** quickly and accurately
- **Guide toward practical solutions** rather than theoretical ones

### Common Workshop Challenges

**Challenge: "We don't know enough about AWS services"**
**Solution:** "Focus on the problems you're solving, not the specific services. I'll help you map problems to appropriate AWS solutions."

**Challenge: "Our design is too complex"**
**Solution:** "Start with the minimum viable architecture. What's the simplest solution that meets your core requirements?"

**Challenge: "We can't agree on the approach"**
**Solution:** "Let's identify the core disagreement and evaluate options against TESDA's specific requirements and constraints."

**Challenge: "We're running out of time"**
**Solution:** "Focus on your team's core responsibility first. We can add details during the integration discussion."

### Success Indicators
- **Active participation** from all team members
- **Practical solutions** that address real TESDA needs
- **Creative problem-solving** within given constraints
- **Enthusiasm** about implementing the solutions

### Workshop Materials Needed
- **Architecture templates** with AWS service icons
- **Requirements checklists** for each team
- **Constraint guidelines** and compliance requirements
- **Best practices references** for each domain
- **Presentation materials** (flip charts, markers, etc.)

---
**Final Module Complete!** This concludes the comprehensive speaker notes for your TESDA AWS Cloud Fundamentals presentation.
