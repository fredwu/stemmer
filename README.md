# Stemmer [![Travis](https://img.shields.io/travis/fredwu/stemmer.svg)](https://travis-ci.org/fredwu/stemmer) [![Hex.pm](https://img.shields.io/hexpm/v/stemmer.svg)](https://hex.pm/packages/stemmer)

An English ([Porter2](http://snowballstem.org/algorithms/english/stemmer.html)) stemming implementation in Elixir.

## Usage

The `Stemmer.stem/1` function supports stemming a single word (`String`), a sentence (`String`) or a list of single words (`List` of `String`s).

```elixir
Stemmer.stem("capabilities")                    # => "capabl"
Stemmer.stem("extraordinary capabilities")      # => "extraordinari capabl"
Stemmer.stem(["extraordinary", "capabilities"]) # => ["extraordinari", "capabl"]
```

## License

Licensed under [MIT](http://fredwu.mit-license.org/).
