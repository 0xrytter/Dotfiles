# Stop and remove all running and stopped containers
docker stop $(docker ps -aq) || true
docker rm $(docker ps -aq) || true

# Remove all Docker images
docker rmi $(docker images -q) || true

# Remove all Docker volumes
docker volume rm $(docker volume ls -q) || true

# Remove all Docker networks (except default ones)
docker network rm $(docker network ls -q) || true

# Prune everything (images, volumes, networks, build cache)
docker system prune -a --volumes -f

# Rebuild everything without using cache
docker-compose build --no-cache

# Start the services again
docker-compose up --build
