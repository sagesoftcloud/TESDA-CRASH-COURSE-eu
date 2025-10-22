# 🏷️ AWS Resource Naming Conventions
## TESDA Crash Course Day 2 & 3 - Student Resource Standards

---

## 📋 **IMPORTANT: STUDENT NUMBERING SYSTEM**

Each participant will be assigned a **student number** (1, 2, 3, etc.) at the beginning of the training.
**ALL AWS resources MUST follow this naming pattern** to avoid confusion and enable proper troubleshooting.

### **Your Student Number**: `X` (Replace X with your assigned number)

---

## 🎯 **DAY 2: OPERATIONAL EXCELLENCE - NAMING STANDARDS**

### **EC2 Instances**
```
Primary Instance: ec2-student1, ec2-student2, ec2-student3...
Web Server: webserver-student1, webserver-student2...
Database Server: dbserver-student1, dbserver-student2...
```

### **Auto Scaling Groups**
```
Web Tier ASG: asg-web-student1, asg-web-student2...
App Tier ASG: asg-app-student1, asg-app-student2...
```

### **Load Balancers**
```
Application Load Balancer: alb-student1, alb-student2...
Network Load Balancer: nlb-student1, nlb-student2...
```

### **CloudWatch Resources**
```
Dashboard: dashboard-student1, dashboard-student2...
Log Group: /aws/ec2/student1, /aws/ec2/student2...
Alarm: alarm-cpu-student1, alarm-memory-student2...
```

### **Lambda Functions**
```
Log Analysis: lambda-loganalysis-student1...
Auto Remediation: lambda-remediation-student2...
Alert Processing: lambda-alerts-student3...
```

### **SNS Topics**
```
Alerts: alerts-student1, alerts-student2...
Notifications: notifications-student1...
```

### **CloudFormation Stacks**
```
Infrastructure: stack-infra-student1...
Monitoring: stack-monitoring-student2...
```

### **IAM Roles**
```
EC2 Role: role-ec2-student1, role-ec2-student2...
Lambda Role: role-lambda-student1...
```

---

## 🚀 **DAY 3: CI/CD & CHAOS ENGINEERING - NAMING STANDARDS**

### **Elastic Beanstalk**
```
Application: ecommerce-student1, ecommerce-student2...
Environment: ecommerce-student1-prod, ecommerce-student2-dev...
```

### **CodeCommit Repositories**
```
Main Repository: app-repo-student1, app-repo-student2...
Config Repository: config-repo-student1...
```

### **CodeBuild Projects**
```
Build Project: build-ecommerce-student1...
Test Project: test-ecommerce-student2...
```

### **CodePipeline**
```
Main Pipeline: pipeline-student1, pipeline-student2...
Deployment Pipeline: deploy-pipeline-student3...
```

### **Target Groups**
```
Blue Environment: tg-blue-student1, tg-blue-student2...
Green Environment: tg-green-student1, tg-green-student2...
```

### **X-Ray Services**
```
Service Name: ecommerce-student1, ecommerce-student2...
```

### **FIS Experiment Templates**
```
CPU Stress: fis-cpu-student1, fis-cpu-student2...
Network Latency: fis-network-student1...
Instance Stop: fis-stop-student2...
```

---

## 📝 **NAMING CONVENTION RULES**

### **Format Pattern**
```
[service-type]-[purpose]-student[X]
```

### **Examples**
- ✅ **Correct**: `ec2-student5`, `alb-student12`, `pipeline-student3`
- ❌ **Incorrect**: `my-instance`, `test-lb`, `pipeline1`

### **Character Rules**
- Use **lowercase letters** only
- Use **hyphens (-)** to separate words
- **No spaces** or special characters
- **No underscores (_)**
- Keep names **under 64 characters**

### **Required Elements**
1. **Service identifier** (ec2, alb, lambda, etc.)
2. **Purpose/function** (optional but recommended)
3. **student[X]** where X is your assigned number

---

## 🎯 **INSTRUCTOR REFERENCE**

### **Student Assignment Template**
```
Student 1: All resources end with -student1
Student 2: All resources end with -student2
Student 3: All resources end with -student3
...
Student N: All resources end with -studentN
```

### **Quick Identification**
- **Filter by student**: Use AWS console filters with "student1", "student2", etc.
- **Troubleshooting**: "Student 5, check your ec2-student5 instance status"
- **Cleanup**: Delete all resources containing "student3" pattern

### **Assessment Benefits**
- **Individual tracking**: Each student's resources clearly identified
- **Progress monitoring**: Check completion by student number
- **Resource accountability**: Students responsible for their numbered resources

---

## 🚨 **CRITICAL REMINDERS**

### **Before Starting Each Project**
1. ✅ **Confirm your student number** with the instructor
2. ✅ **Use your number consistently** across all resources
3. ✅ **Double-check naming** before creating resources
4. ✅ **Ask for help** if unsure about naming

### **During Hands-On Activities**
- **Always include your student number** in resource names
- **Follow the exact naming patterns** provided in guides
- **Don't modify** other students' resources
- **Report naming conflicts** immediately to instructor

### **End of Session Cleanup**
- **Identify your resources** using your student number
- **Delete only your numbered resources**
- **Verify cleanup completion** with instructor

---

## 📊 **BENEFITS OF THIS SYSTEM**

### **For Students**
- ✅ **Clear ownership** of AWS resources
- ✅ **No confusion** about which resources to use
- ✅ **Easy identification** during troubleshooting
- ✅ **Confident resource management**

### **For Instructors**
- ✅ **Quick student assistance** - identify resources instantly
- ✅ **Efficient troubleshooting** - target specific student issues
- ✅ **Easy progress tracking** - monitor individual completion
- ✅ **Simplified cleanup** - filter and delete by student number

### **For Training Success**
- ✅ **Reduced confusion** and time waste
- ✅ **Faster problem resolution**
- ✅ **Higher completion rates**
- ✅ **Professional resource management habits**

---

**Remember**: Consistent naming is crucial for training success. When in doubt, ask your instructor to confirm the correct naming pattern for your student number.
