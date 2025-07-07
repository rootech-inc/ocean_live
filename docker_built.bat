echo "Building...."
docker buildx build --load -t rootleet411/ocean .

echo "Pushing"
docker push rootleet411/ocean

