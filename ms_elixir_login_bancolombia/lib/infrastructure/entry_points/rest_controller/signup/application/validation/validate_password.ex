defmodule MsElixirLoginBancolombia.Infrastructure.EntryPoint.Signup.ValidatePassword do
  @moduledoc """
  Utilidad para validar el formato de un correo electrónico usando una expresión regular.
  """
  @password_regex ~r/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&\.])[A-Za-z\d@$!%*?&\.]{8,}$/

  alias MsElixirLoginBancolombia.Domain.Model.Command

  @spec validate_password(%Command{payload: String.t(), context: any()}) ::
          {:ok, true} | {:error, :weak_password}
  def validate_password(%Command{payload: password, context: context}) do
    case Regex.match?(@password_regex, password) do
      true ->
        {:ok, true}
      false ->
        {:error, :weak_password}
    end
  end
end
