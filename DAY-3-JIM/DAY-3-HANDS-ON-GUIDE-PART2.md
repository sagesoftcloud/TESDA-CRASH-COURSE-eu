# Day 3: Hands-on Lab Guide - Advanced Operational Excellence (Part 2)

## Project 3: Advanced Monitoring & Observability (80 minutes)

### Objective
Implement distributed tracing, business metrics, and ML-based anomaly detection for comprehensive observability.

### Scenario
Create a full observability stack that provides insights into application performance, user experience, and business metrics with predictive capabilities.

### Step 1: Implement X-Ray Distributed Tracing (25 minutes)

**1.1 Update Application for X-Ray Integration**
```javascript
// Enhanced app.js with detailed tracing
const express = require('express');
const AWSXRay = require('aws-xray-sdk-core');
const AWS = AWSXRay.captureAWS(require('aws-sdk'));
const app = express();

// X-Ray configuration
AWSXRay.config([
    AWSXRay.plugins.ECSPlugin,
    AWSXRay.plugins.EC2Plugin
]);

app.use(AWSXRay.express.openSegment('microservice-app'));

// Database simulation with tracing
const simulateDatabase = async (query) => {
    const segment = AWSXRay.getSegment();
    const subsegment = segment.addNewSubsegment('database-query');
    
    subsegment.addAnnotation('query_type', query.type);
    subsegment.addMetadata('query_details', query);
    
    try {
        // Simulate database latency
        const latency = Math.random() * 100 + 50;
        await new Promise(resolve => setTimeout(resolve, latency));
        
        subsegment.addMetadata('latency_ms', latency);
        subsegment.close();
        
        return { success: true, data: `Result for ${query.type}` };
    } catch (error) {
        subsegment.close(error);
        throw error;
    }
};

// Enhanced API endpoint with business metrics
app.get('/api/orders', async (req, res) => {
    const segment = AWSXRay.getSegment();
    const subsegment = segment.addNewSubsegment('order-processing');
    
    try {
        // Add custom annotations for filtering
        subsegment.addAnnotation('user_id', req.query.userId || 'anonymous');
        subsegment.addAnnotation('order_type', req.query.type || 'standard');
        
        // Simulate business logic
        const orderData = await simulateDatabase({
            type: 'order_lookup',
            userId: req.query.userId
        });
        
        // Business metrics
        const orderValue = Math.random() * 1000 + 100;
        subsegment.addMetadata('business_metrics', {
            order_value: orderValue,
            processing_time: Date.now() - req.startTime
        });
        
        // Send custom metrics to CloudWatch
        const cloudwatch = new AWS.CloudWatch();
        await cloudwatch.putMetricData({
            Namespace: 'ECommerce/Business',
            MetricData: [
                {
                    MetricName: 'OrderValue',
                    Value: orderValue,
                    Unit: 'None',
                    Dimensions: [
                        {
                            Name: 'OrderType',
                            Value: req.query.type || 'standard'
                        }
                    ]
                },
                {
                    MetricName: 'OrderCount',
                    Value: 1,
                    Unit: 'Count'
                }
            ]
        }).promise();
        
        subsegment.close();
        res.json({
            success: true,
            order: orderData,
            value: orderValue,
            timestamp: new Date().toISOString()
        });
        
    } catch (error) {
        subsegment.close(error);
        res.status(500).json({ error: 'Order processing failed' });
    }
});

// User experience tracking
app.get('/api/user-experience', (req, res) => {
    const segment = AWSXRay.getSegment();
    const subsegment = segment.addNewSubsegment('user-experience-tracking');
    
    // Simulate user experience metrics
    const metrics = {
        page_load_time: Math.random() * 2000 + 500,
        time_to_interactive: Math.random() * 3000 + 1000,
        first_contentful_paint: Math.random() * 1500 + 300
    };
    
    subsegment.addMetadata('ux_metrics', metrics);
    subsegment.close();
    
    res.json(metrics);
});

app.use(AWSXRay.express.closeSegment());
```

**1.2 Create X-Ray Service Map Configuration**
```bash
# Create X-Ray sampling rule
cat > sampling-rule.json << 'EOF'
{
    "version": 2,
    "default": {
        "fixed_target": 1,
        "rate": 0.1
    },
    "rules": [
        {
            "description": "High-value orders sampling",
            "service_name": "microservice-app",
            "http_method": "GET",
            "url_path": "/api/orders",
            "fixed_target": 2,
            "rate": 0.5
        }
    ]
}
EOF

# Create sampling rule
aws xray create-sampling-rule --sampling-rule file://sampling-rule.json
```

