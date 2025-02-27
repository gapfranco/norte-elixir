defmodule NorteWeb.Router do
  use NorteWeb, :router

  # alias Norte.Guardian

  pipeline :api do
    plug :accepts, ["json"]
    plug(NorteWeb.Plugs.Context)
  end

  # pipeline :jwt_authenticated do
  #   plug Guardian.AuthPipeline
  # end

  if Mix.env() == :dev do
    forward "/sent_emails", Bamboo.SentEmailViewerPlug
  end

  scope "/" do
    pipe_through :api

    forward "/graphql", Absinthe.Plug, schema: NorteWeb.Schema

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: NorteWeb.Schema,
      socket: NorteWeb.UserSocket
  end

  # Other scopes may use custom stacks.
  # scope "/api", NorteWeb do
  #   pipe_through :api
  #   post "/signup", ClientController, :sign_up
  #   post "/signin", UserController, :sign_in
  #   post "/password", UserController, :forgot_password
  #   put "/password", UserController, :create_password
  # end

  # scope "/api", NorteWeb do
  #   pipe_through [:api, :jwt_authenticated]
  #   resources "/users", UserController, except: [:new, :edit]
  #   get "/users-uid/:uid", UserController, :show_uid
  #   resources "/clients", ClientController, only: [:index, :show, :update, :delete]
  #   resources "/units", UnitController, except: [:new, :edit]
  #   resources "/areas", AreaController, except: [:new, :edit]
  #   resources "/processes", ProcessController, except: [:new, :edit]
  #   resources "/risks", RiskController, except: [:new, :edit]
  # end
end
