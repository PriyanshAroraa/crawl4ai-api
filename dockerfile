FROM python:3.11-slim

# Install OS dependencies required by Playwright Chromium
RUN apt-get update && apt-get install -y wget gnupg curl libnss3 libatk1.0-0 libatk-bridge2.0-0 libgtk-3-0 libx11-xcb1 libxcomposite1 libxdamage1 libxrandr2 libasound2 libpangocairo-1.0-0 libcups2 libxss1 fonts-liberation libappindicator3-1 lsb-release libnss3-dev libxshmfence1

# Set working directory
WORKDIR /app

# Copy and install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Install Playwright Chromium browsers
RUN python -m playwright install --with-deps chromium

# Copy the rest of your project
COPY . .

# Expose the application port
EXPOSE 8000

# Start command
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
