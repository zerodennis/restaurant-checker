defmodule RestaurantChecker.RestaurantVisits.Queries do
  @moduledoc """
    Queries relating to the RestaurantVisit model
  """

  import Ecto.Query, only: [from: 2]

  alias RestaurantChecker.RestaurantVisits.RestaurantVisit

  @doc """
    Gets each row that matches restaurant_name in params
  """
  @spec get_visits_by_restaurant_name(nil | maybe_improper_list | map) :: any
  def get_visits_by_restaurant_name(params) do
    from r in RestaurantVisit,
      where: r.restaurant_names == ^params.restaurant_name
  end

  @doc """
    Gets the amount of profit earned by a restaurant, given a restaurant_names
    by getting the sum of food_cost for a restaurant_names
  """
  def get_earnings_by_restaurant_name(%{restaurant_name: restaurant_name}) do
    from r in RestaurantVisit,
      where: r.restaurant_names == ^restaurant_name,
      select: sum(r.food_cost)
  end

  @doc """
    Gets the most popular dish (food_names with the highest occurrence) per
    unique restaurant_names.

    Uses a self-join and a subquery to determine the "popular_dish_count"
    for each combination of "restaurant_names" and "food_names" and then
    selects the rows where the "popular_dish_count" matches the maximum
    count for each "restaurant_names"
  """
  def most_popular_dishes do
    """
      SELECT distinct v.restaurant_names, v.food_names, s.popular_dish_count
      FROM restaurant_visit v
      INNER JOIN (
        SELECT restaurant_names, food_names, COUNT(*) AS popular_dish_count
        FROM restaurant_visit
        GROUP BY restaurant_names, food_names
        HAVING COUNT(*) = (
          SELECT MAX(popular_dish_count)
          FROM (
            SELECT restaurant_names, food_names, COUNT(*) AS popular_dish_count
            FROM restaurant_visit
            GROUP BY restaurant_names, food_names
          ) subquery
          WHERE subquery.restaurant_names = restaurant_visit.restaurant_names
        )
      ) s ON v.restaurant_names = s.restaurant_names AND v.food_names = s.food_names
    """
  end

  @doc """
    Gets the total profit for each combination of restaurant_names and food_items
    with a subquery. Then, another subquery is used to find the maximum total_profit
    per restaurant using the MAX function, grouping by restaurant_names.

    Finally, the main query joins the subquery with the maximum profits to retrieve
    the rows where the total profit matches the maximum profit for each restaurant.
  """
  def most_profitable_dishes do
    """
      WITH subquery AS (
        SELECT restaurant_names, food_names, SUM(food_cost) AS total_profit
        FROM restaurant_visit
        GROUP BY restaurant_names, food_names
      )
      SELECT s.restaurant_names AS restaurant_name, s.food_names AS most_profitable_dish, s.total_profit
      FROM subquery s
      INNER JOIN (
        SELECT restaurant_names, MAX(total_profit) AS max_profit
        FROM subquery
        GROUP BY restaurant_names
      ) m ON s.restaurant_names = m.restaurant_names AND s.total_profit = m.max_profit
    """
  end

  @doc """
    Gets the most frequent visitor (most commonly occurring first_name) for
    each unique restaurant_names.

    This uses a subquery with the ROW_NUMBER() fn and the PARTITION BY clause
    to assign row numbers to each combination of restaurant_names and first_name,
    ordered by the count in descending order within each restaurant_names group.

    Then, in the outer query the row is selected where the row number is 1 which
    indicates the first_name that appeared the most for each restaurant_names.
  """
  def most_frequent_visitor_per_store do
    """
    SELECT restaurant_names, first_name
    FROM (
        SELECT restaurant_names, first_name,
          ROW_NUMBER() OVER (PARTITION BY restaurant_names ORDER BY count DESC) AS rn
        FROM (
            SELECT restaurant_names, first_name, COUNT(*) AS count
            FROM restaurant_visit
            GROUP BY restaurant_names, first_name
        ) AS subquery
    ) AS main_query
    WHERE rn = 1;
    """
  end

  @doc """
    Gets the first_name that visited the most stores by selecting the
    most commonly-occurring first_name
  """
  def most_visited_stores do
    """
    SELECT first_name
    FROM restaurant_visit
    GROUP BY first_name
    ORDER BY COUNT(*) DESC
    LIMIT 1;
    """
  end
end
