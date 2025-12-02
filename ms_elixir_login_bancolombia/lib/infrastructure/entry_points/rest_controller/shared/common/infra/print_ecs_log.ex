defmodule MsElixirLoginBancolombia.Infrastructure.EntryPoint.PrintEcsLog do
  @moduledoc """
  PrintEcsLog
  """
  require Logger
  alias MsElixirLoginBancolombia.Utils.DataTypeUtils

  def print_ecs_log(log) do
    json_log = Poison.encode!(log)
    json_log_new = DataTypeUtils.normalize(json_log)
    Logger.error(json_log_new)
  end
end
