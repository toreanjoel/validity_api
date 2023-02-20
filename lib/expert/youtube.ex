defmodule ValidityServer.Expert.Youtube do
  require Logger

  # env variable imports
  @api_key System.get_env("YOUTUBE_API_V3")
  # youtube params
  @part "id,snippet"
  @url "https://www.googleapis.com/youtube/v3/captions"

  @timeout 20000

  @doc """
    Get the captions tracks given a youtube id
  """
  def caption_tracks(id) do
    {status, resp} = HTTPoison.get(@url <> "?part=#{@part}&video_id=#{id}&key=#{@api_key}")
    case status do
      :ok -> handle_resp(resp)
    end
  end

  @doc """
    Takes a response and check the statuses to return the relevant decoded response body
  """
  def handle_resp(resp) do
    status = Map.get(resp, :status_code)
    body = Map.get(resp, :body)
    case status do
      200 ->
        resp_body = Jason.decode!(body)
        result = get_captions(resp_body["items"])
        IO.inspect(result)
        {:ok, result}
      _ ->
        Logger.error("There was an error")
        {:error, Jason.decode!(body)}
    end
  end

  # loop over tracks to get track data and create caption list
  defp get_captions(tracks) do
    for item <- tracks do
      %{id: item["id"], language: item["snippet"]["language"], video_id: item["snippet"]["videoId"]}
      download_caption(item["id"], @api_key)
    end
  end

  def download_caption(caption_id, access_token) do
    IO.inspect(caption_id)
    IO.inspect(access_token)
    {status, resp} = HTTPoison.get(
      "https://www.googleapis.com/youtube/v3/captions/#{caption_id}",
      headers: Enum.map([{"Authorization", "Bearer #{access_token}"}], &IO.iodata_to_binary/1)
    )
    case status do
      :ok -> {:ok, resp.body}
      _ -> {:error, "Unable to download caption file"}
    end
  end
end
