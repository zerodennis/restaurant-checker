defmodule RestaurantCheckerWeb.RestaurantVisitJSON do
  alias RestaurantChecker.RestaurantVisits.RestaurantVisit

  def index(%{restaurant_visits: restaurant_visits}) do
    %{data: for(restaurant_visit <- restaurant_visits, do: data(restaurant_visit))}
  end

  defp data(%RestaurantVisit{} = visit) do
    visit
    |> Map.take([:first_name, :restaurant_names, :food_names, :food_cost])
  end
end
