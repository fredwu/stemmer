defmodule Stemmer.Step0 do
  alias Stemmer.Rules

  def apply(word) do
    word
    |> trim_apostrophes()
    |> remove_apostrophe_s()
    |> mark_consonant_y()
  end

  @doc """
  ## Examples

      iex> Stemmer.Step0.trim_apostrophes("'ok")
      "ok"

      iex> Stemmer.Step0.trim_apostrophes("o'k")
      "o'k"

      iex> Stemmer.Step0.trim_apostrophes("'o'k'")
      "o'k"
  """
  def trim_apostrophes(word) do
    word
    |> String.replace_prefix("'", "")
    |> String.replace_suffix("'", "")
  end

  @doc """
  ## Examples

      iex> Stemmer.Step0.remove_apostrophe_s("ok's")
      "ok"
  """
  def remove_apostrophe_s(word) do
    String.replace_suffix(word, "'s", "")
  end

  @doc """
  Some of the algorithms begin with a step which puts letters which are normally
  classed as vowels into upper case to indicate that they are are to be treated
  as consonants (the assumption being that the words are presented to the stemmers
  in lower case). Upper case therefore acts as a flag indicating a consonant.

  Set initial `y`, or `y` after a vowel, to `Y`.

  ## Examples

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
    if word =~ "y" do
      String.replace(word, ~r/^y|(#{Rules.vowel()})y/, "\\1Y")
    else
      word
    end
  end
end
