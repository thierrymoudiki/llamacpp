# Global variable to pass R CMD check
utils::globalVariables("llama")

.onLoad <- function(libname, pkgname) {
  # Import llama_cpp
  assign("llama", reticulate::import("llama_cpp", delay_load = TRUE), 
         envir = parent.env(environment()))
}

.onAttach <- function(libname, pkgname) {
  # Check if llama-cpp-python is installed
  if (!reticulate::py_module_available("llama_cpp")) {
    packageStartupMessage("Note: The Python package 'llama-cpp-python' is required.\n",
                         "Install it using: reticulate::py_install('llama-cpp-python')")
  }
}
