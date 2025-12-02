defmodule Domain.Model.Shared.Common.Validate.MessageIdValidate do
  @moduledoc """
  Validation logic for Message ID.
  """

  def validate(nil), do: {:error, :message_id_empty}

  def validate(message_id) when not is_binary(message_id), do: {:error, :message_id_invalid_type}

  def validate(message_id) do
    uuid_pattern = ~r/^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i

    case Regex.match?(uuid_pattern, message_id) do
      true -> {:ok, true}
      false -> {:error, :message_id_invalid_format}
    end
  end
end
