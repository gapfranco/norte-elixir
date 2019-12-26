defmodule NorteWeb.Router do
  use NorteWeb, :router
  alias Norte.Guardian

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :jwt_authenticated do
    plug Guardian.AuthPipeline
  end

  scope "/", NorteWeb do
    pipe_through :browser

    resources "/clients", ClientController, only: [:show, :new, :create]
    get "/", PageController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", NorteWeb.Api do
    pipe_through :api
    post "/signup", ClientController, :sign_up
    post "/signin", UserController, :sign_in
  end

  scope "/api", NorteWeb.Api do
    pipe_through [:api, :jwt_authenticated]
    resources "/users", UserController, except: [:new, :edit]
    resources "/clients", ClientController, only: [:index, :show, :update, :delete]
  end
end
