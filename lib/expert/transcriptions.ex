defmodule ValidityServer.Expert.Transcriptions do
  @moduledoc """
    Youtube module used to get the transcripts of the passed video

    Note: Uses Python to execute the commands
  """

  require Logger

  @python3 "python3"
  @transcriptions_py "transcriptions.py"

  @doc """
    Get the transcriptions of a youtube video.
    This returns list of captions and timestamps
  """
  def get_transcription(id) do
    # we try install the dependency
    Logger.warn("Make sure to install YouTubeTranscriptApi if needed through pip")
    resp = System.cmd(@python3, [ File.cwd! <> "/lib/expert/python/scripts/#{@transcriptions_py}", id])

    # respnse
    return_response(resp)
  end

  @doc """
    Read data and return only the text of the data
  """
  def get_transcription_text(_data) do
    {:ok, "ok"}
  end

  @doc """
    Response returned based on error
  """
  def return_response({resp, code}) do
    case code do
      # success response, other codes we dont care about
      0 ->
        json_string = String.replace(resp, "'", "\"")
        # Use Poison to decode the JSON string
        decoded_resp = Poison.decode!(json_string)
        {:ok, decoded_resp}
      _ -> {:error, "There was an error getting the captions/transcriptions of the given video"}
    end
  end
end
