defmodule MsElixirLoginBancolombia.Domain.Model.Exception do
  @moduledoc """
  Error business catalog.
  """
  defstruct [
    :status,
    :code,
    :detail,
    :log_code,
    :log_message,
    :additional_info
  ]

  @status_code %{
    BAD_REQUEST: 400,
    NOT_FOUND: 404,
    CONFLICT: 409,
    INTERNAL_ERROR: 500,
    HTTP_UNAUTHORIZED: 401
  }

  @code %{
    EMAIL_ALREADY_EXISTS: "EMAIL_ALREADY_EXISTS",
    INVALID_EMAIL_FORMAT: "INVALID_EMAIL_FORMAT",
    WEAK_PASSWORD: "WEAK_PASSWORD",
    MALFORMED_REQUEST: "MALFORMED_REQUEST",
    USER_NOT_FOUND: "USER_NOT_FOUND",
    INVALID_CREDENTIALS: "INVALID_CREDENTIALS",
    UNEXPECTED_ERROR_DETAIL: "UNEXPECTED_ERROR_DETAIL"
  }

  @detail %{
    EMAIL_ALREADY_EXISTS: "Email ya registrado",
    INVALID_EMAIL_FORMAT: "Email incorrecto",
    WEAK_PASSWORD: "Contraseña debil",
    MALFORMED_REQUEST: "Request incorrecto",
    USER_NOT_FOUND: "Usuario no encontrado",
    INVALID_CREDENTIALS: "Credenciales incorrectas",
    UNEXPECTED_ERROR_DETAIL: "Ha ocurrido un error interno en el servicio"
  }

  @log_code %{
    ELB_01: "ELB-01",
    ELB_02: "ELB-02",
    ELB_03: "ELB-03",
    ELB_04: "ELB-04",
    ELB_05: "ELB-05",
    ELB_06: "ELB-06",
    ELB_07: "ELB-07"
  }

  @log_message %{
    ELB_01: "El email ya se encuentra registrado",
    ELB_02: "El email no cumple con las reglas",
    ELB_03: "La contraseña es debil en seguridad",
    ELB_04: "El request no esta bien formulado",
    ELB_05: "No existe registro del usuario",
    ELB_06: "Las credenciales no coinciden con los registros",
    ELB_07: "Ha ocurrido un problema inesperado en el sistema"
  }

  # Base error response functions for each code
  def build_exception({:error, :email_already_exists_detail}) do
    %{
      status: @status_code[:CONFLICT],
      code: @code[:EMAIL_ALREADY_EXISTS],
      detail: @detail[:EMAIL_ALREADY_EXISTS]
    }
  end

  def build_exception({:error, :invalid_email_format_detail}) do
    %{
      status: @status_code[:BAD_REQUEST],
      code: @code[:INVALID_EMAIL_FORMAT],
      detail: @detail[:INVALID_EMAIL_FORMAT]
    }
  end

  def build_exception({:error, :weak_password_detail}) do
    %{
      status: @status_code[:BAD_REQUEST],
      code: @code[:WEAK_PASSWORD],
      detail: @detail[:WEAK_PASSWORD]
    }
  end

  def build_exception({:error, :malformed_request_detail}) do
    %{
      status: @status_code[:BAD_REQUEST],
      code: @code[:MALFORMED_REQUEST],
      detail: @detail[:MALFORMED_REQUEST]
    }
  end

  def build_exception({:error, :user_not_found_detail}) do
    %{
      status: @status_code[:NOT_FOUND],
      code: @code[:USER_NOT_FOUND],
      detail: @detail[:USER_NOT_FOUND]
    }
  end

  def build_exception({:error, :invalid_credentials_detail}) do
    %{
      status: @status_code[:HTTP_UNAUTHORIZED],
      code: @code[:INVALID_CREDENTIALS],
      detail: @detail[:INVALID_CREDENTIALS]
    }
  end

  def build_exception({:error, :unexpected_error_detail}) do
    %{
      status: @status_code[:CONFLICT],
      code: @code[:UNEXPECTED_ERROR_DETAIL],
      detail: @detail[:UNEXPECTED_ERROR_DETAIL]
    }
  end

  def build_exception({:error, :email_already_exists}) do
    %{
      log_code: @log_code[:ELB_01],
      log_message: @log_message[:ELB_01]
    }
    |> Map.merge(build_exception({:error, :email_already_exists_detail}))
  end

  def build_exception({:error, :invalid_email_format}) do
    %{
      log_code: @log_code[:ELB_02],
      log_message: @log_message[:ELB_02]
    }
    |> Map.merge(build_exception({:error, :invalid_email_format_detail}))
  end

  def build_exception({:error, :weak_password}) do
    %{
      log_code: @log_code[:ELB_03],
      log_message: @log_message[:ELB_03]
    }
    |> Map.merge(build_exception({:error, :weak_password_detail}))
  end

  def build_exception({:error, :malformed_request}) do
    %{
      log_code: @log_code[:ELB_04],
      log_message: @log_message[:ELB_04]
    }
    |> Map.merge(build_exception({:error, :malformed_request_detail}))
  end

  def build_exception({:error, :user_not_found}) do
    %{
      log_code: @log_code[:ELB_05],
      log_message: @log_message[:ELB_05]
    }
    |> Map.merge(build_exception({:error, :user_not_found_detail}))
  end

  def build_exception({:error, :invalid_credentials}) do
    %{
      log_code: @log_code[:ELB_06],
      log_message: @log_message[:ELB_06]
    }
    |> Map.merge(build_exception({:error, :invalid_credentials_detail}))
  end

  # Generic error
  def build_exception(error) do
    %{
      log_message: @log_message[:ELB_07],
      log_code: @log_code[:ELB_07],
      additional_info: inspect(error)
    }
    |> Map.merge(build_exception({:error, :unexpected_error_detail}))
  end
end
