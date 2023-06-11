defmodule RestaurantCheckerWeb.RestaurantVisitJSON do
  alias RestaurantChecker.RestaurantVisits.RestaurantVisit

  def index(%{restaurant_visits: restaurant_visits}) do
    %{
      data:
        for(
          restaurant_visit <- restaurant_visits,
          do: data(struct(RestaurantVisit, restaurant_visit))
        )
    }
  end

  @spec import_csv(%{:restaurant_visits => any, optional(any) => any}) :: %{data: <<_::56>>}
  def import_csv(%{message: message}) do
    %{data: message}
  end

  @spec customers_by_restaurant(any) :: %{data: any}
  def customers_by_restaurant(%{visitors: visitors}) do
    %{data: %{visitors: visitors}}
  end

  def earnings_by_restaurant(%{earnings: earnings}) do
    %{data: %{earnings: earnings}}
  end

  def popular_dishes(%{most_popular_dishes: dishes}) do
    %{data: %{dishes: dishes}}
  end

  def most_profitable_dishes(%{most_profitable_dishes: dishes}) do
    %{data: %{dishes: dishes}}
  end

  def most_frequent_visitors(%{most_frequent_visitors: visitors, most_avid_visitor: visitor}) do
    %{data: %{most_frequent_visitors: visitors, most_avid_visitor: visitor}}
  end

  defp data(%RestaurantVisit{} = visit) do
    visit
    |> Map.take([:first_name, :restaurant_names, :food_names, :food_cost])
  end
end
