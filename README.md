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

# Other Questions

### How would you build this differently if the data was being streamed from Kafka?

If I were to build this assuming the data was being streamed from Kafka, I would:

- Integrate my Elixir/Phoenix app with Kafka using Elixir libraries made for interacting with Kafka like `kafka_ex`.
- Create a Kafka consumer module that subscribes to relevant Kafka topics and receives the streamed data. This will be responsible for consuming messages from Kafka and then processing them, replacing the CSV import step in the current application.
- Maybe use Phoenix Channels if real-time updates are needed.
- Implement proper error handling for possible errors that may happen during the streaming process like connectivity issues or processing failures.

### How would you improve the deployment of this system?

- Containerize the system with something like Docker
- Integrate with a CI/CD service like Semaphore or GitHub actions
- Use container orchestration like ECS (Elastic Container Service)
- Use load balancers or autoscaling if needed
- Use something like Grafana for monitoring
- Use Terraform to easily version control and scale if needed

