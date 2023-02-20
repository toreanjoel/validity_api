defmodule ValidityServerWeb.PageController do
  use ValidityServerWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
