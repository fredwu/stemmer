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
      with {:next, _word} <- replace_eed_eedly(word),
           {:next, _word} <- remove_ed_edly_ing_ingly(word) do
        {:found, word}
      end

    word
  end

  @doc """
  Replace by `ee` if in R1.

  ## Examples

      iex> Stemmer.Step1b.replace_eed_eedly("proceed")
      {:found, "procee"}

      iex> Stemmer.Step1b.replace_eed_eedly("proceedly")
      {:found, "procee"}

      iex> Stemmer.Step1b.replace_eed_eedly("need")
      {:found, "need"}
  """
  def replace_eed_eedly(word) do
    if String.ends_with?(word, ["eedly", "eed"]) do
      replace_eed_eedly_in_r1(word)
    else
      {:next, word}
    end
  end

  defp replace_eed_eedly_in_r1(word) do
    word =
      if String.ends_with?(Rules.r1(word), ["eedly", "eed"]) do
        word
        |> String.replace_suffix("eedly", "ee")
        |> String.replace_suffix("eed", "ee")
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

      iex> Stemmer.Step1b.remove_ed_edly_ing_ingly("luxuriating")
      {:found, "luxuriate"}

      iex> Stemmer.Step1b.remove_ed_edly_ing_ingly("hopping")
      {:found, "hop"}

      iex> Stemmer.Step1b.remove_ed_edly_ing_ingly("hoping")
      {:found, "hope"}
  """
  def remove_ed_edly_ing_ingly(word) do
    r_ending = ~r/(#{Rules.vowel()}.*)(ingly|edly|ing|ed)$/

    if word =~ r_ending do
      word =
        word
        |> String.replace(r_ending, "\\1")
        |> post_remove_ed_edly_ing_ingly()

      {:found, word}
    else
      {:next, word}
    end
  end

  defp post_remove_ed_edly_ing_ingly(word) do
    cond do
      String.ends_with?(word, ~w(at bl iz)) -> word <> "e"
      String.ends_with?(word, Rules.doubles()) -> String.slice(word, 0..-2//1)
      Rules.short?(word) -> word <> "e"
      true -> word
    end
  end
end
