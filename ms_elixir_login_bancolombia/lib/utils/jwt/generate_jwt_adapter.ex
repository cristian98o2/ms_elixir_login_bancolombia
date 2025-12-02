defmodule MsElixirLoginBancolombia.Jwt.GenerateJWTAdapter do
  @moduledoc """
  Adaptador para generar y validar JSON Web Tokens (JWT).
  """
  alias Joken.Token
  alias Joken.Signer
  alias Joken
  alias MsElixirLoginBancolombia.Jwt.Token

  @secret_string "12345678912345678912345678912345"
  @expiration_time 300

  @key Joken.Signer.create("HS256", @secret_string)

  @spec generate_token(String.t()) :: {:ok, String.t()} | {:error, any()}
  def generate_token(user_email) do
    case Token.generate_and_sign!(%{"email" => user_email}, @key) do
      token -> {:ok, token}
      {:error, reason} -> {:error, reason}
    end
  end

  @spec validate_token(String.t() | nil) :: {:ok, any()} | {:error, :jwt_expired}
  def validate_token(nil), do: {:error, :jwt_expired}

  def validate_token(token) do
    IO.inspect(token, label: "Cristian")
    IO.inspect(@key, label: "Cristian")
    IO.inspect("Malo" || Token.verify_and_validate(token, @key), label: "Cristian 1")
    case Token.verify_and_validate(token, @key) do
      {:ok, _} ->
        {:ok, :empty}

      {:error, _reason} ->
        {:error, :jwt_expired}
    end
  end
end
