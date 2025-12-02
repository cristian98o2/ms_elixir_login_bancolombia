defmodule MsElixirLoginBancolombia.Infrastructure.EntryPoint.HealthCheck do
  @moduledoc """
  MsElixirLoginBancolombia health check
  """

  alias MsElixirLoginBancolombia.Config.ConfigHolder

  def health() do
    version = ConfigHolder.conf().version
      %{status: "UP", version: version}
  end

  def check_http(), do: :ok
end
