#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# --- Configuration ---
IMAGE_NAME="postman-curl-extractor"
CONTAINER_NAME="postman-curl-extractor-instance"
FLASK_PORT=5000 # The port Flask runs on inside the container
HOST_PORT=5000  # The port you will access on your local machine

# Get the absolute path to the directory containing this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
EXPORT_DIR="${SCRIPT_DIR}/exported_collections"

# --- Script Logic ---

echo "--- Postman cURL Extractor Docker Setup ---"

# 1. Create the export directory on the host if it doesn't exist
echo "[INFO] Ensuring local export directory exists: ${EXPORT_DIR}"
mkdir -p "${EXPORT_DIR}"
if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to create directory: ${EXPORT_DIR}. Please check permissions."
    exit 1
fi
echo "[SUCCESS] Local export directory ensured."

# 2. Build the Docker image
echo "[INFO] Building Docker image: ${IMAGE_NAME}..."
# Build from the Dockerfile in the current directory (where the script is)
docker build -t "${IMAGE_NAME}" "${SCRIPT_DIR}"
if [ $? -ne 0 ]; then
    echo "[ERROR] Docker image build failed."
    exit 1
fi
echo "[SUCCESS] Docker image built successfully: ${IMAGE_NAME}"

# 3. Stop and remove any existing container with the same name (optional but clean)
echo "[INFO] Checking for existing container: ${CONTAINER_NAME}..."
if [ "$(docker ps -a -q -f name=${CONTAINER_NAME})" ]; then
    echo "[INFO] Stopping existing container..."
    docker stop "${CONTAINER_NAME}" > /dev/null
    echo "[INFO] Removing existing container..."
    docker rm "${CONTAINER_NAME}" > /dev/null
    echo "[SUCCESS] Existing container stopped and removed."
else
    echo "[INFO] No existing container found."
fi

# 4. Run the Docker container
echo "[INFO] Running new container: ${CONTAINER_NAME}..."
# -d: Run in detached mode (background)
# -p: Map host port to container port (HOST_PORT:FLASK_PORT)
# -v: Mount the local export directory into the container's export directory
# --name: Assign a name to the container
# ${IMAGE_NAME}: Use the image we just built
docker run -d \
    -p "${HOST_PORT}:${FLASK_PORT}" \
    -v "${EXPORT_DIR}:/app/exported_collections" \
    --name "${CONTAINER_NAME}" \
    "${IMAGE_NAME}"

if [ $? -ne 0 ]; then
    echo "[ERROR] Failed to run Docker container."
    echo "[HINT] Ensure Docker Desktop is running and you have permissions."
    exit 1
fi

echo "[SUCCESS] Container ${CONTAINER_NAME} is running."
echo "[INFO] Access the application at: http://localhost:${HOST_PORT}"
echo "[INFO] Extracted cURL files will appear in: ${EXPORT_DIR}"
echo "--- Setup Complete ---"

# Optional: Show container logs briefly
echo "[INFO] Showing container logs (press Ctrl+C to stop viewing logs)..."
sleep 2 # Give the container a moment to start
docker logs -f "${CONTAINER_NAME}"

