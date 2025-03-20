# ✅ Start from official Playwright image (with Python + browsers + correct GLIBC)
FROM mcr.microsoft.com/playwright/python:v1.41.1-jammy

# Set work directory
WORKDIR /app

# Copy requirements and install them
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Copy your app code
COPY . .

# Expose port
EXPOSE 10000

# Start the server
CMD ["uvicorn", "main:app", "--host=0.0.0.0", "--port=10000"]
