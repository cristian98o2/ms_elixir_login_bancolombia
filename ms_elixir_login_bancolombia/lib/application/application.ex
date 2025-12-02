defmodule MsElixirLoginBancolombia.Application do
  @moduledoc """
  MsElixirLoginBancolombia application
  """

  alias MsElixirLoginBancolombia.Infrastructure.EntryPoint.RouterController
  alias MsElixirLoginBancolombia.Config.{AppConfig, ConfigHolder}
  alias MsElixirLoginBancolombia.Utils.CustomTelemetry
  alias MsElixirLoginBancolombia.Adapters.Persistence.Maps.PersistenceMapAgent

  use Application
  require Logger

  def start(_type, [env]) do
    config = AppConfig.load_config()

    children = with_plug_server(config) ++ application_children(env)

    opts = [strategy: :one_for_one, name: MsElixirLoginBancolombia.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp with_plug_server(%AppConfig{enable_server: true, http_port: port}) do
    Logger.debug("Configure Http server in port #{inspect(port)}. ")
    [{Plug.Cowboy, scheme: :http, plug: RouterController, options: [port: port]}]
  end

  defp with_plug_server(%AppConfig{enable_server: false}), do: []

  def application_children(:test) do
    config = AppConfig.load_config()

    [
      {PersistenceMapAgent, []},
      {ConfigHolder, config},
      {TelemetryMetricsPrometheus, [metrics: CustomTelemetry.metrics()]}
    ]
  end

  def application_children(_other_env) do
    config = AppConfig.load_config()

    [
      {PersistenceMapAgent, []},
      {ConfigHolder, config},
      {TelemetryMetricsPrometheus, [metrics: CustomTelemetry.metrics()]}
    ]
  end
end
