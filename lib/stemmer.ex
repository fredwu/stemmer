defmodule Stemmer do
  @doc """
  ## Examples

      iex> Stemmer.stem("Hello")
      "hello"

      iex> Stemmer.stem("hElLo")
      "hello"

      iex> Stemmer.stem("capabilities")
      "capabilities"

      iex> Stemmer.stem("extraordinary capabilities")
      ["extraordinary", "capabilities"]

      iex> Stemmer.stem(["capabilities"])
      ["capabilities"]

      iex> Stemmer.stem(["extraordinary", "capabilities"])
      ["extraordinary", "capabilities"]
  """
  def stem(input) do
    cond do
      is_list(input) -> input |> Stream.map(&(stem(&1))) |> Enum.to_list
      input =~ " "   -> input |> String.split() |> stem()
      true           -> Stemmer.Engine.start(input)
    end
  end
end
