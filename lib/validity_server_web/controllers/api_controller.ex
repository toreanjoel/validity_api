defmodule ValidityServerWeb.ApiController do
  use ValidityServerWeb, :controller
  import Plug.Conn

  @doc """
    The entry point of the application, just returns a hello for now

    NOTE:
    Oauth needs to be setup, maybe as a plug before accessing this conroller, bearer token requests only
    This means users need to have accounts to use the application.
    This allows to limit requests - making it manual for free users and auto for paid
  """
  def index(conn, _params) do
    return(conn, 200, %{"message" => "Hello world"})
  end

  @doc """
    The request to check taking the data sent from the post to do the check
  """
  def validate(conn, body) do
    IO.inspect(body)
    # pull out the data from the body of the request

    # Get the Youtube captions
    {_status, resp} = fetch_captions("ID")

    # Summarize the captions
    {_status, resp} = fetch_captions(resp)

    # Prompt with the captions to validate credibility
    {_status, resp} = check_validity(resp)

    # assuming there was no errors, else we return relevant ones
    return(conn, 200, resp)
  end

  # The response helper to return with conn
  defp return(conn, status, data) do
    conn
      |> put_resp_content_type("application/json")
      |> send_resp(status, Jason.encode!(data))
  end

  # request against Youtube API to get captions off of a video
  defp fetch_captions(video_id) do
    {:ok, "captions"}
  end

  # take in data and summarize it
  defp summarize_text(data) do
    {:ok, "summary"}
  end

  # pass the string to prompt against OpenAI to verify validity
  defp check_validity(string) do
    {:ok, "validity_score"}
  end
end
