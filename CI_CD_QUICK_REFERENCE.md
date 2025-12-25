# CI/CD Quick Reference

## TL;DR - Deploy Now

```bash
# Set AWS credentials
export AWS_ACCESS_KEY_ID="AKIA..."
export AWS_SECRET_ACCESS_KEY="..."

# Deploy infrastructure
bash ci/scripts/deploy-infra.sh

# Get outputs
cat terraform/outputs.json
```

## Documentation Files

### 🚀 Start Here
- **[DOCKER_SOLUTION.md](DOCKER_SOLUTION.md)** - How we fixed the Docker error

### 📖 Main Guides
- **[DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)** - Step-by-step deployment instructions
- **[INFRASTRUCTURE.md](INFRASTRUCTURE.md)** - Architecture and design overview
- **[JENKINS_TROUBLESHOOTING.md](JENKINS_TROUBLESHOOTING.md)** - Solutions for common problems

### 📝 Technical Docs
- **[SETUP.md](SETUP.md)** - Full project setup (existing)
- **[QUICK_SETUP.md](QUICK_SETUP.md)** - Quick setup (existing)
- **[README.md](README.md)** - Project overview (existing)

## What's New

### Scripts
- `ci/scripts/deploy-infra.sh` - Standalone deployment (no Jenkins needed)
- `ci/scripts/install-terraform.sh` - Robust Terraform installer (improved)

### Jenkins Pipelines
- `jenkins/Jenkinsfile.infra` - Full-featured (original)
- `jenkins/Jenkinsfile.infra.simple` - Docker-free (NEW - RECOMMENDED)
- `jenkins/Jenkinsfile.app` - Application deployment (existing)

### Infrastructure
- `terraform/bootstrap/` - State bucket setup
- `terraform/modules/` - VPC, EKS, RDS, ECR, Secrets
- `terraform/environments/staging.tfvars` - Configuration
- `terraform/providers.tf`, `backend.tf`, `main.tf`, etc.

## Quick Decision Tree

### Q: How do I deploy infrastructure?
```
A1: Via Jenkins (GUI) → Use jenkins/Jenkinsfile.infra.simple
A2: Via CLI (command-line) → bash ci/scripts/deploy-infra.sh
A3: Detailed guide → See DEPLOYMENT_GUIDE.md
```

### Q: Jenkins is showing Docker errors
```
A: See DOCKER_SOLUTION.md and JENKINS_TROUBLESHOOTING.md
   Quick fix: Use jenkins/Jenkinsfile.infra.simple instead of infra.infra
```

### Q: I want to understand the architecture
```
A: See INFRASTRUCTURE.md for diagrams and detailed explanations
```

### Q: How do I set up AWS credentials?
```
A: See DEPLOYMENT_GUIDE.md - AWS Credentials section
   For Jenkins: Create jenkins Credentials with ID: aws-creds
   For CLI: export AWS_ACCESS_KEY_ID=... AWS_SECRET_ACCESS_KEY=...
```

### Q: What gets created?
```
A: VPC, EKS cluster (2 nodes), RDS PostgreSQL, ECR, Secrets Manager
   See INFRASTRUCTURE.md for detailed diagrams
```

### Q: How much does it cost?
```
A: ~$220-290/month (EKS $150-200, RDS $20-30, NAT $30-40)
   See DEPLOYMENT_GUIDE.md - Cost Estimation section
```

## Commands Cheat Sheet

### Deployment
```bash
# Install Terraform
bash ci/scripts/install-terraform.sh 1.5.7

# Plan infrastructure
export ACTION=plan
bash ci/scripts/deploy-infra.sh

# Deploy infrastructure
export ACTION=apply
export AUTO_APPROVE=true
bash ci/scripts/deploy-infra.sh

# Bootstrap first time
export BOOTSTRAP=true
bash ci/scripts/deploy-infra.sh
```

### Terraform Direct
```bash
# Check state
terraform -chdir=terraform state list

# Destroy (careful!)
terraform -chdir=terraform destroy -var-file=environments/staging.tfvars

# Refresh without changes
terraform -chdir=terraform refresh -var-file=environments/staging.tfvars

# Format code
terraform -chdir=terraform fmt -recursive

# Validate
terraform -chdir=terraform validate
```

