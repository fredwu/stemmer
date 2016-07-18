defmodule Stemmer.Step1b do
  alias Stemmer.Rules

  def apply(word) do
    word
    |> replace_eed_eedly_in_r1()
    |> remove_ed_edly_ing_ingly()
  end

  @doc """
  Replace by `ee` if in R1.

  ## Examples

      iex> Stemmer.Step1b.replace_eed_eedly_in_r1("proceed")
      "procee"

      iex> Stemmer.Step1b.replace_eed_eedly_in_r1("proceedly")
      "procee"

      iex> Stemmer.Step1b.replace_eed_eedly_in_r1("need")
      "need"
  """
  def replace_eed_eedly_in_r1(word) do
    cond do
      Rules.r1(word) =~ "eedly" -> String.replace_suffix(word, "eedly", "ee")
      Rules.r1(word) =~ "eed"   -> String.replace_suffix(word, "eed", "ee")
      true                      -> word
    end
  end

  @doc """
  Delete if the preceding word part contains a vowel, and after the deletion:

  - if the word ends `at`, `bl` or `iz` add `e` (so `luxuriat` → `luxuriate`), or
  - if the word ends with a double remove the last letter (so `hopp` → `hop`), or
  - if the word is short, add `e` (so `hop` → `hope`)

  ## Examples

      iex> Stemmer.Step1b.remove_ed_edly_ing_ingly("luxuriating")
      "luxuriate"

      iex> Stemmer.Step1b.remove_ed_edly_ing_ingly("hopping")
      "hop"

      iex> Stemmer.Step1b.remove_ed_edly_ing_ingly("hoping")
      "hope"
  """
  def remove_ed_edly_ing_ingly(word) do
    if word =~ ~r/#{Rules.vowel()}.*(ed|edly|ing|ingly)$/ do
      word
      |> String.replace_suffix("ed", "")
      |> String.replace_suffix("edly", "")
      |> String.replace_suffix("ing", "")
      |> String.replace_suffix("ingly", "")
      |> post_remove_ed_edly_ing_ingly()
    else
      word
    end
  end

  defp post_remove_ed_edly_ing_ingly(word) do
    cond do
      word =~ ~r/(at|bl|iz)$/        -> word <> "e"
      word =~ ~r/#{Rules.double()}$/ -> String.slice(word, 0..-2)
      Rules.short?(word)             -> word <> "e"
      true                           -> word
    end
  end
end
