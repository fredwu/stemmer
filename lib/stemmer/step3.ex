defmodule Stemmer.Step3 do
  alias Stemmer.Rules

  def apply(word) do
    word
    |> replace_suffix_in_r1()
  end

  @doc """
  Search for the longest among the following suffixes, and, if found and in R1,
  perform the action indicated.

  ## Examples

      iex> Stemmer.Step3.replace_suffix_in_r1("proportional")
      "proportion"

      iex> Stemmer.Step3.replace_suffix_in_r1("duplicate")
      "duplic"

      iex> Stemmer.Step3.replace_suffix_in_r1("dupliciti")
      "duplic"

      iex> Stemmer.Step3.replace_suffix_in_r1("duplical")
      "duplic"

      iex> Stemmer.Step3.replace_suffix_in_r1("colourful")
      "colour"

      iex> Stemmer.Step3.replace_suffix_in_r1("eagerness")
      "eager"

      iex> Stemmer.Step3.replace_suffix_in_r1("negative")
      "negative"

      iex> Stemmer.Step3.replace_suffix_in_r1("imaginative")
      "imagin"
  """
  def replace_suffix_in_r1(word) do
    word_r1 = Rules.r1(word)

    cond do
      word_r1 =~ ~r/tional$/ ->
        String.replace_suffix(word, "tional", "tion")
      word_r1 =~ ~r/ational$/ ->
        String.replace_suffix(word, "ational", "ate")
      word_r1 =~ ~r/alize$/ ->
        String.replace_suffix(word, "alize", "al")
      word_r1 =~ ~r/(icate|iciti|ical)$/ ->
        word
        |> String.replace_suffix("icate", "ic")
        |> String.replace_suffix("iciti", "ic")
        |> String.replace_suffix("ical", "ic")
      word_r1 =~ ~r/(ful|ness)$/ ->
        word
        |> String.replace_suffix("ful", "")
        |> String.replace_suffix("ness", "")
      Rules.r2(word) =~ ~r/ative$/ ->
        String.replace_suffix(word, "ative", "")
      true ->
        word
    end
  end
end
