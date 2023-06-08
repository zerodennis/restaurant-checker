defmodule RestaurantChecker.Repo.Migrations.AddRestaurantVisitTable do
  use Ecto.Migration

  def up do
    create table(:restaurant_visit, primary_key: false) do
      add :restaurant_visit_id, :binary_id, primary_key: true
      add :restaurant_names, :string
      add :food_names, :string
      add :food_cost, :decimal
      add :first_name, :string
    end
  end

  def down do
    drop table(:restaurant_visit)
  end
end
