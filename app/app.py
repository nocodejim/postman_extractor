# app.py
import os
import json
import logging
from flask import Flask, request, render_template, redirect, url_for, flash

# --- Configuration ---
# Directory where uploaded files are temporarily stored
UPLOAD_FOLDER = 'uploads'
# Directory where extracted cURL commands will be saved
EXPORT_FOLDER = 'exported_collections'
# Allowed file extension for uploads
ALLOWED_EXTENSIONS = {'json'}

# --- Flask App Setup ---
app = Flask(__name__)
app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER
app.config['EXPORT_FOLDER'] = EXPORT_FOLDER
# Secret key for flashing messages (important for session security)
app.secret_key = b'_5#y2L"F4Q8z\n\xec]/'

# --- Logging Setup ---
# Configure logging to output informational messages
logging.basicConfig(level=logging.INFO,
                    format='%(asctime)s - %(levelname)s - %(message)s')

# --- Helper Functions ---

def allowed_file(filename):
    """Checks if the uploaded file has an allowed extension ('.json')."""
    return '.' in filename and \
           filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

def generate_curl_command(request_item, collection_name):
    """
    Generates a cURL command string from a Postman request item.
    Handles basic request components: method, URL, headers, body (raw).
    Does NOT handle complex auth, variables, or script dependencies.
    """
    try:
        method = request_item.get('request', {}).get('method', 'GET').upper()
        url_parts = request_item.get('request', {}).get('url', {})

        # Handle simple string URL or detailed object URL
        if isinstance(url_parts, str):
            url = url_parts # Assume it's a simple string URL
        elif isinstance(url_parts, dict):
             # Reconstruct URL from parts (protocol, host, path)
            protocol = url_parts.get('protocol', 'http')
            host = ".".join(url_parts.get('host', []))
            path = "/".join(url_parts.get('path', []))
            raw_query = url_parts.get('query')
            query_string = ""
            if raw_query:
                # Build query string from key-value pairs
                query_params = [f"{q['key']}={q['value']}" for q in raw_query if q.get('key') and not q.get('disabled')]
                if query_params:
                    query_string = "?" + "&".join(query_params)

            # Add leading slash to path if host exists and path doesn't start with one
            if host and path and not path.startswith('/'):
                path = '/' + path

            url = f"{protocol}://{host}{path}{query_string}"
            # Handle cases where URL might just be a variable like {{baseUrl}}
            if not host and not path and url_parts.get('raw'):
                 url = url_parts.get('raw')

        else:
            logging.warning(f"Skipping request '{request_item.get('name', 'Unnamed')}' due to unexpected URL format: {url_parts}")
            return None # Skip if URL format is unexpected

        # Basic curl command structure
        curl_command = f"curl --location --request {method} '{url}'"

        # Add headers
        headers = request_item.get('request', {}).get('header', [])
        for header in headers:
            # Skip disabled headers
            if not header.get('disabled'):
                # Escape single quotes in header values
                header_key = header.get('key')
                header_value = header.get('value', '').replace("'", "'\\''")
                if header_key: # Ensure header key exists
                     curl_command += f" \\\n--header '{header_key}: {header_value}'"

        # Add body (only handles 'raw' mode for simplicity)
        body = request_item.get('request', {}).get('body', {})
        if body and body.get('mode') == 'raw':
            raw_body = body.get('raw', '').replace("'", "'\\''") # Escape single quotes
            if raw_body:
                 # Use --data-raw to preserve exact body content
                curl_command += f" \\\n--data-raw '{raw_body}'"
        elif body and body.get('mode') == 'formdata':
             # Add form data parts
             formdata = body.get('formdata', [])
             for item in formdata:
                  if not item.get('disabled') and item.get('key'):
                       # Escape single quotes in values
                       key = item.get('key')
                       value = item.get('value', '').replace("'", "'\\''")
                       item_type = item.get('type', 'text')
                       if item_type == 'file':
                            # For file uploads, indicate the source file path
                            curl_command += f" \\\n--form '{key}=@\"/path/to/your/{value}\"'" # User needs to replace path
                       else:
                            curl_command += f" \\\n--form '{key}={value}'"
        elif body and body.get('mode') == 'urlencoded':
             # Add URL-encoded form parts
             urlencoded_data = body.get('urlencoded', [])
             for item in urlencoded_data:
                 if not item.get('disabled') and item.get('key'):
                      # Escape single quotes in values
                      key = item.get('key')
                      value = item.get('value', '').replace("'", "'\\''")
                      curl_command += f" \\\n--data-urlencode '{key}={value}'"


        return curl_command

    except Exception as e:
        logging.error(f"Error generating cURL for request '{request_item.get('name', 'Unnamed')}': {e}", exc_info=True)
        return None

