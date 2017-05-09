defmodule Poker.Hand.ThreeOfAKind do
  use Poker.Hand
  alias Poker.Card

  import Poker.Card, only: [is_rank: 1]

  @type t :: %__MODULE__{rank_of_three: Card.rank_t, residual_ranks: list(Card.rank_t)}

  @enforce_key ~w{rank_of_three residual_ranks}a
  defstruct [:rank_of_three, :residual_ranks]

  def new(rank, ranks) when is_rank(rank) and is_list(ranks), do: %__MODULE__{rank_of_three: rank, residual_ranks: ranks}

  def compare(%__MODULE__{rank_of_three: rank_of_three0, residual_ranks: ranks0},
              %__MODULE__{rank_of_three: rank_of_three1, residual_ranks: ranks1}) do
    Card.compare_ranks([rank_of_three0 | ranks0], [rank_of_three1 | ranks1])
  end
end
