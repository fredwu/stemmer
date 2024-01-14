defmodule Stemmer.Mixfile do
  use Mix.Project

  def project do
    [
      app: :stemmer,
      version: "1.2.0",
      elixir: "~> 1.12",
      name: "Stemmer",
      package: package(),
      description: "An English (Porter2) stemming implementation in Elixir.",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [coveralls: :test],
      aliases: [publish: ["hex.publish", &git_tag/1]]
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev, runtime: false},
      {:excoveralls, "~> 0.14", only: :test, runtime: false}
    ]
  end

  defp package do
    [
      maintainers: ["Fred Wu"],
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/fredwu/stemmer"}
    ]
  end

  defp git_tag(_args) do
    System.cmd("git", ["tag", "v" <> Mix.Project.config()[:version]])
    System.cmd("git", ["push"])
    System.cmd("git", ["push", "--tags"])
  end
end
