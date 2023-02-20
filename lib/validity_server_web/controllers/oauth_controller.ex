defmodule ValidityServerWeb.OAuthController do
  use ValidityServerWeb, :controller

  @port System.get_env("PORT")
  @site "https://accounts.google.com"
  @url_auth "https://accounts.google.com/o/oauth2/auth"
  @url_token "https://accounts.google.com/o/oauth2/token"
  @redirect_url "http://localhost:4000/oauth/callback"
  @client_id System.get_env("CLIENT_ID")
  @client_secret System.get_env("CLIENT_SECRET")
  @scope "https://www.googleapis.com/auth/youtube.force-ssl"
  @resp_type "code"

  def authorize(conn, _params) do
    client = OAuth2.Client.new([
      client_id: @client_id,
      client_secret: @client_secret,
      site: @site,
      authorize_url: @url_auth,
      token_url: @url_token,
      redirect_uri: @redirect_url
      # response_type: @resp_type
    ])
    {_client, url} = OAuth2.Client.authorize_url(client)
    redirect(conn, external: url <> "&scope=#{URI.encode_www_form(@scope)}")
  end

  def callback(conn, %{"code" => code}) do
    client = OAuth2.Client.new(
      client_id: @client_id,
      client_secret: @client_secret,
      site: @site,
      authorize_url: @url_auth,
      token_url: @url_token,
      redirect_uri: @redirect_url
    )

    %OAuth2.Client{token: %OAuth2.AccessToken{access_token: token}} = OAuth2.Client.get_token!(client, code: code)
    token_data = Jason.decode!(token)
    # Store the access token in the session
    conn = put_session(conn, :access_token, token_data["access_token"])
    conn = %{conn | assigns: %{}} # ensure assigns is present in conn
    conn_with_token = Map.put(conn.assigns, :access_token, token_data["access_token"])
    conn = %{conn | assigns: conn_with_token}
    IO.inspect(conn)
    redirect(conn, to: "/api/")
  end
end
