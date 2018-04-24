defmodule ElixirTelegramWeb.BotController do
  use ElixirTelegramWeb, :controller

  def index(conn, _params) do
    render(conn, "show.json")
  end

  def render("show.json") do
    %{id: "world"}
  end
end
