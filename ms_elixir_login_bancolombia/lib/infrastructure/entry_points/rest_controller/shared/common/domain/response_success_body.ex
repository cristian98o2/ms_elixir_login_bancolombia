defmodule MsElixirLoginBancolombia.Infrastructure.EntryPoint.Shared.ResponseSuccessBody do
  @moduledoc """
  Module to transform and validate the input for ResponseSuccessBody
  """

  def build_response(response_body, message_id) do
    %{
      "data" => response_body
    }
  end
end
