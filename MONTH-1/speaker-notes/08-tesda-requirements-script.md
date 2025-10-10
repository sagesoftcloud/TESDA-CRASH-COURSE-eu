# Module 8 Speaker Script: TESDA Requirements Analysis
**Duration:** 20 minutes  
**Style:** Interactive, analytical, TESDA-focused

## 🎯 Module Opening & Collaborative Approach (2 minutes)
**Script:**
"Now we get to the exciting part - designing something specifically for TESDA! Everything we've learned so far has been building toward this moment.

I need your help for this module. You know TESDA better than I do. You understand the challenges, the constraints, the opportunities. I'm going to guide the technical analysis, but I need your insights about TESDA's real-world needs.

[Look around the room] This isn't just a theoretical exercise. By the end of this session, we're going to have a blueprint that TESDA can actually implement. Your input will shape a solution that could serve thousands of students and hundreds of staff members.

Ready to design the future of TESDA's digital infrastructure? Let's start by understanding where you are today."

**Delivery Notes:**
- Emphasize collaboration and their expertise
- Make eye contact across the room
- Build excitement about real-world impact
- Position them as partners, not just students

## 🔍 Current State Assessment (5 minutes)

### Interactive Discovery Session
**Script:**
"Let's start with an honest assessment of TESDA's current state. I'm going to ask some questions, and I want you to be completely honest. This isn't about judgment - it's about understanding so we can design the right solution.

**Question 1: Identity Management**
Raise your hand if TESDA currently uses:
- Active Directory for user management [count hands]
- Multiple separate login systems [count hands]  
- Shared passwords for system accounts [count hands]
- Manual user account creation processes [count hands]

[Acknowledge responses] Okay, I see a mix of approaches. That's completely normal for organizations in transition."

**Delivery Notes:**
- Encourage honest responses
- Count hands visibly
- Don't judge any responses
- Normalize their current situation

### Security Posture Reality Check
**Script:**
"**Question 2: Current Security Practices**
Show of hands:
- Who has experienced a security incident in the last year? [count]
- Who currently uses multi-factor authentication for critical systems? [count]
- Who has regular security training for staff? [count]
- Who has documented incident response procedures? [count]

[Pause to acknowledge] Thank you for your honesty. This gives me a clear picture of where we're starting from."

**Delivery Notes:**
- Handle security incidents sensitively
- Don't dwell on negative responses
- Thank them for honesty
- Use information to tailor recommendations

### Current System Landscape
**Script:**
"**Question 3: System Integration Challenges**
Let's talk about your current systems. Call out what you're using:
- Learning Management System: What platform? [listen and note]
- Student Information System: What system? [listen and note]
- Financial/Billing System: What do you use? [listen and note]
- Communication Platform: Email, messaging? [listen and note]

[Write responses on board/slide] Now, how many different usernames and passwords does a typical staff member need to remember? [listen to responses]

I'm hearing numbers between 5 and 15 different systems. That's exactly the problem we're going to solve."

**Delivery Notes:**
- Actually write down their responses
- Show you're listening and taking notes
- Let them call out systems naturally
- Summarize the complexity they face

## 🎯 Target Architecture Goals (4 minutes)

### Vision Setting Exercise
**Script:**
"Now let's envision the future. I want you to imagine it's one year from today, and we've successfully implemented everything we're designing.

**Maria, a new curriculum developer, starts work at TESDA.**

Day 1, 9 AM: HR adds Maria to Active Directory and assigns her to the Curriculum Development group.

Day 1, 9:30 AM: Maria receives her welcome email with one set of credentials.

Day 1, 10 AM: Maria logs in once and automatically has access to:
- The curriculum development tools she needs
- The appropriate AWS accounts for her role
- Student data systems relevant to her work
- Communication and collaboration platforms

She doesn't need to call IT. She doesn't need multiple passwords. She's productive from hour one.

[Pause] How does that vision sound compared to your current onboarding process?"

**Delivery Notes:**
- Paint a vivid, specific scenario
- Use timeline to show efficiency
- Contrast with their current experience
- Pause for them to imagine the difference

