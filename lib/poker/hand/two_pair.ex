defmodule Poker.Hand.TwoPair do
  use Poker.Hand
  alias Poker.Card

  @type two_pair_t :: %__MODULE__{pair_ranks: {Card.rank_t, Card.rank_t}, residual_ranks: list(Card.rank_t)}

  @enforce_key ~w{pair_ranks residual_ranks}a
  defstruct [:pair_ranks, :residual_ranks]

  def compare(%__MODULE__{pair_ranks: {larger_rank0, smaller_rank0}, residual_ranks: ranks0},
              %__MODULE__{pair_ranks: {larger_rank1, smaller_rank1}, residual_ranks: ranks1}) do
    Card.compare_ranks([larger_rank0, smaller_rank0, ranks0],
                       [larger_rank1, smaller_rank1, ranks1])
  end
end
