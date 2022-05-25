defmodule HangmanImplGameTest do
  use ExUnit.Case

  alias Hangman.Impl.Game

  test "new game returns a structure" do
    game = Game.new_game
    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert game.letters != []
    assert length(game.letters) > 0
  end

  test "new game returns correct letters for word" do
    game = Game.new_game("wombat")
    assert game.letters == ["w","o","m","b","a","t"]
  end

  test "state doesn't change if game is won or lost" do
    for state <- [:won, :lost] do
      game = Game.new_game("wombat")
      game = Map.put(game, :game_state, state)
      {new_game, _tally} = Game.make_move(game, "x")
      assert new_game == game
    end
  end

  test "a duplicate letter is reported" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state != :already_used

    {game, _tally} = Game.make_move(game, "y")
    assert game.game_state != :already_used

    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "a guesses are being recorded" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "x")
    {game, _tally} = Game.make_move(game, "y")
    assert game.used == MapSet.new(["x","y"])
  end

  test "we recognize a letter in the word" do
    game = Game.new_game("wombat")
    { _game, tally} = Game.make_move(game, "m")
    assert tally.game_state == :good_guess
  end

  test "we recognize a letter not in the word" do
    game = Game.new_game("wombat")
    { _game, tally} = Game.make_move(game, "x")
    assert tally.game_state == :bad_guess
  end

#  test "we recognize a letter not in the word" do
#    game = Game.new_game("wombat")
#    { _game, tally} = Game.make_move(game, "x")
#    assert tally.game_state == :bad_guess
#  end

  # guess the word hello
#  [
#  ["a"]
#  ]
end
