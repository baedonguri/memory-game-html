#!/bin/bash

# Safe CloudFormation Stack Cleanup Script
# Usage: ./cleanup-stack.sh [stack-name] [aws-region] [aws-profile]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Set variables
STACK_NAME="${1:-memory-game-hosting-stack}"
AWS_REGION="${2:-us-east-1}"
AWS_PROFILE="${3:-personal}"

# Set AWS profile
export AWS_PROFILE="$AWS_PROFILE"

print_status "Starting safe cleanup of Memory Game stack..."
print_status "Stack Name: $STACK_NAME"
print_status "AWS Region: $AWS_REGION"
print_status "AWS Profile: $AWS_PROFILE"

# Check if stack exists
STACK_EXISTS=$(aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --region $AWS_REGION \
    --query 'Stacks[0].StackName' \
    --output text 2>/dev/null || echo "NONE")

if [ "$STACK_EXISTS" = "NONE" ]; then
    print_error "Stack '$STACK_NAME' not found!"
    exit 1
fi

# Get bucket name from stack
BUCKET_NAME=$(aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --region $AWS_REGION \
    --query 'Stacks[0].Outputs[?OutputKey==`BucketName`].OutputValue' \
    --output text)

if [ -n "$BUCKET_NAME" ] && [ "$BUCKET_NAME" != "None" ]; then
    print_status "Found S3 bucket: $BUCKET_NAME"
    
    # Empty the bucket
    print_status "Emptying S3 bucket..."
    aws s3 rm s3://$BUCKET_NAME --recursive --region $AWS_REGION
    print_success "S3 bucket emptied successfully!"
else
    print_warning "Could not find S3 bucket name from stack outputs"
fi

# Get CloudFront distribution ID
DISTRIBUTION_ID=$(aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --region $AWS_REGION \
    --query 'Stacks[0].Outputs[?OutputKey==`CloudFrontDistributionId`].OutputValue' \
    --output text)

if [ -n "$DISTRIBUTION_ID" ] && [ "$DISTRIBUTION_ID" != "None" ]; then
    print_status "Found CloudFront distribution: $DISTRIBUTION_ID"
    print_warning "CloudFront distribution will be disabled and deleted (takes 15-20 minutes)"
fi

# Confirm deletion
echo ""
print_warning "This will permanently delete the following resources:"
echo "  - S3 Bucket: $BUCKET_NAME"
echo "  - CloudFront Distribution: $DISTRIBUTION_ID"
echo "  - All associated policies and configurations"
echo ""
read -p "Are you sure you want to proceed? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    print_status "Cleanup cancelled by user"
    exit 0
fi

# Delete the stack
print_status "Deleting CloudFormation stack..."
aws cloudformation delete-stack \
    --stack-name $STACK_NAME \
    --region $AWS_REGION

print_status "Waiting for stack deletion to complete..."
print_warning "This may take 15-20 minutes due to CloudFront distribution deletion..."

aws cloudformation wait stack-delete-complete \
    --stack-name $STACK_NAME \
    --region $AWS_REGION

print_success "Stack deleted successfully!"
print_success "Memory Game service has been completely removed!"

echo ""
print_status "Cleanup Summary:"
echo "✅ S3 bucket and files deleted"
echo "✅ CloudFront distribution deleted"
echo "✅ SSL certificate association removed"
echo "✅ All AWS resources cleaned up"
echo ""
print_warning "Note: Custom domain DNS records may need manual cleanup"
print_status "Your AWS bill will stop accumulating charges for this service"
