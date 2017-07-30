# Stemmer [![Travis](https://img.shields.io/travis/fredwu/stemmer.svg)](https://travis-ci.org/fredwu/stemmer) [![Coverage](https://img.shields.io/coveralls/fredwu/stemmer.svg)](https://coveralls.io/github/fredwu/stemmer?branch=master) [![Hex.pm](https://img.shields.io/hexpm/v/stemmer.svg)](https://hex.pm/packages/stemmer)

An English ([Porter2](http://snowballstem.org/algorithms/english/stemmer.html)) stemming implementation in Elixir.

> In linguistic morphology and information retrieval, __stemming__ is the process of reducing inflected (or sometimes derived) words to their word stem, base or root form—generally a written word form. The stem need not be identical to the morphological root of the word; it is usually sufficient that related words map to the same stem, even if this stem is not in itself a valid root. - [Wikipedia](https://en.wikipedia.org/wiki/Stemming)

## Usage

The `Stemmer.stem/1` function supports stemming a single word (`String`), a sentence (`String`) or a list of single words (`List` of `String`s).

```elixir
Stemmer.stem("capabilities")                    # => "capabl"
Stemmer.stem("extraordinary capabilities")      # => "extraordinari capabl"
Stemmer.stem(["extraordinary", "capabilities"]) # => ["extraordinari", "capabl"]
```

## Compatibility

Stemmer is 100% compatible with the official Porter2 implementation, it is tested against the official [`diffs.txt`](http://snowball.tartarus.org/algorithms/english/diffs.txt) which contains more than 29000 words.

## Naive Bayes

Stemmer was built to support the [Simple Bayes](https://github.com/fredwu/simple_bayes) library. :heart:

## License

Licensed under [MIT](http://fredwu.mit-license.org/).
