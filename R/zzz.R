.onLoad <- function(libname, pkgname) {
  # Ensure reticulate is using the correct Python environment
  reticulate::py_install("llama-cpp-python")
  # Import llama_cpp once on package load
  llama <<- reticulate::import_from_path(module = "llama_cpp",
                                         path = 'r-reticulate',
                                         delay_load = TRUE)
}
