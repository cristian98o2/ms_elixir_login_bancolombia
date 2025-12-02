defmodule MsElixirLoginBancolombia.Model.Shared.Common.Model.MessageId do
  @moduledoc """
  Represents a Message ID with format: MSG + 16 uppercase alphanumeric characters (total length 19).
  """

  alias Domain.Model.Shared.Common.Validate.MessageIdValidate

  defstruct [:message_id]

  @type t :: String.t()

  def new(message_id) do
    case MessageIdValidate.validate(message_id) do
      {:ok, true} ->
        {:ok,
         %__MODULE__{
           message_id: message_id
         }}

      error ->
        error
    end
  end
end
