defmodule MsElixirLoginBancolombia.Infrastructure.EntryPoint.Signin.SigninUserHandler do
  @moduledoc """
  Module to signup user
  """

  use Plug.Router
  require Logger

  alias MsElixirLoginBancolombia.Utils.DataTypeUtils

  alias MsElixirLoginBancolombia.Infrastructure.EntryPoint.ValidationHeaders
  alias MsElixirLoginBancolombia.Infrastructure.EntryPoint.Signin.SigninUserValidationBody

  alias MsElixirLoginBancolombia.Infrastructure.EntryPoint.Signin.SigninBuild
  alias MsElixirLoginBancolombia.UseCase.SigninUseCase

  alias MsElixirLoginBancolombia.Shared.ResponseController
  alias MsElixirLoginBancolombia.Infrastructure.EntryPoint.GlobalExceptionHandleError
  alias MsElixirLoginBancolombia.Infrastructure.EntryPoint.Shared.ResponseSuccessBody

  plug(:match)
  plug(:dispatch)

  @path "/"

  post @path do

    headers =
      conn.req_headers
      |> DataTypeUtils.normalize_headers()

    message_id = Map.get(headers, :MESSAGE_ID, "")
    x_request_id = Map.get(headers, :X_REQUEST_ID, "")
    body = conn.body_params |> DataTypeUtils.normalize()
    with {:ok, true} <- ValidationHeaders.validate_headers(headers),
         {:ok, true} <- SigninUserValidationBody.validate_body(body),
         {:ok, dto_query} <- SigninBuild.build_dto_query(body, headers),
         {:ok, response} <- SigninUseCase.execute(dto_query) do
      ResponseSuccessBody.build_response(
        response,
        message_id
      )
      |> ResponseController.build_response(conn)
    else
      exception ->
        GlobalExceptionHandleError.handle_error(exception, conn, x_request_id, message_id)
    end
  end
end
