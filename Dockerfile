# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Set environment variables
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV PYTHONUNBUFFERED 1

# Set work directory
WORKDIR /home/frappe

# Install system dependencies
RUN apt-get update && \
    apt-get install -y \
    build-essential \
    mariadb-client \
    redis-server \
    curl \
    git \
    vim \
    python3-dev \
    libmariadb-dev-compat \
    libmariadb-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Node.js (required for Frappe)
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs

# Install Yarn (required for Frappe)
RUN npm install -g yarn

# Install wkhtmltopdf (required for PDF generation)
RUN apt-get update && \
    apt-get install -y wkhtmltopdf

# Copy the requirements file and install Python dependencies
COPY requirements.txt /home/frappe/
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Add pm4py to the requirements and install it
RUN pip install pm4py

# Copy the Frappe repository into the container
COPY . /home/frappe

# Expose necessary ports
EXPOSE 8000 9000 3306 6379

# Default command to start the application
CMD ["bench", "start"]
