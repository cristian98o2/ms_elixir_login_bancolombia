defmodule MsElixirLoginBancolombia.Model.User.Signin.SigninDto do
  @moduledoc """
  Represents a SigninDto.
  """

  defstruct [:email, :password]

  @type t :: %__MODULE__{
    email: String.t(),
    password: String.t()
  }

  def new(email, password) do
    {:ok, %__MODULE__{
      email: email,
      password: password
    }}
  end
end
