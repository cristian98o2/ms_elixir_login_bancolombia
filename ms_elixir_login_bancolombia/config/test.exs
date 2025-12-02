import Config

config :ms_elixir_login_bancolombia,
  timezone: "America/Bogota",
  env: :test,
  http_port: 8083,
  enable_server: true,
  version: "0.0.1",
  custom_metrics_prefix_name: "ms_elixir_login_bancolombia_test"

config :logger,
  level: :info

config :junit_formatter,
  report_dir: "_build/release",
  automatic_create_dir?: true,
  report_file: "test-junit-report.xml"

config :elixir_structure_manager,
  sonar_base_folder: "ms_elixir_login_bancolombia/"

# tracer
config :opentelemetry,
  span_processor: :batch,
  traces_exporter: {:otel_exporter_stdout, []}

config :ms_elixir_login_bancolombia,
  persistence_map_adapter: MsElixirLoginBancolombia.Adapters.Persistence.Maps.PersistenceMapAgent
