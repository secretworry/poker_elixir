defmodule Poker.Hand.Straight do
  use Poker.Hand
  alias Poker.Card

  @type t :: %__MODULE__{lowest_rank: Card.rank_t}

  @enforce_key ~w{lowest_rank}a
  defstruct [:lowest_rank]

  def compare(%__MODULE__{lowest_rank: lowest_rank0}, %__MODULE__{lowest_rank: lowest_rank1}) do
    Card.compare_rank(lowest_rank0, lowest_rank1)
  end
end
