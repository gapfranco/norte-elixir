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
end
