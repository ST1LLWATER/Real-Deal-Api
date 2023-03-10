defmodule RealDealApiWeb.Auth.SetAccount do
  import Plug.Conn
  alias RealDealApiWeb.Auth.ErrorResponse
  alias RealDealApi.{Accounts, Accounts.Account}

  def init(_options) do
  end

  def call(%{assigns: assigns} = conn, _options) when is_map_key(assigns, :account) do
    conn
  end

  def call(conn, _options) do
    account_id = get_session(conn, :account_id)

    if account_id == nil, do: raise(ErrorResponse.Unauthorized)

    case Accounts.get_account(account_id) do
      %Account{} = account -> assign(conn, :account, account)
      nil -> raise(ErrorResponse.Unauthorized)
    end
  end
end
