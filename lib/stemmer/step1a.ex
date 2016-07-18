defmodule Stemmer.Step1a do
  alias Stemmer.Rules

  def apply(word) do
    word
    |> replace_sses()
    |> replace_ied_ies()
    |> remove_s()
  end

  @doc """
  Replace by `ss`.

  ## Examples

      iex> Stemmer.Step1a.replace_sses("actresses")
      "actress"
  """
  def replace_sses(word) do
    String.replace_suffix(word, "sses", "ss")
  end

  @doc """
  Replace by `i` if preceded by more than one letter, otherwise by `ie` (so
  `ties` → `tie`, `cries` → `cri`).

  ## Examples

      iex> Stemmer.Step1a.replace_ied_ies("tied")
      "tie"

      iex> Stemmer.Step1a.replace_ied_ies("ties")
      "tie"

      iex> Stemmer.Step1a.replace_ied_ies("cries")
      "cri"
  """
  def replace_ied_ies(word) do
    if String.length(word) > 4 do
      word
      |> String.replace_suffix("ied", "i")
      |> String.replace_suffix("ies", "i")
    else
      word
      |> String.replace_suffix("ied", "ie")
      |> String.replace_suffix("ies", "ie")
    end
  end

  @doc """
  Delete if the preceding word part contains a vowel not immediately before
  the `s` (so gas and this retain the s, gaps and kiwis lose it).

  ## Examples

      iex> Stemmer.Step1a.remove_s("gas")
      "gas"

      iex> Stemmer.Step1a.remove_s("this")
      "this"

      iex> Stemmer.Step1a.remove_s("gaps")
      "gap"

      iex> Stemmer.Step1a.remove_s("kiwis")
      "kiwi"
  """
  def remove_s(word) do
    if word =~ ~r/#{Rules.vowel()}.+s$/ do
      String.replace_suffix(word, "s", "")
    else
      word
    end
  end
end
