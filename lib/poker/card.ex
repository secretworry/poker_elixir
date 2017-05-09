defmodule Poker.Card do
  @type suit_t :: :diamonds | :clubs | :hearts | :spades | :joker
  @type rank_t :: 2..14
  @type t :: {suit_t, rank_t}

  @suits [:diamonds, :clubs, :hearts, :spades, :joker]
  @ranks 2..14
  def new(suit, rank) when suit in @suits and rank in @ranks do
    {suit, rank}
  end

  def new(suit, rank) do
    raise ArgumentError, "Illegal args #{inspect suit}, #{inspect rank}"
  end

  def suits(), do: @suits

  def ranks(), do: @ranks

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

  def sort_by_rank(cards) do
    Enum.sort_by(cards, &(elem(&1, 1)), &>=/2)
  end

  def sort_ranks(ranks) when is_list(ranks) do
    Enum.sort(ranks, &>=/2)
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
