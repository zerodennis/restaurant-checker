defmodule RestaurantCheckerWeb.Router do
  use RestaurantCheckerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, html: {RestaurantCheckerWeb.Layouts, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :openapi do
    plug OpenApiSpex.Plug.PutApiSpec, module: RestaurantCheckerWeb.ApiSpec
  end

  scope "/" do
    pipe_through :browser

    get "/", RestaurantCheckerWeb.PageController, :home
    get "/swaggerui", OpenApiSpex.Plug.SwaggerUI, path: "/api/openapi"
  end

  scope "/api" do
    pipe_through([:api, :openapi])

    get "/openapi", OpenApiSpex.Plug.RenderSpec, []

    scope "/restaurant-visits" do
      get "/", RestaurantCheckerWeb.RestaurantVisitController, :index
      post "/import-csv", RestaurantCheckerWeb.RestaurantVisitController, :import_csv
    end
  end
end
