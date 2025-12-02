defmodule MsElixirLoginBancolombia.EntryPoints.Shared.EcsModelResponse do
  @moduledoc """
  This module is responsible for building responses.
  """

  @service_name "internal_information_ms"
  @level_error "ERROR"

  @derive Jason.Encoder
  defstruct [
    :errors
  ]

  def build_structure(data) do
    %__MODULE__{
      errors: build_error(data)
    }
  end

  def build_error(data) do
    %{
      status: Map.get(data, :status),
      message: Map.get(data, :detail),
      code: Map.get(data, :code),
      internalMessage: Map.get(data, :log_message),
      logCode: Map.get(data, :log_code),
      type: @level_error
    }
  end
end
