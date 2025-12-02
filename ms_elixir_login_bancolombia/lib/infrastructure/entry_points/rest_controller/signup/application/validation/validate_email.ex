defmodule MsElixirLoginBancolombia.Infrastructure.EntryPoint.Signup.ValidateEmail do
  @moduledoc """
  Utilidad para validar el formato de un correo electrónico usando una expresión regular.
  """
  @email_regex ~r/^[a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]{2,6}$/

  alias MsElixirLoginBancolombia.Domain.Model.Command

  @spec validate_email(%Command{payload: String.t(), context: any()}) ::
          {:ok, true} | {:error, :invalid_email_format}
  def validate_email(%Command{payload: email, context: context}) do
    case Regex.match?(@email_regex, email) do
      true ->
        {:ok, true}
      false ->
        {:error, :invalid_email_format}
    end
  end
end
