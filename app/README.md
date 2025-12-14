# SimpleTimeService

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


---
---

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
