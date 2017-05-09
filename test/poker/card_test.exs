defmodule Poker.CardTest do
  use ExUnit.Case

  require Poker.Card
  alias Poker.Card

  describe "compare_rank/2" do

    test "should return :eq for same ranks" do
      Enum.each(Card.ranks, fn rank ->
        assert Card.compare_rank(rank, rank) == :eq
      end)
    end

    test "should return :gt for comparing a rank to a little one, and vice versa" do
      Enum.each(3..14, fn rank ->
        Enum.each(2..rank-1, fn little ->
          assert Card.compare_rank(rank, little) == :gt
          assert Card.compare_rank(little, rank) == :lt
        end)
      end)
    end
  end

  describe "compare_ranks/2" do
    test "should return :eq for identical ranks" do
      ranks = [1, 2, 3, 4]
      assert Card.compare_ranks(ranks, ranks) == :eq
    end

    test "should return :gt for larger ranks" do
      assert Card.compare_ranks([6, 5, 4, 3], [5, 5, 4, 3]) == :gt
      assert Card.compare_ranks([6, 5, 4, 3], [6, 4, 4, 3]) == :gt
      assert Card.compare_ranks([6, 5, 4, 3], [6, 5, 3, 3]) == :gt
      assert Card.compare_ranks([6, 5, 4, 3], [6, 5, 4, 2]) == :gt
    end

    test "should return :lt for smaller ranks" do
      assert Card.compare_ranks([5, 5, 4, 3], [6, 5, 4, 3]) == :lt
      assert Card.compare_ranks([6, 4, 4, 3], [6, 5, 4, 3]) == :lt
      assert Card.compare_ranks([6, 5, 3, 3], [6, 5, 4, 3]) == :lt
      assert Card.compare_ranks([6, 5, 4, 2], [6, 5, 4, 3]) == :lt
    end
  end

  describe "is_suit/1" do
    test "should return true for valid suits" do
      Card.suits |> Enum.each(&(assert Card.is_suit(&1)))
    end

    test "should return false for invalid suit" do
      refute Card.is_suit(:invalid)
    end
  end

  describe "is_rank/1" do
    test "should return true for valid ranks" do
      Enum.each(Card.ranks, &(assert Card.is_rank(&1)))
    end

    test "should reject invalid ranks" do
      refute Card.is_rank(0)
      refute Card.is_rank(1)
      refute Card.is_rank(15)
    end
  end
end
