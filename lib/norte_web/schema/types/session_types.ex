defmodule NorteWeb.Schema.Types.SessionTypes do
  use Absinthe.Schema.Notation

  object :session_type do
    field(:token, :string)
    field(:user, :user_type)
  end

  input_object :session_input_type do
    field(:uid, non_null(:string))
    field(:password, non_null(:string))
  end

  object :user_type do
    field(:id, :id)
    field(:uid, :string)
    field(:username, :string)
    field(:email, :string)
    field(:admin, :boolean)
    field(:block, :boolean)
    field(:client_id, :id)
  end
end
