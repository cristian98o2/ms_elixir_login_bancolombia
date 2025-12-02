defmodule MsElixirLoginBancolombia.Infrastructure.EntryPoint.Signin.SigninBuild do
  @moduledoc """
  Module to transform and validate the input for Signin
  """

  alias MsElixirLoginBancolombia.Domain.Model.Query

  alias MsElixirLoginBancolombia.Model.User.Signin.SigninDto
  alias MsElixirLoginBancolombia.Domain.Model.ContextData

  @spec build_dto_query(any(), any()) ::
          {:error,:malformed_request}
          | {:ok, %MsElixirLoginBancolombia.Domain.Model.Query{context: map(), payload: map()}}
  def build_dto_query(body_data, headers) do
    data = Map.get(body_data, :data, %{})
    with {:ok, signup_dto} <-
           SigninDto.new(data[:email], data[:password]),
         {:ok, context} <-
           ContextData.new(Map.get(headers, :MESSAGE_ID, ""), Map.get(headers, :X_REQUEST_ID, "")) do
      {:ok, %Query{payload: signup_dto, context: context}}
    else
      error -> {:error, :malformed_request}
    end
  end
end
