defmodule NorteWeb.Schema.Mutations.SessionMutations do
  use Absinthe.Schema.Notation

  alias NorteWeb.Schema.Resolvers
  alias NorteWeb.Schema.Middleware

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

    @desc "Change password"
    field :change_password, type: :message_type do
      arg(:old_password, non_null(:string))
      arg(:password, non_null(:string))
      arg(:password_confirmation, non_null(:string))
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.SessionResolvers.change_password/3)
    end

    @desc "Create a user"
    field :user_create, :user_type do
      arg(:uid, non_null(:string))
      arg(:username, non_null(:string))
      arg(:email, non_null(:string))
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.UserResolvers.create_user/3)
    end

    @desc "Update a user"
    field :user_update, :user_type do
      arg(:uid, non_null(:string))
      arg(:username, :string)
      arg(:email, :string)
      arg(:admin, :boolean)
      arg(:block, :boolean)
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.UserResolvers.update_user/3)
    end

    @desc "Delete a user"
    field :user_delete, :user_type do
      arg(:uid, non_null(:string))
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.UserResolvers.delete_user/3)
    end
  end
end
