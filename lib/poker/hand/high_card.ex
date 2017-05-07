defmodule Poker.Hand.HighCard do

  use Poker.Hand
  alias Poker.Card

  @type t :: %__MODULE__{ranks: list(Card.rank_t)}

  defstruct ranks: []

  def compare(%__MODULE__{ranks: ranks0}, %__MODULE__{ranks: ranks1}) do
    Card.compare_ranks(ranks0, ranks1)
  end
end
