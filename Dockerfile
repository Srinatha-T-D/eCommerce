# Use a Python base image
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Install system dependencies needed for psycopg2, Pillow, etc.
RUN apt-get update && apt-get install -y \
    build-essential \
    libpq-dev \
    && rm -rf /var/lib/apt/lists/*

# Copy Django project code (your project is in src/)
COPY src/ /app/

# Install Python dependencies
RUN pip install --upgrade pip && \
    pip install -r requirements.txt

# Expose the port Django will run on
EXPOSE 8000

# Default command: run Django dev server (for demo/learning)
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]

