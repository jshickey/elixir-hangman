defmodule Procs do
  def hello(count) do
    receive do
      {:crash, reason} -> exit(reason)
      {:quit} -> "I'm outta here"
      {:add, n} -> hello(count + n)
      msg ->
        IO.puts "#{count} Hello #{inspect msg}"
        hello(count + 1)
    end
  end
end