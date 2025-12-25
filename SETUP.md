# Setup Guide

## Quick Start with Docker (Recommended)

1. **Make sure Docker and Docker Compose are installed**
   ```bash
   docker --version
   docker-compose --version
   ```

2. **Clone and navigate to the project**
   ```bash
   cd library-management-system
   ```

3. **Start all services**
   ```bash
   docker-compose up -d
   ```

4. **Wait for services to be ready** (about 30-60 seconds)
   ```bash
   docker-compose ps
   ```

5. **Access the application**
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:5000/api
   - Database: localhost:5432

6. **Login with default credentials**
   - Email: `admin@library.com`
   - Password: `admin123`

## Troubleshooting

### If services fail to start:

1. **Check logs**
   ```bash
   docker-compose logs backend
   docker-compose logs frontend
   docker-compose logs db
   ```

2. **Rebuild containers**
   ```bash
   docker-compose down
   docker-compose build --no-cache
   docker-compose up -d
   ```

3. **Check port availability**
   - Make sure ports 3000, 5000, and 5432 are not in use
   - On Windows, you may need to stop PostgreSQL if it's running locally

### Database Issues:

If the database schema is not initialized:

```bash
# Connect to the database container
docker exec -it library_db psql -U postgres -d library_db

# Or run the schema manually
docker exec -i library_db psql -U postgres -d library_db < backend/database/schema.sql
```

### Frontend not connecting to backend:

1. Check that `NEXT_PUBLIC_API_URL` in docker-compose.yml points to the correct backend URL
2. For local development, use `http://localhost:5000/api`
3. For Docker, use `http://backend:5000/api` (internal) or `http://localhost:5000/api` (external)

## Local Development Setup

### Backend

1. **Install Python 3.11+**
2. **Create virtual environment**
   ```bash
   cd backend
   python -m venv venv
   source venv/bin/activate  # Windows: venv\Scripts\activate
   ```

3. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

4. **Set up PostgreSQL**
   - Install PostgreSQL 15+
   - Create database: `CREATE DATABASE library_db;`
   - Run schema: `psql -U postgres -d library_db -f database/schema.sql`

5. **Configure environment**
   ```bash
   cp .env.example .env
   # Edit .env with your database credentials
   ```

6. **Run the server**
   ```bash
   python app.py
   # Or with gunicorn:
   gunicorn --bind 0.0.0.0:5000 --workers 4 app:app
   ```

### Frontend

1. **Install Node.js 18+**
2. **Install dependencies**
   ```bash
   cd frontend
   npm install
   ```

3. **Configure environment**
   ```bash
   cp .env.local.example .env.local
   # Edit .env.local with your API URL
   ```

4. **Run development server**
   ```bash
   npm run dev
   ```

5. **Build for production**
   ```bash
   npm run build
   npm start
   ```

## Production Deployment

1. **Update environment variables** in docker-compose.yml
2. **Change JWT_SECRET_KEY** to a secure random string
3. **Update database password**
4. **Build and start**
   ```bash
   docker-compose build
   docker-compose up -d
   ```

5. **Set up reverse proxy** (nginx/traefik) for production
6. **Enable HTTPS** with Let's Encrypt
7. **Set up backups** for the database

## Default Admin Account

- Email: `admin@library.com`
- Password: `admin123`

**Important:** Change the default admin password in production!

