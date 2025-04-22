# Postman cURL Extractor

A simple tool to extract cURL commands from a Postman collection file.

## Setup
1. Run `./initialize.sh` to create the directory structure.
2. Replace placeholder files (`app/app.py`, `app/templates/index.html`, `Dockerfile`, `build_and_run.sh`) with the actual code provided.
3. Ensure you have Docker Desktop installed and running.

## Usage
1. Run `./build_and_run.sh`.
2. Open your web browser to `http://localhost:5000` (or the host port configured).
3. Upload your Postman collection JSON file.
4. Check the `exported_collections` directory for the generated cURL scripts.
