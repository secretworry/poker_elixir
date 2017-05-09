defmodule Poker.Hand.FourOfAKind do
  use Poker.Hand
  alias Poker.Card

  @type t :: %__MODULE__{rank: Card.rank_t}

  @enforce_key ~w{rank}a
  defstruct [:rank]

  def new(rank), do: %__MODULE__{rank: rank}

  def compare(%__MODULE__{rank: rank0}, %__MODULE__{rank: rank1}) do
    Card.compare_rank(rank0, rank1)
  end
end
