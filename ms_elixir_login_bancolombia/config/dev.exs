import Config

config :ms_elixir_login_bancolombia,
  timezone: "America/Bogota",
  env: :dev,
  http_port: 8083,
  enable_server: true,
  version: "0.0.1",
  custom_metrics_prefix_name: "ms_elixir_login_bancolombia_local"

config :logger,
  level: :debug

# tracer
config :opentelemetry,
  span_processor: :batch,
  traces_exporter: {:otel_exporter_stdout, []}

config :ms_elixir_login_bancolombia,
  persistence_map_adapter: MsElixirLoginBancolombia.Adapters.Persistence.Maps.PersistenceMapAgent
