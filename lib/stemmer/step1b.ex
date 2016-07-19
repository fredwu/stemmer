defmodule Stemmer.Step1b do
  alias Stemmer.Rules

  def apply(word) do
    word
    |> replace_suffix()
  end

  @doc """
  ## Examples

      iex> Stemmer.Step1b.replace_suffix("bleed")
      "bleed"
  """
  def replace_suffix(word) do
    {_, word} =
      with {:not_found, _word} <- replace_eed_eedly(word, "eedly"),
           {:not_found, _word} <- remove_ed_edly_ing_ingly(word, "ingly|edly"),
           {:not_found, _word} <- replace_eed_eedly(word, "eed"),
           {:not_found, _word} <- remove_ed_edly_ing_ingly(word, "ing|ed")
        do {:not_found, word}
      end

    word
  end

  @doc """
  Replace by `ee` if in R1.

  ## Examples

      iex> Stemmer.Step1b.replace_eed_eedly("proceed", "eed")
      {:found, "procee"}

      iex> Stemmer.Step1b.replace_eed_eedly("proceedly", "eedly")
      {:found, "procee"}

      iex> Stemmer.Step1b.replace_eed_eedly("need", "eed")
      {:found, "need"}
  """
  def replace_eed_eedly(word, suffix) do
    if word =~ ~r/#{suffix}$/ do
      replace_eed_eedly_in_r1(word, suffix)
    else
      {:not_found, word}
    end
  end

  defp replace_eed_eedly_in_r1(word, suffix) do
    r_ending = ~r/#{suffix}$/

    word = if Rules.r1(word) =~ r_ending do
      String.replace(word, r_ending, "ee")
    else
      word
    end

    {:found, word}
  end

  @doc """
  Delete if the preceding word part contains a vowel, and after the deletion:

  - if the word ends `at`, `bl` or `iz` add `e` (so `luxuriat` → `luxuriate`), or
  - if the word ends with a double remove the last letter (so `hopp` → `hop`), or
  - if the word is short, add `e` (so `hop` → `hope`)

  ## Examples

      iex> Stemmer.Step1b.remove_ed_edly_ing_ingly("luxuriating", "ing")
      {:found, "luxuriate"}

      iex> Stemmer.Step1b.remove_ed_edly_ing_ingly("hopping", "ing")
      {:found, "hop"}

      iex> Stemmer.Step1b.remove_ed_edly_ing_ingly("hoping", "ing")
      {:found, "hope"}
  """
  def remove_ed_edly_ing_ingly(word, suffix) do
    r_ending = ~r/(#{Rules.vowel()}.*)(#{suffix})$/

    if word =~ r_ending do
      word = word
      |> String.replace(r_ending, "\\1")
      |> post_remove_ed_edly_ing_ingly()

      {:found, word}
    else
      {:not_found, word}
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
