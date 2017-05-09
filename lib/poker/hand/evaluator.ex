defmodule Poker.Hand.Evaluator do

  alias Poker.Hand

  @callback eval(cards) :: nil | Hand.t when cards: list(Poker.Card.t)

  defmacro __using__(_) do
    quote do
      @behaviour unquote(__MODULE__)
    end
  end
end
