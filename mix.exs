defmodule Stemmer.Mixfile do
  use Mix.Project

  def project do
    [app: :stemmer,
     version: "1.0.0-beta.1",
     elixir: "~> 1.3",
     name: "Stemmer",
     package: package(),
     description: "An English (Porter2) stemming implementation in Elixir.",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:ex_doc, ">= 0.0.0", only: :dev}]
  end

  defp package do
    [
      maintainers: ["Fred Wu"],
      licenses:    ["MIT"],
      links:       %{"GitHub" => "https://github.com/fredwu/stemmer"}
    ]
  end
end
