#' Install required Python packages
#' @param method Installation method ('virtualenv' or 'conda')
#' @param python_version Python version to use (e.g., "3.9")
#' @export
install_llama_deps <- function(method = "virtualenv", python_version = "3.9") {
  # Check for Python
  python_cmd <- Sys.which("python3")
  if (python_cmd == "") python_cmd <- Sys.which("python")
  if (python_cmd == "") {
    stop("Python not found. Please install Python first.")
  }
  
  tryCatch({
    if (method == "conda") {
      stop("Conda method not yet supported. Please use method='virtualenv'")
    } else {
      message("Setting up Python environment...")
      
      # Create virtualenv directory
      venv_dir <- "~/.virtualenvs/r-reticulate"
      dir.create(dirname(venv_dir), showWarnings = FALSE, recursive = TRUE)
      
      # Create virtual environment
      result <- system2("python3", c("-m", "venv", venv_dir))
      if (result != 0) {
        stop("Failed to create virtual environment")
      }
      
      # Get the pip path
      pip_path <- file.path(venv_dir, "bin", "pip")
      if (.Platform$OS.type == "windows") {
        pip_path <- file.path(venv_dir, "Scripts", "pip.exe")
      }
      
      # Install/upgrade pip
      message("Upgrading pip...")
      system2(pip_path, c("install", "--upgrade", "pip"))
      
      # Install llama-cpp-python
      message("Installing llama-cpp-python...")
      result <- system2(pip_path, 
                       c("install", "llama-cpp-python"),
                       stdout = TRUE, 
                       stderr = TRUE)
      
      # Set up reticulate to use this environment
      Sys.setenv(RETICULATE_PYTHON = file.path(venv_dir, "bin", "python"))
      reticulate::use_virtualenv(venv_dir, required = TRUE)
      
      # Verify installation
      if (!reticulate::py_module_available("llama_cpp")) {
        stop("Installation verification failed. Error: ", 
             paste(result, collapse = "\n"))
      }
      
      message("Installation successful!")
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