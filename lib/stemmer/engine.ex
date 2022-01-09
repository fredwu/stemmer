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

      iex> Stemmer.Engine.start("only")
      "onli"

      iex> Stemmer.Engine.start("communicate")
      "communic"
  """
  def start(word) do
    word = String.downcase(word)

    if String.length(word) <= 2 do
      word
    else
      word
      |> Stemmer.SpecialWord.apply()
      |> post_special_word()
    end
  end

  defp post_special_word({true, word}), do: word

  defp post_special_word({false, word}) do
    word
    |> Rules.invariant?()
    |> post_invariant()
  end

  defp post_invariant({true, word}), do: word

  defp post_invariant({false, word}) do
    word
    |> Stemmer.Step0.apply()
    |> Stemmer.Step1a.apply()
    |> Rules.invariant_after_1a?()
    |> post_invariant_after_1a()
  end

  defp post_invariant_after_1a({true, word}), do: word

  defp post_invariant_after_1a({false, word}) do
    word
    |> Stemmer.Step1b.apply()
    |> Stemmer.Step1c.apply()
    |> Stemmer.Step2.apply()
    |> Stemmer.Step3.apply()
    |> Stemmer.Step4.apply()
    |> Stemmer.Step5.apply()
  end
end
