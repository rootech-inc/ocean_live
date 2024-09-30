echo "Building...."
docker build -t rootleet411/ocean .

echo "Pushing"
docker push rootleet411/ocean

echo "connecting to server..."
ssh reza@192.168.2.60


