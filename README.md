# MERN Stack CI/CD Pipeline with Terraform & Kubernetes

![MERN-CICD-EKS-MONITORING](https://raw.githubusercontent.com/Mosrichard/MERN-TODO-END-TO-END-CICD-DEPLOYMENT-MONITORING/main/MERN-CICD-EKS-MONITORING.png)

A complete DevOps project featuring a MERN (MongoDB, Express, React, Node.js) application with automated CI/CD pipeline, infrastructure as code, and Kubernetes orchestration.

## 🚀 Features

### Application Features
- **💬 Real-time Chat** - Personal messaging between users
- **✓ Todo Management** - Task creation, completion, and deletion
- **📝 Quote Sharing** - Public quote posting and management
- **🎨 Theme Toggle** - Dark/Light mode support
- **🔐 Authentication** - User registration and login with duplicate username validation

### DevOps Features
- **Infrastructure as Code** - Terraform for AWS VPC and EKS cluster
- **CI/CD Pipeline** - GitHub Actions for automated deployment
- **Container Orchestration** - Kubernetes manifests for application deployment
- **Monitoring** - Prometheus and Grafana stack
- **Security** - OIDC authentication for AWS, secrets management

## 📋 Architecture

```
Frontend (React) → Nginx → Backend (Express) → MongoDB
                                ↓
                          Kubernetes (EKS)
                                ↓
                          AWS Infrastructure
```

## 🛠️ Tech Stack

### Application
- **Frontend**: React, Framer Motion, CSS3
- **Backend**: Node.js, Express.js
- **Database**: MongoDB
- **Admin UI**: Mongo Express

### DevOps
- **Cloud**: AWS (VPC, EKS, EC2)
- **IaC**: Terraform
- **CI/CD**: GitHub Actions
- **Containerization**: Docker
- **Orchestration**: Kubernetes
- **Monitoring**: Prometheus, Grafana
- **Registry**: DockerHub

## 📁 Project Structure

```
cicd-tf-vpc-actions/
├── .github/workflows/       # GitHub Actions workflows
│   ├── main.yaml           # Main CI/CD pipeline
│   ├── terraform.yaml      # Infrastructure provisioning
│   ├── observability.yaml  # Monitoring setup
│   └── deploy.yaml         # Kubernetes deployment
├── terraform/              # Infrastructure as Code
│   ├── main.tf            # VPC, EKS, Node Groups
│   ├── variables.tf       # Input variables
│   └── outputs.tf         # Output values
├── kubernetes-manifests/   # K8s deployment files
│   ├── namespace.yaml     # Namespace definition
│   ├── mongo.yaml         # MongoDB deployment
│   ├── backend.yaml       # Backend deployment
│   ├── frontend.yaml      # Frontend deployment
│   └── mongo-express.yaml # MongoDB admin UI
├── frontend/              # React application
│   ├── src/
│   ├── Dockerfile
│   └── nginx.conf
├── backend/               # Express API
│   ├── server.js
│   ├── Dockerfile
│   └── package.json
└── README.md
```

## 🚦 Getting Started

### Prerequisites
- AWS Account with OIDC configured
- GitHub Account
- DockerHub Account
- kubectl installed
- Terraform installed (for local testing)

### Environment Setup

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/cicd-tf-vpc-actions.git
cd cicd-tf-vpc-actions
```

2. **Configure GitHub Secrets**
```
AWS_ROLE_ARN          # AWS IAM Role ARN for OIDC
DOCKERHUB_USERNAME    # DockerHub username
DOCKERHUB_TOKEN       # DockerHub access token
```

3. **Update Terraform Variables**
Edit `terraform/terraform.tfvars`:
```hcl
vpc_cidr = "10.0.0.0/16"
cluster_name = "my-eks-cluster"
```

## 🔄 CI/CD Pipeline

### Pipeline Stages

1. **Infrastructure Provisioning** (Terraform)
   - Creates VPC with public/private subnets
   - Provisions EKS cluster
   - Sets up node groups

2. **Build & Push** (Docker)
   - Builds frontend and backend images
   - Pushes to DockerHub registry
   - Tags with commit SHA

3. **Deploy** (Kubernetes)
   - Applies namespace and secrets
   - Deploys MongoDB with persistent storage
   - Deploys backend and frontend services
   - Configures LoadBalancer

4. **Observability** (Monitoring)
   - Installs Prometheus stack
   - Configures Grafana dashboards
   - Sets up service monitoring

### Trigger Pipeline

Push to `main` branch:
```bash
git add .
git commit -m "Deploy application"
git push origin main
```

## 🐳 Docker Images

### Build Locally

**Frontend:**
```bash
docker build -t mosrichard1234/cicd-tf-vpc-actions-frontend:latest ./frontend
docker push mosrichard1234/cicd-tf-vpc-actions-frontend:latest
```

**Backend:**
```bash
docker build -t mosrichard1234/cicd-tf-vpc-actions-backend:latest ./backend
docker push mosrichard1234/cicd-tf-vpc-actions-backend:latest
```

## ☸️ Kubernetes Deployment

### Deploy to Cluster

```bash
# Update kubeconfig
aws eks update-kubeconfig --name my-eks-cluster --region ap-south-1

# Apply manifests
kubectl apply -f kubernetes-manifests/namespace.yaml
kubectl apply -f kubernetes-manifests/mongo-secrets.yaml
kubectl apply -f kubernetes-manifests/mongo.yaml
kubectl apply -f kubernetes-manifests/backend.yaml
kubectl apply -f kubernetes-manifests/frontend.yaml
kubectl apply -f kubernetes-manifests/mongo-express.yaml
```

### Check Deployment Status

```bash
kubectl get pods -n mern-app
kubectl get svc -n mern-app
```

### Access Application

```bash
# Get LoadBalancer URL
kubectl get svc frontend-svc -n mern-app

# Access Mongo Express
kubectl get svc mongo-express-svc -n mern-app
# URL: http://<node-ip>:30001
# Credentials: admin / admin123
```

## 🔧 Configuration

### MongoDB Connection
```yaml
MONGO_URL: mongodb://admin:admin123@mongodb-service:27017/appdb?authSource=admin
```

### Frontend Proxy (nginx.conf)
```nginx
location /api {
  proxy_pass http://backend-svc:3000;
}
```

## 📊 Monitoring

Access Grafana:
```bash
kubectl get svc -n monitoring
# Get LoadBalancer URL for Grafana
```

Default credentials: `admin / prom-operator`

## 🔐 Security

- MongoDB credentials stored in Kubernetes secrets
- OIDC authentication for AWS access
- No hardcoded credentials in code
- Network policies for pod communication
- Private subnets for database and backend

## 🐛 Troubleshooting

### Pods not starting
```bash
kubectl describe pod <pod-name> -n mern-app
kubectl logs <pod-name> -n mern-app
```

### MongoDB connection issues
```bash
kubectl exec -it <mongodb-pod> -n mern-app -- mongosh -u admin -p admin123
```

### Image pull errors
```bash
kubectl get events -n mern-app
# Check DockerHub credentials
```

## 📝 API Endpoints

### Authentication
- `POST /api/register` - Register new user
- `POST /api/login` - User login

### Chat
- `GET /api/users` - Get all users
- `GET /api/messages/:user` - Get messages with user
- `POST /api/messages` - Send message

### Todos
- `GET /api/todos` - Get user todos
- `POST /api/todos` - Create todo
- `PUT /api/todos/:id` - Toggle todo
- `DELETE /api/todos/:id` - Delete todo

### Quotes
- `GET /api/quotes` - Get all quotes
- `POST /api/quotes` - Create quote
- `DELETE /api/quotes/:id` - Delete quote

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License.

## 👤 Author

**Your Name**
- GitHub: [@Mosrichard](https://github.com/Mosrichard)



---

**⭐ Star this repo if you find it helpful!**
