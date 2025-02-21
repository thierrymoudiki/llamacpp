#' Infer from a llama model
#' @param prompt The prompt to infer from
#' @param model_path The path to the model
#' @return The response from the model
#' @export
#'
#' @example
#' 
#' \dontrun{
#' llama_infer("What's the capital of Spain?")
#' }
#' 
llama_infer <- function(prompt = "What's the capital of Spain?", model_path = NULL) {
  if (!exists("llama", envir = .GlobalEnv) || is.null(llama)) {
    stop("llama_cpp module not loaded. Make sure Python is properly set up.")
  }

  # Use a default model path outside the package
  if (is.null(model_path)) {
    model_path <- file.path(Sys.getenv("HOME"), "models", "llama-7b.gguf")
  }

  # Ensure the model exists
  if (!file.exists(model_path)) {
    stop(paste("Model file not found:", model_path, "\nDownload it manually or use `download_llama_model()`"))
  }

  model <- llama$Llama(model_path = model_path)
  response <- model$completion(prompt)
  return(response)
}


#' Download a llama model
#' @param model_url The URL to the model
#' @param dest_dir The directory to save the model
#' @return The path to the model
#' @export
#'
#' @examples
#' 
#' \dontrun{
#' download_llama_model()
#' }
download_llama_model <- function(model_url = "https://your_model_host.com/llama-7b.gguf",
                                 dest_dir = file.path(Sys.getenv("HOME"), "models")) {
  if (!dir.exists(dest_dir)) dir.create(dest_dir, recursive = TRUE)
  dest_file <- file.path(dest_dir, basename(model_url))

  if (!file.exists(dest_file)) {
    message("Downloading model... This may take a while.")
    download.file(model_url, destfile = dest_file, mode = "wb")
    message("Download complete: ", dest_file)
  } else {
    message("Model already exists: ", dest_file)
  }

  return(dest_file)
}
