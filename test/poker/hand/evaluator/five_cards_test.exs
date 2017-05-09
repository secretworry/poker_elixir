defmodule Poker.Hand.Evaluator.FiveCardsTest do

  use ExUnit.Case

  alias Poker.Card
  alias Poker.Hand

  defp call_eval(cards) do
    Poker.Hand.Evaluator.FiveCards.eval(cards)
  end

  def cards_of(ranks) do
    available_suits = Enum.map(Card.suits, &(List.duplicate(&1, 4))) |> List.flatten |> Enum.shuffle
    Enum.zip(available_suits, ranks) |> Enum.map(fn
      {suit, rank} ->
        Card.new(suit, rank)
    end)
  end

  describe "eval/1" do
    test "should eval royal flush" do
      Card.suits |> Enum.each(fn
        suit ->
          cards = Enum.map([14, 13, 12, 11, 10], &(Card.new(suit, &1)))
          assert call_eval(cards) == Hand.RoyalFlush.new
      end)
    end

    test "should eval straight flush" do
      Card.suits |> Enum.each(fn
        suit ->
          Enum.each(6..13, fn
            rank ->
              cards = Enum.map(rank-4..rank, &(Card.new(suit, &1)))
              assert call_eval(cards) == Hand.StraightFlush.new(rank)
          end)
      end)
    end

    test "should eval four of a kind" do
      for rank0 <- Card.ranks, rank1 <- Card.ranks, rank0 != rank1 do
        suits4 = Card.suits |> Enum.shuffle |> Enum.take(4)
        suit1 = Card.suits |> Enum.random
        cards = Enum.reduce(suits4, [], &([Card.new(&1, rank0) | &2]))
        cards = [Card.new(suit1, rank1) | cards]
        assert call_eval(cards) == Hand.FourOfAKind.new(rank0)

        cards = Enum.reduce(suits4, [], &([Card.new(&1, rank1) | &2]))
        cards = [Card.new(suit1, rank0) | cards]
        assert call_eval(cards) == Hand.FourOfAKind.new(rank1)
      end
    end

    test "should eval full house" do
      for rank0 <- Card.ranks, rank1 <- Card.ranks, rank0 != rank1 do
        suits3 = Card.suits |> Enum.shuffle |> Enum.take(3)
        suits2 = Card.suits |> Enum.shuffle |> Enum.take(2)
        cards = Enum.reduce(suits3, [], &([Card.new(&1, rank0) | &2]))
        cards = Enum.reduce(suits2, cards, &([Card.new(&1, rank1) | &2]))
        assert call_eval(cards) == Hand.FullHouse.new(rank0, rank1)

        cards = Enum.reduce(suits3, [], &([Card.new(&1, rank1) | &2]))
        cards = Enum.reduce(suits2, cards, &([Card.new(&1, rank0) | &2]))
        assert call_eval(cards) == Hand.FullHouse.new(rank1, rank0)
      end
    end

    test "should eval flush" do
      Enum.each(Card.suits, fn suit ->
        ranks = Card.ranks |> Enum.shuffle |> Enum.take(5)
        cards = Enum.map(ranks, fn
          rank ->
            Card.new(suit, rank)
        end)
        sorted_ranks = ranks |> Enum.sort(&>=/2)
        # skip royal flush
        if sorted_ranks != [14, 13, 12, 11, 10] do
          assert call_eval(cards) == Hand.Flush.new(sorted_ranks)
        end
      end)
    end

    test "should eval straight" do
      # 4 item at the most for each suit to prevent from creating a royal flush
      available_suits = Enum.map(Card.suits, &(List.duplicate(&1, 4))) |> List.flatten
      Enum.each(6..14, fn
        rank ->
          suits = available_suits |> Enum.shuffle |> Enum.take(5)
          cards = Enum.zip(rank-4..rank, suits) |> Enum.map(fn
            {rank ,suit} ->
              Card.new(suit, rank)
          end)
          assert call_eval(cards) == Hand.Straight.new(rank)
      end)
    end

    test "should eval two pair" do
      assert call_eval(cards_of([2, 2, 3, 3, 4])) == Hand.TwoPair.new({3, 2}, [4])
      assert call_eval(cards_of([2, 2, 3, 4, 4])) == Hand.TwoPair.new({4, 2}, [3])
      assert call_eval(cards_of([2, 3, 3, 4, 4])) == Hand.TwoPair.new({4, 3}, [2])
    end

    test "should eval one pair" do
      assert call_eval(cards_of([2, 2, 3, 4, 5])) == Hand.OnePair.new(2, [5, 4, 3])
      assert call_eval(cards_of([2, 3, 3, 4, 5])) == Hand.OnePair.new(3, [5, 4, 2])
      assert call_eval(cards_of([2, 3, 4, 4, 5])) == Hand.OnePair.new(4, [5, 3, 2])
      assert call_eval(cards_of([2, 3, 4, 5, 5])) == Hand.OnePair.new(5, [4, 3, 2])
    end

    test "should eval high card" do
      assert call_eval(cards_of([3, 5, 7, 9, 11])) == Hand.HighCard.new([11, 9, 7, 5, 3])
    end
  end
end
