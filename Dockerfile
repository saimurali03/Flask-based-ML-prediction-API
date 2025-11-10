#########################################
# 🧠 Flask-based ML Prediction API Dockerfile
#########################################

# Use official Python image (lightweight)
FROM python:3.9-slim

# Set working directory inside container
WORKDIR /app

#########################################
# ✅ Install dependencies
#########################################

# Copy requirement file
COPY app/requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

#########################################
# ✅ Copy project files
#########################################

# Copy all code into container
COPY app/ /app/

#########################################
# ✅ Expose Flask Port
#########################################

EXPOSE 5000

#########################################
# ✅ Run Flask app
#########################################

CMD ["python", "app.py"]
