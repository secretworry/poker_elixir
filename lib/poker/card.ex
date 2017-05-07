defmodule Poker.Card do
  @type suit_t :: :diamonds | :clubs | :hearts | :spades | :joker
  @type rank_t :: 1..13
  @type t :: {suit_t, rank_t}

  @suits [:diamonds, :clubs, :hearts, :spades, :joker]
  @ranks 1..13
  def new(suit, rank) when suit in @suits and rank in @ranks do
    {suit, rank}
  end

  def suits(), do: @suits

  defmacro is_suit(suit) do
    quote do
      unquote(suit) in unquote(@suits)
    end
  end

  defmacro is_rank(rank) do
    quote do
      unquote(rank) in unquote(Macro.escape(@ranks))
    end
  end

  def new(suit, rank) do
    raise ArgumentError, "Illegal args #{inspect suit}, #{inspect rank}"
  end

  def compare_ranks([rank0 | ranks0], [rank1 | ranks1]) do
    case compare_rank(rank0, rank1) do
      diff when diff in [:gt, :lt] ->
        diff
      :eq ->
        compare_ranks(ranks0, ranks1)
    end
  end

  def compare_ranks([], []), do: :eq

  def compare_rank(rank, rank), do: :eq
  def compare_rank(1, _), do: :gt
  def compare_rank(_, 1), do: :lt
  def compare_rank(rank0, rank1) do
    cond do
      rank0 > rank1 ->
        :gt
      rank0 < rank1 ->
        :lt
      true ->
        :eq
    end
  end
end