### Step 2: Create Business Metrics Dashboard (20 minutes)

**2.1 Advanced CloudWatch Dashboard**
```json
{
    "widgets": [
        {
            "type": "metric",
            "properties": {
                "metrics": [
                    ["ECommerce/Business", "OrderValue", "OrderType", "standard"],
                    [".", ".", ".", "premium"],
                    [".", "OrderCount"]
                ],
                "period": 300,
                "stat": "Sum",
                "region": "us-east-1",
                "title": "Business Metrics - Revenue & Orders"
            }
        },
        {
            "type": "metric",
            "properties": {
                "metrics": [
                    ["AWS/X-Ray", "TracesReceived"],
                    [".", "LatencyHigh", "ServiceName", "microservice-app"],
                    [".", "ErrorRate", ".", "."]
                ],
                "period": 300,
                "stat": "Average",
                "region": "us-east-1",
                "title": "Application Performance (X-Ray)"
            }
        },
        {
            "type": "log",
            "properties": {
                "query": "SOURCE '/aws/ecs/microservice-app'\n| fields @timestamp, @message\n| filter @message like /ERROR/\n| sort @timestamp desc\n| limit 20",
                "region": "us-east-1",
                "title": "Recent Errors",
                "view": "table"
            }
        }
    ]
}
```

**2.2 Create Custom Metrics for SLA Tracking**
```bash
# Create SLA tracking script
cat > sla-tracker.sh << 'EOF'
#!/bin/bash

while true; do
    # Check application availability
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://your-load-balancer/health)
    
    if [ "$RESPONSE" = "200" ]; then
        AVAILABILITY=1
    else
        AVAILABILITY=0
    fi
    
    # Send availability metric
    aws cloudwatch put-metric-data \
        --namespace "ECommerce/SLA" \
        --metric-data \
        MetricName=Availability,Value=$AVAILABILITY,Unit=None
    
    # Check response time
    RESPONSE_TIME=$(curl -s -o /dev/null -w "%{time_total}" http://your-load-balancer/api/data)
    RESPONSE_TIME_MS=$(echo "$RESPONSE_TIME * 1000" | bc)
    
    # Send response time metric
    aws cloudwatch put-metric-data \
        --namespace "ECommerce/SLA" \
        --metric-data \
        MetricName=ResponseTime,Value=$RESPONSE_TIME_MS,Unit=Milliseconds
    
    sleep 60
done
EOF

chmod +x sla-tracker.sh
nohup ./sla-tracker.sh &
```

### Step 3: Implement ML-Based Anomaly Detection (20 minutes)

**3.1 Create Anomaly Detection Alarms**
```bash
# Create anomaly detector for order volume
aws cloudwatch put-anomaly-detector \
    --namespace "ECommerce/Business" \
    --metric-name "OrderCount" \
    --stat "Sum"

# Create anomaly alarm
aws cloudwatch put-metric-alarm \
    --alarm-name "OrderVolume-AnomalyDetection" \
    --alarm-description "Detect anomalies in order volume" \
    --actions-enabled \
    --alarm-actions "arn:aws:sns:region:account:anomaly-alerts" \
    --metric-name "OrderCount" \
    --namespace "ECommerce/Business" \
    --statistic "Sum" \
    --period 300 \
    --evaluation-periods 2 \
    --threshold-metric-id "m1" \
    --comparison-operator "LessThanLowerOrGreaterThanUpperThreshold" \
    --metrics '[
        {
            "Id": "m1",
            "MetricStat": {
                "Metric": {
                    "Namespace": "ECommerce/Business",
                    "MetricName": "OrderCount"
                },
                "Period": 300,
                "Stat": "Sum"
            }
        },
        {
            "Id": "ad1",
            "Expression": "ANOMALY_DETECTION_FUNCTION(m1, 2)"
        }
    ]'
```

