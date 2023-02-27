defmodule ValidityServer.Expert.Transcriptions do
  @moduledoc """
    Youtube module used to get the transcripts of the passed video

    Note: Uses Python to execute the commands
  """

  require Logger
  alias ValidityServer.Expert.ReponseHelper, as: Response

  @python3 "python3"
  @transcriptions_py "transcriptions.py"

  @doc """
    Get the transcriptions of a youtube video.
    This returns list of captions and timestamps
  """
  def get_transcription(id) do
    Logger.warn("Dependency: Python || pip || YouTubeTranscriptApi")
    resp = System.cmd(@python3, [ File.cwd! <> "/lib/expert/python/scripts/#{@transcriptions_py}", id])
    return_response(resp, id)
  end

  @doc """
    Response returned based on error
  """
  def return_response({resp, _code}, id) when resp === "" do
    Logger.error("Error getting captions/transcriptions, video_id: #{id}", file: "transcriptions.ex", stacktrace: "fn -> get_transcription")
    {
      :error,
      Response.error("There was an error getting the captions/transcriptions of the given video")
    }
  end

  def return_response({resp, _code}, _id) do
    {
      :ok,
      Response.error("Successfully fetched captions/transcriptions", resp)
    }
  end
end
