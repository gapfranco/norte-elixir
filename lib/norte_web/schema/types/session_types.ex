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

  input_object :signup_input_type do
    field(:cid, non_null(:string))
    field(:name, non_null(:string))
    field(:uid, non_null(:string))
    field(:username, non_null(:string))
    field(:email, non_null(:string))
    field(:password, non_null(:string))
    field(:password_confirmation, non_null(:string))
  end

  input_object :create_password_input_type do
    field(:uid, non_null(:string))
    field(:token, non_null(:string))
    field(:password, non_null(:string))
    field(:password_confirmation, non_null(:string))
  end

  object :signup_type do
    field(:cid, non_null(:string))
    field(:name, non_null(:string))
    field(:uid, non_null(:string))
    field(:username, non_null(:string))
    field(:email, non_null(:string))
  end

  object :message_type do
    field(:msg, non_null(:string))
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
