#' Install required Python packages
#' @param method Installation method ('virtualenv' or 'conda')
#' @param python_version Python version to use (e.g., "3.9")
#' @export
install_llama_deps <- function(method = "virtualenv", python_version = "3.9") {
  if (!reticulate::py_available(initialize = TRUE)) {
    stop("Python is not available. Please install Python first.")
  }
  
  tryCatch({
    # Create and activate environment
    if (method == "conda") {
      if (is.null(reticulate::conda_binary())) {
        stop("Conda not available. Please install Miniconda or use method='virtualenv'")
      }
      reticulate::conda_install("r-reticulate", "pip")
      reticulate::use_condaenv("r-reticulate", required = TRUE)
    } else {
      message("Setting up Python environment...")
      reticulate::virtualenv_create("r-reticulate", python_version = python_version)
      reticulate::use_virtualenv("r-reticulate", required = TRUE)
    }
    
    # Install the package using pip
    message("Installing llama-cpp-python...")
    result <- system2(
      reticulate::py_config()$python,
      c("-m", "pip", "install", "llama-cpp-python"),
      stdout = TRUE,
      stderr = TRUE
    )
    
    # Check if installation was successful
    if (!reticulate::py_module_available("llama_cpp")) {
      stop("Installation failed. Error: ", paste(result, collapse = "\n"))
    }
    
    message("Installation successful!")
    
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