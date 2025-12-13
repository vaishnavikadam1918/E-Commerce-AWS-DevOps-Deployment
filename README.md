# E-Commerce-AWS-DevOps-Deployment

## 📌 Project Overview
This project demonstrates how to deploy an **E-Commerce Spring Boot Application** on **AWS EC2** with **Amazon RDS** as the database, using **Terraform** for Infrastructure as Code (IaC) and **Jenkins** for CI/CD automation.

It covers:
- Automated infrastructure provisioning using Terraform  
- EC2 deployment of Spring Boot application  
- RDS database provisioning (MySQL/PostgreSQL)  
- Jenkins pipeline for build → test → deploy  
- Artifact handling via S3  
- Secure secret management  

---

## 🏗️ Architecture

Developer → GitHub → Jenkins Pipeline
|
| (Terraform)
v
AWS Infrastructure Provisioning
|
-------------------------------------
| |
EC2 Instance (App) RDS Database (Private)

|| VPC Networking 

## 🚀 Features

### ✔️ Fully automated AWS setup using Terraform
- VPC, Subnets, Route Tables  
- EC2 Instance with user_data startup script  
- RDS Database in private subnets  
- Security groups & IAM roles  
- S3 Remote backend for Terraform state  

### ✔️ Jenkins CI/CD Pipeline
- GitHub webhook triggers build  
- Maven build for Spring Boot  
- Upload JAR to S3 artifact bucket  
- Terraform plan + apply  
- Remote deployment on EC2 (SSH or S3 pull)  

### ✔️ Spring Boot Application Setup
- Runs as a **systemd service**  
- Reads DB credentials securely via SSM or Secrets Manager  

---

## 📂 Project Structure
project-root/
• app/ (Spring Boot Application)
• terraform/
   - main.tf
   - variables.tf
   - backend.tf
   - providers.tf
   - ec2.tf
   - rds.tf
• jenkins/
   - Jenkinsfile
• README.md

---

## ⚙️ Terraform Setup

### Initialize Terraform
```sh
cd terraform
terraform init
terraform plan -var-file=envs/dev.tfvars
terraform apply -var-file=envs/dev.tfvars

## Example Variables
variable "aws_region" { default = "ap-south-1" }
variable "instance_type" { default = "t3.small" }
variable "db_engine" { default = "postgres" }
variable "db_username" {}
variable "db_password" {}

## EC2 User Data Script (Excerpt)
#!/bin/bash
yum update -y
amazon-linux-extras install java-openjdk11 -y
aws s3 cp s3://artifact-bucket/ecommerce-app.jar /opt/app/app.jar

systemctl restart ecommerce
```

## 🔄 Jenkins CI/CD Pipeline
```
Jenkinsfile (Summary)
pipeline {
  agent any
  stages {
    stage('Checkout') { steps { checkout scm } }
    stage('Build') {
      steps {
        dir('app') {
          sh './mvnw clean package -DskipTests'
        }
      }
    }
    stage('Upload to S3') {
      steps {
        sh 'aws s3 cp app/target/*.jar s3://artifact-bucket/app.jar'
      }
    }
    stage('Terraform Apply') {
      steps {
        dir('terraform') {
          sh 'terraform init'
          sh 'terraform apply -auto-approve'
        }
      }
    }
    stage('Deploy to EC2') {
      steps {
        sh 'ssh ec2-user@<EC2-IP> "sudo systemctl restart ecommerce"'
      }
    }
  }
}
```
## 🔐 Secrets & Credentials

Store DB password in AWS SSM Parameter Store (SecureString)

Give EC2 IAM role read access to the parameter

Store AWS keys in Jenkins Credentials Manager

## 🧪 Local Testing
Build locally
cd app
./mvnw clean package
java -jar target/*.jar

## 🛠️ Troubleshooting
| Issue                     | Fix                                      |
| ------------------------- | ---------------------------------------- |
| EC2 cannot connect to RDS | Check SG inbound rules + subnet routes   |
| Terraform state errors    | Verify S3 bucket & DynamoDB table        |
| Jenkins SSH failures      | Update EC2 SG + correct private key      |
| App not starting          | Check logs: `journalctl -u ecommerce -f` |

💰 Cost Considerations
---
Use t3.micro/t3.small for cost-effective EC2

Use db.t3.micro for RDS (free tier eligible)

Shut down dev EC2 when not in use

⭐ Summary
---
This project provides an end-to-end DevOps pipeline that:

Automates AWS infrastructure provisioning

Deploys a Spring Boot application on EC2

Integrates CI/CD using Jenkins

Uses best practices for secrets, networking, and reliability

## ✍️ Author

**Vaishnavi Kadam**  
DevOps & Cloud Enthusiast  
- 🚀 Specializing in AWS, Terraform, Jenkins & CI/CD  
- 💡 Passionate about automation, cloud deployments, and scalable architectures  
- 🌐 GitHub: https://github.com/vaishnavikadam1918 
- 📧 Email: vaishnavikadam8153@gmail.com
