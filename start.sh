#!/bin/bash

# Library Management System - Startup Script
# This script helps set up and start the application on Ubuntu/Linux

set -e

echo "🚀 Library Management System - Startup Script"
echo "=============================================="
echo ""

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker is not installed. Please install Docker first."
    echo "   See README.md for installation instructions."
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker compose &> /dev/null; then
    echo "❌ Docker Compose is not installed. Please install Docker Compose first."
    echo "   See README.md for installation instructions."
    exit 1
fi

echo "✅ Docker and Docker Compose are installed"
echo ""

# Check if .env files exist, create from examples if not
if [ ! -f "backend/.env" ]; then
    echo "📝 Creating backend/.env from example..."
    if [ -f "backend/.env.example" ]; then
        cp backend/.env.example backend/.env
        echo "✅ Created backend/.env"
    fi
fi

if [ ! -f "frontend/.env.local" ]; then
    echo "📝 Creating frontend/.env.local from example..."
    if [ -f "frontend/.env.local.example" ]; then
        cp frontend/.env.local.example frontend/.env.local
        echo "✅ Created frontend/.env.local"
    fi
fi

echo ""
echo "🐳 Building and starting Docker containers..."
echo ""

# Build and start containers
docker compose up -d --build

echo ""
echo "⏳ Waiting for services to be ready..."
sleep 10

# Check if database is ready
echo "🔍 Checking database connection..."
for i in {1..30}; do
    if docker compose exec -T db pg_isready -U library_user &> /dev/null; then
        echo "✅ Database is ready"
        break
    fi
    if [ $i -eq 30 ]; then
        echo "❌ Database failed to start after 30 attempts"
        exit 1
    fi
    sleep 2
done

# Run migrations and seed data (if not already done)
echo ""
echo "📊 Database setup (migrations and seeding happen automatically on first start)..."
echo "   If you need to re-seed, run: docker compose exec backend python seed_data.py"

echo ""
echo "✅ Setup complete!"
echo ""
echo "📍 Access the application:"
echo "   Frontend: http://localhost:3055"
echo "   Backend API: http://localhost:5055/api"
echo ""
echo "🔑 Default Login Credentials:"
echo "   Admin: admin@library.com / admin123"
echo ""
echo "📋 Useful commands:"
echo "   View logs: docker compose logs -f"
echo "   Stop services: docker compose down"
echo "   Restart services: docker compose restart"
echo ""