### Measurable Objectives
**Script:**
"Let's set specific, measurable goals for TESDA's cloud architecture:

**Goal 1: Centralized Identity Management**
- Single sign-on for all systems
- Automatic user provisioning based on role
- 90% reduction in password reset requests

**Goal 2: Scalable Multi-Account Structure**
- Separate environments for development, testing, production
- Department-specific resource isolation
- Automatic cost allocation by department

**Goal 3: Enhanced Security Controls**
- 100% MFA adoption within 60 days
- Complete audit trails for all system access
- Automated compliance checking

**Goal 4: Cost-Effective Resource Utilization**
- 30% reduction in IT administrative overhead
- Clear visibility into spending by department
- Optimized resource usage through proper tagging

Which of these goals resonates most with your current challenges?"

**Delivery Notes:**
- Present goals with specific metrics
- Ask which resonates most
- Listen to their priorities
- Adjust emphasis based on their responses

## 📊 Key Requirements Deep Dive (6 minutes)

### Learning Management System Requirements
**Script:**
"Let's dive deep into your specific system requirements. Starting with your Learning Management System:

**Current LMS Challenges** - What are your biggest pain points? [Listen to responses]

**Common issues I hear:**
- Slow performance during peak enrollment periods
- Difficulty integrating with other TESDA systems
- Complex user management across multiple training centers
- Limited reporting and analytics capabilities

**AWS Solutions:**
- Auto-scaling to handle enrollment surges
- API Gateway for seamless system integration
- Centralized user management through Identity Center
- Advanced analytics with QuickSight and data lakes

**Question for the group:** What would success look like for your LMS in the cloud? [Facilitate discussion]"

**Delivery Notes:**
- Ask for their specific pain points first
- Validate their challenges
- Offer concrete AWS solutions
- Facilitate group discussion

### Assessment and Certification Platform
**Script:**
"**Assessment System Requirements:**

This is critical for TESDA - your assessment and certification systems must be:
- **Highly Available** - Students can't wait for system downtime during exam periods
- **Secure** - Assessment integrity is paramount
- **Scalable** - Handle thousands of simultaneous test-takers
- **Compliant** - Meet government standards for certification

**Technical Requirements:**
- Real-time proctoring capabilities
- Secure content delivery
- Automated scoring and reporting
- Integration with national certification databases

**Question:** What are your current assessment system limitations? [Listen and note responses]

**AWS Architecture Benefits:**
- Multi-AZ deployment for 99.99% uptime
- CloudFront for fast, secure content delivery
- Lambda for real-time processing
- RDS with automated backups for data integrity"

**Delivery Notes:**
- Emphasize the critical nature of assessments
- List specific technical requirements
- Ask about current limitations
- Show how AWS addresses each requirement

### Student Information System Integration
**Script:**
"**Student Information System (SIS) Requirements:**

Your SIS is the heart of TESDA operations. It needs to:
- Handle student enrollment and registration
- Track academic progress and achievements
- Manage financial aid and scholarships
- Generate reports for government compliance
- Integrate with partner institutions

**Integration Challenges:**
- Data synchronization across multiple campuses
- Real-time updates for enrollment changes
- Secure data sharing with other government agencies
- Mobile access for field staff

**Cloud Architecture Solutions:**
- Event-driven architecture for real-time updates
- API Gateway for secure external integrations
- Mobile-optimized interfaces
- Automated backup and disaster recovery

What's your biggest SIS challenge right now? [Facilitate discussion]"

**Delivery Notes:**
- Position SIS as the operational heart
- List comprehensive requirements
- Address integration complexity
- Ask for their biggest challenge

## 🚧 Technical Constraints Analysis (3 minutes)

### Government-Specific Constraints
**Script:**
"Now let's address the constraints we need to work within. As a government agency, TESDA faces unique challenges:

**Government Network Connectivity:**
- Limited bandwidth in some regional offices
- Firewall restrictions for external connections
- VPN requirements for remote access
- Integration with existing government networks

**Data Residency Requirements:**
- Student data must remain in the Philippines
- Compliance with local data privacy laws
- Restrictions on cross-border data transfer
- Government audit and oversight requirements

