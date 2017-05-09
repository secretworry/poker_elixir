defmodule Poker.Hand.Straight do
  use Poker.Hand
  alias Poker.Card

  import Poker.Card, only: [is_rank: 1]

  @type t :: %__MODULE__{highest_rank: Card.rank_t}

  @enforce_key ~w{highest_rank}a
  defstruct [:highest_rank]

  def new(rank) when is_rank(rank), do: %__MODULE__{highest_rank: rank}

  def compare(%__MODULE__{highest_rank: highest_rank0}, %__MODULE__{highest_rank: highest_rank1}) do
    Card.compare_rank(highest_rank0, highest_rank1)
  end
end
