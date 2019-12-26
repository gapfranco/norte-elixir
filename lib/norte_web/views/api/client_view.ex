defmodule NorteWeb.Api.ClientView do
  use NorteWeb, :view
  alias NorteWeb.Api.ClientView

  def render("index.json", %{clients: clients}) do
    %{data: render_many(clients, ClientView, "client.json")}
  end

  def render("show.json", %{client: client}) do
    %{data: render_one(client, ClientView, "client.json")}
  end

  def render("client.json", %{client: client}) do
    %{
      id: client.id,
      cid: client.cid,
      name: client.name,
      code: client.code,
      term: client.term,
      val_user: client.val_user,
      val_unit: client.val_unit,
      status: client.status
    }
  end

  def render("signup.json", %{client: client, user: user}) do
    %{
      client: %{
        type: "client",
        id: client.id,
        cid: client.cid,
        name: client.name,
        code: client.code,
        term: client.term,
        val_user: client.val_user,
        val_unit: client.val_unit,
        status: client.status
      },
      user: %{
        type: "user",
        id: user.id,
        uid: user.uid,
        username: user.username,
        email: user.email,
        client_id: user.client_id
      }
    }
  end

  def render("errors.json", %{errors: errors}) do
    msgs =
      Enum.into(errors, %{})
      |> Enum.map(fn {k, {t, _}} -> {k, t} end)
      |> Enum.into(%{})

    %{errors: msgs}
  end
end
