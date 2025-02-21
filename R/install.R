#' Install required Python packages
#' @export
install_llama_deps <- function() {
  reticulate::py_install("llama-cpp-python")
} 