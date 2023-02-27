defmodule ValidityServer.Expert.Gpt do
  @moduledoc """
    The helper module and tools to interact with OPEN API
  """
  require Logger
  alias ValidityServer.Expert.ReponseHelper, as: Response

  # API key
  @api_key System.get_env("OPEN_API")
  # prompt
  @prompt_validity "Rate the validity of a statement out of 10 (where 10 is true) and give a limited 25 word response. Use \" || \" to split the rating and response. Add a link to a wiki link if applicable."
  @url "https://api.openai.com/v1/completions"
  # body
  @body %{
    "max_tokens" => 128,
    "temperature" => 0.4,
    "model" => "text-davinci-003"
  }
  # header
  @headers [
    {"Content-type", "application/json"},
    {"Authorization", "Bearer " <> to_string(@api_key)}
  ]

  @timeout 20000

  @doc """
    The prompt sent to get the message
    NOTE: This module will have set the params to a manageable temp and potentially limit input
    See body
  """
  def prompt_validity(msg) do
    prompt = """
    #{@prompt_validity}
    #{msg}
    """
    body_payload = Map.put(@body, "prompt", prompt)
    {status, resp} = HTTPoison.post(@url, Jason.encode!(body_payload), @headers, recv_timeout: @timeout)
    case status do
      :error ->
        Logger.error("Error HTTP, status error", file: "gpt.ex", stacktrace: "fn -> prompt_validity | HTTPoison")
        {
          :error,
          Response.error("There was an error: #{resp}")
        }
      :ok -> handle_validity_resp(resp)
    end
  end

  # Handle the success reponse and its codes that came back from the HTTP post
  defp handle_validity_resp(resp) do
    IO.inspect(resp)
    case resp.status_code do
      400 ->
        {
          :error,
          Response.error("There was an error: #{Jason.decode!(resp.body)}")
        }
      200 ->
        resp = Jason.decode!(resp.body)
        {_status, data} = return_choice_by_index(resp, 0)
        {:ok, data}
      _ ->
        Logger.error("Error prompt", file: "gpt.ex", stacktrace: "fn -> handle_validity_resp | innput resp from fn -> prompt_validity")
    end
  end

  # Take in a list of choiced from a response and return the index
  defp return_choice_by_index(choices, index) do
    {_tag, data} = Enum.at(choices, index)
    resp = Enum.at(data, 0)
    {_status, data} = generate_resp(resp["text"])
    {:ok, data}
  end

  # Create a proper response splitting the string and the score
  defp generate_resp(string) do
    split = String.trim(string)
    |> String.split("||")

    {
      :ok,
      %{
        "score" => String.trim(Enum.at(split, 0) <> "/ 10"),
        "desc" => String.trim(Enum.at(split, 1)),
      }
    }
  end
end
