defmodule MsElixirLoginBancolombia.Adapters.Persistence.Maps.User do
  @moduledoc """
  Modelo de datos interno para el usuario almacenado en la persistencia en memoria.
  """

  # Define la estructura con sus valores por defecto a nil.
  defstruct [:email, :password, :name, :session_id]

  @type t :: %__MODULE__{
          email: String.t(),
          password: String.t(),
          name: String.t(),
          session_id: String.t() | nil
        }

  def new(email, password, name, session_id) do
    %__MODULE__{
      email: email,
      password: password,
      name: name,
      session_id: session_id
    }
  end
end
