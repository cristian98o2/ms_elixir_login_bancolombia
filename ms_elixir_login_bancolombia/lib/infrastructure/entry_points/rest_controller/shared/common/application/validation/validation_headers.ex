defmodule MsElixirLoginBancolombia.Infrastructure.EntryPoint.ValidationHeaders do
  @moduledoc """
  Module to validate headers for services
  """

  def validate_headers(%{} = headers) when map_size(headers) == 0 do
    {:error, :retrieve_relation_headers_empty}
  end

  def validate_headers(headers) do
    x_request_id = Map.get(headers, :X_REQUEST_ID, "")
    message_id = Map.get(headers, :MESSAGE_ID, "")

    with {:ok, true} <- validate_exist_header(x_request_id),
         {:ok, true} <- validate_exist_header(message_id) do
      {:ok, true}
    else
      error -> error
    end
  end

  defp validate_exist_header(header) when is_binary(header) do
    if String.length(header) > 0 do
      {:ok, true}
    else
      {:error, :malformed_request}
    end
  end
end
