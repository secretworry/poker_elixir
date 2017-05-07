defmodule Poker.Hand.RoyalFlush do
  alias Poker.Card

  @type t :: %__MODULE__{}

  defstruct []

  def compare(%__MODULE__{}, %__MODULE__{}), do: :eq
end
