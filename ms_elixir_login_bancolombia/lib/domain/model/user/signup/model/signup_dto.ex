defmodule MsElixirLoginBancolombia.Model.User.Signup.SignupDto do
  @moduledoc """
  Represents a SignupDto.
  """

  defstruct [:name, :email, :password]

  @type t :: %__MODULE__{
    name: String.t(),
    email: String.t(),
    password: String.t()
  }

  def new(name, email, password) do
    {:ok, %__MODULE__{
      name: name,
      email: email,
      password: password
    }}
  end
end
