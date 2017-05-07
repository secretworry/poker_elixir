defmodule Poker.Hand.FullHouse do
  use Poker.Hand
  alias Poker.Card

  import Poker.Card, only: [is_rank: 1]

  @type t :: %__MODULE__{rank_of_three: Card.rank_t, rank_of_two: Card.rank_t}

  @enforce_key ~w{rank_of_three rank_of_two}a
  defstruct [:rank_of_three, :rank_of_two]

  def new(rank_of_three, rank_of_two) when is_rank(rank_of_three) and is_rank(rank_of_three) do
    %__MODULE__{rank_of_three: rank_of_three, rank_of_two: rank_of_two}
  end

  def compare(%__MODULE__{rank_of_three: rank_of_three0, rank_of_two: rank_of_two0},
              %__MODULE__{rank_of_three: rank_of_three1, rank_of_two: rank_of_two1}) do
    Card.compare_ranks([rank_of_three0, rank_of_two0], [rank_of_three1, rank_of_two1])
  end
end
