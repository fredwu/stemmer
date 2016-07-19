defmodule Stemmer.Step4 do
  alias Stemmer.Rules

  def apply(word) do
    word
    |> remove_suffix_in_r2()
  end

  @doc """
  Search for the longest among the following suffixes, and, if found and in R2,
  perform the action indicated.

  ## Examples

      iex> Stemmer.Step4.remove_suffix_in_r2("national")
      "nation"

      iex> Stemmer.Step4.remove_suffix_in_r2("association")
      "associat"

      iex> Stemmer.Step4.remove_suffix_in_r2("apprehension")
      "apprehens"

      iex> Stemmer.Step4.remove_suffix_in_r2("concepcion")
      "concepcion"
  """
  def remove_suffix_in_r2(word) do
    {_, word} =
      with {:not_found, _word} <- remove_suffix(word),
           {:not_found, _word} <- remove_suffix_ion(word)
        do {:not_found, word}
      end

    word
  end

  defp remove_suffix(word) do
    r_suffix = ~r/(al|ance|ence|er|ic|able|ible|ant|ement|ment|ent|ism|ate|iti|ous|ive|ize)$/

    if Rules.r2(word) =~ r_suffix do
      {:found, String.replace(word, r_suffix, "")}
    else
      {:not_found, word}
    end
  end

  defp remove_suffix_ion(word) do
    if Rules.r2(word) =~ ~r/(s|t)ion$/ do
      {:found, String.replace_suffix(word, "ion", "")}
    else
      {:not_found, word}
    end
  end
end
