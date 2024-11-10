# EC2 Deployment with CloudWatch Monitoring and SNS Alerts Using Terraform
This project automates the deployment of an EC2 instance on AWS with monitoring and alerting set up via CloudWatch and SNS using Terraform. The configuration includes:

* Custom VPC and Subnet: Sets up a new VPC and subnet to host the EC2 instance.
* EC2 Instance: Launches an instance based on a specified AMI, instance type, and key pair, with a security group allowing SSH access.
* CloudWatch Monitoring: Configures a CloudWatch alarm that triggers when the CPU utilization exceeds 70%.
* SNS Alerts: Sets up an SNS topic and email subscription to send alerts when the CloudWatch alarm is triggered.
* CPU Utilization Dashboard: Provides a CloudWatch dashboard to monitor the instance’s CPU utilization.
## Files in this Repository
* main.tf: Sets up the Terraform AWS provider.
* resource.tf: Contains the definitions for all AWS resources, including the VPC, subnet, EC2 instance, CloudWatch, and SNS configurations.
* variables.tf: Defines input variables like AMI ID, instance type, and key pair, allowing flexibility in resource configurations.
* outputs.tf: Displays the public IP of the EC2 instance upon deployment completion.
## Getting Started
* Customize variables.tf with your preferred AMI, instance type, and key pair.
* Initialize, plan, and apply the configuration using Terraform commands.
* After deployment, monitor the CloudWatch dashboard for CPU usage, and receive SNS alerts if the utilization exceeds the set threshold.
## This project serves as a straightforward way to deploy an EC2 instance with essential monitoring and alerting features, providing valuable infrastructure insights and automated notifications on AWS.
