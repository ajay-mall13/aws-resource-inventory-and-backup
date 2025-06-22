#!/bin/bash


###############################################################################
# AWS Resource Inventory Script
# --------------------------------------------
# Description : Automates the daily listing of all AWS resources in the account,
#               saves the output as a JSON file, and uploads it to an S3 bucket for backup.
# Author      : Ajay Mall
# Requirements: AWS CLI configured with proper IAM permissions

# Below are the services that are supported by this script:
# 1. EC2
# 2. RDS
# 3. S3
# 4. CloudFront
# 5. VPC
# 6. IAM
# 7. Route53
# 8. CloudWatch
# 9. CloudFormation
# 10. Lambda
# 11. SNS
# 12. SQS
# 13. DynamoDB
# 14. VPC
# 15. EBS
#
# The script will prompt the user to enter the AWS region and the service for which the resources need to be listed.
#
# Usage: ./aws_resource_list.sh  <aws_region> <aws_service>
# Example: ./aws_resource_list.sh us-east-1 ec2
#############################################################################



# Check input arguments
if [ $# -ne 2 ]; then
    echo "Usage: ./ajju2.sh <aws_region> <aws_service>"
    exit 1
fi

aws_region=$1
aws_service=$2
today=$(date '+%Y-%m-%d')

# Folder to store daily backups
output_dir="/home/ubuntu/aws_resource_backups"
mkdir -p "$output_dir"

# File to save output
output_file="${output_dir}/${aws_service}_${aws_region}_${today}.json"

# S3 bucket (replace this with your actual bucket)
s3_bucket="your-s3-bucket-name"
s3_path="s3://${s3_bucket}/aws_backups/"


echo "Listing $aws_service resources in $aws_region..."
echo "Saving output to $output_file"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    echo "AWS CLI is not installed. Please install the AWS CLI and try again."
    exit 1
fi

# Check if AWS CLI is configured
if [ ! -d ~/.aws ]; then
    echo "AWS CLI is not configured. Please configure the AWS CLI and try again."
    exit 1
fi

# Fetch and store AWS resource output
case $aws_service in
    ec2)
        echo "Listing EC2 Instances in $aws_region"
        aws ec2 describe-instances --region "$aws_region" > "$output_file"
        ;;
    rds)
        echo "Listing RDS Instances in $aws_region"
        aws rds describe-db-instances --region "$aws_region" > "$output_file"
        ;;
    s3)
        echo "Listing S3 Buckets (S3 is global)"
        aws s3api list-buckets > "$output_file"
        ;;
    cloudfront)
        echo "Listing CloudFront Distributions (CloudFront is global)"
        aws cloudfront list-distributions > "$output_file"
        ;;
    vpc)
        echo "Listing VPCs in $aws_region"
        aws ec2 describe-vpcs --region "$aws_region" > "$output_file"
        ;;
    iam)
        echo "Listing IAM Users (IAM is global)"
        aws iam list-users > "$output_file"
        ;;
    route53)
        echo "Listing Route53 Hosted Zones (Route53 is global)"
        aws route53 list-hosted-zones > "$output_file"
        ;;
    cloudwatch)
        echo "Listing CloudWatch Alarms in $aws_region"
        aws cloudwatch describe-alarms --region "$aws_region" > "$output_file"
        ;;
    cloudformation)
        echo "Listing CloudFormation Stacks in $aws_region"
        aws cloudformation describe-stacks --region "$aws_region" > "$output_file"
        ;;
    lambda)
        echo "Listing Lambda Functions in $aws_region"
        aws lambda list-functions --region "$aws_region" > "$output_file"
        ;;
    sns)
        echo "Listing SNS Topics in $aws_region"
        aws sns list-topics --region "$aws_region" > "$output_file"
        ;;
    sqs)
        echo "Listing SQS Queues in $aws_region"
        aws sqs list-queues --region "$aws_region" > "$output_file"
        ;;
    dynamodb)
        echo "Listing DynamoDB Tables in $aws_region"
        aws dynamodb list-tables --region "$aws_region" > "$output_file"
        ;;
    ebs)
        echo "Listing EBS Volumes in $aws_region"
        aws ec2 describe-volumes --region "$aws_region" > "$output_file"
        ;;
    *)
        echo "Invalid service. Please enter a valid service name like ec2, rds, s3, etc."
        exit 1
        ;;
esac

# Final status
if [ -s "$output_file" ]; then
    echo "✅ Output saved successfully to $output_file"
else
    echo "⚠️  Output file is empty (no resources found)"
fi

# Sync to S3
echo "☁️ Syncing backup directory to $s3_path ..."
aws s3 sync "$output_dir" "$s3_path"

if [ $? -eq 0 ]; then
    echo "✅ Sync to S3 completed successfully"
else
    echo "❌ Sync to S3 failed"
fi
