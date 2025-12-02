defmodule MsElixirLoginBancolombia.UseCase.SigninUseCase do
  @moduledoc """
  SigninUseCase
  """

  alias MsElixirLoginBancolombia.Model.User.Signin.SigninDto
  alias MsElixirLoginBancolombia.Domain.Model.Query
  alias MsElixirLoginBancolombia.Domain.Model.ContextData

  @persistence_map_adapter Application.compile_env(
                            :ms_elixir_login_bancolombia,
                            :persistence_map_adapter
                          )

  def execute(
        %Query{
          payload: %SigninDto{} = signin,
          context: %ContextData{} = context
        } = query
  ) do
    case @persistence_map_adapter.validate_user(query) do
        {:ok, :empty} -> @persistence_map_adapter.save_session(query)
        {:ok, session} -> {:ok, session}
        {:error, error} -> {:error, error}
    end
  end
end
