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
    case Token.generate_and_sign!(%{"email" => user_email, "fecha" => get_request_date()}, @key) do
      token -> {:ok, token}
      {:error, reason} -> {:error, reason}
    end
  end

  @spec validate_token(String.t() | nil) :: {:ok, any()} | {:error, :jwt_expired}
  def validate_token(nil), do: {:error, :jwt_expired}

  def validate_token(token) do
    case Token.verify_and_validate(token, @key) do
      {:ok, claims} ->
        if(Map.get(claims, "fecha") < get_request_date()) do
          {:error, :jwt_expired}
        else
          {:ok, :empty}
        end

      {:error, _reason} ->
        {:error, :jwt_expired}
    end
  end

  defp get_request_date() do
    now = DateTime.utc_now() |> Timex.to_datetime("America/Bogota")

    "#{now.day}/#{now.month}/#{now.year} #{now.hour}:#{now.minute}:#{now.second}:#{elem(now.microsecond, 0)}"
  end
end
