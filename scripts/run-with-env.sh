#!/bin/bash

# Run AWS CLI commands with environment variables loaded

# Load environment variables if .env exists
if [ -f .env ]; then
    echo "📄 Loading environment variables from .env file..."
    set -a
    source .env
    set +a
    echo "✅ Environment variables loaded"
else
    echo "⚠️  No .env file found. Using defaults."
fi

# Set defaults if not provided
export AWS_REGION=${AWS_REGION:-us-east-1}
export AWS_PROFILE=${AWS_PROFILE:-default}
export STACK_NAME=${STACK_NAME:-memory-game-hosting-stack}

# Execute the command passed as arguments
exec "$@"
