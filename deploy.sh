#!/bin/bash

# Memory Game S3 Static Website Deployment Script
# Usage: ./deploy.sh <bucket-name> [aws-region] [stack-name] [aws-profile]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
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

# Check if bucket name is provided
if [ -z "$1" ]; then
    print_error "Bucket name is required!"
    echo "Usage: $0 <bucket-name> [aws-region] [stack-name] [aws-profile]"
    echo "Example: $0 my-memory-game-bucket us-east-1 memory-game-stack personal"
    exit 1
fi

# Set variables
BUCKET_NAME="$1"
AWS_REGION="${2:-us-east-1}"
STACK_NAME="${3:-memory-game-hosting-stack}"
AWS_PROFILE="${4:-default}"
TEMPLATE_FILE="deploy.yaml"

# Set AWS profile if specified
if [ "$AWS_PROFILE" != "default" ]; then
    export AWS_PROFILE="$AWS_PROFILE"
    print_status "Using AWS Profile: $AWS_PROFILE"
fi

print_status "Starting deployment of Memory Game to S3..."
print_status "Bucket Name: $BUCKET_NAME"
print_status "AWS Region: $AWS_REGION"
print_status "Stack Name: $STACK_NAME"

# Check if AWS CLI is installed
if ! command -v aws &> /dev/null; then
    print_error "AWS CLI is not installed. Please install it first."
    exit 1
fi

# Check if template file exists
if [ ! -f "$TEMPLATE_FILE" ]; then
    print_error "CloudFormation template file '$TEMPLATE_FILE' not found!"
    exit 1
fi

# Check if game files exist
if [ ! -f "index.html" ]; then
    print_error "Game file 'index.html' not found!"
    exit 1
fi

# Validate CloudFormation template
print_status "Validating CloudFormation template..."
aws cloudformation validate-template \
    --template-body file://$TEMPLATE_FILE \
    --region $AWS_REGION

print_success "Template validation successful!"

# Deploy CloudFormation stack
print_status "Deploying CloudFormation stack..."
aws cloudformation deploy \
    --template-file $TEMPLATE_FILE \
    --stack-name $STACK_NAME \
    --parameter-overrides BucketName=$BUCKET_NAME \
    --capabilities CAPABILITY_IAM \
    --region $AWS_REGION

if [ $? -eq 0 ]; then
    print_success "CloudFormation stack deployed successfully!"
else
    print_error "CloudFormation stack deployment failed!"
    exit 1
fi

# Get stack outputs
print_status "Retrieving stack outputs..."
WEBSITE_URL=$(aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --region $AWS_REGION \
    --query 'Stacks[0].Outputs[?OutputKey==`WebsiteURL`].OutputValue' \
    --output text)

CLOUDFRONT_URL=$(aws cloudformation describe-stacks \
    --stack-name $STACK_NAME \
    --region $AWS_REGION \
    --query 'Stacks[0].Outputs[?OutputKey==`CloudFrontURL`].OutputValue' \
    --output text)

# Upload files to S3
print_status "Uploading game files to S3..."

# Upload main game file
aws s3 cp index.html s3://$BUCKET_NAME/ \
    --content-type "text/html" \
    --region $AWS_REGION

# Upload error page
aws s3 cp error.html s3://$BUCKET_NAME/ \
    --content-type "text/html" \
    --region $AWS_REGION

print_success "Files uploaded successfully!"

# Wait for CloudFront distribution to be deployed (this can take 15-20 minutes)
print_warning "CloudFront distribution is being deployed. This may take 15-20 minutes."
print_warning "You can access the site immediately via S3, but CloudFront will provide better performance."

# Display results
echo ""
echo "🎉 Deployment Complete!"
echo "=================================="
echo "S3 Website URL: $WEBSITE_URL"
echo "CloudFront URL: $CLOUDFRONT_URL"
echo ""
echo "📝 Next Steps:"
echo "1. Test your game at: $WEBSITE_URL"
echo "2. Wait for CloudFront deployment to complete for HTTPS access"
echo "3. Use CloudFront URL for production: $CLOUDFRONT_URL"
echo ""
echo "🔧 Management Commands:"
echo "- Update files: aws s3 sync . s3://$BUCKET_NAME --exclude '*.sh' --exclude '*.yaml'"
echo "- Delete stack: aws cloudformation delete-stack --stack-name $STACK_NAME --region $AWS_REGION"
echo ""

print_success "Memory Game is now live! 🎮"
