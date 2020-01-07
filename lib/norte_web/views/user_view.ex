defmodule NorteWeb.UserView do
  use NorteWeb, :view
  alias NorteWeb.UserView

  def render("index.json", %{users: users}) do
    %{data: render_many(users, UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{
      id: user.id,
      uid: user.uid,
      username: user.username,
      email: user.email,
      expired: user.expired,
      admin: user.admin,
      block: user.block,
      token: user.token,
      token_date: user.token_date,
      client_id: user.client_id
      # client: render_one(user.client, NorteWeb.Api.ClientView, "client.json")
    }
  end

  def render("jwt.json", %{jwt: jwt}) do
    %{jwt: jwt}
  end

  def render("errors.json", %{errors: errors}) do
    msgs =
      Enum.into(errors, %{})
      |> Enum.map(fn {k, {t, _}} -> {k, t} end)
      |> Enum.into(%{})

    %{errors: msgs}
  end
end
