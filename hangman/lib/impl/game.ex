defmodule Hangman.Impl.Game do
  alias Hangman.Type

  @type t :: %__MODULE__{
          turns_left: integer(),
          game_state: Type.state(),
          letters: list(String.t()),
          used: MapSet.t(String.t())
        }

  defstruct(
    turns_left: 7,
    game_state: :initializing,
    letters: [],
    used: MapSet.new()
  )

  ##############################################
  @spec new_game() :: t
  def new_game() do
    new_game(Dictionary.random_word())
  end

  @spec new_game(String.t()) :: t
  def new_game(word) do
    %__MODULE__{
      letters:
        word
        |> String.codepoints()
    }
  end

  ###############################################
  #  def make_move(_game, _guess) do
  #  end

  @spec make_move(Game.t(), String.t()) :: {Game.t(), Type.tally()}
  def make_move(game = %{game_state: state}, _guess)
      when state in [:won, :lost] do
    game
    |> return_with_tally()
  end

  def make_move(game = %{game_state: _state}, guess) do
    accept_guess(game, guess, MapSet.member?(game.used, guess))
    |> return_with_tally()
  end

  ###############################################

  defp accept_guess(game, _guess, _already_used = true) do
    %{game | game_state: :already_used}
  end

  defp accept_guess(game, guess, _already_used) do
    %{game | used: MapSet.put(game.used, guess)}
    |> score_guess(Enum.member?(game.letters, guess))
  end

  ###############################################
  defp score_guess(game, _good_guess = true) do
    # guessed all letters, game is :won
    new_state = maybe_won(MapSet.subset?(MapSet.new(game.letters), game.used))
    %{game | game_state: new_state}
  end

  defp score_guess(game = %{turn_left: 1}, _bad_guess) do
    # turns_left == 1 -> lost | dec turns_left, :bad_guess
    %{game | game_state: :lost}
  end

  defp score_guess(game, _bad_guess) do
    # turns_left == 1 -> lost | dec turns_left, :bad_guess
    %{game | game_state: :bad_guess, turns_left: game.turns_left - 1}
  end

  ###############################################
  defp tally(game) do
    %{
      turns_left: game.turns_left,
      game_state: game.game_state,
      letters: reveal_guessed_letters(game),
      used:
        game.used
        |> MapSet.to_list()
        |> Enum.sort()
    }
  end

  defp return_with_tally(game) do
    {game, tally(game)}
  end

  ###############################################
  defp maybe_won(_all_letters_guessed = true) do
    :won
  end

  defp maybe_won(_all_letters_not_guessed) do
    :good_guess
  end

  defp reveal_guessed_letters(game) do
    Enum.map(game.letters, fn letter ->
      MapSet.member?(game.used, letter)
      |> maybe_reveal_letter(letter) end)
  end

  defp maybe_reveal_letter(_good_guess = true, letter) do
    letter
  end

  defp maybe_reveal_letter(_bad_guess, letter) do
    "_"
  end
end
