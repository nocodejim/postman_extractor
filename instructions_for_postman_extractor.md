# Instructions for Postman Script Extractor Tool

## 1. What is this?

This tool helps you take a Postman collection file (which usually ends in `.json`) and turn the API requests inside it into simple command-line scripts. You can choose to generate scripts compatible with Bash/Shell (using `curl`) or PowerShell 7+ (using `Invoke-RestMethod`).

### Why?

Sometimes you might receive a Postman collection from someone else (like a vendor or a teammate with a full Postman license), but you might not have a paid Postman license or need a simple way to run those requests without the full Postman app. The free "lightweight" Postman client cannot import these collection files directly. This tool bridges that gap by giving you runnable command-line scripts.

### What are the output scripts?

* **Shell Scripts (`.sh`):** These contain `curl` commands, which are standard on Linux, macOS, and available in Windows environments like Git Bash or WSL.
* **PowerShell Scripts (`.ps1`):** These contain `Invoke-RestMethod` commands, which are native to Windows PowerShell (especially modern versions like 7+).

### What about the Postman Lightweight Client?

It's important to understand that the output of this tool (the `.sh` or `.ps1` files) cannot be directly imported back into the Postman Lightweight API Client. You run these script files from your computer's terminal (like Command Prompt, PowerShell, Terminal, or Git Bash).

## 2. Core Concepts Explained Simply

* **Postman Collection (`.json` file):** A recipe book for APIs (URL, Method, Headers, Body, etc.).
* **`cURL` Command:** A command-line instruction to run a single API request (used in `.sh` files).
* **`Invoke-RestMethod`:** PowerShell's command for making web API requests (used in `.ps1` files).
* **JSON:** A text format for data (how Postman collections are stored).
* **Python/Flask:** The programming language and web toolkit used to build this tool's interface.
* **Docker:** A "shipping container" for software, packaging the app and its needs so you don't have to install Python/Flask locally.
* **Docker Image:** The blueprint for the container.
* **Docker Container:** A running instance of the image (the app running in its box).
* **Bash Script (`.sh` file):** Commands for Linux/macOS/Git Bash terminals.
* **PowerShell Script (`.ps1` file):** Commands for the Windows PowerShell terminal.

## 3. Prerequisites

* **Docker Desktop:** **MUST** be installed and running. Download from [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/).
* **Terminal/Command Line:**
    * For `.sh` files: Git Bash (Windows), Terminal (macOS/Linux), WSL (Windows).
    * For `.ps1` files: Windows PowerShell (preferably version 7 or later).
* **Postman Collection File:** The `.json` file you want to process.

## 4. Setup Steps

*(Ensure you have the latest versions of `app.py`, `index.html` (via `update_style.sh`), `Dockerfile`, `build_and_run.sh`, `initialize.sh`)*

1.  **Create Project Folder:** Make a folder for the tool.
2.  **Save Files:** Place `initialize.sh`, `build_and_run.sh`, `Dockerfile`, `update_style.sh`, `instructions.md` (this file) in the main folder.
3.  **Create `app` Folder:** Inside the main folder, create `app`.
4.  **Save `app.py`:** Place `app.py` inside the `app` folder.
5.  **Create `templates` Folder:** Inside `app`, create `templates`.
6.  **Save `index.html`:** Place `index.html` inside `app/templates`. (Note: `update_style.sh` will overwrite this, so you just need the structure initially).
7.  **Run Initialization Script:**
    * Open your terminal in the main project folder.
    * `chmod +x initialize.sh`
    * `./initialize.sh` (This creates `README.md`, `.gitignore` etc.)
8.  **Run Style Update Script:**
    * `chmod +x update_style.sh`
    * `./update_style.sh` (This creates the correct `index.html` with two buttons).

## 5. Running the Tool

1.  Ensure Docker is Running.
2.  Open Terminal in the project folder.
3.  Make Run Script Executable: `chmod +x build_and_run.sh`
4.  Run the Script: `./build_and_run.sh`
    * This builds the Docker image (if needed) and starts the container.
    * It will show logs; press `Ctrl+C` to stop viewing logs (the app keeps running).

## 6. Using the Web Interface

1.  **Open Browser:** Go to `http://localhost:5000` (or the configured port).
2.  **Upload File:** Click "Choose File", select your Postman `.json` collection.
3.  **Choose Format:** Click either the "Process to Shell (.sh)" button or the "Process to PowerShell (.ps1)" button.
4.  **Check Feedback:** The page will refresh with a success or error message.
5.  **Find Output:** Go to your project folder on your computer. Look inside `exported_collections`. You will find a subdirectory named after your collection with a suffix indicating the format you chose (e.g., `MyCollection_sh` or `MyCollection_pwsh`). Inside that directory are the generated script files (`.sh` or `.ps1`).

## 7. Using the Extracted Script Files

### A. Using Shell Scripts (`.sh`)

1.  **Open Terminal:** Use Bash (Linux, macOS, Git Bash on Windows).
2.  **Navigate:** `cd exported_collections/Your_Collection_Name_sh`
3.  **Make Executable:** `chmod +x Name_Of_Request.sh`
4.  **Run:** `./Name_Of_Request.sh`
    * The API response prints to the terminal.

### B. Using PowerShell Scripts (`.ps1`)

1.  **Open Terminal:** Use PowerShell (preferably v7+).
2.  **Navigate:** `cd exported_collections\Your_Collection_Name_pwsh` (Note the backslash `\` for Windows paths).
3.  **Execution Policy (If Needed):** PowerShell might prevent running scripts by default. You may need to adjust the execution policy for your current session (this is generally safer than changing it globally). Run:
    ```powershell
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope Process -Force
    ```
    *(This allows local scripts to run. You might need to run PowerShell as Administrator to change policies).*
4.  **Run:** Execute the script:
    ```powershell
    .\Name_Of_Request.ps1
    ```
    *(Note the `.\` needed to run scripts in the current directory).*
    * The API response object or data will be displayed in the PowerShell console.

***Note on File Paths in Scripts:*** If your Postman request involved uploading a file (form-data), the generated script will contain a placeholder path like `@"/path/to/your/filename.ext"` (for `.sh`) or `Get-Item -Path '/path/to/your/filename.ext'` (for `.ps1`). You **must** edit the script file and replace this placeholder with the actual path to the file you want to upload on your local machine *before* running the script.

## 8. Stopping the Application

1.  Open Terminal.
2.  Stop Container: `docker stop postman-curl-extractor-instance`
3.  Remove Container (Optional): `docker rm postman-curl-extractor-instance`

## 9. Troubleshooting

* **PowerShell Execution Policy Errors:** See step 7.B.3 above about `Set-ExecutionPolicy`.
* **PowerShell Command Errors:** The generated PowerShell commands are based on common `Invoke-RestMethod` usage. Complex authentication (like OAuth requiring interactive flows) or highly specific body formats might require manual adjustments to the `.ps1` script. Check the error message in PowerShell for clues.
* **File Uploads in PowerShell:** Ensure the path in `Get-Item -Path '...'` is correct and accessible to your PowerShell session.
* *(Other Docker/general errors as previously listed)*