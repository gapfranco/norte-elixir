defmodule Norte.Pagination do
  import Ecto.Query
  alias Norte.Repo

  def query(query, page, per_page: per_page) when is_binary(page) do
    query(query, String.to_integer(page), per_page: per_page)
  end

  def query(query, page, per_page: per_page) do
    query
    |> limit(^(per_page + 1))
    |> offset(^(per_page * (page - 1)))
    |> Repo.all()
  end

  def page(query, page, per_page: per_page) when is_binary(page) do
    page(query, String.to_integer(page), per_page: per_page)
  end

  def page(query, page, per_page: per_page) do
    results = query(query, page, per_page: per_page)
    Enum.slice(results, 0, per_page)
  end

  def list_query(q, params) do
    page =
      cond do
        is_nil(params[:page]) -> 1
        true -> params[:page]
      end

    size =
      cond do
        is_nil(params[:size]) -> 10
        true -> params[:size]
      end

    page(q, page, per_page: size)
  end

  # def page2(query, page, per_page: per_page) when is_binary(page) do
  #   page(query, String.to_integer(page), per_page: per_page)
  # end

  # def page2(query, page, per_page: per_page) do
  #   IO.inspect(page)
  #   results = query(query, page, per_page: per_page)
  #   count = Repo.one(from(t in subquery(query), select: count("*")))
  #   Enum.slice(results, 0, per_page)

  #   %{
  #     count: count,
  #     has_next: length(results) > per_page,
  #     has_prev: page > 1,
  #     next_page: page + 1,
  #     page: page,
  #     prev_page: page - 1,
  #     first: (page - 1) * per_page + 1,
  #     last: Enum.min([page * per_page, count]),
  #     list: Enum.slice(results, 0, per_page)
  #   }
  # end

  # def list_query2(q, params) do
  #   opts = query_params(params)

  #   page =
  #     cond do
  #       is_nil(opts[:page]) -> 1
  #       true -> opts[:page]
  #     end

  #   size =
  #     cond do
  #       is_nil(opts[:size]) -> 10
  #       true -> opts[:size]
  #     end

  #   opr =
  #     cond do
  #       is_nil(opts[:opr]) -> "=="
  #       true -> opts[:opr]
  #     end

  #   if is_nil(opts[:field]) do
  #     page(q, page, per_page: size)
  #   else
  #     field = opts[:field]
  #     value = opts[:value]

  #     qw =
  #       case opr do
  #         "eq" -> from w in q, where: field(w, ^field) == ^value
  #         "gt" -> from w in q, where: field(w, ^field) > ^value
  #         "ge" -> from w in q, where: field(w, ^field) >= ^value
  #         "lt" -> from w in q, where: field(w, ^field) < ^value
  #         "le" -> from w in q, where: field(w, ^field) <= ^value
  #         "lk" -> from w in q, where: ilike(field(w, ^field), ^"%#{value}%")
  #       end

  #     page2(qw, page, per_page: size)
  #   end
  # end

  # def query_params(params) do
  #   opts = []

  #   pg =
  #     case params do
  #       %{"p" => p} -> String.to_integer(p)
  #       _ -> 1
  #     end

  #   opts = opts ++ [page: pg]

  #   sz =
  #     case params do
  #       %{"s" => s} -> String.to_integer(s)
  #       _ -> 10
  #     end

  #   opts = opts ++ [size: sz]

  #   f =
  #     case params do
  #       %{"f" => f} -> :"#{f}"
  #       _ -> nil
  #     end

  #   opts = opts ++ [field: f]

  #   c =
  #     case params do
  #       %{"c" => c} -> c
  #       _ -> "=="
  #     end

  #   opts = opts ++ [opr: c]

  #   v =
  #     case params do
  #       %{"v" => v} -> v
  #       _ -> nil
  #     end

  #   opts ++ [value: v]
  # end
end
