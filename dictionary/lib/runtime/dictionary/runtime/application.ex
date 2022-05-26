defmodule Dictionary.Runtime.Application do
  @moduledoc false
  


  use Application

  def start(_type, _args) do
    Dictionary.Runtime.Server.start_link()
  end
end