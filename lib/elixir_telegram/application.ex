defmodule ElixirTelegram.Application do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(ElixirTelegram.Repo, []),
      # Start the endpoint when the application starts
      supervisor(ElixirTelegramWeb.Endpoint, [])
      # Start your own worker by calling: ElixirTelegram.Worker.start_link(arg1, arg2, arg3)
      # worker(ElixirTelegram.Worker, [arg1, arg2, arg3]),
    ]

    case HTTPoison.post(
           "https://api.telegram.org/bot#{System.get_env("TELEGRAM_BOT_KEY")}/setWebhook",
           "{\"url\": \"#{System.get_env("BOT_URL")}/api/message\"}",
           [{"Content-Type", "application/json"}]
         ) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.puts("success!!")
        IO.puts(body)

      {:ok, %HTTPoison.Response{status_code: 400, body: body}} ->
        IO.puts(body)

      {:ok, %HTTPoison.Response{status_code: 404, body: body}} ->
        IO.puts(body)
    end

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ElixirTelegram.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    ElixirTelegramWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
