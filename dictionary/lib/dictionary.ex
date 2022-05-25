defmodule Dictionary do
  @moduledoc """
  Documentation for `Dictionary`.
  """
  @word_list "assets/words.txt"
  |> File.read!
  |> String.split( "\n", trim: true)

  def random_word do
    @word_list
    |> Enum.random
  end

  def swap({a,b}) do
    {b,a}
  end
  def same?({a,a}) do
    true
  end

  def same?({_,_}) do
    false
  end
end
