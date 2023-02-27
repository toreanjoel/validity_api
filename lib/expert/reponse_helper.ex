defmodule ValidityServer.Expert.ReponseHelper do
  @moduledoc """
    The helper functions that will be used to cleanup and return relevant responses and data
  """

  @doc """
    The success response that will be the structured payload
  """
  def success(msg, data \\ %{}) do
    %{
      "success" => true,
      "message" => msg,
      "data" => data
    }
  end

  @doc """
    The error response that will be the structured payload
  """
  def error(msg, data \\ %{}) do
    %{
      "success" => false,
      "message" => msg,
      "data" => data
    }
  end
end
