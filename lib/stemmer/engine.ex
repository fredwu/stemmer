defmodule Stemmer.Engine do
  alias Stemmer.Rules

  @doc """
  ## Examples

      iex> Stemmer.Engine.start("I")
      "i"

      iex> Stemmer.Engine.start("as")
      "as"

      iex> Stemmer.Engine.start("skies")
      "sky"

      iex> Stemmer.Engine.start("sky")
      "sky"

      iex> Stemmer.Engine.start("news")
      "news"

      iex> Stemmer.Engine.start("inning")
      "inning"
  """
  def start(word) do
    word = String.downcase(word)

    cond do
      String.length(word) <= 2 ->
        word
      true ->
        word = word
               |> Stemmer.SpecialWord.apply()

        if Rules.invariant?(word) do
          word
        else
          word = word
                 |> Stemmer.Step0.apply()
                 |> Stemmer.Step1a.apply()

          if Rules.invariant_after_1a?(word) do
            word
          else
            word
            |> Stemmer.Step1b.apply()
            |> Stemmer.Step1c.apply()
            |> Stemmer.Step2.apply()
            |> Stemmer.Step3.apply()
            |> Stemmer.Step4.apply()
            |> Stemmer.Step5.apply()
          end
        end
    end
  end
end
