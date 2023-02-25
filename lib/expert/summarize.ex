defmodule ValidityServer.Expert.Summarize do
  @moduledoc """
    Youtube module used to get the transcripts of the passed video

    Note: Uses Python to execute the commands
  """

  require Logger

  @python3 "python3"
  @summarize_py "summarize.py"

  @doc """
    Get the transcriptions of a youtube video.
    This returns list of captions and timestamps
  """
  def summarize(text) do
    # we try install the dependency
    Logger.warn("Make sure to install Gensim 3.8.3 if needed through pip")
    resp = System.cmd(@python3, [ File.cwd! <> "/lib/expert/python/scripts/#{@summarize_py}", text])
    # respnse payload
    return_response(resp)
  end

  @doc """
    Response returned based on error
  """
  def return_response({resp, _code}) when resp === "", do: {:error, "There was an error summarizing of the given string"}
  def return_response({resp, _code}) do
    {:ok, resp}
  end
end
