defmodule MsElixirLoginBancolombia.UseCase.SigninUseCaseTest do
  use ExUnit.Case
  import Mock

  alias MsElixirLoginBancolombia.UseCase.SigninUseCase
  alias MsElixirLoginBancolombia.Domain.Model.Query
  alias MsElixirLoginBancolombia.Domain.Model.ContextData
  alias MsElixirLoginBancolombia.Model.User.Signin.SigninDto

  @persistence_adapter_mock MsElixirLoginBancolombia.Adapters.Persistence.Maps.PersistenceMapAgent

  defp create_valid_context_data() do
    %ContextData{message_id: "msg-9876", x_request_id: "req-5432"}
  end

  defp create_valid_signin_dto() do
    %SigninDto{
      email: "test@example.com",
      password: "Password123."
    }
  end

  defp create_valid_signin_query() do
    %Query{
      payload: create_valid_signin_dto(),
      context: create_valid_context_data()
    }
  end

  defp create_error_result(error_atom) do
    {:error, error_atom}
  end

  describe "execute/1" do
    test "should return existing session when validate_user succeeds with valid token" do
      # Simula que la sesión es válida (validate_user devuelve la cadena session_id)
      existing_session_id = "valid_jwt_token_12345"
      expected_result = {:ok, existing_session_id}

      with_mocks([
        {@persistence_adapter_mock, [:passthrough], [validate_user: fn(_query) -> expected_result end]}
      ]) do
        result = SigninUseCase.execute(create_valid_signin_query())

        assert ^expected_result = result
        assert called(@persistence_adapter_mock.validate_user(:_))
        refute called(@persistence_adapter_mock.save_session(:_))
      end
    end

    test "should call save_session and return new session when validate_user returns empty" do
      validation_result = {:ok, :empty}

      new_session_id = "new_jwt_token_67890"
      save_result = {:ok, new_session_id}

      with_mocks([
        {@persistence_adapter_mock, [:passthrough], [
          validate_user: fn(_query) -> validation_result end,
          save_session: fn(_query) -> save_result end
        ]}
      ]) do
        result = SigninUseCase.execute(create_valid_signin_query())

        assert ^save_result = result
        assert called(@persistence_adapter_mock.validate_user(:_))
        assert called(@persistence_adapter_mock.save_session(:_))
      end
    end

    test "should propagate error when validation fails user not found" do
      error_result = create_error_result(:user_not_found)

      with_mocks([
        {@persistence_adapter_mock, [:passthrough], [validate_user: fn(_query) -> error_result end]}
      ]) do
        result = SigninUseCase.execute(create_valid_signin_query())

        assert ^error_result = result
        assert called(@persistence_adapter_mock.validate_user(:_))
        refute called(@persistence_adapter_mock.save_session(:_))
      end
    end

    test "should propagate error when validation fails invalid credentials" do
      error_result = create_error_result(:invalid_credentials)

      with_mocks([
        {@persistence_adapter_mock, [:passthrough], [validate_user: fn(_query) -> error_result end]}
      ]) do
        result = SigninUseCase.execute(create_valid_signin_query())

        assert ^error_result = result
        assert called(@persistence_adapter_mock.validate_user(:_))
        refute called(@persistence_adapter_mock.save_session(:_))
      end
    end
  end
end