def process_collection_item(item, collection_name, export_dir):
    """
    Recursively processes items (requests or folders) in a Postman collection.
    Saves generated cURL commands to files.
    """
    # Check if the item is a folder (has 'item' key) or a request
    if 'item' in item:
        # It's a folder, process its contents recursively
        folder_name = item.get('name', 'UnnamedFolder')
        logging.info(f"Processing folder: {folder_name}")
        # Create a subdirectory for the folder if it doesn't exist
        folder_export_dir = os.path.join(export_dir, sanitize_filename(folder_name))
        os.makedirs(folder_export_dir, exist_ok=True)
        for sub_item in item.get('item', []):
            process_collection_item(sub_item, collection_name, folder_export_dir)
    elif 'request' in item:
        # It's a request
        request_name = item.get('name', 'UnnamedRequest')
        logging.info(f"Processing request: {request_name}")
        curl_command = generate_curl_command(item, collection_name)
        if curl_command:
            # Sanitize filename and save the cURL command to a .sh file
            filename = sanitize_filename(request_name) + ".sh"
            filepath = os.path.join(export_dir, filename)
            try:
                with open(filepath, 'w') as f:
                    f.write("#!/bin/bash\n\n")
                    f.write("# Generated from Postman collection: " + collection_name + "\n")
                    f.write("# Request: " + request_name + "\n\n")
                    f.write(curl_command + "\n")
                logging.info(f"Saved cURL command to: {filepath}")
            except IOError as e:
                logging.error(f"Failed to write file {filepath}: {e}")
            except Exception as e:
                 logging.error(f"An unexpected error occurred writing file {filepath}: {e}")
        else:
             logging.warning(f"Could not generate cURL for request: {request_name}")


def sanitize_filename(name):
    """Removes or replaces characters invalid for filenames."""
    # Remove leading/trailing whitespace
    name = name.strip()
    # Replace spaces and common invalid characters with underscores
    name = name.replace(' ', '_').replace('/', '_').replace('\\', '_').replace(':', '_')
    name = name.replace('*', '_').replace('?', '_').replace('"', '_').replace('<', '_')
    name = name.replace('>', '_').replace('|', '_')
    # Limit length to avoid issues on some filesystems
    return name[:100]

# --- Flask Routes ---

@app.route('/', methods=['GET'])
def index():
    """Renders the main upload page."""
    # Renders the html template located in templates/index.html
    return render_template('index.html')

@app.route('/upload', methods=['POST'])
def upload_file():
    """Handles file upload, processes the collection, and redirects."""
    if 'file' not in request.files:
        flash('No file part in the request!', 'error')
        return redirect(url_for('index'))

    file = request.files['file']

    if file.filename == '':
        flash('No file selected!', 'error')
        return redirect(url_for('index'))

    if file and allowed_file(file.filename):
        # Ensure upload and export directories exist
        os.makedirs(app.config['UPLOAD_FOLDER'], exist_ok=True)
        os.makedirs(app.config['EXPORT_FOLDER'], exist_ok=True)

        # Save the uploaded file temporarily (optional, could process in memory)
        # For simplicity and potentially large files, saving first is safer.
        # Using a sanitized filename is less critical here as it's temporary.
        # filepath = os.path.join(app.config['UPLOAD_FOLDER'], file.filename)
        # file.save(filepath)
        # logging.info(f"File temporarily saved to {filepath}")

        try:
            # Read the content directly from the file stream
            file_content = file.read().decode('utf-8')
            collection_data = json.loads(file_content)
            # collection_data = json.load(file) # Alternative if saving file first

            collection_name = collection_data.get('info', {}).get('name', 'UnnamedCollection')
            logging.info(f"Processing collection: {collection_name}")

            # Create a subdirectory within EXPORT_FOLDER named after the collection
            collection_export_dir = os.path.join(app.config['EXPORT_FOLDER'], sanitize_filename(collection_name))
            os.makedirs(collection_export_dir, exist_ok=True)
            logging.info(f"Output directory created: {collection_export_dir}")

            # Process items (requests and folders)
            items = collection_data.get('item', [])
            if not items:
                 flash('Collection appears to be empty or has an invalid structure.', 'warning')
                 return redirect(url_for('index'))

            for item in items:
                process_collection_item(item, collection_name, collection_export_dir)

            flash(f'Collection "{collection_name}" processed successfully! Check the "exported_collections/{sanitize_filename(collection_name)}" directory.', 'success')

        except json.JSONDecodeError:
            logging.error("Failed to decode JSON from uploaded file.")
            flash('Invalid JSON file. Please upload a valid Postman collection.', 'error')
        except Exception as e:
            logging.error(f"An error occurred during processing: {e}", exc_info=True)
            flash(f'An unexpected error occurred: {e}', 'error')
        # finally:
            # Clean up the uploaded file if it was saved
            # if os.path.exists(filepath):
            #     os.remove(filepath)
            #     logging.info(f"Temporary file {filepath} removed.")

        return redirect(url_for('index'))
    else:
        flash('Invalid file type. Please upload a .json file.', 'error')
        return redirect(url_for('index'))

# --- Main Execution ---
if __name__ == '__main__':
    # Runs the Flask app.
    # host='0.0.0.0' makes it accessible from outside the container.
    # debug=True is useful for development but should be False in production.
    app.run(host='0.0.0.0', port=5000, debug=False)
