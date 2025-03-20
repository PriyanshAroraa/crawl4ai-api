# ✅ Start from official Playwright image (includes browsers & correct GLIBC)
FROM mcr.microsoft.com/playwright/python:v1.41.1-jammy

WORKDIR /app

# Copy and install requirements
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Copy the rest of the app
COPY . .

EXPOSE 10000

# Run the app
CMD ["uvicorn", "main:app", "--host=0.0.0.0", "--port=10000"]
