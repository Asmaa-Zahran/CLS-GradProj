# Quick Setup Guide - Ubuntu/Linux

## Prerequisites

- Ubuntu 20.04+ or any Linux distribution
- Docker and Docker Compose installed

## Installation Steps

### 1. Install Docker (if not installed)

```bash
# Update package index
sudo apt-get update

# Install prerequisites
sudo apt-get install -y ca-certificates curl gnupg lsb-release

# Add Docker's official GPG key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# Set up the repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Install Docker Engine
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Verify installation
sudo docker --version
sudo docker compose version

# Add your user to docker group (optional, to run without sudo)
sudo usermod -aG docker $USER
# Log out and log back in for this to take effect
```

### 2. Clone and Setup

```bash
# Clone the repository
git clone <repository-url>
cd library-management-system

# Make startup script executable
chmod +x start.sh

# Run the startup script (optional, or use docker compose directly)
./start.sh
```

### 3. Start with Docker Compose

```bash
# Start all services
docker compose up -d

# View logs
docker compose logs -f

# Check status
docker compose ps
```

### 4. Access the Application

- **Frontend**: http://localhost:3055
- **Backend API**: http://localhost:5055/api
- **Database**: localhost:5432
  - Username: `library_user`
  - Password: `library_password_2024`
  - Database: `library_db`

### 5. Default Login

- **Email**: `admin@library.com`
- **Password**: `admin123`

## Database Configuration

### Default Credentials
- **Host**: `db` (container) or `localhost` (from host)
- **Port**: `5432`
- **Database**: `library_db`
- **Username**: `library_user`
- **Password**: `library_password_2024`

### Change Credentials

1. Edit `docker-compose.yml`:
   ```yaml
   db:
     environment:
       POSTGRES_DB: your_database_name
       POSTGRES_USER: your_username
       POSTGRES_PASSWORD: your_secure_password
   ```

2. Update backend environment in `docker-compose.yml`:
   ```yaml
   backend:
     environment:
       DB_NAME: your_database_name
       DB_USER: your_username
       DB_PASSWORD: your_secure_password
       DATABASE_URL: postgresql://your_username:your_secure_password@db:5432/your_database_name
   ```

3. Rebuild:
   ```bash
   docker compose down -v
   docker compose up -d --build
   ```

## Common Commands

```bash
# Start services
docker compose up -d

# Stop services
docker compose down

# Stop and remove volumes (⚠️ deletes data)
docker compose down -v

# View logs
docker compose logs -f [service_name]

# Restart service
docker compose restart [service_name]

# Rebuild containers
docker compose up -d --build

# Access database shell
docker compose exec db psql -U library_user -d library_db

# Access backend shell
docker compose exec backend bash

# Access frontend shell
docker compose exec frontend sh
```

## Troubleshooting

### Port Already in Use

If ports 3055, 5055, or 5432 are in use, edit `docker-compose.yml`:

```yaml
frontend:
  ports:
    - "3056:3000"  # Change 3055 to 3056
backend:
  ports:
    - "5056:5000"  # Change 5055 to 5056
db:
  ports:
    - "5433:5432"  # Change 5432 to 5433
```

### Database Connection Issues

```bash
# Check database status
docker compose ps db

# Check database logs
docker compose logs db

# Test connection
docker compose exec db psql -U library_user -d library_db -c "SELECT version();"
```

### Services Not Starting

```bash
# Check all logs
docker compose logs

# Restart all services
docker compose restart

# Rebuild from scratch
docker compose down -v
docker compose up -d --build
```

## Production Deployment

1. **Change default passwords** in `docker-compose.yml`
2. **Update JWT_SECRET_KEY** with a strong random key
3. **Configure firewall** rules
4. **Set up reverse proxy** (Nginx/Apache)
5. **Enable HTTPS** with SSL certificates
6. **Set up regular backups** of the database

## Support

For more details, see the main [README.md](README.md) file.

