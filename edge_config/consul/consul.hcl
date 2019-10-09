data_dir = "/tmp/"
log_level = "DEBUG"
server = false
ui = false

bind_addr = "0.0.0.0"
client_addr = "0.0.0.0"

connect {
  enabled = true
}

ports {
  grpc = 8502
}

enable_central_service_config = true
