defmodule RealDealApiWeb.ProtectedController do
  use RealDealApiWeb, :controller

  def index(conn, _params) do
    conn
    |> json(%{message: "Protected Route Lessgo"})
  end
end
