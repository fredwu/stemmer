defmodule Stemmer.SpecialWord do
  def apply(word) do
    word
    |> special_word()
  end

  @doc """
  ## Examples

      iex> Stemmer.SpecialWord.special_word("skis")
      "ski"

      iex> Stemmer.SpecialWord.special_word("buying")
      "buying"
  """
  def special_word(word) do
    mapping = %{
      "skis"   => "ski",
      "skies"  => "sky",
      "dying"  => "die",
      "lying"  => "lie",
      "tying"  => "tie",
      "idly"   => "idl",
      "gently" => "gentl",
      "ugly"   => "ugli",
      "early"  => "earli",
      "only"   => "onli",
      "singly" => "singl"
    }

    if mapping |> Map.keys() |> Enum.member?(word) do
      mapping[word]
    else
      word
    end
  end
end
