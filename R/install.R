#' Install required Python packages
#' @param method Installation method ('virtualenv' or 'conda')
#' @param python_version Python version to use (e.g., "3.9")
#' @param envname Name of the virtual environment (default: "r-reticulate")
#' @export
install_llama_deps <- function(method = "virtualenv", 
                             python_version = "3.9",
                             envname = "r-reticulate") {
  if (!reticulate::py_available(initialize = TRUE)) {
    stop("Python is not available. Please install Python first.")
  }
  
  # Try to create a new environment
  tryCatch({
    # First check if python-venv is installed (needed for virtualenv)
    if (method == "virtualenv") {
      # Try to install python3-venv if on Ubuntu/Debian
      if (file.exists("/etc/debian_version")) {
        system("apt-get update && apt-get install -y python3-venv")
      }
    }
    
    if (method == "conda") {
      # Check if conda is available
      if (is.null(reticulate::conda_binary())) {
        stop("Conda not available. Please install Miniconda or use method='virtualenv'")
      }
      message("Creating conda environment...")
      reticulate::conda_create(envname, python_version = python_version)
      reticulate::use_condaenv(envname, required = TRUE)
    } else {
      message("Creating virtual environment...")
      # Try to create virtualenv directly using system Python
      python_cmd <- Sys.which("python3")
      if (python_cmd == "") python_cmd <- Sys.which("python")
      
      if (python_cmd == "") {
        stop("Python not found. Please install Python first.")
      }
      
      # Create virtualenv directory if it doesn't exist
      venv_dir <- file.path(Sys.getenv("HOME"), ".virtualenvs")
      if (!dir.exists(venv_dir)) {
        dir.create(venv_dir, recursive = TRUE)
      }
      
      # Create the virtual environment
      venv_path <- file.path(venv_dir, envname)
      system2(python_cmd, c("-m", "venv", venv_path))
      
      # Use the created environment
      reticulate::use_virtualenv(venv_path, required = TRUE)
    }
    
    # Get Python path
    python <- reticulate::py_config()$python
    
    # Install pip and upgrade it
    message("Upgrading pip...")
    system2(python, c("-m", "ensurepip", "--upgrade"))
    system2(python, c("-m", "pip", "install", "--upgrade", "pip"))
    
    message("Installing llama-cpp-python...")
    reticulate::py_install("llama-cpp-python", pip = TRUE)
    
    # Verify installation
    if (reticulate::py_module_available("llama_cpp")) {
      message("Installation successful!")
    } else {
      stop("Installation failed. Please try installing manually:\n",
           "pip install llama-cpp-python")
    }
  }, error = function(e) {
    stop("Failed to install dependencies: ", e$message, "\n",
         "Try installing manually:\n",
         "1. Create a Python virtual environment:\n",
         "   python3 -m venv ~/.virtualenvs/r-reticulate\n",
         "2. Activate the environment:\n",
         "   source ~/.virtualenvs/r-reticulate/bin/activate\n",
         "3. Install the package:\n",
         "   pip install llama-cpp-python")
  })
} 