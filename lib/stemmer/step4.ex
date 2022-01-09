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

      iex> Stemmer.Step4.remove_suffix_in_r2("addition")
      "addit"

      iex> Stemmer.Step4.remove_suffix_in_r2("agreement")
      "agreement"
  """
  def remove_suffix_in_r2(word) do
    {_, word} =
      with {:next, _word} <- remove_suffix(word),
           {:next, _word} <- remove_suffix_ion(word) do
        {:found, word}
      end

    word
  end

  defp remove_suffix(word) do
    ~r/(al|ance|ence|er|ic|able|ible|ant|ement|ment|ent|ism|ate|iti|ous|ive|ize)$/
    |> Regex.run(word)
    |> match_suffix(word)
  end

  defp match_suffix(nil, word), do: {:next, word}
  defp match_suffix(match, word), do: remove_suffix_in_r2(word, List.first(match))

  defp remove_suffix_in_r2(word, suffix) do
    if String.ends_with?(Rules.r2(word), suffix) do
      {:found, String.replace_suffix(word, suffix, "")}
    else
      {:found, word}
    end
  end

  defp remove_suffix_ion(word) do
    if String.ends_with?(Rules.r2(word), "ion") && String.ends_with?(word, ["sion", "tion"]) do
      {:found, String.replace_suffix(word, "ion", "")}
    else
      {:next, word}
    end
  end
end
