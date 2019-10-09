services {
  id   = "edge-proxy"
  name = "edge-proxy"
  // envoy admin port
  port = 19000

  check {
    name = "Envoy Server Info Endpoint"
    http = "http://localhost:19000/server_info"
    interval = "15s"
  }

  connect {
    sidecar_service {
      proxy {
        upstreams {
          destination_name = "web"
          local_bind_port  = 14001
        }

        upstreams {
          destination_name = "api"
          local_bind_port  = 14002
        }
      }

      // Overwrite default checks, so Consul contacts Envoy on it's Admin port instead of the expected public_listener port.
      checks {
        name = "Envoy Admin Listener"
        tcp = "127.0.0.1:19000"
        interval = "10s"
      }

      checks {
        name = "Envoy HTTPS Listener"
        tcp = "127.0.0.1:443"
        interval = "10s"
      }
    }
  }
}