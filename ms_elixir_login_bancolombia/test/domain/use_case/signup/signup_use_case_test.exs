defmodule MsElixirLoginBancolombia.UseCase.SignupUseCaseTest do
  use ExUnit.Case
  import Mock

  alias MsElixirLoginBancolombia.UseCase.SignupUseCase
  alias MsElixirLoginBancolombia.Domain.Model.Command
  alias MsElixirLoginBancolombia.Domain.Model.ContextData
  alias MsElixirLoginBancolombia.Model.User.Signup.SignupDto

  @persistence_adapter_mock MsElixirLoginBancolombia.Adapters.Persistence.Maps.PersistenceMapAgent

  defp create_valid_context_data() do
    %ContextData{message_id: "msg-12345", x_request_id: "req-67890"}
  end

  defp create_valid_signup_dto() do
    %SignupDto{
      name: "Test User",
      email: "test@example.com",
      password: "Password123."
    }
  end

  defp create_valid_signup_command() do
    %Command{
      payload: create_valid_signup_dto(),
      context: create_valid_context_data()
    }
  end

  defp create_error_result(error_atom) do
    {:error, error_atom}
  end

  describe "execute/1" do
    test "should return success when persistence is successful" do
      expected_result = {:ok, :empty}

      with_mocks([
        {@persistence_adapter_mock, [:passthrough], [signup_user: fn(_command) -> expected_result end]}
      ]) do
        result = SignupUseCase.execute(create_valid_signup_command())

        assert ^expected_result = result

        assert called(@persistence_adapter_mock.signup_user(:_))
      end
    end

    test "should propagate error when persistence fails email exists" do
      error_result = create_error_result(:email_already_exists)

      with_mocks([
        {@persistence_adapter_mock, [:passthrough], [signup_user: fn(_command) -> error_result end]}
      ]) do
        result = SignupUseCase.execute(create_valid_signup_command())

        assert ^error_result = result

        assert called(@persistence_adapter_mock.signup_user(:_))
      end
    end
  end
end
