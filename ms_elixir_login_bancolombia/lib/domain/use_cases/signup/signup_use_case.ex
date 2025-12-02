defmodule MsElixirLoginBancolombia.UseCase.SignupUseCase do
  @moduledoc """
  SignupUseCase
  """

  alias MsElixirLoginBancolombia.Model.User.Signup.SignupDto
  alias MsElixirLoginBancolombia.Domain.Model.Command
  alias MsElixirLoginBancolombia.Domain.Model.ContextData

  @persistence_map_adapter Application.compile_env(
                            :ms_elixir_login_bancolombia,
                            :persistence_map_adapter
                          )

  def execute(
        %Command{
          payload: %SignupDto{} = signup,
          context: %ContextData{} = context
        } = command
      ) do
    with {:ok, :empty} <- @persistence_map_adapter.signup_user(command) do
      {:ok, :empty}
    else
      error -> error
    end
  end
end
