defmodule RestaurantCheckerWeb.Schemas.RestaurantVisit do
  require OpenApiSpex
  alias OpenApiSpex.Schema

  OpenApiSpex.schema(%{
    title: "Restaurant Visit",
    type: :object,
    properties: %{
      restaurant_visit_id: %Schema{
        type: :string,
        format: :uuid,
        example: "e8b90c4a-4eb0-4bb8-a2cb-5edef30d833c"
      },
      restaurant_names: %Schema{type: :string},
      food_names: %Schema{type: :string},
      first_name: %Schema{type: :string},
      food_cost: %Schema{type: :decimal, example: "1.0"},
      restaurant_name: %Schema{type: :string},
      visitors: %Schema{type: :decimal}
    }
  })
end
