defmodule Poker.Hand.Flush do
  use Poker.Hand
  alias Poker.Card

  @type t :: %__MODULE__{ranks: list(Card.rank_t)}

  defstruct ranks: []

  def new(ranks), do: %__MODULE__{ranks: ranks}

  def compare(%__MODULE__{ranks: ranks0}, %__MODULE__{ranks: ranks1}) do
    Card.compare_ranks(ranks0, ranks1)
  end
end
