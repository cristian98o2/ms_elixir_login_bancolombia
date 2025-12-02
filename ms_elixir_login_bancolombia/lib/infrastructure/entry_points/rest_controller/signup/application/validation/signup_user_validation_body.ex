defmodule MsElixirLoginBancolombia.Infrastructure.EntryPoint.Signup.SignupUserValidationBody do
  @moduledoc """
  Module to validate the body for Signup
  """

  def validate_body(body) do
    with {:ok, true} <- validate_map(body),
         {:ok, true} <- validate_field_data(body),
         {:ok, true} <- validate_fields(body.data, :email),
         {:ok, true} <- validate_fields(body.data, :password),
         {:ok, true} <- validate_fields(body.data, :name) do
      {:ok, :true}
    else
      error ->
        error
    end
  end

  defp validate_map(body) do
    case Enum.count(Map.to_list(body)) do
      0 -> {:error, :malformed_request}
      _ -> {:ok, true}
    end
  end

  defp validate_field_data(data) do
    case Map.has_key?(data, :data) do
      false -> {:error, :malformed_request}
      true -> {:ok, true}
    end
  end

  defp validate_fields(data, field_key) do
    case Map.get(data, field_key) do
      nil -> {:error, :malformed_request}
      val when val != "" -> {:ok, true}
      _ -> {:error, :malformed_request}
    end
  end
end
