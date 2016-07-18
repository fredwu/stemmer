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
      "sensation"

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
    word_r1 = Rules.r1(word)

    cond do
      word_r1 =~ ~r/tional$/ ->
        String.replace_suffix(word, "tional", "tion")
      word_r1 =~ ~r/enci$/ ->
        String.replace_suffix(word, "enci", "ence")
      word_r1 =~ ~r/anci$/ ->
        String.replace_suffix(word, "anci", "ance")
      word_r1 =~ ~r/abli$/ ->
        String.replace_suffix(word, "abli", "able")
      word_r1 =~ ~r/entli$/ ->
        String.replace_suffix(word, "entli", "ent")
      word_r1 =~ ~r/(izer|ization)$/ ->
        word
        |> String.replace_suffix("izer", "ize")
        |> String.replace_suffix("ization", "ize")
      word_r1 =~ ~r/(ational|ation|ator)$/ ->
        word
        |> String.replace_suffix("ational", "ate")
        |> String.replace_suffix("ation", "ate")
        |> String.replace_suffix("ator", "ate")
      word_r1 =~ ~r/(alism|aliti|alli)$/ ->
        word
        |> String.replace_suffix("alism", "al")
        |> String.replace_suffix("aliti", "al")
        |> String.replace_suffix("alli", "al")
      word_r1 =~ ~r/fulness$/ ->
        String.replace_suffix(word, "fulness", "ful")
      word_r1 =~ ~r/(ousli|ousness)$/ ->
        word
        |> String.replace_suffix("ousli", "ous")
        |> String.replace_suffix("ousness", "ous")
      word_r1 =~ ~r/(iveness|iviti)$/ ->
        word
        |> String.replace_suffix("iveness", "ive")
        |> String.replace_suffix("iviti", "ive")
      word_r1 =~ ~r/(biliti|bli)$/ ->
        word
        |> String.replace_suffix("biliti", "ble")
        |> String.replace_suffix("bli", "ble")
      word_r1 =~ ~r/logi$/ ->
        String.replace_suffix(word, "ogi", "og")
      word_r1 =~ ~r/fulli$/ ->
        String.replace_suffix(word, "fulli", "ful")
      word_r1 =~ ~r/lessli$/ ->
        String.replace_suffix(word, "lessli", "less")
      word_r1 =~ ~r/#{Rules.li_ending}li$/ ->
        String.replace_suffix(word, "li", "")
      true ->
        word
    end
  end
end
