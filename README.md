# SimpleTimeService

A minimal production-ready microservice that returns the current UTC timestamp and the client IP address as a JSON response. This service is designed to be easy to run locally, containerized with Docker, and deployable using infrastructure-as-code (Terraform).

## API Behavior

**Endpoint**

```
GET /
```

**Response (JSON)**

```json
{
  "timestamp": "2025-01-01T10:00:00Z",
  "ip": "203.0.113.10"
}
```

* `timestamp`: Current UTC time in ISO-8601 format
* `ip`: Client IP (uses `X-Forwarded-For` header if present)

---

## Project Structure

```
.
├── app.py              # Flask application
├── requirements.txt    # Python dependencies
├── Dockerfile          # Container build instructions
└── README.md           # Deployment documentation
```

---

## Prerequisites

Install the following tools before proceeding:

### 1. Git

Used to clone the repository.

* [https://git-scm.com/downloads](https://git-scm.com/downloads)

Verify:

```bash
git --version
```

### 2. Python 3.9+

Required to run the application locally (without Docker).

* [https://www.python.org/downloads/](https://www.python.org/downloads/)

Verify:

```bash
python --version
```


### 3. Flask (Python Framework)

Flask is required to run the web service locally. It will be installed automatically via `requirements.txt`.

No manual installation is needed if you run:

```bash
pip install -r requirements.txt
```


### 4. Docker

Used to build and run the container.

* [https://docs.docker.com/get-docker/](https://docs.docker.com/get-docker/)

Verify:

```bash
docker --version
```

> ⚠️ Make sure Docker Desktop is **running** before continuing.


```
## Clone the Repository

```bash
git clone https://github.com/Aavyooh/SimpleTimeService
cd <REPOSITORY_NAME>
```


## Run the Application Using Docker 

### 1. Build the Docker image

```bash
docker build -t simple-time-service .
```

### 2. Run the container

```bash
docker run -p 8080:8080 simple-time-service
```

### 3. Test

Open a browser or run:

```bash
curl http://localhost:8080
```

---

## Container Configuration Notes

* Application runs as a **non-root user** for security
* Port **8080** is exposed
* Suitable for use behind a load balancer (ALB / Nginx / API Gateway)

---

## Deploying to AWS using Terraform (ECS with Modules)

This project is deployed to **AWS ECS (Fargate)** using **Terraform modules**. The Terraform code provisions networking, security, IAM, ECS cluster, task definition, service, and an Application Load Balancer.

---

## Terraform Prerequisites

Install the following before deploying infrastructure:

### 1. Terraform (>= 1.5)

Used for infrastructure provisioning.

* [https://developer.hashicorp.com/terraform/downloads](https://developer.hashicorp.com/terraform/downloads)

Verify:

```bash
terraform version
```

---

### 2. AWS CLI

Used for authentication and provider access.

* [https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)

Verify:

```bash
aws --version
```

---

## AWS Credentials Configuration

Configure AWS credentials locally:

```bash
aws configure
```

Provide:

* AWS Access Key ID
* AWS Secret Access Key
* Default region (e.g. `ap-south-1`)
* Output format (`json`)

Terraform will automatically use these credentials.

---

## Project Structure (Terraform)

```
terraform/
├── main.tf                 # Root module wiring all sub-modules
├── providers.tf            # AWS provider configuration
├── variables.tf            # Input variables
├── outputs.tf              # Terraform outputs
├── terraform.tfvars        # Environment-specific values
├── versions.tf             # Provider & Terraform versions
└── modules/
    ├── vpc/                # VPC, subnets, routing
    ├── security-groups/    # SGs for ALB and ECS tasks
    ├── iam-ecs/            # IAM roles for ECS execution & task
    ├── alb/                # Application Load Balancer
    ├── ecs-cluster/        # ECS cluster
    ├── ecs-task-definition # Task definition (Docker image)
    └── ecs-service/        # ECS service & autoscaling
```

---

## Docker Image Configuration (Docker Hub – Public)

The application Docker image is hosted in a **public Docker Hub repository**.

Terraform pulls the image directly from Docker Hub — **no ECR build or push is required**.

The image reference can be changed in the **root `terraform.tfvars`** file.

---

## Docker Image Variable

Example from `terraform.tfvars`:

```hcl
docker_image = "dockerhub-username/time-service:latest"
```

Where:

* `dockerhub-username` → Your Docker Hub username or org
* `time-service` → Repository name
* `latest` → Image tag (can be versioned)

Because the image is **public**:

* No Docker Hub credentials are required
* ECS can pull the image without secrets

---

## Updating the Image Version

To deploy a new version:

1. Build and push a new image to Docker Hub

```bash
docker build -t dockerhub-username/time-service:v1.1 ./app
docker push dockerhub-username/time-service:v1.1
```

2. Update `terraform.tfvars`

```hcl
docker_image = "dockerhub-username/time-service:v1.1"
```

3. Apply Terraform

```bash
terraform apply
```

ECS will perform a rolling deployment.

---

## Terraform Deployment Steps

From the **terraform/** directory:

### 1. Initialize

```bash
terraform init
```

### 2. Validate

```bash
terraform validate
```

### 3. Plan

```bash
terraform plan
```

### 4. Apply

```bash
terraform apply
```

Confirm with `yes` when prompted.

---

## Accessing the Application

After successful deployment, Terraform will output:

* ALB DNS name

Access the service:

```
http://<alb-dns-name>/
```

---

## Cleanup

To destroy all AWS resources:

```bash
terraform destroy
```

---

## AWS Credentials Configuration

Configure credentials using the AWS CLI:

```bash
aws configure
```

You will be prompted for:

* AWS Access Key ID
* AWS Secret Access Key
* Region (e.g. `ap-south-1`)
* Output format (`json`)

Credentials are stored locally at:

```
~/.aws/credentials
```

---
