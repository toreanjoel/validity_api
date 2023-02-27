defmodule ValidityServerWeb.ApiController do
  use ValidityServerWeb, :controller
  require Logger
  import Plug.Conn

  alias ValidityServer.Expert.Transcriptions, as: Transcriptions
  alias ValidityServer.Expert.Gpt, as: Gpt
  alias ValidityServer.Expert.Summarize, as: Summarize

  @moduledoc """
    TODO:
     - limit by category? Tags? - Educational ect
     - error handling
     - move extention in the same project and update git
     - research ui for extention (fiverr)
     - add compare based off title?
     - Design extention landing page
     - planning auth and paid tier
  """

  @doc """
    The entry point of the application, just returns a hello for now

    NOTE:
    Oauth needs to be setup, maybe as a plug before accessing this conroller, bearer token requests only
    This means users need to have accounts to use the application.
    This allows to limit requests - making it manual for free users and auto for paid
  """
  def index(conn, _params) do
    return(conn, 200,
    %{"message" => "Welcome - Validity returns the credibility of statements, returns a score and link for ref if possible"})
  end

  @doc """
    The request to check taking the data sent from the post to do the check
  """
  def validate(conn, %{"id" => video_id}) do
    # Get the Youtube captions
    {status, resp} = fetch_captions(video_id)
    # Summarize the captions
    case status do
      :ok ->
        {_status, resp} = check_validity(resp["data"])
        return(conn, 200, resp)
      _ -> return(conn, 404, resp)
    end
  end

  # The response helper to return with conn
  defp return(conn, status, data) do
    conn
      |> put_resp_content_type("application/json")
      |> send_resp(status, Jason.encode!(data))
  end

  # request against Youtube API to get captions off of a video
  defp fetch_captions(video_id) do
    Transcriptions.get_transcription(video_id)
  end

  # take in data and summarize it
  defp summarize_text(data) do
    {_status, resp} = Summarize.summarize(data)
    clean_str = String.replace(resp["data"], "\n", "")
    {:ok, clean_str}
  end

  # pass the string to prompt against OpenAI to verify validity
  defp check_validity(data) do
    {_status, text} = summarize_text(data)
    {status, resp} = Gpt.prompt_validity(text)
    case status do
      :ok -> {:ok, resp}
      _ -> {:error, resp}
    end
  end
end
