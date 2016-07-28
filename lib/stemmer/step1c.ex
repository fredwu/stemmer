defmodule Stemmer.Step1c do
  alias Stemmer.Rules

  def apply(word) do
    word
    |> replace_suffix_y()
  end

  @doc """
  Replace suffix `y` or `Y` by `i` if preceded by a non-vowel which is not the
  first letter of the word (so `cry` → `cri`, `by` → `by`, `say` → `say`).

  ## Examples

      iex> Stemmer.Step1c.replace_suffix_y("cry")
      "cri"

      iex> Stemmer.Step1c.replace_suffix_y("by")
      "by"

      iex> Stemmer.Step1c.replace_suffix_y("say")
      "say"
  """
  def replace_suffix_y(word) do
    cond do
      word =~ ~r/.+#{Rules.consonant()}y$/ -> String.replace_suffix(word, "y", "i")
      word =~ ~r/.+#{Rules.consonant()}Y$/ -> String.replace_suffix(word, "Y", "i")
      true -> word
    end
  end
end
