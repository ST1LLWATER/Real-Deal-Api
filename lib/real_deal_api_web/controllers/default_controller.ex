defmodule RealDealApiWeb.DefaultController do
  use RealDealApiWeb, :controller

  def index(conn, _params) do
    text(conn, "The API Is Live -#{Mix.env()}")
  end
end
