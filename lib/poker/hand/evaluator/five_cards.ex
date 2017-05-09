defmodule Poker.Hand.Evaluator.FiveCards do

  use Poker.Hand.Evaluator

  alias __MODULE__

  def eval(cards) do
    FiveCards.ByFeature.eval(cards)
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

  defmodule ByFeature do
    use Poker.Hand.Evaluator

    alias Poker.Hand
    alias Poker.Card

    @features Map.new([
      {5,  :single},
      {6,  :one_pair},
      {7,  :two_pair},
      {9,  :three_of_a_kind},
      {10, :full_house},
      {16, :four_of_a_kind}])

    def eval(cards) do
      case pattern(cards) do
        {:one_pair, map} ->
          {pair_rank, residual_ranks} = Enum.reduce(map, {nil, []}, fn
            {pair_rank, 3}, {_, ranks} ->
              {pair_rank, ranks}
            {residual_rank, 1}, {pair_rank, ranks} ->
              {pair_rank, [residual_rank | ranks]}
          end)
          Hand.OnePair.new(pair_rank, residual_ranks |> Card.sort_ranks)
        {:two_pair, map} ->
          {pair_ranks, residual_ranks} = Enum.reduce(map, {[], []}, fn
            {pair_rank, 3}, {pair_ranks, residual_ranks} ->
              {[pair_rank | pair_ranks], residual_ranks}
            {residual_rank, 1}, {pair_ranks, residual_ranks} ->
              {pair_ranks, [residual_rank | residual_ranks]}
          end)
          pair_ranks = pair_ranks |> Card.sort_ranks |> List.to_tuple
          Hand.TwoPair.new(pair_ranks, residual_ranks)
        {:three_of_a_kind, map} ->
          {rank_of_three, residual_ranks} = Enum.reduce(map, {nil, []}, fn
            {rank, 7}, {_, residual_ranks} ->
              {rank, residual_ranks}
            {rank, 1}, {rank_of_three, residual_ranks} ->
              {rank_of_three, [rank | residual_ranks]}
          end)
          Hand.ThreeOfAKind.new(rank_of_three, residual_ranks)
        {:full_house, map} ->
          {rank_of_three, rank_of_two} = Enum.reduce(map, {nil, nil}, fn
            {rank, 7}, {_, rank_of_two} ->
              {rank, rank_of_two}
            {rank, 3}, {rank_of_three, _} ->
              {rank_of_three, rank}
          end)
          Hand.FullHouse.new(rank_of_three, rank_of_two)
        {:four_of_a_kind, map} ->
          rank = Enum.reduce(map, nil, fn
            {rank, 15}, _ ->
              rank
            _, rank ->
              rank
          end)
          Hand.FourOfAKind.new(rank)
        {:single, _} ->
          flush_suit = flush?(cards)
          highest_straight = straight?(cards)
          cond do
            flush_suit && highest_straight && highest_straight == 14 ->
              Hand.RoyalFlush.new
            flush_suit && highest_straight ->
              Hand.StraightFlush.new(highest_straight)
            flush_suit ->
              Hand.Flush.new(Enum.map(cards, &(elem(&1, 1))) |> Card.sort_ranks)
            highest_straight ->
              Hand.Straight.new(highest_straight)
            true ->
              Hand.HighCard.new(Enum.map(cards, &(elem(&1, 1))) |> Card.sort_ranks)
          end
      end
    end

    defp pattern(cards) do
      import Bitwise, only: [{:<<<, 2}, {:|||, 2}]
      map = Enum.reduce(cards, %{}, fn
        {_, rank}, acc->
          Map.update(acc, rank, 1, fn value ->
            (value <<< 1) ||| 1
          end)
      end)
      feature = map |> Map.values |> Enum.sum
      pattern = Map.get(@features, feature)
      {pattern, map}
    end

    defp flush?(cards) do
      cards |> Enum.reduce_while(nil, fn
        {suit, _}, nil ->
          {:cont, suit}
        {suit, _}, suit ->
          {:cont, suit}
        {_, _}, _ ->
          {:halt, false}
      end)
    end

    defp straight?(cards) do
      import Bitwise
      {feature, max} = Enum.reduce(cards, {0, -1}, fn
        {_, rank}, {feature, max} ->
          {feature ||| (1 <<< rank), if rank > max do rank else max end}
      end)
      div(feature, (feature &&& -feature)) === 0x1f && max
    end
  end
end
