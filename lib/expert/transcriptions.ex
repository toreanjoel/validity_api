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
    # respnse payload
    return_response(resp)
  end

  @doc """
    Response returned based on error
  """
  def return_response({resp, _code}) when resp === "", do: {:error, "There was an error getting the captions/transcriptions of the given video"}
  def return_response({resp, _code}) do
    {:ok, resp}
  end
end
