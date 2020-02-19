defmodule Norte.Seeds do
  def run() do
    alias Norte.{Repo, Accounts, Base, Areas, Processes, Risks, Items}

    # Clients
    client1 =
      %Accounts.Client{cid: "cl1", name: "Client 1"}
      |> Repo.insert!()

    client2 =
      %Accounts.Client{cid: "cl2", name: "Client 2"}
      |> Repo.insert!()

    # Users
    params = %{
      uid: "usr@cl1",
      username: "Person 1.1",
      email: "fake@example.com",
      password: "secret",
      password_confirmation: "secret",
      client_id: client1.id
    }

    %Accounts.User{}
    |> Accounts.User.changeset_with_password(params)
    |> Repo.insert!()

    params = %{
      uid: "usr@cl2",
      username: "Person 2.1",
      email: "fake@example.com",
      password: "secret",
      password_confirmation: "secret",
      client_id: client2.id
    }

    %Accounts.User{}
    |> Accounts.User.changeset_with_password(params)
    |> Repo.insert!()

    # Units 1
    %Base.Unit{key: "01", name: "Unit 1.1", client_id: client1.id} |> Repo.insert!()
    %Base.Unit{key: "02", name: "Unit 1.2", client_id: client1.id} |> Repo.insert!()

    # Areas 1
    %Areas.Area{key: "01", name: "Area 1.1", client_id: client1.id} |> Repo.insert!()
    %Areas.Area{key: "02", name: "Area 1.2", client_id: client1.id} |> Repo.insert!()

    # Risks 1
    %Risks.Risk{key: "01", name: "Risk 1.1", client_id: client1.id} |> Repo.insert!()
    %Risks.Risk{key: "02", name: "Risk 1.2", client_id: client1.id} |> Repo.insert!()

    # Processes 1
    %Processes.Process{key: "01", name: "Process 1.1", client_id: client1.id} |> Repo.insert!()
    %Processes.Process{key: "02", name: "Process 1.2", client_id: client1.id} |> Repo.insert!()

    # Items 1
    %Items.Item{key: "01", name: "Item 1.1", client_id: client1.id} |> Repo.insert!()
    %Items.Item{key: "02", name: "Item 1.2", client_id: client1.id} |> Repo.insert!()

    # Units 2
    %Base.Unit{key: "011", name: "Unit 2.1", client_id: client2.id} |> Repo.insert!()
    %Base.Unit{key: "021", name: "Unit 2.2", client_id: client2.id} |> Repo.insert!()

    # Areas 2
    %Areas.Area{key: "011", name: "Area 2.1", client_id: client2.id} |> Repo.insert!()
    %Areas.Area{key: "021", name: "Area 2.2", client_id: client2.id} |> Repo.insert!()

    # Risks 2
    %Risks.Risk{key: "011", name: "Risk 2.1", client_id: client2.id} |> Repo.insert!()
    %Risks.Risk{key: "021", name: "Risk 2.2", client_id: client2.id} |> Repo.insert!()

    # Processes 2
    %Processes.Process{key: "011", name: "Process 2.1", client_id: client2.id} |> Repo.insert!()
    %Processes.Process{key: "021", name: "Process 2.2", client_id: client2.id} |> Repo.insert!()

    # Items 2
    %Items.Item{key: "011", name: "Item 2.1", client_id: client2.id} |> Repo.insert!()
    %Items.Item{key: "021", name: "Item 2.2", client_id: client2.id} |> Repo.insert!()

    :ok
  end
end
