defmodule ElixirTelegramWeb.PageController do
  use ElixirTelegramWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
