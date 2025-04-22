# Use an official Python runtime as a parent image
# Using slim-buster for a smaller image size
FROM python:3.9-slim-buster

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file into the container at /app
# (We only need Flask for this simple app, so we install it directly)
# If you had more dependencies, you'd use: COPY requirements.txt .
# RUN pip install --no-cache-dir -r requirements.txt

# Install Flask directly
# --no-cache-dir reduces image size
# --trusted-host pypi.python.org avoids potential issues in some network environments
RUN pip install --no-cache-dir --trusted-host pypi.python.org -U Flask

# --- Correction ---
# Copy the contents of the local 'app' directory into the container at /app
# This ensures app.py and templates/ are directly under /app in the container
COPY ./app /app
# --- End Correction ---

# Create necessary directories within the container image
# Although volumes will be mounted, creating them ensures they exist
# Note: 'uploads' isn't strictly needed inside the image if not saving uploads there
# but 'exported_collections' is the target for the volume mount point.
RUN mkdir -p /app/uploads && mkdir -p /app/exported_collections

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Define environment variables (optional, but good practice)
# ENV NAME World

# Run app.py when the container launches
# Uses "python -u" for unbuffered output, which helps with logging in Docker
CMD ["python", "-u", "app.py"]

