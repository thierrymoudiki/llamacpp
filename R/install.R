#' Install required Python packages
#' @export
install_llama_deps <- function() {
  if (!reticulate::py_available(initialize = TRUE)) {
    stop("Python is not available. Please install Python first.")
  }
  
  message("Installing llama-cpp-python...")
  reticulate::py_install("llama-cpp-python", pip = TRUE)
  
  # Verify installation
  if (reticulate::py_module_available("llama_cpp")) {
    message("Installation successful!")
  } else {
    stop("Installation failed. Please try installing manually:\n",
         "pip install llama-cpp-python")
  }
} 