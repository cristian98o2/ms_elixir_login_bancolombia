defmodule MsElixirLoginBancolombia.Adapters.Persistence.Maps.PersistenceMapAgent do
  @moduledoc """
  Adaptador de persistencia en memoria.
  """

  use Agent

  alias MsElixirLoginBancolombia.Domain.Model.Command
  alias MsElixirLoginBancolombia.Domain.Model.Query
  alias MsElixirLoginBancolombia.Adapters.Persistence.Maps.User
  alias MsElixirLoginBancolombia.Jwt.GenerateJWTAdapter

  alias MsElixirLoginBancolombia.Model.User.Signup.SignupDto
  alias MsElixirLoginBancolombia.Model.User.Signin.SigninDto

  @name __MODULE__

  def start_link(args) do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  def signup_user(%Command{payload: %SignupDto{} = payload, context: context}) do
    email = payload.email
    case Agent.get(@name, fn users -> Map.get(users, email) end) do
      {:ok, _} ->
        {:error, :email_already_exists}

      nil ->
        Agent.update(@name, fn users ->
          new_user = User.new(email, payload.password, payload.name, nil
          )
          Map.put(users, email, new_user)
        end)

        {:ok, :empty}
    end
  end

  def validate_user(%Query{payload: %SigninDto{} = payload, context: context}) do
    email = payload.email
    input_password = payload.password
    case Agent.get(@name, fn users -> Map.get(users, email) end) do
      nil ->
        {:error, :user_not_found}

      %User{} = user ->
        if user.password != input_password do
          {:error, :invalid_credentials}
        else
          case GenerateJWTAdapter.validate_token(user.session_id) do
            {:ok, :empty} ->
              {:ok, user.session_id}

            {:error, _reason} ->
              {:ok, :empty}
          end
        end
    end
  end

  def save_session(%Query{payload: %SigninDto{} = payload, context: context}) do
    email = payload.email

    case Agent.get(@name, fn users -> Map.get(users, email) end) do
      nil ->
        {:error, :user_not_found}

      %User{} = user ->
        case GenerateJWTAdapter.generate_token(user.email) do
          {:ok, session_id} ->
            Agent.update(@name, fn users ->
              updated_user = %{user | session_id: session_id}
              Map.replace(users, email, updated_user)
            end)

            {:ok, session_id}

          {:error, reason} ->
            {:error}
        end
    end
  end
end
