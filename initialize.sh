#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

echo "--- Initializing Postman cURL Extractor Project Structure ---"

# Define directories to create
APP_DIR="app"
TEMPLATES_DIR="${APP_DIR}/templates"
EXPORT_DIR="exported_collections"
UPLOAD_DIR="uploads" # Optional, but good to have if app saves uploads

# Create main directories
echo "[INFO] Creating main directories..."
mkdir -p "${APP_DIR}"
mkdir -p "${TEMPLATES_DIR}"
mkdir -p "${EXPORT_DIR}"
mkdir -p "${UPLOAD_DIR}" # Create uploads dir too

# Create placeholder files (optional, but helpful)
echo "[INFO] Creating placeholder/example files..."

# Create app.py (if it doesn't exist)
if [ ! -f "${APP_DIR}/app.py" ]; then
    echo "# Placeholder for app.py - Replace with actual Flask app code" > "${APP_DIR}/app.py"
    echo "print('app.py created')" >> "${APP_DIR}/app.py"
    echo "[CREATED] ${APP_DIR}/app.py"
else
    echo "[EXISTS] ${APP_DIR}/app.py"
fi

# Create templates/index.html (if it doesn't exist)
if [ ! -f "${TEMPLATES_DIR}/index.html" ]; then
    echo "<!DOCTYPE html><html><head><title>Upload</title></head><body><h1>Upload Postman Collection</h1><form method='post' enctype='multipart/form-data'><input type='file' name='file'><button type='submit'>Upload</button></form></body></html>" > "${TEMPLATES_DIR}/index.html"
    echo "[CREATED] ${TEMPLATES_DIR}/index.html"
else
    echo "[EXISTS] ${TEMPLATES_DIR}/index.html"
fi

# Create Dockerfile (if it doesn't exist)
if [ ! -f "Dockerfile" ]; then
    echo "# Placeholder for Dockerfile - Replace with actual Dockerfile content" > "Dockerfile"
    echo "FROM python:3.9-slim" >> "Dockerfile"
    echo "WORKDIR /app" >> "Dockerfile"
    echo "RUN pip install Flask" >> "Dockerfile"
    echo "COPY ./app /app" >> "Dockerfile"
    echo "EXPOSE 5000" >> "Dockerfile"
    echo "CMD [\"python\", \"-u\", \"app.py\"]" >> "Dockerfile"
    echo "[CREATED] Dockerfile"
else
    echo "[EXISTS] Dockerfile"
fi

# Create build_and_run.sh (if it doesn't exist)
if [ ! -f "build_and_run.sh" ]; then
    echo "#!/bin/bash" > "build_and_run.sh"
    echo "echo 'Placeholder build_and_run.sh - Replace with actual script'" >> "build_and_run.sh"
    echo "docker build -t myapp ." >> "build_and_run.sh"
    echo "docker run -p 5000:5000 myapp" >> "build_and_run.sh"
    chmod +x "build_and_run.sh" # Make it executable
    echo "[CREATED] build_and_run.sh (executable)"
else
    echo "[EXISTS] build_and_run.sh"
fi

# Create initialize.sh (self - if it doesn't exist, though it must to run)
if [ ! -f "initialize.sh" ]; then
    echo "#!/bin/bash" > "initialize.sh"
    echo "echo 'Placeholder initialize.sh'" >> "initialize.sh"
    chmod +x "initialize.sh" # Make it executable
    echo "[CREATED] initialize.sh (executable)"
else
     # Ensure it's executable if it exists
     chmod +x "initialize.sh"
     echo "[EXISTS] initialize.sh (executable)"
fi


# Create README.md (if it doesn't exist)
if [ ! -f "README.md" ]; then
    echo "# Postman cURL Extractor" > README.md
    echo "" >> README.md
    echo "A simple tool to extract cURL commands from a Postman collection file." >> README.md
    echo "" >> README.md
    echo "## Setup" >> README.md
    echo "1. Run \`./initialize.sh\` to create the directory structure." >> README.md
    echo "2. Replace placeholder files (\`app/app.py\`, \`app/templates/index.html\`, \`Dockerfile\`, \`build_and_run.sh\`) with the actual code provided." >> README.md
    echo "3. Ensure you have Docker Desktop installed and running." >> README.md
    echo "" >> README.md
    echo "## Usage" >> README.md
    echo "1. Run \`./build_and_run.sh\`." >> README.md
    echo "2. Open your web browser to \`http://localhost:5000\` (or the host port configured)." >> README.md
    echo "3. Upload your Postman collection JSON file." >> README.md
    echo "4. Check the \`exported_collections\` directory for the generated cURL scripts." >> README.md
    echo "[CREATED] README.md"
else
    echo "[EXISTS] README.md"
fi

# Create .gitignore (if it doesn't exist) - Good practice if using Git
if [ ! -f ".gitignore" ]; then
    echo "# Ignore Python cache files" > .gitignore
    echo "__pycache__/" >> .gitignore
    echo "*.pyc" >> .gitignore
    echo "*.pyo" >> .gitignore
    echo "" >> .gitignore
    echo "# Ignore virtual environment folders (if used locally)" >> .gitignore
    echo "venv/" >> .gitignore
    echo ".venv/" >> .gitignore
    echo "" >> .gitignore
    echo "# Ignore temporary upload files" >> .gitignore
    echo "uploads/" >> .gitignore
    echo "" >> .gitignore
    echo "# Ignore exported collections (usually generated artifacts)" >> .gitignore
    echo "exported_collections/" >> .gitignore
    echo "[CREATED] .gitignore"
else
    echo "[EXISTS] .gitignore"
fi


echo "--- Project structure initialization complete. ---"
echo "Next steps:"
echo "1. Replace placeholder files with the actual code provided."
echo "2. Ensure Docker Desktop is installed and running."
echo "3. Run './build_and_run.sh' to start the application."

