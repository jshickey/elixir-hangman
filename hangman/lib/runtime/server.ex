defmodule Hangman.Runtime.Server do
  @moduledoc false

  @type t :: pid()

  alias Hangman.Impl.Game

  use GenServer

  #### client process code
  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  #### serve process
  def init(_opts) do
    {:ok, Game.new_game }
  end

  def handle_call({:make_move, guess}, _from, game) do
    {updated_game, tally} = Game.make_move(game, guess)
    {:reply, tally, updated_game}
  end

  def handle_call({:tally}, _from, game) do
    {:reply, Game.tally(game), game}
  end
end