### AWS CLI
```bash
# Check credentials
aws sts get-caller-identity

# List EKS clusters
aws eks list-clusters

# Get RDS endpoints
aws rds describe-db-instances --query 'DBInstances[*].[DBInstanceIdentifier,Endpoint.Address]'

# List ECR repositories
aws ecr describe-repositories
```

### Kubernetes
```bash
# Get kubeconfig
aws eks update-kubeconfig --name <cluster-name> --region eu-west-1

# Check nodes
kubectl get nodes

# Check pods
kubectl get pods -A

# View logs
kubectl logs -f deployment/backend
```

## Environment Variables

### Required for Deployment
```bash
export AWS_ACCESS_KEY_ID="AKIA..."      # AWS Access Key
export AWS_SECRET_ACCESS_KEY="..."      # AWS Secret Key
```

### Optional for Script Control
```bash
export BOOTSTRAP=true/false             # Run bootstrap stage
export ACTION=plan/apply/plan-and-apply # What to do
export AUTO_APPROVE=true/false          # Skip confirmation
```

## Troubleshooting Quick Fixes

| Problem | Solution |
|---------|----------|
| Docker error in Jenkins | Use `jenkins/Jenkinsfile.infra.simple` |
| Terraform not found | Run `bash ci/scripts/install-terraform.sh 1.5.7` |
| AWS credentials error | Check `aws sts get-caller-identity` |
| State bucket not found | Run with `BOOTSTRAP=true` first |
| Permission denied | Check IAM user has EC2, EKS, RDS, S3, DynamoDB, Secrets Manager access |

For more details: See [JENKINS_TROUBLESHOOTING.md](JENKINS_TROUBLESHOOTING.md)

## File Organization

```
Infrastructure Code
├── terraform/main.tf                    # Orchestrates all modules
├── terraform/backend.tf                 # S3 + DynamoDB state
├── terraform/providers.tf               # AWS/Kubernetes providers
├── terraform/variables.tf               # Input variables
├── terraform/outputs.tf                 # Output values
├── terraform/bootstrap/main.tf          # Creates state bucket
├── terraform/modules/
│   ├── vpc/                             # VPC + subnets
│   ├── eks/                             # EKS cluster
│   ├── rds/                             # RDS database
│   ├── ecr/                             # ECR repository
│   └── secrets/                         # AWS Secrets Manager
└── terraform/environments/staging.tfvars # Environment config

CI/CD Pipelines
├── jenkins/Jenkinsfile.infra            # Full-featured pipeline
├── jenkins/Jenkinsfile.infra.simple     # Docker-free (RECOMMENDED)
├── jenkins/Jenkinsfile.app              # App deployment
└── jenkins/job-dsl/create_jobs.groovy   # Job automation

Scripts
└── ci/scripts/
    ├── install-terraform.sh             # Terraform installer
    └── deploy-infra.sh                  # Standalone deployment

Documentation
├── DOCKER_SOLUTION.md                   # Docker error fix (START HERE)
├── DEPLOYMENT_GUIDE.md                  # Step-by-step instructions
├── INFRASTRUCTURE.md                    # Architecture overview
├── JENKINS_TROUBLESHOOTING.md           # Common solutions
└── CI_CD_QUICK_REFERENCE.md             # This file
```

## Recommended Reading Order

1. **First time?** → Start with [DOCKER_SOLUTION.md](DOCKER_SOLUTION.md)
2. **Ready to deploy?** → Go to [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md)
3. **Want to understand?** → Read [INFRASTRUCTURE.md](INFRASTRUCTURE.md)
4. **Having issues?** → Check [JENKINS_TROUBLESHOOTING.md](JENKINS_TROUBLESHOOTING.md)
5. **Need details?** → See specific docs above

## Support

### Debugging Steps
1. Check all documentation files above
2. Review error messages in logs
3. Try manual deployment: `bash ci/scripts/deploy-infra.sh`
4. Verify AWS credentials: `aws sts get-caller-identity`
5. Check Terraform syntax: `terraform -chdir=terraform validate`

### Common Errors
- "docker: not found" → Use `jenkins/Jenkinsfile.infra.simple`
- "terraform: not found" → Run install script first
- "bucket not found" → Run bootstrap (`BOOTSTRAP=true`)
- "invalid credentials" → Check AWS keys

## Status

✅ Infrastructure code complete
✅ Jenkins pipelines working (Docker-free option available)
✅ Scripts tested and documented
✅ Ready for deployment

---

**Last Updated:** December 20, 2025
**For Latest:** See individual guide files
