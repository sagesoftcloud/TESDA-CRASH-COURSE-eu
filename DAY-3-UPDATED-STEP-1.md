# 🚀 Day 3 - Updated Step 1: Fork and Setup Sample Web Application (5 minutes)

## 🎯 **MUCH FASTER APPROACH - No More Coding from Scratch!**

Instead of spending 15 minutes creating code, students will **fork and clone** a pre-built, tested application.

---

## 📋 **Prerequisites (Amazon Linux 2023)**

### **Install Required Tools**
```bash
# Update system
sudo dnf update -y

# Install Node.js 18 (required for Beanstalk)
sudo dnf install -y nodejs npm

# Install Git
sudo dnf install -y git

# Verify installations
node --version    # Should show v18.x.x or higher
npm --version     # Should show 9.x.x or higher  
git --version     # Should show git version
```

---

## 🔄 **Step 1: Fork and Clone Sample Application (5 minutes)**

### **1.1 Fork the Sample Repository**
```
🖥️ VISUAL: GitHub Browser
📍 Go to: https://github.com/YOUR_ORG/ecommerce-beanstalk-sample
📍 Click "Fork" button (top right)
📍 Select your GitHub account
📍 Click "Create fork"
✅ You now have your own copy of the sample app!
```

### **1.2 Clone Your Fork**
```bash
# Clone your forked repository (replace YOUR_USERNAME)
git clone https://github.com/YOUR_USERNAME/ecommerce-beanstalk-sample.git

# Navigate to the project
cd ecommerce-beanstalk-sample

# Check the files
ls -la
# You should see:
# - package.json (Node.js dependencies)
# - app.js (main application)
# - views/ (HTML templates)
# - app.test.js (test suite)
# - buildspec.yml (AWS CodeBuild config)
# - README.md (documentation)
```

### **1.3 Quick Application Test**
```bash
# Run the quick test script
./quick-test.sh

# This will:
# ✅ Check Node.js and npm versions
# ✅ Install all dependencies
# ✅ Run automated tests
# ✅ Start the application for manual testing
```

### **1.4 Manual Verification**
```
🖥️ VISUAL: Open Browser
📍 Go to: http://localhost:3000
✅ You should see: "TESDA E-commerce Demo" homepage
✅ Beautiful dashboard with product stats
✅ Interactive API test buttons

📍 Test the APIs by clicking buttons:
✅ "Test Health" - Should show healthy status
✅ "Test Products" - Should show product list
✅ "Test Metrics" - Should show business metrics
```

### **1.5 Stop Local Testing**
```bash
# Press Ctrl+C to stop the application
# You'll see: "Server stopped"
```

---

## 🎯 **What You Just Got (Instead of 15 minutes of coding)**

### **Complete E-commerce Application**
- ✅ **6 Products** - Laptops, phones, clothing, etc.
- ✅ **Order System** - Create and track orders
- ✅ **Business Metrics** - Revenue, conversion rates
- ✅ **Health Checks** - Application monitoring endpoints
- ✅ **Error Handling** - Professional 404 pages
- ✅ **Responsive Design** - Beautiful, modern UI

### **AWS-Ready Configuration**
- ✅ **package.json** - Optimized for Beanstalk Node.js 18
- ✅ **buildspec.yml** - CodeBuild automation ready
- ✅ **Health endpoint** - `/health` for load balancer checks
- ✅ **Environment variables** - Production-ready configuration
- ✅ **Error logging** - Structured application logs

### **Professional Testing**
- ✅ **10 Automated Tests** - All API endpoints covered
- ✅ **Jest Framework** - Industry-standard testing
- ✅ **100% Test Coverage** - Every feature tested
- ✅ **CI/CD Ready** - Tests run in CodeBuild pipeline

---

## 🚀 **Ready for AWS Deployment**

Your application is now ready for:

### **Next Steps (Remaining Day 3)**
1. **Create CodeCommit Repository** - Push your code
2. **Setup Elastic Beanstalk** - Deploy the application  
3. **Build CI/CD Pipeline** - Automate deployments
4. **Implement Chaos Engineering** - Test resilience
5. **Add Advanced Monitoring** - X-Ray tracing

### **Time Saved**
- ❌ **Old approach**: 15 minutes coding + debugging
- ✅ **New approach**: 5 minutes fork + clone + test
- 🎯 **Result**: 10 extra minutes for AWS learning!

---

## 🔧 **Troubleshooting**

### **If Node.js Version is Wrong**
```bash
# Check version
node --version

# If < 18.x, reinstall
sudo dnf remove nodejs npm
sudo dnf install nodejs npm
node --version  # Should now show 18.x
```

### **If Git Clone Fails**
```bash
# Make sure you forked the repository first
# Check your GitHub username is correct in the URL
# Ensure you have internet connection
```

### **If Tests Fail**
```bash
# Make sure no other app is running on port 3000
sudo lsof -ti:3000 | xargs kill -9

# Clear npm cache and reinstall
rm -rf node_modules package-lock.json
npm install
npm test
```

### **If Application Won't Start**
```bash
# Check for port conflicts
netstat -tulpn | grep :3000

# Try different port
PORT=3001 npm start
```

---

## ✅ **Success Checklist**

Before proceeding to AWS deployment:

- [ ] ✅ Repository forked and cloned successfully
- [ ] ✅ `npm install` completed without errors
- [ ] ✅ All 10 tests pass with `npm test`
- [ ] ✅ Application starts with `npm start`
- [ ] ✅ Homepage loads at http://localhost:3000
- [ ] ✅ All API test buttons work
- [ ] ✅ Health check returns "healthy" status

---

## 🎓 **Learning Benefits**

### **Professional Workflow**
- ✅ **Real-world approach** - Developers fork existing projects
- ✅ **Version control** - Proper Git workflow
- ✅ **Code review ready** - Professional repository structure
- ✅ **Team collaboration** - Multiple developers can work on forks

### **Focus on AWS Skills**
- ✅ **More time for CI/CD** - Skip application development
- ✅ **Operational excellence** - Focus on deployment and monitoring
- ✅ **Cloud-native practices** - Learn AWS services, not coding syntax
- ✅ **Professional deployment** - Real-world application architecture

---

**🎯 Ready to deploy to AWS? You now have a production-ready application in just 5 minutes!**

**Next: Step 2 - Create Elastic Beanstalk Application (20 minutes)**
