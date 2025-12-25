# Deployment Without Docker - Quick Start Guide

## Overview

This project has been updated to support deployment **without Docker**. The application now:
- ✅ Uses **RDS PostgreSQL** for the database (no local database container)
- ✅ Deploys directly to **EC2 instances** (no Docker containers)
- ✅ Runs backend and frontend as **systemd services**
- ✅ **No Docker required** in Jenkins pipeline

## What Changed

### 1. Jenkins Pipeline (`jenkins/Jenkinsfile.app`)
- **Old**: Required Docker to build and push images to ECR
- **New**: Deploys directly to EC2 via SSH, no Docker needed
- **Backup**: Old Docker-based pipeline saved as `jenkins/Jenkinsfile.app.docker-backup`

### 2. Database Configuration
- **Old**: Used local PostgreSQL container or Kubernetes PostgreSQL service
- **New**: Uses RDS PostgreSQL at `librarymngsys-cls.c5ae4oesoop2.eu-west-1.rds.amazonaws.com`
- **Updated**: `k8s/secrets.yaml` now points to RDS

### 3. Deployment Method
- **Old**: Docker containers in Kubernetes/EKS
- **New**: Direct deployment to EC2 with systemd services

## Quick Start

### Option 1: Use Jenkins Pipeline (Recommended)

1. **Configure Jenkins**:
   - Open your Jenkins job
   - Make sure it uses `jenkins/Jenkinsfile.app` (the new no-docker version)
   - Configure parameters:
     - `EC2_HOST`: Your EC2 instance IP (e.g., `54.123.45.67`)
     - `SSH_KEY_ID`: Jenkins credential ID for your SSH private key
     - `RUN_MIGRATIONS`: `true`
     - `RESTART_SERVICES`: `true`

2. **Setup SSH Key in Jenkins**:
   - Go to Jenkins → Credentials → Add Credentials
   - Type: "SSH Username with private key"
   - ID: `ec2-deploy-key` (or match your `SSH_KEY_ID` parameter)
   - Username: `ubuntu` (or your EC2 user)
   - Private Key: Paste your SSH private key

3. **Run the Pipeline**:
   - Click "Build with Parameters"
   - Fill in `EC2_HOST` with your EC2 instance IP
   - Click "Build"
   - The pipeline will:
     - Build the frontend
     - Create deployment package
     - Deploy to EC2
     - Setup Python environment
     - Install dependencies
     - Configure systemd services
     - Run database migrations
     - Start backend and frontend services

### Option 2: Manual Deployment

See `deployment/README.md` for detailed manual deployment instructions.

## EC2 Instance Requirements

Your EC2 instance needs:

1. **Operating System**: Ubuntu 20.04+ or Amazon Linux 2
2. **Software**:
   - Python 3.8+
   - Node.js 18+
   - npm
   - pip
3. **Security Groups**: Allow:
   - Port 22 (SSH)
   - Port 5000 (Backend API)
   - Port 3000 (Frontend)
4. **RDS Access**: Security group must allow EC2 to connect to RDS on port 5432

## RDS Configuration

The application is configured to use:
- **Host**: `librarymngsys-cls.c5ae4oesoop2.eu-west-1.rds.amazonaws.com`
- **Port**: `5432`
- **Database**: `Library-db`
- **User**: `postgres`
- **Password**: `Mahmoud2wagdy`

**Important**: Make sure your RDS security group allows inbound connections from your EC2 instance's security group.

## Service Management

After deployment, services run as systemd services:

```bash
# Check status
sudo systemctl status library-backend
sudo systemctl status library-frontend

# View logs
sudo journalctl -u library-backend -f
sudo journalctl -u library-frontend -f

# Restart services
sudo systemctl restart library-backend
sudo systemctl restart library-frontend

# Stop services
sudo systemctl stop library-backend
sudo systemctl stop library-frontend
```

## Accessing the Application

- **Frontend**: http://<EC2_IP>:3000
- **Backend API**: http://<EC2_IP>:5000/api
- **Health Check**: http://<EC2_IP>:5000/api/health

## Troubleshooting

### Jenkins Pipeline Fails

1. **Docker errors**: These should be gone! If you still see Docker errors, make sure you're using `jenkins/Jenkinsfile.app` (not the backup).

2. **SSH connection fails**:
   - Verify EC2 instance is running
   - Check SSH key is correct in Jenkins credentials
   - Verify security group allows SSH (port 22)
   - Test SSH manually: `ssh -i <key> ubuntu@<EC2_IP>`

3. **Deployment fails on EC2**:
   - Check EC2 instance has Python 3.8+ and Node.js 18+
   - Verify EC2 has internet access (for pip/npm installs)
   - Check EC2 security group allows outbound connections

### Services Not Starting

1. **Backend service fails**:
   ```bash
   sudo journalctl -u library-backend -n 50
   ```
   - Check RDS connection
   - Verify environment variables in service file
   - Check Python dependencies

2. **Frontend service fails**:
   ```bash
   sudo journalctl -u library-frontend -n 50
   ```
   - Verify Node.js version (18+)
   - Check if frontend build exists
   - Verify npm dependencies installed

### Database Connection Issues

1. **RDS not accessible**:
   - Verify RDS security group allows EC2 security group
   - Test connection: `psql -h librarymngsys-cls.c5ae4oesoop2.eu-west-1.rds.amazonaws.com -U postgres -d Library-db`
   - Check RDS is in same VPC or has proper network configuration

2. **Migrations fail**:
   - Verify database credentials in systemd service file
   - Check database exists: `psql -h <RDS_HOST> -U postgres -l`
   - Run migrations manually: `cd /opt/library-management/backend && source venv/bin/activate && python run_migrations.py`

## Files Changed

- ✅ `jenkins/Jenkinsfile.app` - Replaced with no-docker version
- ✅ `jenkins/Jenkinsfile.app.docker-backup` - Backup of old Docker-based pipeline
- ✅ `jenkins/Jenkinsfile.app.no-docker` - New no-docker pipeline (same as Jenkinsfile.app)
- ✅ `k8s/secrets.yaml` - Updated to use RDS
- ✅ `deployment/deploy-to-ec2.sh` - Manual deployment script
- ✅ `deployment/README.md` - Detailed deployment guide

## Next Steps

1. **Test the deployment** on a development EC2 instance first
2. **Update RDS password** in production (currently using default)
3. **Update JWT secret** in production
4. **Configure proper security groups** for EC2 and RDS
5. **Set up monitoring** for the systemd services
6. **Configure reverse proxy** (nginx/Apache) if needed for production

## Support

If you encounter issues:
1. Check the logs: `sudo journalctl -u library-backend -f`
2. Verify RDS connectivity
3. Check EC2 security groups
4. Review `deployment/README.md` for detailed troubleshooting

