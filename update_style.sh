#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Define the target HTML file path relative to the script's execution location
TARGET_HTML_FILE="app/templates/index.html"

echo "[INFO] Preparing to update the style of ${TARGET_HTML_FILE} with revised branding and footer..."

# Check if the target file exists
if [ ! -f "${TARGET_HTML_FILE}" ]; then
    echo "[ERROR] Target file not found: ${TARGET_HTML_FILE}"
    echo "[HINT] Make sure you are running this script from the project's base directory,"
    echo "       and the file exists at 'app/templates/index.html'."
    exit 1
fi

# Use cat and a HERE document (EOF) to overwrite the target HTML file
# This replaces the entire content of the file with the new HTML structure below.
cat > "${TARGET_HTML_FILE}" << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Postman Collection to cURL Extractor</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;600&display=swap" rel="stylesheet">

    <style>
        /* --- Base Styles & Variables (Updated) --- */
        :root {
            /* Retaining primary blue for accents/buttons as per initial request */
            --primary-blue: #1d398d;
            /* Backgrounds based on analysis */
            --background-light: #f8f9fa; /* Light gray for overall page bg */
            --background-white: #FFFFFF; /* White for content containers */
            /* Text colors based on analysis */
            --text-dark: #27272a; /* rgb(39, 39, 42) */
            --text-secondary: #6c757d; /* Keeping a standard secondary gray */
            /* Borders and Alerts */
            --border-color: #dee2e6;
            --success-bg: #d4edda;
            --success-text: #155724;
            --success-border: #c3e6cb;
            --error-bg: #f8d7da;
            --error-text: #721c24;
            --error-border: #f5c6cb;
            --warning-bg: #fff3cd;
            --warning-text: #856404;
            --warning-border: #ffeeba;
        }

        html {
            /* Set base font size, though body usually takes precedence */
            font-size: 16px;
        }

        body {
            font-family: 'Roboto', sans-serif; /* Updated Font */
            line-height: 1.6;
            color: var(--text-dark); /* Updated Text Color */
            background-color: var(--background-light); /* Use light gray for page */
            margin: 0;
            padding: 0;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            font-weight: 400; /* Default weight */
        }

        /* --- Layout & Structure --- */
        .page-container {
            max-width: 800px;
            margin: 0 auto;
            padding: 1em 2em 2em 2em;
            flex-grow: 1;
            width: 90%;
        }

        header.main-header {
            background-color: var(--background-white); /* White header background */
            padding: 0.5em 2em; /* Adjusted padding for logo */
            border-bottom: 1px solid var(--border-color);
            margin-bottom: 2em;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
            display: flex; /* Align logo */
            align-items: center;
        }

        /* Style for the actual logo image */
        .header-logo img {
             display: block; /* Remove extra space below image */
             /* Height is set on the img tag, width adjusts automatically */
             max-height: 70px; /* Ensure logo doesn't get too tall */
             width: auto; /* Maintain aspect ratio */
        }


        footer.main-footer {
            background-color: var(--background-white);
            color: var(--text-secondary);
            text-align: center;
            padding: 1em 2em;
            margin-top: auto;
            border-top: 1px solid var(--border-color);
            font-size: 0.9em;
        }

        /* --- Content Styles --- */
        h1 {
            color: var(--primary-blue);
            text-align: center;
            margin-bottom: 1em;
            font-weight: 600; /* Heading weight */
        }

        .upload-form-container {
            background-color: var(--background-white); /* White form background */
            padding: 2em;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border: 1px solid var(--border-color);
        }

        .form-group {
            margin-bottom: 1.5em;
        }

        label {
            display: block;
            margin-bottom: 0.5em;
            font-weight: 600; /* Semibold labels */
            color: var(--text-dark);
        }

        input[type="file"] {
            display: block;
            width: 100%;
            padding: 0.7em;
            border: 1px solid var(--border-color);
            border-radius: 4px;
            box-sizing: border-box;
            background-color: var(--background-white);
            color: var(--text-dark);
            font-family: 'Roboto', sans-serif; /* Ensure input uses correct font */
        }

        input[type="file"]::file-selector-button {
            background-color: var(--background-light);
            color: var(--text-dark);
            padding: 0.6em 1em;
            border: 1px solid var(--border-color);
            border-radius: 4px;
            cursor: pointer;
            margin-right: 1em;
            transition: background-color 0.2s ease;
            font-family: 'Roboto', sans-serif; /* Ensure button uses correct font */
            font-weight: 400;
        }
        input[type="file"]::file-selector-button:hover {
             background-color: #e2e6ea;
        }


        button[type="submit"] {
            background-color: var(--primary-blue);
            color: white;
            padding: 0.8em 1.5em;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 1em;
            font-weight: 600;
            display: block;
            width: 100%;
            margin-top: 1em;
            transition: background-color 0.2s ease;
            font-family: 'Roboto', sans-serif; /* Ensure button uses correct font */
        }

        button[type="submit"]:hover {
            background-color: #162d72; /* Darker blue on hover */
        }

        .flash-messages {
            list-style: none;
            padding: 0;
            margin: 1.5em 0;
        }

        .flash-messages li {
            padding: 1em;
            margin-bottom: 1em;
            border-radius: 4px;
            border: 1px solid transparent;
        }

        .flash-success {
            background-color: var(--success-bg);
            color: var(--success-text);
            border-color: var(--success-border);
        }

        .flash-error {
            background-color: var(--error-bg);
            color: var(--error-text);
            border-color: var(--error-border);
        }

        .flash-warning {
            background-color: var(--warning-bg);
            color: var(--warning-text);
            border-color: var(--warning-border);
        }

        .description-text {
            margin-top: 2em;
            text-align: center;
            font-size: 0.95em;
            color: var(--text-secondary);
        }
    </style>
