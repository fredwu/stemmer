defmodule Stemmer.Step4 do
  alias Stemmer.Rules

  def apply(word) do
    word
    |> replace_suffix_in_r2()
  end

  @doc """
  Search for the longest among the following suffixes, and, if found and in R2,
  perform the action indicated.

  ## Examples

      iex> Stemmer.Step4.replace_suffix_in_r2("national")
      "nation"

      iex> Stemmer.Step4.replace_suffix_in_r2("association")
      "associat"

      iex> Stemmer.Step4.replace_suffix_in_r2("apprehension")
      "apprehens"

      iex> Stemmer.Step4.replace_suffix_in_r2("concepcion")
      "concepcion"
  """
  def replace_suffix_in_r2(word) do
    word_r2  = Rules.r2(word)
    r_suffix = ~r/(al|ance|ence|er|ic|able|ible|ant|ement|ment|ent|ism|ate|iti|ous|ive|ize)$/

    cond do
      word_r2 =~ r_suffix ->
        String.replace(word, r_suffix, "")
      word_r2 =~ ~r/(s|t)(ion)$/ ->
        String.replace_suffix(word, "ion", "")
      true ->
        word
    end
  end
end
