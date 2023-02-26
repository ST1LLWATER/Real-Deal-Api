defmodule RealDealApiWeb.AccountController do
  use RealDealApiWeb, :controller

  alias RealDealApiWeb.{Auth.Guardian, Auth.ErrorResponse}
  alias RealDealApi.{Accounts, Accounts.Account, Users.User, Users}

  plug :is_authorized when action in [:update, :delete]

  action_fallback RealDealApiWeb.FallbackController

  defp is_authorized(conn, _opts) do
    try do
      %{params: %{"id" => id}} = conn

      if conn.assigns.account.id != id, do: raise(ErrorResponse.Forbidden)

      case Accounts.get_account(id) do
        %Account{} ->
          conn

        _ ->
          raise(ErrorResponse.NotFound, message: "Account not found")
      end
    catch
      err -> dbg(err)
    end
  end

  def index(conn, _params) do
    accounts = Accounts.list_accounts()
    render(conn, "index.json", accounts: accounts)
  end

  def create(conn, %{"account" => account_params}) do
    with {:ok, %Account{} = account} <- Accounts.create_account(account_params),
         {:ok, token, _claims} <- Guardian.encode_and_sign(account),
         {:ok, %User{} = _user} <- Users.create_user(account, account_params) do
      conn
      |> put_status(:created)
      |> render("account_token.json", %{account: account, token: token})
    end
  end

  def show(conn, %{"id" => _id}) do
    # account = Accounts.get_account!(id)
    account = conn.assigns.account
    render(conn, "show.json", account: account)
  end

  # def update(%{"query_params" => %{"id" => id}, "body_params" => body_params} = conn, _params) do
  def update(conn, %{"id" => id} = params) do
    account = Accounts.get_account!(id)

    with {:ok, %Account{}} <- Accounts.update_account(account, params) do
      json(conn, %{success: true, message: "Account updated successfully"})
    end
  end

  def delete(conn, %{"id" => id}) do
    account = Accounts.get_account!(id)

    with {:ok, %Account{}} <- Accounts.delete_account(account) do
      send_resp(conn, :no_content, "")
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case Guardian.authenticate(email, password) do
      {:error, :unauthorized} ->
        raise ErrorResponse.Unauthorized, message: "Invalid email or password"

      {:ok, account, token} ->
        conn
        |> Plug.Conn.put_session(:account_id, account.id)
        |> put_status(:ok)
        |> render("account_token.json", %{account: account, token: token})
    end
  end
end
