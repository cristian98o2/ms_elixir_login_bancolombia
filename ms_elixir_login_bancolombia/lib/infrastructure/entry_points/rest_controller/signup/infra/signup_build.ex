defmodule MsElixirLoginBancolombia.Infrastructure.EntryPoint.Signup.SignupBuild do
  @moduledoc """
  Module to transform and validate the input for Signup
  """

  alias MsElixirLoginBancolombia.Domain.Model.Command

  alias MsElixirLoginBancolombia.Model.User.Signup.SignupDto
  alias MsElixirLoginBancolombia.Domain.Model.ContextData

  @spec build_dto_command(any(), any()) ::
          {:error,:malformed_request}
          | {:ok, %MsElixirLoginBancolombia.Domain.Model.Command{context: map(), payload: map()}}
  def build_dto_command(body_data, headers) do
    data = Map.get(body_data, :data, %{})
    with {:ok, signup_dto} <-
           SignupDto.new(data[:name], data[:email], data[:password]),
         {:ok, context} <-
           ContextData.new(Map.get(headers, :MESSAGE_ID, ""), Map.get(headers, :X_REQUEST_ID, "")) do
      {:ok, %Command{payload: signup_dto, context: context}}
    else
      error -> {:error, :malformed_request}
    end
  end

  @spec build_email_command(any(), any()) ::
          {:error,:malformed_request}
          | {:ok, %MsElixirLoginBancolombia.Domain.Model.Command{context: map(), payload: map()}}
  def build_email_command(body_data, headers) do
    data = Map.get(body_data, :data, %{})
    with {:ok, context} <-
           ContextData.new(Map.get(headers, :MESSAGE_ID, ""), Map.get(headers, :X_REQUEST_ID, "")) do
      {:ok, %Command{payload: data[:email], context: context}}
    else
      error -> {:error, :malformed_request}
    end
  end

  @spec build_password_command(any(), any()) ::
          {:error,:malformed_request}
          | {:ok, %MsElixirLoginBancolombia.Domain.Model.Command{context: map(), payload: map()}}
  def build_password_command(body_data, headers) do
    data = Map.get(body_data, :data, %{})
    with {:ok, context} <-
           ContextData.new(Map.get(headers, :MESSAGE_ID, ""), Map.get(headers, :X_REQUEST_ID, "")) do
      {:ok, %Command{payload: data[:password], context: context}}
    else
      error -> {:error, :malformed_request}
    end
  end
end
