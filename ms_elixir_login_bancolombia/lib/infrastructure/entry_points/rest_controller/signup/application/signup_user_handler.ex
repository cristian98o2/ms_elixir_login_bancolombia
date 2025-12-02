defmodule MsElixirLoginBancolombia.Infrastructure.EntryPoint.Signup.SignupUserHandler do
  @moduledoc """
  Module to signup user
  """

  use Plug.Router
  require Logger

  alias MsElixirLoginBancolombia.Utils.DataTypeUtils

  alias MsElixirLoginBancolombia.Infrastructure.EntryPoint.ValidationHeaders
  alias MsElixirLoginBancolombia.Infrastructure.EntryPoint.Signup.SignupUserValidationBody
  alias MsElixirLoginBancolombia.Infrastructure.EntryPoint.Signup.ValidatePassword
  alias MsElixirLoginBancolombia.Infrastructure.EntryPoint.Signup.ValidateEmail

  alias MsElixirLoginBancolombia.Infrastructure.EntryPoint.Signup.SignupBuild
  alias MsElixirLoginBancolombia.UseCase.SignupUseCase

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
         {:ok, true} <- SignupUserValidationBody.validate_body(body),
         {:ok, email_command} <- SignupBuild.build_email_command(body, headers),
         {:ok, true} <- ValidateEmail.validate_email(email_command),
         {:ok, password_command} <- SignupBuild.build_password_command(body, headers),
         {:ok, true} <- ValidatePassword.validate_password(password_command),
         {:ok, dto_command} <- SignupBuild.build_dto_command(body, headers),
         {:ok, :empty} <- SignupUseCase.execute(dto_command) do
      ResponseSuccessBody.build_response(
        "",
        message_id
      )
      |> ResponseController.build_response(conn)
    else
      exception ->
        GlobalExceptionHandleError.handle_error(exception, conn, x_request_id, message_id)
    end
  end
end
