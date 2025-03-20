# Use the official Playwright base image (it has all dependencies pre-installed)
FROM mcr.microsoft.com/playwright/python:v1.41.1-jammy

# Set working directory
WORKDIR /app

# Install system dependencies (optional safety)
RUN apt-get update && apt-get install -y libnss3 libatk1.0-0 libatk-bridge2.0-0 libcups2 libdrm2 libxkbcommon0 libxcomposite1 libxdamage1 libxrandr2 libgbm1 libpango-1.0-0 libpangocairo-1.0-0 fonts-liberation libasound2 libxshmfence1 xvfb

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Copy the rest of the code
COPY . .

# Expose port
EXPOSE 10000

# Start the server
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "10000"]