**3.2 Create Lambda Function for Advanced Analytics**
```python
import json
import boto3
import numpy as np
from datetime import datetime, timedelta

def lambda_handler(event, context):
    cloudwatch = boto3.client('cloudwatch')
    
    # Get metrics for the last 24 hours
    end_time = datetime.utcnow()
    start_time = end_time - timedelta(hours=24)
    
    # Fetch order metrics
    response = cloudwatch.get_metric_statistics(
        Namespace='ECommerce/Business',
        MetricName='OrderCount',
        Dimensions=[],
        StartTime=start_time,
        EndTime=end_time,
        Period=3600,  # 1 hour periods
        Statistics=['Sum']
    )
    
    # Analyze trends
    datapoints = sorted(response['Datapoints'], key=lambda x: x['Timestamp'])
    values = [dp['Sum'] for dp in datapoints]
    
    if len(values) >= 2:
        # Calculate trend
        trend = np.polyfit(range(len(values)), values, 1)[0]
        
        # Calculate moving average
        if len(values) >= 4:
            moving_avg = np.mean(values[-4:])  # Last 4 hours average
        else:
            moving_avg = np.mean(values)
        
        # Send trend metrics
        cloudwatch.put_metric_data(
            Namespace='ECommerce/Analytics',
            MetricData=[
                {
                    'MetricName': 'OrderTrend',
                    'Value': trend,
                    'Unit': 'None'
                },
                {
                    'MetricName': 'OrderMovingAverage',
                    'Value': moving_avg,
                    'Unit': 'Count'
                }
            ]
        )
        
        # Generate insights
        insights = {
            'trend': 'increasing' if trend > 0 else 'decreasing',
            'trend_strength': abs(trend),
            'moving_average': moving_avg,
            'recommendation': generate_recommendation(trend, moving_avg)
        }
        
        return {
            'statusCode': 200,
            'body': json.dumps(insights)
        }
    
    return {
        'statusCode': 200,
        'body': json.dumps({'message': 'Insufficient data for analysis'})
    }

def generate_recommendation(trend, moving_avg):
    if trend > 5 and moving_avg > 100:
        return "High growth detected. Consider scaling infrastructure."
    elif trend < -5 and moving_avg < 50:
        return "Declining orders. Review marketing campaigns."
    else:
        return "Normal operation. Continue monitoring."
```

### Step 4: Create Operational Runbooks (15 minutes)

**4.1 Automated Incident Response Runbook**
```yaml
# incident-response-runbook.yml
schemaVersion: '0.3'
description: 'Automated incident response for microservice application'
assumeRole: '{{ AutomationAssumeRole }}'
parameters:
  InstanceId:
    type: String
    description: 'EC2 instance ID experiencing issues'
  AutomationAssumeRole:
    type: String
    description: 'IAM role for automation execution'

mainSteps:
  - name: CheckInstanceHealth
    action: 'aws:executeAwsApi'
    inputs:
      Service: ec2
      Api: DescribeInstanceStatus
      InstanceIds:
        - '{{ InstanceId }}'
    outputs:
      - Name: InstanceStatus
        Selector: '$.InstanceStatuses[0].InstanceStatus.Status'
        Type: String

  - name: RestartApplicationIfUnhealthy
    action: 'aws:runCommand'
    precondition:
      StringEquals:
        - '{{ CheckInstanceHealth.InstanceStatus }}'
        - 'impaired'
    inputs:
      DocumentName: 'AWS-RunShellScript'
      InstanceIds:
        - '{{ InstanceId }}'
      Parameters:
        commands:
          - 'sudo systemctl restart docker'
          - 'docker restart $(docker ps -q)'
          - 'sleep 30'
          - 'curl -f http://localhost:3000/health || exit 1'

  - name: ScaleOutIfNeeded
    action: 'aws:executeAwsApi'
    inputs:
      Service: ecs
      Api: UpdateService
      cluster: 'microservice-cluster'
      service: 'microservice-service'
      desiredCount: 4

  - name: NotifyOperationsTeam
    action: 'aws:executeAwsApi'
    inputs:
      Service: sns
      Api: Publish
      TopicArn: 'arn:aws:sns:region:account:ops-notifications'
      Message: 'Automated incident response completed for {{ InstanceId }}'
```

**4.2 Create Systems Manager Document**
```bash
# Create the automation document
aws ssm create-document \
    --name "IncidentResponseRunbook" \
    --document-type "Automation" \
    --document-format "YAML" \
    --content file://incident-response-runbook.yml
```

---

## Final Assessment & Integration (20 minutes)

### Comprehensive Project Integration

**Integration Challenge**: Combine all three projects into a cohesive operational excellence solution.

### Step 1: End-to-End Testing (10 minutes)

