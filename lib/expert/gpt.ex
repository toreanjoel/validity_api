defmodule ValidityServer.Expert.Gpt do
  @moduledoc """
    The helper module and tools to interact with OPEN API
  """
  require Logger

  # API key
  @api_key System.get_env("OPEN_API")
  # prompt
  @prompt_validity "Rate the validity of a statement out of 10 (where 10 is true) and give a 30-word reason. Use \" || \" to split the rating and response - be strict about it. Add a wiki short link if needed."
  @url "https://api.openai.com/v1/completions"
  # body
  @body %{
    "max_tokens" => 256,
    "temperature" => 0.7,
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
        {:error, "There was an error: #{resp}"}
      :ok -> handle_validity_resp(resp)
    end
  end

  # Handle the success reponse and its codes that came back from the HTTP post
  defp handle_validity_resp(resp) do
    case resp.status_code do
      400 -> {:error, "There was an error: #{Jason.decode!(resp.body)}"}
      200 ->
        resp = Jason.decode!(resp.body)
        {:ok, return_choice_by_index(resp, 0)}
      _ ->
        Logger.error(
          "There was an unknown response code",
          %{"code" => resp.status_code, "body" => resp.body}
        )
    end
  end

  # Take in a list of choiced from a response and return the index
  defp return_choice_by_index(choices, index) do
    {_tag, data} = Enum.at(choices, index)
    resp = Enum.at(data, 0)
    generate_resp(resp["text"])
  end

  # Create a proper response splitting the string and the score
  defp generate_resp(string) do
    split = String.trim(string)
    |> String.split("||")

    %{
      "score" => String.trim(Enum.at(split, 0) <> "/ 10"),
      "desc" => String.trim(Enum.at(split, 1)),
    }
  end
end
