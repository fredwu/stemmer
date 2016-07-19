defmodule Stemmer.Step2 do
  alias Stemmer.Rules

  def apply(word) do
    word
    |> replace_suffix_in_r1()
  end

  @doc """
  Search for the longest among the following suffixes, and, if found and in R1,
  perform the action indicated.

  ## Examples

      iex> Stemmer.Step2.replace_suffix_in_r1("sensational")
      "sensate"

      iex> Stemmer.Step2.replace_suffix_in_r1("sentenci")
      "sentence"

      iex> Stemmer.Step2.replace_suffix_in_r1("entranci")
      "entrance"

      iex> Stemmer.Step2.replace_suffix_in_r1("pocketabli")
      "pocketable"

      iex> Stemmer.Step2.replace_suffix_in_r1("momentli")
      "moment"

      iex> Stemmer.Step2.replace_suffix_in_r1("nationalizer")
      "nationalize"

      iex> Stemmer.Step2.replace_suffix_in_r1("nationalization")
      "nationalize"

      iex> Stemmer.Step2.replace_suffix_in_r1("acceleration")
      "accelerate"

      iex> Stemmer.Step2.replace_suffix_in_r1("accelerator")
      "accelerate"

      iex> Stemmer.Step2.replace_suffix_in_r1("nationalism")
      "national"

      iex> Stemmer.Step2.replace_suffix_in_r1("nationaliti")
      "national"

      iex> Stemmer.Step2.replace_suffix_in_r1("nationalli")
      "national"

      iex> Stemmer.Step2.replace_suffix_in_r1("usefulness")
      "useful"

      iex> Stemmer.Step2.replace_suffix_in_r1("generousli")
      "generous"

      iex> Stemmer.Step2.replace_suffix_in_r1("generousness")
      "generous"

      iex> Stemmer.Step2.replace_suffix_in_r1("activeness")
      "active"

      iex> Stemmer.Step2.replace_suffix_in_r1("activiti")
      "active"

      iex> Stemmer.Step2.replace_suffix_in_r1("capabiliti")
      "capable"

      iex> Stemmer.Step2.replace_suffix_in_r1("capabli")
      "capable"

      iex> Stemmer.Step2.replace_suffix_in_r1("analogi")
      "analog"

      iex> Stemmer.Step2.replace_suffix_in_r1("bulldogi")
      "bulldogi"

      iex> Stemmer.Step2.replace_suffix_in_r1("masterfulli")
      "masterful"

      iex> Stemmer.Step2.replace_suffix_in_r1("tirelessli")
      "tireless"

      iex> Stemmer.Step2.replace_suffix_in_r1("argumentli")
      "argument"

      iex> Stemmer.Step2.replace_suffix_in_r1("mopli")
      "mopli"
  """
  def replace_suffix_in_r1(word) do
    {_, word} =
      with {:not_found, _word} <- replace_suffix_by(word, "ization", "ize"),
           {:not_found, _word} <- replace_suffix_by(word, "ational", "ate"),
           {:not_found, _word} <- replace_suffix_by(word, "fulness", "ful"),
           {:not_found, _word} <- replace_suffix_by(word, "ousness", "ous"),
           {:not_found, _word} <- replace_suffix_by(word, "iveness", "ive"),
           {:not_found, _word} <- replace_suffix_by(word, "tional", "tion"),
           {:not_found, _word} <- replace_suffix_by(word, "biliti", "ble"),
           {:not_found, _word} <- replace_suffix_by(word, "lessli", "less"),
           {:not_found, _word} <- replace_suffix_by(word, "entli", "ent"),
           {:not_found, _word} <- replace_suffix_by(word, "ation", "ate"),
           {:not_found, _word} <- replace_suffix_by(word, "alism", "al"),
           {:not_found, _word} <- replace_suffix_by(word, "aliti", "al"),
           {:not_found, _word} <- replace_suffix_by(word, "ousli", "ous"),
           {:not_found, _word} <- replace_suffix_by(word, "iviti", "ive"),
           {:not_found, _word} <- replace_suffix_by(word, "fulli", "ful"),
           {:not_found, _word} <- replace_suffix_by(word, "enci", "ence"),
           {:not_found, _word} <- replace_suffix_by(word, "anci", "ance"),
           {:not_found, _word} <- replace_suffix_by(word, "abli", "able"),
           {:not_found, _word} <- replace_suffix_by(word, "izer", "ize"),
           {:not_found, _word} <- replace_suffix_by(word, "ator", "ate"),
           {:not_found, _word} <- replace_suffix_by(word, "alli", "al"),
           {:not_found, _word} <- replace_suffix_by(word, "bli", "ble"),
           {:not_found, _word} <- replace_suffix_ogi(word),
           {:not_found, _word} <- replace_suffix_li(word)
        do {:not_found, word}
      end

    word
  end

  defp replace_suffix_by(word, suffix, replacement) do
    if Rules.r1(word) =~ ~r/#{suffix}$/ do
      {:found, String.replace_suffix(word, suffix, replacement)}
    else
      {:not_found, word}
    end
  end

  defp replace_suffix_ogi(word) do
    if Rules.r1(word) =~ ~r/logi$/ do
      {:found, String.replace_suffix(word, "ogi", "og")}
    else
      {:not_found, word}
    end
  end

  defp replace_suffix_li(word) do
    if Rules.r1(word) =~ ~r/#{Rules.li_ending}li$/ do
      {:found, String.replace_suffix(word, "li", "")}
    else
      {:not_found, word}
    end
  end
end
