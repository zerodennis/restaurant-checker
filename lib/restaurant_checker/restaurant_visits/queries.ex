defmodule RestaurantChecker.RestaurantVisits.Queries do
  import Ecto.Query, only: [from: 2]

  alias RestaurantChecker.RestaurantVisits.RestaurantVisit

  @spec get_visitors_by_restaurant_name(nil | maybe_improper_list | map) :: any
  def get_visitors_by_restaurant_name(params) do
    from r in RestaurantVisit,
      where: r.restaurant_names == ^params.restaurant_name
  end

  def get_earnings_by_restaurant_name(%{restaurant_name: restaurant_name}) do
    from r in RestaurantVisit,
      where: r.restaurant_names == ^restaurant_name,
      select: sum(r.food_cost)
  end

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
