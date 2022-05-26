defmodule TextClient.Impl.Player do

  @typep tally :: Hangman.Type.tally()
  @typep game :: Hangman.game()
  @typep state :: {game, tally}

  @spec start() :: :ok
  def start() do
    game = Hangman.new_game()
    tally = Hangman.tally(game)
    interact({game, tally})
  end

  @spec interact(state) :: :ok
  def interact({_game, _tally = %{game_state: :won}}) do
    IO.puts("Congratulations! You Won!")
  end

  def interact({_game, tally = %{game_state: :lost}}) do
    IO.puts "Sorry! You lost, the word was #{
      tally.letters
      |> Enum.join
    }"
  end

  def interact({ game, tally}) do
    IO.puts feedback_for(tally)
    IO.puts current_word(tally)
    tally = Hangman.make_move(game, get_guess())
    interact({game, tally})
  end

  def get_guess() do
    IO.gets("Next letter: ")
    |> String.trim()
    |> String.downcase
  end

  def current_word(tally) do
    [
      "Words so far: ",
      tally.letters
      |> Enum.join(" "),
      " turns left: ",
      tally.turns_left
      |> to_string,
      " used so far: ",
      tally.used
      |> Enum.join(",")
    ]
  end

  defp feedback_for(tally = %{game_state: :initializing}) do
    "welcome! I'm thinking of a #{
      tally.letters
      |> length
    } letter word"
  end

  defp feedback_for(_tally = %{game_state: :good_guess}), do: "good guess"
  defp feedback_for(_tally = %{game_state: :bad_guess}), do: "bad guess"
  defp feedback_for(_tally = %{game_state: :already_used}), do: "You already used the letter"
end