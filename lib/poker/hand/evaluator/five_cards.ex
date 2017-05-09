defmodule Poker.Hand.Evaluator.FiveCards do

  use Poker.Hand.Evaluator

  alias __MODULE__

  def eval(cards) do
    FiveCards.ByMatching.eval(cards)
  end

  defmodule ByMatching do
    use Poker.Hand.Evaluator

    alias Poker.Hand
    alias Poker.Card

    def eval(cards) do
      cards |> Card.sort_by_rank |> do_eval
    end

    # RoyalFlush---------------------------------

    defp do_eval([{s, 14}, {s, 13}, {s, 12}, {s, 11}, {s, 10}]) do
      Hand.RoyalFlush.new
    end

    # StraightFlush---------------------------------

    defp do_eval([{s, r}, {s, r1}, {s, r2}, {s, r3}, {s, r4}])
    when r1 == r - 1 and r2 == r - 2 and r3 == r - 3 and r4 == r - 4 do
      Hand.StraightFlush.new(r)
    end
    defp do_eval([{s, 14}, {s, 5}, {s, 4}, {s, 3}, {s, 2}]) do
      Hand.StraightFlush.new(5)
    end

    # FourOfAKind---------------------------------

    defp do_eval([{_, r0}, {_, r0}, {_, r0}, {_, r0}, {_, _}]) do
      Hand.FourOfAKind.new(r0)
    end

    defp do_eval([{_, _}, {_, r0}, {_, r0}, {_, r0}, {_, r0}]) do
      Hand.FourOfAKind.new(r0)
    end

    # FullHouse---------------------------------

    defp do_eval([{_, r0}, {_, r0}, {_, r0}, {_, r1}, {_, r1}]) do
      Hand.FullHouse.new(r0, r1)
    end

    defp do_eval([{_, r0}, {_, r0}, {_, r1}, {_, r1}, {_, r1}]) do
      Hand.FullHouse.new(r1, r0)
    end

    # Flush---------------------------------

    defp do_eval([{s, r0}, {s, r1}, {s, r2}, {s, r3}, {s, r4}]) do
      Hand.Flush.new([r0, r1, r2, r3, r4])
    end

    # Straight------------------------------

    defp do_eval([{_, 14}, {_, 5}, {_, 4}, {_, 3}, {_, 2}]) do
      Hand.Straight.new(5)
    end

    defp do_eval([{_, r}, _, _, _, {_, r4}]) when r4 == r - 4 do
      Hand.Straight.new(r)
    end

    # ThreeOfAKind------------------------------

    defp do_eval([{_, r}, {_, r}, {_, r}, {_, r1}, {_, r2}]) do
      Hand.ThreeOfAKind.new(r, [r1, r2])
    end

    defp do_eval([{_, r1}, {_, r}, {_, r}, {_, r}, {_, r2}]) do
      Hand.ThreeOfAKind.new(r, [r1, r2])
    end
    defp do_eval([{_, r1}, {_, r2}, {_, r}, {_, r}, {_, r}]) do
      Hand.ThreeOfAKind.new(r, [r1, r2])
    end

    # TwoPair------------------------------
    defp do_eval([{_, r}, {_, r1}, {_, r1}, {_, r2}, {_, r2}]) do
      Hand.TwoPair.new({r1, r2}, [r])
    end

    defp do_eval([{_, r1}, {_, r1}, {_, r}, {_, r2}, {_, r2}]) do
      Hand.TwoPair.new({r1, r2}, [r])
    end

    defp do_eval([{_, r1}, {_, r1}, {_, r2}, {_, r2}, {_, r}]) do
      Hand.TwoPair.new({r1, r2}, [r])
    end

    # OnePair------------------------------

    defp do_eval([{_, r}, {_, r}, {_, r1}, {_, r2}, {_, r3}]) do
      Hand.OnePair.new(r, [r1, r2, r3])
    end
    defp do_eval([{_, r1}, {_, r}, {_, r}, {_, r2}, {_, r3}]) do
      Hand.OnePair.new(r, [r1, r2, r3])
    end
    defp do_eval([{_, r1}, {_, r2}, {_, r}, {_, r}, {_, r3}]) do
      Hand.OnePair.new(r, [r1, r2, r3])
    end
    defp do_eval([{_, r1}, {_, r2}, {_, r3}, {_, r}, {_, r}]) do
      Hand.OnePair.new(r, [r1, r2, r3])
    end

    # HighCard------------------------------
    defp do_eval([{_, r1}, {_, r2}, {_, r3}, {_, r4}, {_, r5}]) do
      Hand.HighCard.new([r1, r2, r3, r4, r5])
    end

  end
end
