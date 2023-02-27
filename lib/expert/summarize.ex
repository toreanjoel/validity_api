defmodule ValidityServer.Expert.Summarize do
  @moduledoc """
    Youtube module used to get the transcripts of the passed video

    Note: Uses Python to execute the commands
  """

  require Logger
  alias ValidityServer.Expert.ReponseHelper, as: Response

  @python3 "python3"
  @summarize_py "summarize.py"

  @doc """
    Get the transcriptions of a youtube video.
    This returns list of captions and timestamps
  """
  def summarize(text) do
    Logger.warn("Dependency: Python || pip || Gensim - 3.8.3")
    resp = System.cmd(@python3, [ File.cwd! <> "/lib/expert/python/scripts/#{@summarize_py}", text])
    # respnse payload
    return_response(resp)
  end

  @doc """
    Response returned based on error
  """
  def return_response({resp, _code}) when resp === "" do
    Logger.error("Error summarizing text", file: "summarize.ex", stacktrace: "fn -> summarize")
    {
      :error,
      Response.error("There was an error createing summary")
    }
  end

  def return_response({resp, _code}) do
    {
      :ok,
      Response.success("Successfully summarized text", resp)
    }
  end
end
