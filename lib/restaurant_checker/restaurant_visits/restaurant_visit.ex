defmodule RestaurantChecker.RestaurantVisits.RestaurantVisit do
  use Ecto.Schema

  @schema_fields [
    :restaurant_visit_id,
    :restaurant_names,
    :food_names,
    :first_name,
    :food_cost
  ]

  @derive {Phoenix.Param, key: :restaurant_visit_id}
  @derive {Jason.Encoder, only: @schema_fields}

  @primary_key {:restaurant_visit_id, :binary_id, autogenerate: true}

  schema "restaurant_visit" do
    field(:restaurant_names, :string)
    field(:food_names, :string)
    field(:first_name, :string)
    field(:food_cost, :decimal)
  end
end
