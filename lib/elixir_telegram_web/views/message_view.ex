defmodule ElixirTelegramWeb.MessageView do
  use ElixirTelegramWeb, :view
  alias ElixirTelegramWeb.MessageView

  def render("index.json", %{messages: messages}) do
    %{data: render_many(messages, MessageView, "message.json")}
  end

  def render("show.json", _params) do
    %{message: "some weird value"}
    # %{data: render_one(message, MessageView, "message.json")}
  end

  def render("message.json", %{message: message}) do
    %{id: message.id, text: message.text}
  end
end
