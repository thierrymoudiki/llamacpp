# Global variable to pass R CMD check
utils::globalVariables("llama")

.onLoad <- function(libname, pkgname) {
  # Try to find and use the r-llama environment
  tryCatch({
    if (reticulate::conda_available() && reticulate::conda_env_exists("r-llama")) {
      reticulate::use_condaenv("r-llama", required = TRUE)
    } else if (reticulate::virtualenv_exists("r-llama")) {
      reticulate::use_virtualenv("r-llama", required = TRUE)
    }
  }, error = function(e) {
    warning("Could not load r-llama environment: ", e$message)
  })
  
  # Import llama_cpp
  assign("llama", reticulate::import("llama_cpp", delay_load = TRUE), 
         envir = parent.env(environment()))
}

.onAttach <- function(libname, pkgname) {
  if (!reticulate::py_module_available("llama_cpp")) {
    packageStartupMessage("Note: The Python package 'llama-cpp-python' is required.\n",
                         "Install it using: llamacpp::install_llama_deps()")
  }
}
