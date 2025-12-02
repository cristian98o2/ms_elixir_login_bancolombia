defmodule MsElixirLoginBancolombia.EntryPoints.Shared.BuildResponse do
  @moduledoc """
  This module is responsible for building responses.
  """
  use Plug.Router

  def build_response(%{status: status, body: body}, conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(status, Poison.encode!(body))
  end

  def build_response(response, conn), do: build_response(%{status: 200, body: response}, conn)

  match _ do
    conn
    |> send_resp(404, "Not found")
  end
end
