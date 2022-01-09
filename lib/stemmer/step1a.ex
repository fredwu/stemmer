defmodule Stemmer.Step1a do
  alias Stemmer.Rules

  def apply(word) do
    word
    |> replace_suffix()
  end

  @doc """
  ## Examples

      iex> Stemmer.Step1a.replace_suffix("abyss")
      "abyss"
  """
  def replace_suffix(word) do
    {_, word} =
      with {:next, _word} <- replace_sses(word),
           {:next, _word} <- replace_ied_ies(word),
           {:next, _word} <- leave_us_ss(word),
           {:next, _word} <- remove_s(word) do
        {:found, word}
      end

    word
  end

  @doc """
  Replace by `ss`.

  ## Examples

      iex> Stemmer.Step1a.replace_sses("actresses")
      {:found, "actress"}
  """
  def replace_sses(word) do
    if String.ends_with?(word, "sses") do
      {:found, String.replace_suffix(word, "sses", "ss")}
    else
      {:next, word}
    end
  end

  @doc """
  Replace by `i` if preceded by more than one letter, otherwise by `ie` (so
  `ties` → `tie`, `cries` → `cri`).

  ## Examples

      iex> Stemmer.Step1a.replace_ied_ies("tied")
      {:found, "tie"}

      iex> Stemmer.Step1a.replace_ied_ies("ties")
      {:found, "tie"}

      iex> Stemmer.Step1a.replace_ied_ies("cries")
      {:found, "cri"}
  """
  def replace_ied_ies(word) do
    if String.ends_with?(word, ["ied", "ies"]) do
      word =
        if String.length(word) > 4 do
          word
          |> String.replace_suffix("ied", "i")
          |> String.replace_suffix("ies", "i")
        else
          word
          |> String.replace_suffix("ied", "ie")
          |> String.replace_suffix("ies", "ie")
        end

      {:found, word}
    else
      {:next, word}
    end
  end

  @doc """
  Do nothing.

  ## Examples

      iex> Stemmer.Step1a.leave_us_ss("abyss")
      {:found, "abyss"}
  """
  def leave_us_ss(word) do
    if String.ends_with?(word, ["us", "ss"]) do
      {:found, word}
    else
      {:next, word}
    end
  end

  @doc """
  Delete if the preceding word part contains a vowel not immediately before
  the `s` (so `gas` and `this` retain the `s`, `gaps` and `kiwis` lose it).

  ## Examples

      iex> Stemmer.Step1a.remove_s("gas")
      {:next, "gas"}

      iex> Stemmer.Step1a.remove_s("this")
      {:next, "this"}

      iex> Stemmer.Step1a.remove_s("gaps")
      {:found, "gap"}

      iex> Stemmer.Step1a.remove_s("kiwis")
      {:found, "kiwi"}
  """
  def remove_s(word) do
    if word =~ ~r/#{Rules.vowel()}.+s$/ do
      {:found, String.replace_suffix(word, "s", "")}
    else
      {:next, word}
    end
  end
end
