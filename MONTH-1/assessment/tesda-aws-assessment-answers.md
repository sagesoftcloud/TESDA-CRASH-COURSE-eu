# TESDA AWS Cloud Fundamentals Assessment - Answer Key
## Correct Answers with Explanations

---

## Question 1: **Answer B**
**Correct:** It allows centralized management and billing of multiple AWS accounts

**Explanation:** AWS Organizations enables TESDA to manage multiple AWS accounts from a central location, providing consolidated billing, centralized policy management, and organizational structure. This is essential for government agencies that need clear separation between departments while maintaining centralized oversight and cost control.

---

## Question 2: **Answer C**
**Correct:** Physical security of data centers

**Explanation:** In the AWS Shared Responsibility Model, AWS is responsible for "security OF the cloud" - including physical infrastructure, network infrastructure, and hypervisor security. Customers are responsible for "security IN the cloud" - including data encryption, IAM configuration, and application security.

---

## Question 3: **Answer B**
**Correct:** Multi-Factor Authentication

**Explanation:** MFA adds an extra layer of security by requiring users to provide two or more verification factors (something you know + something you have). This is critical for government agencies like TESDA to protect against 99.9% of account compromises that occur due to password-only authentication.

---

## Question 4: **Answer B**
**Correct:** AWS IAM Identity Center

**Explanation:** AWS IAM Identity Center (formerly AWS SSO) provides centralized single sign-on access to multiple AWS accounts and applications. It integrates with existing identity providers like Active Directory and enables users to access all authorized systems with one login.

---

## Question 5: **Answer A**
**Correct:** Users are for people, Roles are for AWS services and temporary access

**Explanation:** IAM Users represent individual people with long-term credentials. IAM Roles are for temporary access scenarios - AWS services accessing other services, cross-account access, or federated users. Roles don't have permanent credentials and are assumed when needed.

---

## Question 6: **Answer B**
**Correct:** To define what actions are allowed or denied in AWS accounts

**Explanation:** Service Control Policies (SCPs) act as guardrails that define the maximum permissions for accounts in an organization. They prevent accounts from performing certain actions, helping enforce compliance and prevent costly mistakes across the organization.

---

## Question 7: **Answer B**
**Correct:** A container for grouping AWS accounts

**Explanation:** Organizational Units (OUs) are logical containers that help organize AWS accounts within an organization. They enable you to group accounts by function, department, or environment and apply policies consistently across groups of accounts.

---

## Question 8: **Answer B**
**Correct:** You receive one bill for all accounts in the organization

**Explanation:** Consolidated billing combines usage across all accounts in the organization into a single bill, often resulting in volume discounts. It simplifies financial management and provides better visibility into organizational spending patterns.

---

## Question 9: **Answer B**
**Correct:** Principle of Least Privilege - give minimum access needed

**Explanation:** The Principle of Least Privilege is a fundamental security concept that grants users only the minimum access necessary to perform their job functions. This reduces the risk of accidental or malicious actions and limits the potential impact of security breaches.

---

## Question 10: **Answer C**
**Correct:** Monitoring and recording AWS resource configurations

**Explanation:** AWS Config continuously monitors and records the configuration of AWS resources, evaluates them against desired configurations, and provides compliance reporting. This is essential for government agencies that need to demonstrate compliance with security and regulatory requirements.

---

## Question 11: **Answer C**
**Correct:** Management Account

**Explanation:** AWS updated terminology in 2020 to use "Management Account" instead of "Master Account" for more inclusive language. The management account is the AWS account used to create the organization and has administrative control over all member accounts.

---

## Question 12: **Answer B**
**Correct:** Audit logs of all API calls and user activities

**Explanation:** AWS CloudTrail provides detailed audit logs of all API calls made in AWS accounts, including who made the call, when, and from where. This is crucial for government compliance, security monitoring, and forensic analysis of account activities.

---

## Question 13: **Answer B**
**Correct:** Templates that define what AWS permissions users get

**Explanation:** Permission Sets in IAM Identity Center are reusable templates that define a collection of AWS permissions. They can be assigned to users or groups across multiple AWS accounts, providing consistent role-based access control across the organization.

---

## Question 14: **Answer B**
**Correct:** A security model that verifies every user and device

**Explanation:** Zero Trust Architecture operates on the principle "never trust, always verify." It requires verification for every user, device, and network connection attempting to access resources, regardless of their location or previous authentication status.

---

## Question 15: **Answer C**
**Correct:** Immediately disable/delete their access across all systems

**Explanation:** When an employee leaves, their access should be immediately revoked across all systems to prevent unauthorized access. This is a critical security practice that prevents former employees from accessing sensitive data or systems after their employment ends.

---

## Question 16: **Answer B**
**Correct:** It provides isolation and separation between environments

**Explanation:** Multi-account strategy provides strong isolation boundaries between different environments (production, development, testing) and departments. This prevents accidental cross-contamination, improves security, and enables better cost allocation and governance.

---

## Question 17: **Answer B**
**Correct:** Implementing multiple layers of security controls

**Explanation:** Defense in Depth is a security strategy that uses multiple layers of security controls to protect resources. If one layer fails, other layers continue to provide protection. This approach is essential for government agencies handling sensitive data.

---

## Question 18: **Answer B**
**Correct:** A dynamic value that changes based on the user context

**Explanation:** Policy variables like ${aws:username} or ${saml:Department} allow policies to dynamically adapt based on the requesting user's context. This enables scalable, flexible policies that work for many users without creating individual policies for each person.

---

## Question 19: **Answer B**
**Correct:** Having complete audit trails and access controls

**Explanation:** For government agencies like TESDA, compliance requires comprehensive audit trails, proper access controls, and the ability to demonstrate security measures to auditors. This is more important than cost optimization or technical features for meeting regulatory requirements.

---

## Question 20: **Answer C**
**Correct:** Establish governance framework and security policies

**Explanation:** Before implementing any cloud services, organizations should establish governance frameworks that define security policies, compliance requirements, and operational procedures. This foundation ensures that all subsequent technical implementations align with organizational needs and regulatory requirements.

---

## Scoring Guide:
- **18-20 correct (90-100%):** Excellent understanding - Ready for implementation
- **14-17 correct (70-85%):** Good understanding - Minor review needed
- **10-13 correct (50-65%):** Basic understanding - Additional training recommended
- **Below 10 correct (<50%):** Needs comprehensive review before proceeding

## Key Learning Areas by Score:
**If scored low on questions 1-8:** Review AWS Organizations and basic IAM concepts
**If scored low on questions 9-16:** Focus on security best practices and Identity Center
**If scored low on questions 17-20:** Study governance and compliance frameworks
