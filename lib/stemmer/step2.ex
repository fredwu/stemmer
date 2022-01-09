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

      iex> Stemmer.Step2.replace_suffix_in_r1("geologi")
      "geolog"

      iex> Stemmer.Step2.replace_suffix_in_r1("greatli")
      "great"

      iex> Stemmer.Step2.replace_suffix_in_r1("fluentli")
      "fluentli"
  """
  def replace_suffix_in_r1(word) do
    {_, word} =
      with {:next, _word} <- Rules.replace_suffix_in_r1(word, "ization", "ize"),
           {:next, _word} <- Rules.replace_suffix_in_r1(word, "ational", "ate"),
           {:next, _word} <- Rules.replace_suffix_in_r1(word, "fulness", "ful"),
           {:next, _word} <- Rules.replace_suffix_in_r1(word, "ousness", "ous"),
           {:next, _word} <- Rules.replace_suffix_in_r1(word, "iveness", "ive"),
           {:next, _word} <- Rules.replace_suffix_in_r1(word, "tional", "tion"),
           {:next, _word} <- Rules.replace_suffix_in_r1(word, "biliti", "ble"),
           {:next, _word} <- Rules.replace_suffix_in_r1(word, "lessli", "less"),
           {:next, _word} <- Rules.replace_suffix_in_r1(word, "entli", "ent"),
           {:next, _word} <- Rules.replace_suffix_in_r1(word, "ation", "ate"),
           {:next, _word} <- Rules.replace_suffix_in_r1(word, "alism", "al"),
           {:next, _word} <- Rules.replace_suffix_in_r1(word, "aliti", "al"),
           {:next, _word} <- Rules.replace_suffix_in_r1(word, "ousli", "ous"),
           {:next, _word} <- Rules.replace_suffix_in_r1(word, "iviti", "ive"),
           {:next, _word} <- Rules.replace_suffix_in_r1(word, "fulli", "ful"),
           {:next, _word} <- Rules.replace_suffix_in_r1(word, "enci", "ence"),
           {:next, _word} <- Rules.replace_suffix_in_r1(word, "anci", "ance"),
           {:next, _word} <- Rules.replace_suffix_in_r1(word, "abli", "able"),
           {:next, _word} <- Rules.replace_suffix_in_r1(word, "izer", "ize"),
           {:next, _word} <- Rules.replace_suffix_in_r1(word, "ator", "ate"),
           {:next, _word} <- Rules.replace_suffix_in_r1(word, "alli", "al"),
           {:next, _word} <- Rules.replace_suffix_in_r1(word, "bli", "ble"),
           {:next, _word} <- replace_suffix_ogi(word),
           {:next, _word} <- replace_suffix_li(word) do
        {:found, word}
      end

    word
  end

  defp replace_suffix_ogi(word) do
    if String.ends_with?(Rules.r1(word), "ogi") && String.ends_with?(word, "logi") do
      {:found, String.replace_suffix(word, "ogi", "og")}
    else
      {:next, word}
    end
  end

  defp replace_suffix_li(word) do
    if String.ends_with?(Rules.r1(word), "li") && String.ends_with?(word, Rules.li_endings()) do
      {:found, String.replace_suffix(word, "li", "")}
    else
      {:next, word}
    end
  end
end
