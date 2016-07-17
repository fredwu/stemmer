defmodule Stemmer.Step0 do
  def apply(word) do
    word
    |> remove_initial_apostrophe()
    |> mark_consonant_y()
  end

  @doc """
  ## Examples

      iex> Stemmer.Step0.remove_initial_apostrophe("'ok")
      "ok"

      iex> Stemmer.Step0.remove_initial_apostrophe("o'k")
      "o'k"
  """
  def remove_initial_apostrophe(word) do
    String.replace_prefix(word, "'", "")
  end

  @doc """
  Some of the algorithms begin with a step which puts letters which are normally
  classed as vowels into upper case to indicate that they are are to be treated
  as consonants (the assumption being that the words are presented to the stemmers
  in lower case). Upper case therefore acts as a flag indicating a consonant.

  Set initial `y`, or `y` after a vowel, to `Y`.

  ## Examples

      iex> Stemmer.Step0.mark_consonant_y("youth")
      "Youth"

      iex> Stemmer.Step0.mark_consonant_y("boy")
      "boY"

      iex> Stemmer.Step0.mark_consonant_y("boyish")
      "boYish"

      iex> Stemmer.Step0.mark_consonant_y("fly")
      "fly"

      iex> Stemmer.Step0.mark_consonant_y("flying")
      "flying"

      iex> Stemmer.Step0.mark_consonant_y("syzygy")
      "syzygy"
  """
  def mark_consonant_y(word) do
    String.replace(word, ~r/^y|(#{Stemmer.Rules.vowel()})y/, "\\1Y")
  end
end
