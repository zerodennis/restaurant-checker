# RestaurantChecker

<img width="1440" alt="image" src="https://github.com/zerodennis/restaurant-checker/assets/19771211/c66fff03-c084-4a42-b4e3-513978dc6d31">

# Prerequisites

- Install Elixir
- Set up/install Phoenix
- Set up/install Postgres
- You will need a postgres user with the name "postgres" and the password "postgres"
- In project root: Run `mix deps.get`
- In project root: Run `mix ecto.create`
- In project root: Run `mix ecto.migrate`

# Get started

- Run `iex -S mix phx.server` in project root
- Go to `localhost:4000/swaggerui` on your browser once the Phoenix server has started
- Import your `data.csv` using the `/import-csv` endpoint
- Use the remaining endpoints.
