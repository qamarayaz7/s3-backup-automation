# Automated S3 Backup

## Overview
This project automatically backs up files from a **source S3 bucket** to a **destination S3 bucket** using **AWS Lambda** and **Terraform**.  
The Lambda function runs **daily** using an **EventBridge scheduler** and copies all files from the source bucket to the destination bucket.

---

## 🛠 Tech Stack
- **AWS S3** → Source and destination buckets  
- **AWS Lambda** → Serverless function for backup  
- **IAM** → Role and policy with least privilege  
- **EventBridge** → Schedule Lambda daily  
- **Terraform** → Infrastructure as code  

---

## ⚡ How It Works
1. Terraform provisions:
   - IAM role & policy
   - Lambda function
   - EventBridge rule and permission
2. Lambda reads all files from the source bucket
3. Copies them to the destination bucket
4. Versioning ensures previous files are kept
5. EventBridge triggers Lambda **every 24 hours**

---

## 🔧 Deployment (Local)
1. Install Terraform
2. Configure AWS CLI with your credentials
3. Zip the Lambda code:
   ```bash
   Compress-Archive -Path lambda_function.py -DestinationPath lambda_function.zip

## Run Terraform:

terraform init
terraform plan
terraform apply

## 🧪 Testing

Manual Test: Trigger the Lambda function in AWS console to immediately copy files

Scheduled Test: Wait for EventBridge to run daily

## 📁 Folder Structure
uptime-monitor-pro/
├── lambda_function.py
├── lambda_function.zip
├── main.tf
├── providers.tf
├── README.md
└── .gitignore

## 💡 Notes

Buckets have versioning enabled and public access blocked

Lambda runs with least privilege IAM role

Future improvements:

CloudWatch alerts on failure

CI/CD integration for automatic deployments

## dummy triggers

echo "dummy trigger to push"