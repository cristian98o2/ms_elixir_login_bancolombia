defmodule MsElixirLoginBancolombia.Infrastructure.EntryPoint.RouterController do
  @compile if Mix.env() == :test, do: :export_all
    @moduledoc """
    Access point to the rest exposed services
    """

  alias MsElixirLoginBancolombia.Infrastructure.EntryPoint.HealthCheck
  alias MsElixirLoginBancolombia.EntryPoints.Shared.BuildResponse

  require Logger
  use Plug.Router
  use Timex

  @path_health "/health"
  @path_signup "/signup"
  @path_signin "/signin"

  plug(CORSPlug,
    methods: ["GET", "POST", "PUT", "DELETE"],
    origin: [~r/.*/],
    headers: ["Content-Type", "Accept", "User-Agent"]
  )

  plug(Plug.Logger, log: :debug)
  plug(:match)
  plug(OpentelemetryPlug.Propagation)
  plug(Plug.Parsers, parsers: [:urlencoded, :json], json_decoder: Poison)
  plug(Plug.Telemetry, event_prefix: [:internal_information_ms, :plug])
  plug(:dispatch)

  get @path_health do
    HealthCheck.health()
    |> BuildResponse.build_response(conn)
  end

  forward(@path_signup,
    to:
      MsElixirLoginBancolombia.Infrastructure.EntryPoint.Signup.SignupUserHandler
  )

  forward(@path_signin,
    to: MsElixirLoginBancolombia.Infrastructure.EntryPoint.Signin.SigninUserHandler
  )

  match _ do
    handle_not_found(conn)
  end

  defp handle_not_found(conn) do
    if Logger.level() == :debug do
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(404, Poison.encode!(%{status: 404, path: conn.request_path}))
    else
      conn
      |> send_resp(404, "")
    end
  end
end
