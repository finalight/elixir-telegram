defmodule ElixirTelegramWeb.UserView do
  use ElixirTelegramWeb, :view
  alias ElixirTelegramWeb.UserView

  def render("index.json", _) do
    %{helloo: "world"}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      email: user.email,
      encrypted_password: user.encrypted_password}
  end
end
