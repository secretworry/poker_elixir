defmodule Poker.Card do
  @type suit_t :: :diamonds | :clubs | :hearts | :spades
  @type rank_t :: 1..13
  @type t :: %__MODULE__{suit: suit_t, rank: rank_t}

  @enforce_keys ~w{suit rank}a
  defstruct [:suit, :rank]

  @suits [:diamonds, :clubs, :hearts, :spades]
  @ranks 1..13
  def new(suit, rank) when suit in @suits and rank in @ranks do
    %__MODULE__{suit: suit, rank: rank}
  end

  def new(suit, rank) do
    raise ArgumentError, "Illegal args #{inspect suit}, #{inspect rank}"
  end

  def to_string(%Poker.Card{suit: suit, rank: rank}) do
    suit_to_string(suit) <> rank_to_string(rank)
  end

  def to_string(illegal_card) do
    "illegal_card_#{inspect illegal_card}"
  end

  defp suit_to_string(:diamonds), do: "♦️"
  defp suit_to_string(:clubs), do: "♣️"
  defp suit_to_string(:hearts), do: "♥️"
  defp suit_to_string(:spades), do: "♠️"
  defp suit_to_string(suit), do: "error_#{inspect suit}"

  defp rank_to_string(1), do: "A"
  defp rank_to_string(11), do: "J"
  defp rank_to_string(12), do: "Q"
  defp rank_to_string(13), do: "K"
  defp rank_to_string(num) when num >= 2 and num <= 10, do: Integer.to_string(num)
  defp rank_to_string(error_num), do: "error_#{inspect error_num}"

  defimpl String.Chars do
    def to_string(card), do: Poker.Card.to_string(card)
  end

end
