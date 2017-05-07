defmodule Poker.Hand.ThreeOfAKind do
  use Poker.Hand
  alias Poker.Card

  @type t :: %__MODULE__{rank_of_three: Card.rank_t, residual_ranks: list(Card.rank_t)}

  @enforce_key ~w{rank_of_three residual_ranks}a
  defstruct [:rank_of_three, :residual_ranks]

  def compare(%__MODULE__{rank_of_three: rank_of_three0, residual_ranks: ranks0},
              %__MODULE__{rank_of_three: rank_of_three1, residual_ranks: ranks1}) do
    Card.compare_ranks([rank_of_three0 | ranks0], [rank_of_three1 | ranks1])
  end
end
