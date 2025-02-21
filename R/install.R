#' Install required Python packages
#' @param method Installation method ('virtualenv' or 'conda')
#' @param python_version Python version to use (e.g., "3.9")
#' @export
install_llama_deps <- function(method = "virtualenv", python_version = "3.9") {
  if (!reticulate::py_available(initialize = TRUE)) {
    stop("Python is not available. Please install Python first.")
  }
  
  # Try to create a new environment
  tryCatch({
    env_name <- "r-llama"
    
    if (method == "conda") {
      # Check if conda is available
      if (is.null(reticulate::conda_binary())) {
        stop("Conda not available. Please install Miniconda or use method='virtualenv'")
      }
      message("Creating conda environment...")
      reticulate::conda_create(env_name, python_version = python_version)
      reticulate::use_condaenv(env_name, required = TRUE)
    } else {
      message("Creating virtual environment...")
      reticulate::virtualenv_create(env_name, python_version = python_version)
      reticulate::use_virtualenv(env_name, required = TRUE)
    }
    
    # Install pip if needed
    python <- reticulate::py_config()$python
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
         "1. Create a Python virtual environment\n",
         "2. Run: pip install llama-cpp-python")
  })
} 