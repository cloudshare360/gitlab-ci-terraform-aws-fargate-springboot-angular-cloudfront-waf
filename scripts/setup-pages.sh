#!/bin/bash

# GitLab Pages Setup Script
echo "🚀 GitLab Pages Setup and Testing Script"
echo "========================================"

# Function to test documentation locally
test_docs_locally() {
    echo "📖 Testing documentation locally..."
    
    # Create public directory if it doesn't exist
    if [ ! -d "public" ]; then
        mkdir -p public
        cp -r docs/* public/
        echo "✅ Created public directory with docs"
    fi
    
    # Start local server
    echo "🌐 Starting local server on http://localhost:8080"
    echo "💡 Press Ctrl+C to stop the server"
    cd public && python3 -m http.server 8080
}

# Function to prepare for GitLab deployment
prepare_gitlab_deployment() {
    echo "🔧 Preparing for GitLab deployment..."
    
    # Check if we're in a git repository
    if [ ! -d ".git" ]; then
        echo "❌ This is not a git repository. Initialize git first:"
        echo "   git init"
        echo "   git add ."
        echo "   git commit -m 'Initial commit'"
        return 1
    fi
    
    # Check GitLab CI file
    if [ -f ".gitlab-ci.yml" ]; then
        echo "✅ GitLab CI configuration found"
    else
        echo "❌ .gitlab-ci.yml not found"
        return 1
    fi
    
    # Check docs directory
    if [ -d "docs" ]; then
        echo "✅ Documentation directory found"
        echo "📁 Docs files:"
        ls -la docs/
    else
        echo "❌ docs/ directory not found"
        return 1
    fi
    
    echo ""
    echo "🚀 Ready for GitLab deployment!"
    echo "📋 Next steps:"
    echo "   1. Push this repository to GitLab:"
    echo "      git remote add origin https://gitlab.com/your-username/your-repo.git"
    echo "      git push -u origin main"
    echo ""
    echo "   2. GitLab will automatically:"
    echo "      - Run the CI/CD pipeline"
    echo "      - Build the documentation site"
    echo "      - Deploy to GitLab Pages"
    echo ""
    echo "   3. Your docs will be available at:"
    echo "      https://your-username.gitlab.io/your-repo/"
    echo ""
}

# Function to show help
show_help() {
    echo "Usage: $0 [OPTION]"
    echo ""
    echo "Options:"
    echo "  test      Test documentation locally"
    echo "  prepare   Check GitLab deployment readiness"
    echo "  help      Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 test     # Start local docs server"
    echo "  $0 prepare  # Check deployment readiness"
}

# Main script logic
case "${1:-help}" in
    "test")
        test_docs_locally
        ;;
    "prepare")
        prepare_gitlab_deployment
        ;;
    "help"|*)
        show_help
        ;;
esac