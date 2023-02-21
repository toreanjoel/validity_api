defmodule Plugs.Auth do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _opts) do
    IO.inspect("AUTORIZING...")
    IO.inspect(conn)
    # here we check if the user has an access token
    if authorized?(conn) do
      conn
    else
      # User is not authenticated, send unauthorized response
      conn
      |> send_resp(401, "Unauthorized")
      |> halt()
    end
  end

  defp authorized?(conn) do
    # check existence of access token
    # check if access token is valie
    # true, let the connection continue
      # if false, go and redirect the user to sign in and refresh the token
      # give the user the token and refresh
    conn_with_token = Map.get(conn.assigns, :access_token)
    IO.inspect(conn_with_token)
    # Your authentication logic here.
    # For example, you could check the presence of a valid JWT token in the request headers.
    true
  end
end
