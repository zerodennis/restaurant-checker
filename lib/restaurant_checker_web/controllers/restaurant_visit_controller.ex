defmodule RestaurantCheckerWeb.RestaurantVisitController do
  @moduledoc """
    Controller module for the RestaurantVisit context.
  """
  use RestaurantCheckerWeb, :controller

  import OpenApiSpex.Operation, only: [response: 3]
  alias OpenApiSpex.{Operation, Schema}

  alias RestaurantCheckerWeb.Schemas.RestaurantVisit, as: Visit
  alias RestaurantChecker.RestaurantVisits.Resolver

  plug OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true

  @spec open_api_operation(atom) :: Operation.t()
  def open_api_operation(action) do
    operation = String.to_existing_atom("#{action}_operation")
    apply(__MODULE__, operation, [])
  end

  def import_csv_operation() do
    %Operation{
      tags: ["Restaurant Visit"],
      summary: "Import CSV",
      description: "Import CSV",
      operationId: "RestaurantVisitController.import_csv",
      parameters: [],
      requestBody:
        Operation.request_body("csv file", "multipart/form-data", %Schema{
          type: :object,
          properties: %{
            file: %Schema{type: :string, format: :binary}
          }
        }),
      responses: %{
        200 =>
          response("Uploaded successfully", "application/json", %Schema{
            type: :array,
            items: Visit
          })
      }
    }
  end

  @doc """
    Take in a CSV file containing fields and values for a RestaurantVisit
    and insert them into the database.
  """
  def import_csv(conn, _params) do
    %{body_params: %{file: %Plug.Upload{filename: _filename, path: path}}} = conn
    res = decode_csv(path)
    Resolver.batch_insert(res)
    render(conn, :import_csv, message: "success")
  end

  def customers_by_restaurant_operation() do
    %Operation{
      tags: ["Restaurant Visit"],
      summary: "Find number of visitors using restaurant name",
      description: "Find the number visitors using restaurant name",
      operationId: "RestaurantVisitController.customers_by_restaurant",
      parameters: [
        Operation.parameter(
          :restaurant_name,
          :query,
          %Schema{
            type: :string
          },
          "Restaurant Name",
          required: true
        )
      ],
      responses: %{
        200 =>
          response("Number of visitors", "application/json", %Schema{
            type: :object,
            properties: %{
              visitors: %Schema{type: :decimal}
            }
          })
      }
    }
  end

  def customers_by_restaurant(conn, params) do
    visitors = Resolver.customers_by_restaurant(params)

    render(conn, :customers_by_restaurant, visitors: visitors)
  end

  def earnings_by_restaurant_operation() do
    %Operation{
      tags: ["Restaurant Visit"],
      summary: "Calculate the amount of money earned by a restaurant",
      description: "Calculate the amount of money earned by a restaurant",
      operationId: "RestaurantVisitController.earnings_by_restaurant",
      parameters: [
        Operation.parameter(
          :restaurant_name,
          :query,
          %Schema{
            type: :string
          },
          "Restaurant Name",
          required: true
        )
      ],
      responses: %{
        200 =>
          response("Money earned", "application/json", %Schema{
            type: :object,
            properties: %{
              total_earnings: %Schema{type: :decimal}
            }
          })
      }
    }
  end

  def earnings_by_restaurant(conn, params) do
    res = Resolver.earnings_by_restaurant(params)

    render(conn, :earnings_by_restaurant, earnings: res)
  end

  def popular_dishes_operation() do
    %Operation{
      tags: ["Restaurant Visit"],
      summary: "List popular dishes",
      description: "List the most popular dishes per restaurant",
      operationId: "RestaurantVisitController.popular_dishes",
      responses: %{
        200 =>
          response("Most popular dishes per restaurant", "application/json", %Schema{
            type: :array,
            items: %Schema{
              type: :object,
              properties: %{
                restaurant_name: %Schema{type: :string},
                food_name: %Schema{type: :string},
                food_count: %Schema{type: :integer}
              }
            }
          })
      }
    }
  end

  def popular_dishes(conn, _) do
    {:ok, %{rows: rows}} = Resolver.most_popular_dishes()

    formatted_result =
      Enum.map(rows, fn [restaurant_name, food_name, food_count] ->
        %{
          restaurant_name: restaurant_name,
          food_name: food_name,
          food_count: food_count
        }
      end)

    render(conn, :popular_dishes, most_popular_dishes: formatted_result)
  end

  def most_profitable_dishes_operation() do
    %Operation{
      tags: ["Restaurant Visit"],
      summary: "List most profitable dishes",
      description: "List most profitable dishes per restaurant",
      operationId: "RestaurantVisitController.most_profitable_dishes",
      responses: %{
        200 =>
          response("Most profitable dishes per restaurant", "application/json", %Schema{
            type: :array,
            items: %Schema{
              type: :object,
              properties: %{
                restaurant_name: %Schema{type: :string},
                food_name: %Schema{type: :string},
                total_profit: %Schema{type: :decimal}
              }
            }
          })
      }
    }
  end

  def most_profitable_dishes(conn, _params) do
    {:ok, %{rows: rows}} = Resolver.most_profitable_dishes()

    formatted_result =
      Enum.map(rows, fn [restaurant_name, food_name, total_profit] ->
        %{
          restaurant_name: restaurant_name,
          food_name: food_name,
          total_profit: total_profit
        }
      end)

    render(conn, :most_profitable_dishes, most_profitable_dishes: formatted_result)
  end

  def most_frequent_visitors_operation() do
    %Operation{
      tags: ["Restaurant Visit"],
      summary: "Find most frequent visitors",
      description:
        "Find the most frequent visitors per restaurant and the customer that visited the most stores",
      operationId: "RestaurantVisitController.most_frequent_visitor",
      responses: %{
        200 =>
          response("Most frequent visitors", "application/json", %Schema{
            type: :array,
            items: %Schema{
              type: :object,
              properties: %{
                most_frequent_visitors: %Schema{
                  type: :array,
                  items: %Schema{
                    type: :object,
                    properties: %{
                      restaurant_name: %Schema{type: :string},
                      visitor_name: %Schema{type: :string}
                    }
                  }
                },
                most_avid_visitor: %Schema{type: :string}
              }
            }
          })
      }
    }
  end

  def most_frequent_visitors(conn, _params) do
    {:ok, %{rows: rows}} = Resolver.most_frequent_visitors_per_store()
    {:ok, %{rows: visitor}} = Resolver.most_avid_visitor()

    formatted_most_frequent_visitors =
      Enum.map(rows, fn [restaurant_name, visitor_name] ->
        %{restaurant_name: restaurant_name, visitor_name: visitor_name}
      end)

    formatted_most_avid_visitor = Enum.flat_map(visitor, & &1) |> List.first()

    render(conn, :most_frequent_visitors, %{
      most_frequent_visitors: formatted_most_frequent_visitors,
      most_avid_visitor: formatted_most_avid_visitor
    })
  end

  defp decode_csv(path) do
    "#{path}"
    |> Path.expand(__DIR__)
    |> File.stream!()
    |> CSV.decode!(headers: true)
    |> Enum.map(fn item ->
      %{
        restaurant_names: item["restaurant_names"],
        first_name: item["first_name"],
        food_names: item["food_names"],
        food_cost: Decimal.new(item["food_cost"])
      }
    end)
  end
end
