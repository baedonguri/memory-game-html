#!/bin/bash

# AWS CLI and credentials check script

set -e

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${GREEN}🔍 Checking AWS CLI setup...${NC}"

# Check AWS CLI installation
if ! command -v aws &> /dev/null; then
    echo -e "${RED}❌ AWS CLI is not installed${NC}"
    echo "Please install AWS CLI: https://aws.amazon.com/cli/"
    exit 1
fi

echo -e "${GREEN}✅ AWS CLI is installed${NC}"
aws --version

# Check AWS credentials
PROFILE=${AWS_PROFILE:-default}
echo -e "${GREEN}🔑 Checking AWS credentials for profile: $PROFILE${NC}"

if aws sts get-caller-identity --profile $PROFILE &> /dev/null; then
    echo -e "${GREEN}✅ AWS credentials are valid${NC}"
    aws sts get-caller-identity --profile $PROFILE --query '{Account:Account,User:Arn}' --output table
else
    echo -e "${RED}❌ AWS credentials are not configured or invalid${NC}"
    echo "Please configure AWS credentials:"
    echo "  aws configure --profile $PROFILE"
    exit 1
fi

echo -e "${GREEN}🎉 AWS setup is ready for deployment!${NC}"
