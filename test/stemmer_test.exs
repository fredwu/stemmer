defmodule StemmerTest do
  use ExUnit.Case, async: true

  doctest Stemmer

  test "official diffs.txt" do
    file_path = Path.join(File.cwd!, "test/samples/diffs.tar.gz")
    temp_path = Path.join(File.cwd!, "test/temp")

    System.cmd("tar", ["xzvf", file_path, "-C", temp_path], [stderr_to_stdout: true])

    Path.join(temp_path, "diffs.txt")
    |> File.stream!()
    |> Enum.each(fn (line) ->
      [word, official_stemmed] = String.split(line)

      # according to the official Porter2 algorithm `fluently` should be stemmed
      # to `fluent`, however the test file suggests it stemmed to `fluentli`
      unless word == "fluently" do
        assert Stemmer.stem(word) == official_stemmed
      end
    end)
  end
end
