defmodule NorteWeb.Schema.Types.SessionTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  # import Absinthe.Resolution.Helpers, only: [dataloader: 1, dataloader: 3]

  @desc "User and token for the session"
  object :session_type do
    field(:token, :string)
    field(:user, :user_type)
  end

  @desc "New session signin"
  input_object :session_input_type do
    field(:uid, non_null(:string))
    field(:password, non_null(:string))
  end

  @desc "Client and user creation data"
  input_object :signup_input_type do
    field(:cid, non_null(:string))
    field(:name, non_null(:string))
    field(:uid, non_null(:string))
    field(:username, non_null(:string))
    field(:email, non_null(:string))
    field(:password, non_null(:string))
    field(:password_confirmation, non_null(:string))
  end

  @desc "Create a new password"
  input_object :create_password_input_type do
    field(:uid, non_null(:string))
    field(:token, non_null(:string))
    field(:password, non_null(:string))
    field(:password_confirmation, non_null(:string))
  end

  @desc "Client and user created"
  object :signup_type do
    field(:cid, non_null(:string))
    field(:name, non_null(:string))
    field(:uid, non_null(:string))
    field(:username, non_null(:string))
    field(:email, non_null(:string))
  end

  @desc "Return message"
  object :message_type do
    field(:msg, non_null(:string))
  end

  @desc "Client register"
  object :client_type do
    field(:id, :id)
    field(:cid, :string)
    field(:name, :string)
    field(:code, :string)
    field(:term, :datetime)
    field(:val_unit, :decimal)
    field(:val_user, :decimal)
    field :users, list_of(:user_type), resolve: dataloader(Users)
  end

  @desc "User register"
  object :user_type do
    field(:id, :id)
    field(:uid, :string)
    field(:username, :string)
    field(:email, :string)
    field(:admin, :boolean)
    field(:block, :boolean)
    field :client, :client_type, resolve: dataloader(Clients)
  end

  @desc "Filters for queries"
  input_object :user_filter do
    @desc "Matching a field"
    field :matching, :string
  end

  @desc "User list paginated"
  object :paginated_users do
    field(:count, :integer)
    field(:first, :integer)
    field(:last, :integer)
    field(:has_next, :boolean)
    field(:has_prev, :boolean)
    field(:next_page, :integer)
    field(:prev_page, :integer)
    field(:page, :integer)
    field(:list, list_of(:user_type))
  end

  @desc "Clients list paginated"
  object :paginated_clients do
    field(:count, :integer)
    field(:first, :integer)
    field(:last, :integer)
    field(:has_next, :boolean)
    field(:has_prev, :boolean)
    field(:next_page, :integer)
    field(:prev_page, :integer)
    field(:page, :integer)
    field(:list, list_of(:client_type))
  end
end
