defmodule Poker.Hand.OnePair do
  use Poker.Hand
  alias Poker.Card

  @type t :: %__MODULE__{pair_rank: Card.rank_t, residual_ranks: list(Card.rank_t)}

  @enforce_key ~w{pair_rank residual_ranks}a
  defstruct [:pair_rank, :residual_ranks]

  def compare(%__MODULE__{pair_rank: pair_rank0, residual_ranks: ranks0},
              %__MODULE__{pair_rank: pair_rank1, residual_ranks: ranks1}) do
    Card.compare_ranks([pair_rank0 | ranks0], [pair_rank1 | ranks1])
  end
end