</head>
<body>

    <header class="main-header">
        <div class="header-logo">
            <img alt="Cincinnati Insurance Companies logo" loading="lazy" width="158" height="70" decoding="async" data-nimg="1" src="https://edge.sitecorecloud.io/cincinna-x33xq9h6/media/Project/Cincinnati-Financial/CinFin/Images/campaign-hidden/cic-logo.svg?h=70&amp;iar=0&amp;w=158&amp;hash=929A68574991C73D4F651345D916C134" style="color: transparent;">
        </div>
    </header>

    <div class="page-container">
        <h1>Postman Collection to cURL Extractor</h1>

        {% with messages = get_flashed_messages(with_categories=true) %}
          {% if messages %}
            <ul class="flash-messages">
            {% for category, message in messages %}
              <li class="flash-{{ category }}">{{ message }}</li>
            {% endfor %}
            </ul>
          {% endif %}
        {% endwith %}

        <div class="upload-form-container">
            <form method="post" action="{{ url_for('upload_file') }}" enctype="multipart/form-data">
                <div class="form-group">
                    <label for="file">Select Postman Collection (.json file):</label>
                    <input type="file" name="file" id="file" accept=".json" required>
                </div>
                <button type="submit">Process Collection</button>
            </form>
        </div>

        <p class="description-text">
            Upload your exported Postman collection file. The tool will extract requests and save them as individual cURL command scripts (.sh files) in the 'exported_collections' directory.
        </p>
    </div> <footer class="main-footer">
        &copy; $(date +%Y) Cincinnati Financial - Jim Ball. Internal Tool.
    </footer>

</body>
</html>
EOF
# End of HERE document

echo "[SUCCESS] ${TARGET_HTML_FILE} has been updated with the Cincinnati Financial logo and revised styling/footer."
echo "[INFO] You may need to clear your browser cache to see the changes."
echo "[INFO] Now you can re-run './build_and_run.sh' to apply the changes to the running container."

