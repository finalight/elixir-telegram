defmodule ElixirTelegramWeb.MessageController do
  use ElixirTelegramWeb, :controller

  alias ElixirTelegram.Bot
  alias ElixirTelegram.Bot.Message

  action_fallback(ElixirTelegramWeb.FallbackController)

  def index(conn, _params) do
    messages = Bot.list_messages()
    render(conn, "index.json", messages: messages)
  end

  def create(conn, params) do
    # IO.puts(Poison.encode!(params))
    IO.puts(get_in(params, ["message", "from", "id"]))
    IO.puts("lol")

    body = %{
      chat_id: get_in(params, ["message", "from", "id"]),
      text: get_in(params, ["message", "text"])
    }

    case HTTPoison.post(
           "https://api.telegram.org/bot#{System.get_env("TELEGRAM_BOT_KEY")}/sendMessage",
           Poison.encode!(body),
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

    render(conn, "show.json")
    # with {:ok, %Message{} = message} <- Bot.create_message(message_params) do
    #   conn
    #   |> put_status(:created)
    #   |> put_resp_header("location", message_path(conn, :show, message))
    #   |> render("show.json", message: message)
    # end
  end

  def show(conn, %{"id" => id}) do
    message = Bot.get_message!(id)
    render(conn, "show.json", message: message)
  end

  def update(conn, %{"id" => id, "message" => message_params}) do
    message = Bot.get_message!(id)

    with {:ok, %Message{} = message} <- Bot.update_message(message, message_params) do
      render(conn, "show.json", message: message)
    end
  end

  def delete(conn, %{"id" => id}) do
    message = Bot.get_message!(id)

    with {:ok, %Message{}} <- Bot.delete_message(message) do
      send_resp(conn, :no_content, "")
    end
  end
end
