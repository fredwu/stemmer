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
    {_, word} =
      with {:not_found, _word} <- Rules.replace_suffix_in_r1(word, "ational", "ate"),
           {:not_found, _word} <- Rules.replace_suffix_in_r1(word, "tional", "tion"),
           {:not_found, _word} <- Rules.replace_suffix_in_r1(word, "alize", "al"),
           {:not_found, _word} <- Rules.replace_suffix_in_r1(word, "icate", "ic"),
           {:not_found, _word} <- Rules.replace_suffix_in_r1(word, "iciti", "ic"),
           {:not_found, _word} <- Rules.replace_suffix_in_r1(word, "ical", "ic"),
           {:not_found, _word} <- Rules.replace_suffix_in_r1(word, "ness", ""),
           {:not_found, _word} <- Rules.replace_suffix_in_r1(word, "ful", ""),
           {:not_found, _word} <- replace_suffix_ative_in_r2(word)
        do {:not_found, word}
      end

    word
  end

  defp replace_suffix_ative_in_r2(word) do
    if Rules.r2(word) =~ ~r/ative$/ do
      {:found, String.replace_suffix(word, "ative", "")}
    else
      {:not_found, word}
    end
  end
end
