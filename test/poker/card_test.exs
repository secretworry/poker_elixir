defmodule Poker.CardTest do
  use ExUnit.Case

  alias Poker.Card

  describe "to_string/1" do
    test "should convert normal cards" do
      assert to_string(Card.new(:diamonds, 1)) == "♦️A"
      assert to_string(Card.new(:clubs, 2)) == "♣️2"
      assert to_string(Card.new(:hearts, 3)) == "♥️3"
      assert to_string(Card.new(:spades, 4)) == "♠️4"
      assert to_string(Card.new(:diamonds, 10)) == "♦️10"
      assert to_string(Card.new(:diamonds, 11)) == "♦️J"
      assert to_string(Card.new(:diamonds, 12)) == "♦️Q"
      assert to_string(Card.new(:diamonds, 13)) == "♦️K"
    end
  end
end
