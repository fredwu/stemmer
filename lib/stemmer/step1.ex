defmodule Stemmer.Step1 do
  def apply(word) do
    word
    # step 1a
    |> replace_sses()
    |> replace_ied_ies()
    |> remove_s()
  end

  @doc """
  ## Examples

      iex> Stemmer.Step1.replace_sses("actresses")
      "actress"
  """
  def replace_sses(word) do
    String.replace_suffix(word, "sses", "ss")
  end

  @doc """
  ## Examples

      iex> Stemmer.Step1.replace_ied_ies("tied")
      "tie"

      iex> Stemmer.Step1.replace_ied_ies("ties")
      "tie"

      iex> Stemmer.Step1.replace_ied_ies("cries")
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
  ## Examples

      iex> Stemmer.Step1.remove_s("gas")
      "gas"

      iex> Stemmer.Step1.remove_s("this")
      "this"

      iex> Stemmer.Step1.remove_s("gaps")
      "gap"

      iex> Stemmer.Step1.remove_s("kiwis")
      "kiwi"
  """
  def remove_s(word) do
    vowel_not_immediately_before_s = ~r/(#{Stemmer.Rules.vowel()}.+)s$/

    if word =~ vowel_not_immediately_before_s do
      String.replace_suffix(word, "s", "")
    else
      word
    end
  end
end
