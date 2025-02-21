#' Infer from a llama model
#' @param prompt The prompt to infer from
#' @param model_path The path to the model
#' @param auto_install If TRUE, automatically install dependencies and download model if needed
#' @return The response from the model
#' @export
#'
#' @example
#' 
#' \dontrun{
#' llama_infer("What's the capital of Spain?")
#' }
#' 
llama_infer <- function(prompt = "What's the capital of Spain?", 
                       model_path = NULL,
                       auto_install = TRUE) {
  # First check if Python is available
  if (!reticulate::py_available(initialize = TRUE)) {
    stop("Python is not available. Please install Python and configure reticulate.")
  }

  # Try to load llama_cpp, install if needed and auto_install is TRUE
  if (!reticulate::py_module_available("llama_cpp")) {
    if (auto_install) {
      message("Installing llama-cpp-python...")
      install_llama_deps()
    } else {
      stop("llama_cpp module not found. Set auto_install=TRUE or run install_llama_deps()")
    }
  }
  
  llama <- reticulate::import("llama_cpp")

  # Use a default model path outside the package
  if (is.null(model_path)) {
    model_path <- file.path(Sys.getenv("HOME"), "models", "llama-2-7b-chat.Q4_K_M.gguf")
    
    # Download model if it doesn't exist and auto_install is TRUE
    if (!file.exists(model_path) && auto_install) {
      message("Model not found. Downloading...")
      model_path <- download_llama_model()
    }
  }

  # Ensure the model exists
  if (!file.exists(model_path)) {
    stop("Model file not found: ", model_path, 
         "\nSet auto_install=TRUE or run download_llama_model()")
  }

  # Create model instance and generate response
  tryCatch({
    model <- llama$Llama(model_path = model_path)
    response <- model$completion(prompt)
    return(response)
  }, error = function(e) {
    stop("Error during model inference: ", e$message)
  })
}


#' Download a llama model
#' @param model_name The name of the model to download (default: "llama-2-7b-chat.Q4_K_M.gguf")
#' @param dest_dir The directory to save the model
#' @return The path to the model
#' @export
#'
#' @examples
#' 
#' \dontrun{
#' download_llama_model()
#' }
download_llama_model <- function(
    model_name = "llama-2-7b-chat.Q4_K_M.gguf",
    dest_dir = file.path(Sys.getenv("HOME"), "models")) {
  
  base_url <- "https://huggingface.co/TheBloke/Llama-2-7B-Chat-GGUF/resolve/main"
  model_url <- file.path(base_url, model_name)
  
  if (!dir.exists(dest_dir)) dir.create(dest_dir, recursive = TRUE)
  dest_file <- file.path(dest_dir, model_name)

  if (!file.exists(dest_file)) {
    message("Downloading model from ", model_url)
    message("This may take a while...")
    download.file(model_url, destfile = dest_file, mode = "wb")
    message("Download complete: ", dest_file)
  } else {
    message("Model already exists: ", dest_file)
  }

  return(dest_file)
}
