defmodule DictionaryTest do
  use ExUnit.Case
  doctest Dictionary

  test "greets the world" do
    assert Dictionary.random_word != nil
  end
end
