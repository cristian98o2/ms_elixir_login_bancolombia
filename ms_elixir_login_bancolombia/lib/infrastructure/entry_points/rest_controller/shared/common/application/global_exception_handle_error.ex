defmodule MsElixirLoginBancolombia.Infrastructure.EntryPoint.GlobalExceptionHandleError do
  @moduledoc """
  MsElixirLoginBancolombia health GlobalExceptionHandleError
  """
  alias MsElixirLoginBancolombia.EntryPoints.Shared.EcsModelResponse
  require Logger
  alias MsElixirLoginBancolombia.Infrastructure.EntryPoint.PrintEcsLog
  alias MsElixirLoginBancolombia.Shared.ResponseController
  alias MsElixirLoginBancolombia.Domain.Model.Exception

  def handle_error(exception, conn, x_request_id, message_id) do
    exception
    |> make_error(message_id, x_request_id, conn)
    |> build_error_response(conn)
  end

  defp make_error(exception, message_id, x_request_id, conn) do
    exception_result = Exception.build_exception(exception)
    exception_result
    |> EcsModelResponse.build_structure()
    |> PrintEcsLog.print_ecs_log()
    %{
      "status" => exception_result.status,
      "error" => %{
        "code" => exception_result.code,
        "message" => exception_result.detail,
        "details" => [],
        "correlation" => %{
          "message_id" => message_id,
          "x_request_id" => x_request_id
        }
      }
    }
  end

  defp build_error_response(response, conn),
    do: ResponseController.build_response(%{status: response["status"], body: response["error"]}, conn)
end
