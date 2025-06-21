#!/bin/bash

# Load environment variables from .env file if it exists

if [ -f .env ]; then
    echo "📄 Loading environment variables from .env file..."
    
    # Load and export environment variables
    set -a  # automatically export all variables
    source .env
    set +a  # stop automatically exporting
    
    echo "✅ Environment variables loaded"
    echo "   AWS_PROFILE: ${AWS_PROFILE:-default}"
    echo "   AWS_REGION: ${AWS_REGION:-us-east-1}"
    echo "   STACK_NAME: ${STACK_NAME:-memory-game-hosting-stack}"
else
    echo "⚠️  No .env file found. Using default values or command line arguments."
    echo "💡 Create a .env file from .env.example for easier configuration"
    echo "   Run: npm run setup"
fi
