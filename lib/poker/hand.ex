defmodule Poker.Hand do

  alias Poker.Hand

  @type t :: Hand.RoyalFlush.t
           | Hand.StraightFlush.t
           | Hand.FourOfAKind.t
           | Hand.FullHouse.t
           | Hand.Flush.t
           | Hand.Straight.t
           | Hand.ThreeOfAKind.t
           | Hand.TwoPair.t
           | Hand.OnePair.t
           | Hand.HighCard.t

  @callback compare(t, t) :: :lt | :eq | :gt

  defmacro __using__(_) do
    quote do
      @behaviour unquote(__MODULE__)
    end
  end
end
