defmodule Stemmer.Step5 do
  alias Stemmer.Rules

  @doc """
  ## Examples

      iex> Stemmer.Step5.apply("Yellow")
      "yellow"
  """
  def apply(word) do
    word
    |> remove_suffix_in_r2()
    |> String.downcase()
  end

  @doc """
  Search for the following suffixes, and, if found, perform the action indicated.

  ## Examples

      iex> Stemmer.Step5.remove_suffix_in_r2("conceive")
      "conceiv"

      iex> Stemmer.Step5.remove_suffix_in_r2("move")
      "move"

      iex> Stemmer.Step5.remove_suffix_in_r2("momoie")
      "momoi"

      iex> Stemmer.Step5.remove_suffix_in_r2("moe")
      "moe"

      iex> Stemmer.Step5.remove_suffix_in_r2("daniell")
      "daniel"

      iex> Stemmer.Step5.remove_suffix_in_r2("doll")
      "doll"

      iex> Stemmer.Step5.remove_suffix_in_r2("mail")
      "mail"
  """
  def remove_suffix_in_r2(word) do
    word_r2 = Rules.r2(word)

    cond do
      word_r2 =~ ~r/e$/ ->
        String.replace_suffix(word, "e", "")
      Rules.r1(word) =~ ~r/e$/ && not (word =~ ~r/#{Rules.short_syllable()}e$/) ->
        String.replace_suffix(word, "e", "")
      word_r2 =~ ~r/l$/ && word =~ ~r/ll$/ ->
        String.replace_suffix(word, "l", "")
      true ->
        word
    end
  end
end
