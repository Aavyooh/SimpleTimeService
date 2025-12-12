# -------- Stage 1: Build --------
FROM python:3.12-slim AS builder

WORKDIR /app

# Install build dependencies
RUN apt-get update && apt-get install -y --no-install-recommends gcc

COPY requirements.txt .
RUN pip install --upgrade pip && \
    pip install --prefix=/install -r requirements.txt

# -------- Stage 2: Runtime --------
FROM python:3.12-slim

# Create non-root user
RUN useradd -m appuser

WORKDIR /app

# Copy installed deps
COPY --from=builder /install /usr/local

# Copy app
COPY app.py .

# Fix ownership
RUN chown -R appuser:appuser /app

USER appuser

EXPOSE 8080

CMD ["python", "app.py"]
