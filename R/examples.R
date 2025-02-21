#' Complete example of using the llamacpp package
#' @examples
#' \dontrun{
#' # 1. First time setup (only needed once)
#' llamacpp::install_llama_deps()
#' 
#' # 2. Basic usage with automatic model download
#' response <- llamacpp::llama_infer("What is artificial intelligence?")
#' print(response)
#' 
#' # 3. More examples with different prompts
#' # Creative writing
#' story <- llamacpp::llama_infer(
#'   "Write a very short story about a robot learning to paint."
#' )
#' print(story)
#' 
#' # Technical explanation
#' explanation <- llamacpp::llama_infer(
#'   "Explain how a neural network works in simple terms."
#' )
#' print(explanation)
#' 
#' # 4. Advanced usage with custom model path
#' # First download a specific model
#' model_path <- llamacpp::download_llama_model(
#'   model_name = "llama-2-7b-chat.Q2_K.gguf",  # smaller, faster model
#'   dest_dir = "~/my_models"  # custom directory
#' )
#' 
#' # Then use it for inference
#' response <- llamacpp::llama_infer(
#'   prompt = "What's the meaning of life?",
#'   model_path = model_path
#' )
#' print(response)
#' } 