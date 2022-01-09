defmodule Stemmer.Rules do
  @v "aeiouy"
  @vowel "[#{@v}]"
  @non_vowel_wxy "[^#{@v}wxY]"
  @consonant "[^#{@v}]"
  @short_syllable "((#{@consonant}#{@vowel}#{@non_vowel_wxy})|(^#{@vowel}#{@consonant}))"

  def vowel, do: @vowel
  def consonant, do: @consonant
  def doubles, do: ~w(bb dd ff gg mm nn pp rr tt)
  def li_endings, do: ~w(cli dli eli gli hli kli mli nli rli tli)
  def short_syllable, do: @short_syllable
  def r_vc, do: ~r/^#{@consonant}*#{@vowel}+#{@consonant}/

  @doc """
  R1 is the region after the first non-vowel following a vowel, or is the null
  region at the end of the word if there is no such non-vowel.

  ## Examples

      iex> Stemmer.Rules.r1("beautiful")
      "iful"

      iex> Stemmer.Rules.r1("beauty")
      "y"

      iex> Stemmer.Rules.r1("beaut")
      ""

      iex> Stemmer.Rules.r1("beau")
      ""

      iex> Stemmer.Rules.r1("animadversion")
      "imadversion"

      iex> Stemmer.Rules.r1("sprinkled")
      "kled"

      iex> Stemmer.Rules.r1("eucharist")
      "harist"

      iex> Stemmer.Rules.r1("generation")
      "ation"

      iex> Stemmer.Rules.r1("communication")
      "ication"

      iex> Stemmer.Rules.r1("arsenal")
      "al"
  """
  def r1(word) do
    Regex.run(~r/^(gener|commun|arsen)/, word) |> match_r1(word)
  end

  defp match_r1(nil, word), do: normal_r1(word)

  defp match_r1(match, word) do
    String.replace_prefix(word, List.first(match), "")
  end

  defp normal_r1(word) do
    Regex.run(r_vc(), word) |> match_normal_r1(word)
  end

  defp match_normal_r1(nil, _word), do: ""

  defp match_normal_r1(match, word) do
    String.replace_prefix(word, List.first(match), "")
  end

  @doc """
  R2 is the region after the first non-vowel following a vowel in R1, or is
  the null region at the end of the word if there is no such non-vowel.

  ## Examples

      iex> Stemmer.Rules.r2("beautiful")
      "ul"

      iex> Stemmer.Rules.r2("beauty")
      ""

      iex> Stemmer.Rules.r1("beaut")
      ""

      iex> Stemmer.Rules.r2("beau")
      ""

      iex> Stemmer.Rules.r2("animadversion")
      "adversion"

      iex> Stemmer.Rules.r2("sprinkled")
      ""

      iex> Stemmer.Rules.r2("eucharist")
      "ist"
  """
  def r2(word) do
    word |> r1() |> normal_r1()
  end

  @doc """
  ## Examples

      iex> Stemmer.Rules.short?("rap")
      true

      iex> Stemmer.Rules.short?("trap")
      true

      iex> Stemmer.Rules.short?("ow")
      true

      iex> Stemmer.Rules.short?("on")
      true

      iex> Stemmer.Rules.short?("at")
      true

      iex> Stemmer.Rules.short?("bed")
      true

      iex> Stemmer.Rules.short?("shed")
      true

      iex> Stemmer.Rules.short?("shred")
      true

      iex> Stemmer.Rules.short?("uproot")
      false

      iex> Stemmer.Rules.short?("bestow")
      false

      iex> Stemmer.Rules.short?("disturb")
      false

      iex> Stemmer.Rules.short?("bead")
      false

      iex> Stemmer.Rules.short?("embed")
      false

      iex> Stemmer.Rules.short?("beds")
      false
  """
  def short?(word) do
    r1(word) == "" && word =~ ~r/#{@short_syllable}$/
  end

  @doc """
  ## Examples

      iex> Stemmer.Rules.invariant?("sky")
      {true, "sky"}

      iex> Stemmer.Rules.invariant?("skynet")
      {false, "skynet"}
  """
  def invariant?(word) do
    bool = Enum.member?(~w(sky news howe atlas cosmos bias andes), word)

    {bool, word}
  end

  @doc """
  ## Examples

      iex> Stemmer.Rules.invariant_after_1a?("inning")
      {true, "inning"}

      iex> Stemmer.Rules.invariant_after_1a?("manning")
      {false, "manning"}
  """
  def invariant_after_1a?(word) do
    bool = Enum.member?(~w(inning outing canning herring earring proceed exceed succeed), word)

    {bool, word}
  end

  @doc """
  ## Examples

      iex> Stemmer.Rules.replace_suffix_in_r1("sensational", "ational", "ate")
      {:found, "sensate"}
  """
  def replace_suffix_in_r1(word, suffix, replacement) do
    if word =~ ~r/#{suffix}$/ do
      found_suffix_in_r1(word, suffix, replacement)
    else
      {:next, word}
    end
  end

  defp found_suffix_in_r1(word, suffix, replacement) do
    if r1(word) =~ ~r/#{suffix}$/ do
      {:found, String.replace_suffix(word, suffix, replacement)}
    else
      {:found, word}
    end
  end
end
