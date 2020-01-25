defmodule NorteWeb.Schema.Mutations.SessionMutations do
  use Absinthe.Schema.Notation

  alias NorteWeb.Schema.Resolvers

  object :session_mutations do
    @desc "User sign in returning JWT token"
    field :signin, type: :session_type do
      arg(:input, non_null(:session_input_type))
      resolve(&Resolvers.SessionResolvers.login_user/3)
    end

    @desc "Create new client and user"
    field :signup, type: :signup_type do
      arg(:input, non_null(:signup_input_type))
      resolve(&Resolvers.SessionResolvers.signup_user/3)
    end

    @desc "Forgot password - send e-mail to reset"
    field :forgot_password, type: :message_type do
      arg(:uid, non_null(:string))
      resolve(&Resolvers.SessionResolvers.forgot_password/3)
    end

    @desc "Create new password"
    field :create_password, type: :message_type do
      arg(:input, non_null(:create_password_input_type))
      resolve(&Resolvers.SessionResolvers.create_password/3)
    end
  end
end
