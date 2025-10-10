# 🚀 DAY 2 LAUNCH GUIDE - Operational Excellence Part 1

## 📋 Pre-Launch Checklist (30 mins before)

### Technical Setup
- [ ] AWS accounts ready for all participants
- [ ] CloudWatch access verified
- [ ] EC2 launch permissions confirmed
- [ ] Lambda execution role prepared
- [ ] CloudFormation permissions checked

### Materials Ready
- [ ] Lab instructions printed/accessible
- [ ] Code samples uploaded to shared drive
- [ ] CloudFormation templates prepared
- [ ] Dashboard templates ready

### Environment Check
- [ ] Internet connectivity stable
- [ ] AWS Console access working
- [ ] Screen sharing setup tested
- [ ] Backup internet connection ready

## ⏰ Detailed Schedule (5 Hours)

### Hour 1: Theory Foundation (60 mins)
**9:00-9:15** - Welcome & Day Overview
- Introduce operational excellence pillars
- Review Day 1 recap
- Set expectations for hands-on labs

**9:15-9:45** - Monitoring Strategies (30 mins)
- CloudWatch fundamentals
- Metrics vs Logs vs Traces
- Alerting best practices
- Cost optimization for monitoring

**9:45-10:00** - Break & Q&A

### Hours 2-3: Project 1 - CloudWatch Monitoring (90 mins)
**10:00-10:15** - Project Setup
- Launch EC2 instances
- Install CloudWatch agent
- Verify connectivity

**10:15-11:00** - Hands-on Implementation
- Configure custom metrics
- Create CloudWatch dashboard
- Set up basic alarms
- Test notification system

**11:00-11:30** - Testing & Validation
- Trigger alarms intentionally
- Verify notifications work
- Review dashboard data
- Troubleshoot issues

### Hour 3-4: Project 2 - Log Analysis (90 mins)
**11:30-11:45** - Project Setup
- Configure CloudWatch Logs
- Set up log groups
- Install log agents

**11:45-12:30** - Implementation
- Create Log Insights queries
- Build Lambda for log analysis
- Set up automated alerts
- Test pattern detection

**12:30-1:00** - Validation & Demo
- Generate test logs
- Verify automated analysis
- Demo alert generation
- Group presentations

### Hour 4-5: Project 3 - IaC with Monitoring (90 mins)
**1:00-1:15** - Advanced Setup
- CloudFormation template review
- CI/CD pipeline overview
- Self-healing concepts

**1:15-2:00** - Implementation
- Deploy infrastructure as code
- Integrate monitoring into templates
- Set up automated responses
- Configure self-healing

**2:00-2:30** - Final Testing & Wrap-up
- End-to-end testing
- Break infrastructure intentionally
- Verify self-healing works
- Day 2 assessment quiz

## 🎯 Learning Checkpoints

### After Hour 1
- [ ] Can explain operational excellence principles
- [ ] Understands monitoring strategies
- [ ] Knows when to use different AWS monitoring tools

### After Project 1
- [ ] CloudWatch agent installed and working
- [ ] Custom metrics being collected
- [ ] Alarms triggering correctly
- [ ] Dashboard showing relevant data

### After Project 2
- [ ] Logs centralized in CloudWatch
- [ ] Automated analysis working
- [ ] Alerts generated from log patterns
- [ ] Can write Log Insights queries

### After Project 3
- [ ] Infrastructure deployed via code
- [ ] Monitoring integrated into IaC
- [ ] Self-healing demonstrated
- [ ] CI/CD pipeline functional

## 🛠️ Troubleshooting Guide

### Common Issues & Solutions

**CloudWatch Agent Not Reporting**
- Check IAM permissions
- Verify agent configuration
- Restart CloudWatch agent service
- Check network connectivity

**Alarms Not Triggering**
- Verify metric thresholds
- Check alarm state history
- Confirm SNS topic permissions
- Test notification endpoints

**Log Analysis Lambda Failing**
- Check Lambda execution role
- Verify log group permissions
- Review CloudWatch Logs for errors
- Test Lambda function independently

**CloudFormation Stack Failures**
- Review stack events
- Check resource limits
- Verify IAM permissions
- Validate template syntax

## 📊 Assessment Criteria

### Project 1 Success Metrics
- [ ] EC2 metrics visible in CloudWatch
- [ ] Custom metrics being collected
- [ ] Alarms trigger within 5 minutes
- [ ] Dashboard shows real-time data

### Project 2 Success Metrics
- [ ] Logs aggregated successfully
- [ ] Automated analysis detects patterns
- [ ] Alerts generated from log events
- [ ] Log Insights queries return results

### Project 3 Success Metrics
- [ ] Infrastructure deploys via CloudFormation
- [ ] Monitoring included in templates
- [ ] Self-healing responds to failures
- [ ] Pipeline deploys successfully

## 🔄 Backup Plans

### If AWS Issues Occur
- Switch to AWS simulator/LocalStack
- Use pre-recorded demos
- Focus on theory and best practices
- Reschedule hands-on for later

### If Time Runs Short
- Prioritize Project 1 (foundational)
- Demo Projects 2 & 3 instead of hands-on
- Provide take-home lab instructions
- Schedule follow-up session

### If Participants Struggle
- Pair programming approach
- Provide pre-built templates
- Focus on concepts over implementation
- Offer additional support sessions

## 📝 Day 2 Wrap-up

### Final 15 Minutes
- [ ] Quick assessment quiz
- [ ] Collect feedback forms
- [ ] Preview Day 3 content
- [ ] Share additional resources
- [ ] Schedule office hours if needed

### Success Indicators
- All participants completed at least Project 1
- 80% completed Project 2
- 60% attempted Project 3
- Positive feedback on hands-on approach
- Clear understanding of operational excellence

---
**Next**: Day 3 - Advanced Automation & Chaos Engineering
