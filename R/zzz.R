# Global variable to pass R CMD check
utils::globalVariables("llama")

.onLoad <- function(libname, pkgname) {
  # Try to find and use the r-reticulate environment
  tryCatch({
    if (!is.null(reticulate::conda_binary()) && 
        length(reticulate::conda_list()$name == "r-reticulate") > 0) {
      reticulate::use_condaenv("r-reticulate", required = TRUE)
    } else if (reticulate::virtualenv_exists("r-reticulate")) {
      reticulate::use_virtualenv("r-reticulate", required = TRUE)
    }
  }, error = function(e) {
    warning("Could not load r-reticulate environment: ", e$message)
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
