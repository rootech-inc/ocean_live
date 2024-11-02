#!/bin/bash

# Pull the latest image
echo "Pulling Latest Image"
docker pull rootleet411/ocean
if [ $? -ne 0 ]; then
  echo "Failed to pull the latest image."
  exit 1
fi

# copy file
echo "Copying Checlish........"
#docker cp ocean:/app/static/uploads/job_check_lists /files/dolphine/job_check_lists/

# Stop and remove any existing container with the same name
existing_container=$(docker ps -q --filter "name=ocean")
if [ -n "$existing_container" ]; then
  echo "Stopping existing container"
  docker stop ocean
  if [ $? -ne 0 ]; then
    echo "Failed to stop the existing container."
    exit 1
  fi

  echo "Removing existing container"
  docker rm ocean
  if [ $? -ne 0 ]; then
    echo "Failed to remove the existing container."
    exit 1
  fi
fi



# Set environment variables
echo "Setting Variables"
export DB_HOST=192.168.2.60

echo "Running Container"
# Run Docker container
docker run -e DB_HOST=$DB_HOST -v /files:/app/static/uploads -v /files/rest_items:/app/static/retail/products -v /files/servicing:/static/uploads/dolphine/servicing/ --network=host --restart always --name ocean -d rootleet411/ocean
if [ $? -ne 0 ]; then
  echo "Failed to run the container."
  exit 1
fi

echo "Container is running successfully."