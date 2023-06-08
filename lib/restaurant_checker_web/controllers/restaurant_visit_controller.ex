defmodule RestaurantCheckerWeb.RestaurantVisitController do
  use RestaurantCheckerWeb, :controller

  import OpenApiSpex.Operation, only: [parameter: 5, request_body: 4, response: 3]
  alias OpenApiSpex.{Operation, Reference, Schema}

  alias RestaurantCheckerWeb.Schemas.RestaurantVisit, as: Visit
  alias RestaurantChecker.RestaurantVisits.RestaurantVisit
  alias RestaurantChecker.RestaurantVisits.Resolver

  plug OpenApiSpex.Plug.CastAndValidate, json_render_error_v2: true

  @spec open_api_operation(atom) :: Operation.t()
  def open_api_operation(action) do
    operation = String.to_existing_atom("#{action}_operation")
    apply(__MODULE__, operation, [])
  end

  @spec index_operation() :: Operation.t()
  def index_operation() do
    %Operation{
      tags: ["Restaurant Visit"],
      summary: "List restaurant visits",
      description: "List all restaurant visits",
      operationId: "RestaurantVisitController.index",
      responses: %{
        200 =>
          response("Restaurant Visit List Response", "application/json", %Schema{
            type: :array,
            items: Visit
          }),
        422 => %Reference{"$ref": "#/components/responses/unprocessable_entity"}
      }
    }
  end

  def index(conn, _params) do
    render(conn, :index, %{restaurant_visits: []})
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

  def import_csv(conn, _params) do
    %{body_params: %{file: %Plug.Upload{filename: _filename, path: path}}} = conn
    res = decode_csv(path)
    render(conn, :import_csv, %{restaurant_visits: res})
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
