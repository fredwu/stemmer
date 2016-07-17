defmodule Stemmer.Engine do
  @doc """
  ## Examples

      iex> Stemmer.Engine.start("I")
      "i"

      iex> Stemmer.Engine.start("as")
      "as"
  """
  def start(word) do
    if String.length(word) <= 2 do
      word
      |> String.downcase
    else
      word
      |> String.downcase
      |> Stemmer.Step0.apply()
      |> Stemmer.Step1.apply()
      |> Stemmer.Step2.apply()
      |> Stemmer.Step3.apply()
      |> Stemmer.Step4.apply()
      |> Stemmer.Step5.apply()
    end
  end
end
