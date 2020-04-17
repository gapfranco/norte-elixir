defmodule Norte.Email do
  use Bamboo.Phoenix, view: Norte.EmailView

  def forgot_password_text_email(email_address, user, client, token) do
    new_email()
    |> to(email_address)
    |> from("norte@m2iapp.com")
    |> subject("Recriar senha")
    |> put_text_layout({NorteWeb.EmailView, "forgot_password.text"})
    |> render("forgot_password.text", user: user, client: client, token: token)
  end

  def forgot_password_email(email_address, user, client, token) do
    email_address
    |> forgot_password_text_email(user, client, token)
    |> put_html_layout({NorteWeb.EmailView, "forgot_password.html"})
    |> render("forgot_password.html", user: user, client: client, token: token)
  end

  def welcome_text_email(email_address, user, client) do
    new_email()
    |> to(email_address)
    |> from("norte@m2iapp.com")
    |> subject("Bem vindo")
    |> put_text_layout({NorteWeb.EmailView, "welcome.text"})
    |> render("welcome.text",
      uid: user.uid,
      username: user.username,
      cid: client.cid,
      name: client.name
    )
  end

  # Email.forgot_password_email(user.email, user.uid, client.cid, token) |> Mailer.deliver_now()

  def welcome_email(email_address, user, client) do
    email_address
    |> welcome_text_email(user, client)
    |> put_html_layout({NorteWeb.EmailView, "welcome.html"})
    |> render("welcome.html",
      uid: user.uid,
      username: user.username,
      cid: client.cid,
      name: client.name
    )
  end

  def alert_event_text_email(email_address, event) do
    new_email()
    |> to(email_address)
    |> from("norte@m2iapp.com")
    |> subject("Ocorrência de não conformidade")
    |> put_text_layout({NorteWeb.EmailView, "event_alert.text"})
    |> render("event_alert.text",
      item_key: event.item_key,
      item_name: event.item_name,
      text: event.text,
      unit_key: event.unit_key,
      unit_name: event.unit_name,
      uid: event.uid,
      event_date: event.event_date
    )
  end

  def alert_event_email(email_address, event) do
    email_address
    |> alert_event_text_email(event)
    |> put_html_layout({NorteWeb.EmailView, "event_alert.html"})
    |> render("event_alert.html",
      item_key: event.item_key,
      item_name: event.item_name,
      text: event.text,
      unit_key: event.unit_key,
      unit_name: event.unit_name,
      uid: event.uid,
      event_date: event.event_date
    )
  end
end
