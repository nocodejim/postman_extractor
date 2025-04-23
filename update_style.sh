#!/bin/bash

# Exit immediately if a command exits with a non-zero status.
set -e

# Define the target HTML file path relative to the script's execution location
TARGET_HTML_FILE="app/templates/index.html"

echo "[INFO] Preparing to update ${TARGET_HTML_FILE} with correct styles, logos, and dual buttons..."

# Check if the target file exists
if [ ! -f "${TARGET_HTML_FILE}" ]; then
    echo "[ERROR] Target file not found: ${TARGET_HTML_FILE}"
    echo "[HINT] Make sure you are running this script from the project's base directory,"
    echo "       and the file exists at 'app/templates/index.html'."
    exit 1
fi

# Use cat and a HERE document (EOF) to overwrite the target HTML file
# This version combines ALL desired elements: CinFin styles, both logos, footer, AND dual buttons.
cat > "${TARGET_HTML_FILE}" << EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Postman Collection Script Extractor</title> <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;600&display=swap" rel="stylesheet">

    <style>
        /* --- Base Styles & Variables (CinFin Inspired + Button Colors) --- */
        :root {
            --primary-blue: #1d398d;
            --secondary-green: #28a745; /* Color for PowerShell button */
            --background-light: #f8f9fa;
            --background-white: #FFFFFF;
            --text-dark: #27272a; /* rgb(39, 39, 42) */
            --text-secondary: #6c757d;
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

        html { font-size: 16px; }

        body {
            font-family: 'Roboto', sans-serif;
            line-height: 1.6;
            color: var(--text-dark);
            background-color: var(--background-light);
            margin: 0; padding: 0;
            display: flex; flex-direction: column;
            min-height: 100vh; font-weight: 400;
        }

        /* --- Layout & Structure --- */
        .page-container {
            max-width: 800px; margin: 0 auto;
            padding: 1em 2em 2em 2em; flex-grow: 1; width: 90%;
        }

        header.main-header {
            background-color: var(--background-white); padding: 0.5em 2em;
            border-bottom: 1px solid var(--border-color); margin-bottom: 2em;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05); display: flex;
            align-items: center; justify-content: space-between; /* Space out logos */
        }

        /* Style for the logo containers */
        .header-logo img,
        .header-logo-secondary img {
             display: block;
             max-height: 70px; /* Consistent max height for both logos */
             width: auto; /* Maintain aspect ratio */
        }

        footer.main-footer {
            background-color: var(--background-white); color: var(--text-secondary);
            text-align: center; padding: 1em 2em; margin-top: auto;
            border-top: 1px solid var(--border-color); font-size: 0.9em;
        }

        /* --- Content Styles --- */
        h1 {
            color: var(--primary-blue); text-align: center;
            margin-bottom: 1em; font-weight: 600;
        }

        .upload-form-container {
            background-color: var(--background-white); padding: 2em;
            border-radius: 8px; box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border: 1px solid var(--border-color);
        }

        .form-group { margin-bottom: 1.5em; }

        label {
            display: block; margin-bottom: 0.5em;
            font-weight: 600; color: var(--text-dark);
        }

        input[type="file"] {
            display: block; width: 100%; padding: 0.7em;
            border: 1px solid var(--border-color); border-radius: 4px;
            box-sizing: border-box; background-color: var(--background-white);
            color: var(--text-dark); font-family: 'Roboto', sans-serif;
        }

        input[type="file"]::file-selector-button {
            background-color: var(--background-light); color: var(--text-dark);
            padding: 0.6em 1em; border: 1px solid var(--border-color);
            border-radius: 4px; cursor: pointer; margin-right: 1em;
            transition: background-color 0.2s ease;
            font-family: 'Roboto', sans-serif; font-weight: 400;
        }
        input[type="file"]::file-selector-button:hover { background-color: #e2e6ea; }

        /* --- Button Styles (Including Dual Buttons) --- */
        .button-group {
            display: flex; /* Arrange buttons side-by-side */
            gap: 1em; /* Space between buttons */
            margin-top: 1.5em; /* Space above buttons */
        }

        button[type="submit"] { /* Style applies to both buttons */
            flex-grow: 1; /* Make buttons share space */
            color: white;
            padding: 0.8em 1.5em; border: none;
            border-radius: 4px; cursor: pointer;
            font-size: 1em; font-weight: 600;
            transition: background-color 0.2s ease, transform 0.1s ease;
            font-family: 'Roboto', sans-serif;
        }
        button[type="submit"]:active {
            transform: scale(0.98); /* Slight press effect */
        }

        /* Specific button colors */
        button.button-shell { background-color: var(--primary-blue); }
        button.button-shell:hover { background-color: #162d72; } /* Darker blue */

        button.button-powershell { background-color: var(--secondary-green); }
        button.button-powershell:hover { background-color: #218838; } /* Darker green */


        /* --- Flash Messages --- */
        .flash-messages { list-style: none; padding: 0; margin: 1.5em 0; }
        .flash-messages li {
            padding: 1em; margin-bottom: 1em; border-radius: 4px;
            border: 1px solid transparent;
        }
        .flash-success { background-color: var(--success-bg); color: var(--success-text); border-color: var(--success-border); }
        .flash-error { background-color: var(--error-bg); color: var(--error-text); border-color: var(--error-border); }
        .flash-warning { background-color: var(--warning-bg); color: var(--warning-text); border-color: var(--warning-border); }

        .description-text {
            margin-top: 2em; text-align: center;
            font-size: 0.95em; color: var(--text-secondary);
        }
    </style>
</head>
<body>

    <header class="main-header">
        <div class="header-logo">
            <img alt="Cincinnati Insurance Companies logo" loading="lazy" width="158" height="70" decoding="async" data-nimg="1" src="https://edge.sitecorecloud.io/cincinna-x33xq9h6/media/Project/Cincinnati-Financial/CinFin/Images/campaign-hidden/cic-logo.svg?h=70&amp;iar=0&amp;w=158&amp;hash=929A68574991C73D4F651345D916C134" style="color: transparent;">
        </div>
        <div class="header-logo-secondary">
            <img alt="Animated Logo" loading="lazy" src="https://raw.githubusercontent.com/nocodejim/mp4_to_svg/master/video.apng" style="color: transparent;">
        </div>
    </header>

    <div class="page-container">
        <h1>Postman Collection Script Extractor</h1>

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
                <div class="button-group">
                    <button type="submit" name="output_format" value="sh" class="button-shell">Process to Shell (.sh)</button>
                    <button type="submit" name="output_format" value="pwsh" class="button-powershell">Process to PowerShell (.ps1)</button>
                </div>
            </form>
        </div>

        <p class="description-text">
            Upload your exported Postman collection file. Choose the desired output script format (.sh for Bash/Shell or .ps1 for PowerShell). The tool will extract requests and save them in the 'exported_collections' directory.
        </p>
    </div> <footer class="main-footer">
        &copy; $(date +%Y) Cincinnati Financial - Jim Ball. Internal Tool.
    </footer>

</body>
</html>
EOF
# End of HERE document

echo "[SUCCESS] ${TARGET_HTML_FILE} has been updated with the correct combined styles, logos, footer, and dual buttons."
echo "[INFO] You may need to clear your browser cache to see the changes."
echo "[INFO] Now you can re-run './build_and_run.sh' to apply the changes to the running container."

