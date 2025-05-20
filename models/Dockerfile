FROM python:3.9-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libgl1-mesa-glx \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements and install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the model and API code
COPY emotion_api.py .
COPY emotion_model.pth .

# Expose the port
EXPOSE 5000

# Run the API server
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "emotion_api:app"]