**1.1 Deployment Pipeline Test**
```bash
# Trigger full CI/CD pipeline
git add .
git commit -m "feat: Add advanced monitoring and chaos engineering"
git push origin main

# Monitor pipeline execution
aws codepipeline get-pipeline-state --name microservice-pipeline
```

**1.2 Chaos Engineering Validation**
```bash
# Run chaos experiment during deployment
aws fis start-experiment --experiment-template-id $CHAOS_EXPERIMENT_ID

# Validate system resilience
curl -s http://your-load-balancer/health | jq .
```

### Step 2: Operational Excellence Assessment (10 minutes)

**Assessment Checklist**:

**CI/CD Pipeline (25 points)**
- [ ] Automated testing passes (5 points)
- [ ] Blue-green deployment successful (10 points)
- [ ] Monitoring integrated in pipeline (5 points)
- [ ] Rollback capability demonstrated (5 points)

**Chaos Engineering (25 points)**
- [ ] Fault injection experiments created (10 points)
- [ ] System resilience validated (10 points)
- [ ] Recovery procedures automated (5 points)

**Advanced Monitoring (25 points)**
- [ ] Distributed tracing implemented (10 points)
- [ ] Business metrics tracked (5 points)
- [ ] Anomaly detection configured (5 points)
- [ ] Operational runbooks automated (5 points)

**Knowledge Assessment (25 points)**
- [ ] Operational excellence principles explained (10 points)
- [ ] Best practices demonstrated (10 points)
- [ ] Future improvements identified (5 points)

### Knowledge Check Quiz

**Question 1**: What are the key benefits of blue-green deployment?
- A) Faster deployments
- B) Zero-downtime deployments and easy rollback
- C) Reduced infrastructure costs
- D) Better security

**Question 2**: What is the primary goal of chaos engineering?
- A) To break production systems
- B) To test system resilience and build confidence
- C) To reduce operational costs
- D) To improve development speed

**Question 3**: Which AWS service provides distributed tracing?
- A) CloudWatch
- B) CloudTrail
- C) X-Ray
- D) Config

**Question 4**: What triggers an anomaly detection alarm?
- A) Fixed thresholds
- B) Machine learning models detecting unusual patterns
- C) Manual intervention
- D) Scheduled events

**Question 5**: What is the benefit of Infrastructure as Code?
- A) Faster manual deployments
- B) Consistent, repeatable, and version-controlled infrastructure
- C) Reduced cloud costs
- D) Better application performance

### Answers:
1. B, 2. B, 3. C, 4. B, 5. B

---

## Certification Preparation & Next Steps

### AWS Certification Paths
1. **AWS Certified DevOps Engineer - Professional**
   - Focus: CI/CD, monitoring, automation
   - Preparation: Practice labs, whitepapers, sample exams

2. **AWS Certified Solutions Architect - Professional**
   - Focus: Advanced architecture patterns
   - Preparation: Design complex solutions, cost optimization

### Recommended Study Resources
- AWS Well-Architected Framework
- AWS DevOps whitepapers
- Chaos Engineering principles
- Site Reliability Engineering practices

### Continuous Learning Path
1. **Week 1-2**: Review and practice all lab exercises
2. **Week 3-4**: Study AWS certification materials
3. **Month 2**: Build personal projects using learned concepts
4. **Month 3**: Take practice exams and schedule certification

### Industry Best Practices to Explore
- GitOps workflows
- Observability-driven development
- Platform engineering
- FinOps (Financial Operations)

---

## Troubleshooting Guide

### Common Issues and Solutions

**CI/CD Pipeline Failures**
- Check IAM permissions for all services
- Verify buildspec.yml syntax
- Review CloudWatch Logs for detailed errors

**Chaos Engineering Experiments Not Starting**
- Verify FIS service role permissions
- Check stop conditions and alarms
- Ensure target resources exist and are tagged correctly

**X-Ray Traces Not Appearing**
- Verify X-Ray daemon is running
- Check IAM permissions for X-Ray
- Validate sampling rules configuration

**Anomaly Detection Not Working**
- Ensure sufficient historical data (minimum 2 weeks)
- Check metric namespace and names
- Verify CloudWatch permissions

### Support Resources
- AWS Documentation: https://docs.aws.amazon.com/
- AWS Well-Architected Tool: https://aws.amazon.com/well-architected-tool/
- AWS Training and Certification: https://aws.amazon.com/training/

**Congratulations!** You've completed the advanced operational excellence training. You now have the skills to build, deploy, and operate resilient systems at enterprise scale.
