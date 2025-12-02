defmodule MsElixirLoginBancolombia.Model.Shared.Common.Model.XRequestId do
  @moduledoc """
  Represents a Message ID with format: MSG + 16 uppercase alphanumeric characters (total length 19).
  """

  alias Domain.Model.Shared.Common.Validate.MessageIdValidate

  defstruct [:x_request_id]

  @type t :: String.t()

  def new(x_request_id) do
    case MessageIdValidate.validate(x_request_id) do
      {:ok, true} ->
        {:ok,
         %__MODULE__{
           x_request_id: x_request_id
         }}

      error ->
        error
    end
  end
end
