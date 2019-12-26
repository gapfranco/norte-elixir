defmodule Norte.Guardian.AuthPipeline do
  use Guardian.Plug.Pipeline,
    otp_app: :Norte,
    module: Norte.Guardian,
    error_handler: Norte.AuthErrorHandler

  plug Guardian.Plug.VerifyHeader, realm: "Bearer"
  plug Guardian.Plug.EnsureAuthenticated
  plug Guardian.Plug.LoadResource
end
