# Stage 1: Build Stage
FROM python:3.9 AS builder

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container
COPY requirements.txt .

# Install app dependencies
RUN pip install -r requirements.txt

# Copy the rest of the application
COPY . .

# Stage 2: Final Stage
FROM python:3.9-slim

# Install MariaDB client library
RUN apt-get update && apt-get install -y mariadb-client

# Set the working directory in the container
WORKDIR /app

# Copy installed dependencies from the builder stage
COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages

# Copy the application code
COPY --from=builder /app .

# Specify the command to run your application
CMD ["python", "app.py"]
