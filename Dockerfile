# Use the official Python image as the base image
FROM rootleet411/debpy

# Set environment variables for the Django app
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Set MySQL database credentials as environment variables (RECOMMENDED: remove for security)
# ENV DB_HOST=127.0.0.1 \
#     DB_PORT=3306 \
#     DB_NAME=ocean \
#     DB_USER=root \
#     DB_PASSWORD=111

# Install system dependencies including ODBC library and MySQL client dev libraries
# RUN apt-get update && \
#     apt-get install -y pkg-config default-libmysqlclient-dev && \
#     rm -rf /var/lib/apt/lists/*

# Create and set the working directory in the container
WORKDIR /app

# Copy the requirements.txt file and install Python dependencies
# COPY req.txt /app/
# RUN pip install --upgrade pip && pip install -r req.txt

# Copy the Django project files to the container
COPY . /app/

# Expose the port that Django runs on (80)
EXPOSE 80

# Run the Django development server using exec JSON form for proper signal handling
CMD ["python3", "manage.py", "runserver", "0.0.0.0:80"]
