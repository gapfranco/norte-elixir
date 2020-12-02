# Norte

Implementação da API para o sistema Norte (compliance e risco)

Usando Elixir e GraphQL via Absinthe.

Para testar localmente:

- Ajustar os parâmetros de banco de dados e de envio de e-mail em config/dev.exs
- Instalar dependências com `mix deps.get`
- Criar e migrar o banco de dados com `mix ecto.setup`
- Instalar dependências Node.js com `cd assets && npm install`, se necessário
- Iniciar o endpoint Phoenix com `mix phx.server`

Pode acessar o endpoint graphQL com [`localhost:4000`](http://localhost:4000/graphiql) com browser.
