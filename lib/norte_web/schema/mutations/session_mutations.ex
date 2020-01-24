defmodule NorteWeb.Schema.Mutations.SessionMutations do
  use Absinthe.Schema.Notation

  alias NorteWeb.Schema.Resolvers

  object :session_mutations do
    @desc "Login a user and return a JWT token"
    field :login_user, type: :session_type do
      arg(:input, non_null(:session_input_type))
      resolve(&Resolvers.SessionResolvers.login_user/3)
    end

    @desc "Signup a new user and client"
    field :signup_user, type: :signup_type do
      arg(:input, non_null(:signup_input_type))
      resolve(&Resolvers.SessionResolvers.signup_user/3)
    end

    @desc "Forgot password - send e-mail to reset"
    field :forgot_password, type: :message_type do
      arg(:uid, non_null(:string))
      resolve(&Resolvers.SessionResolvers.forgot_password/3)
    end
  end
end