**Budget Limitations:**
- Multi-year budget planning cycles
- Procurement process requirements
- Cost justification for new technology
- Need for predictable, manageable costs

**Timeline Considerations:**
- Academic calendar constraints
- Staff training and change management
- Phased implementation requirements
- Minimal disruption to ongoing operations

Which of these constraints concerns you most? [Listen to responses and address concerns]"

**Delivery Notes:**
- Acknowledge the reality of government constraints
- Show understanding of their challenges
- Ask which concerns them most
- Address concerns directly and practically

### Practical Solutions for Constraints
**Script:**
"Here's how our AWS architecture addresses these constraints:

**Connectivity Solutions:**
- CloudFront edge locations in Asia Pacific for faster access
- Offline-capable applications for limited connectivity
- Bandwidth optimization through compression and caching
- Hybrid cloud options for gradual migration

**Data Residency Compliance:**
- AWS Asia Pacific (Singapore) region for Philippine data
- Data classification and automated compliance checking
- Encryption in transit and at rest
- Complete audit trails for regulatory compliance

**Budget Management:**
- Reserved Instance pricing for predictable costs
- Detailed cost allocation by department and project
- Budget alerts and spending controls
- Phased implementation to spread costs over time

**Timeline Management:**
- Pilot programs during low-activity periods
- Parallel systems during transition
- Comprehensive training programs
- 24/7 support during critical periods

These aren't just theoretical solutions - they're proven approaches used by other government agencies."

**Delivery Notes:**
- Provide specific, practical solutions
- Show how each constraint is addressed
- Mention other government agencies for credibility
- Build confidence in the approach

## ✅ Requirements Summary & Validation (1 minute)

**Script:**
"Let me summarize what I've heard about TESDA's requirements:

**Current State:** Multiple disconnected systems, manual processes, security gaps, complex user management.

**Target State:** Integrated, secure, scalable cloud architecture with single sign-on and automated processes.

**Key Systems:** LMS, Assessment Platform, Student Information System, Administrative Tools.

**Critical Constraints:** Government compliance, data residency, budget limitations, timeline restrictions.

**Success Metrics:** Reduced IT overhead, improved security, better user experience, cost optimization.

Does this accurately capture TESDA's needs? What did I miss? [Pause for feedback]

Perfect! Now let's design the architecture that meets all these requirements."

**Delivery Notes:**
- Summarize clearly and concisely
- Ask for validation and feedback
- Make adjustments based on their input
- Build excitement for the design phase

## 🎤 Delivery Tips for This Module

### Interactive Facilitation
- **Ask open-ended questions** and listen actively
- **Write down their responses** visibly
- **Validate their challenges** without judgment
- **Build on their input** to create solutions

### Audience Management
- **Encourage participation** from different departments
- **Handle sensitive topics** (security incidents) carefully
- **Keep discussions focused** but allow natural flow
- **Acknowledge all contributions** positively

### Requirements Gathering
- **Probe for specifics** - "Can you give me an example?"
- **Understand current pain points** before proposing solutions
- **Identify stakeholders** and their different needs
- **Document constraints** clearly and completely

### Energy Management
- **Start collaborative** and maintain engagement
- **Balance listening** with providing direction
- **Build excitement** about possibilities
- **End with clarity** about next steps

### Common Challenges & Responses

**Challenge: "We don't have budget for major changes"**
**Response:** "That's exactly why we're designing a phased approach. We can start small and grow incrementally, proving value at each step."

**Challenge: "Our staff aren't technical enough for cloud systems"**
**Response:** "The beauty of what we're designing is that it's actually easier for end users. Single sign-on and automated processes reduce complexity, not increase it."

**Challenge: "We can't risk disrupting current operations"**
**Response:** "Absolutely right. That's why we'll run parallel systems during transition and have comprehensive rollback plans. Student services never stop."

**Challenge: "Government procurement takes forever"**
**Response:** "We'll design the architecture to work with your procurement timeline. Some components can be implemented immediately while others go through formal procurement."

---
**Next Module:** [Architecture Workshop Script](./09-architecture-workshop-script.md)
