defmodule FettlePlug.Mixfile do
  use Mix.Project

  def project do
    [
      app: :fettle_plug,
      version: "1.1.0",
      elixir: "~> 1.11",
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      source_url: "https://github.com/Financial-Times/fettle_plug",
      description: description(),
      package: package(),
      docs: docs(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    # Specify extra applications you'll use from Erlang/Elixir
    [extra_applications: [:logger, :plug]]
  end

  def package do
    [
      maintainers: ["Ellis Pritchard"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/Financial-Times/fettle_plug"}
    ]
  end

  defp description do
    """
    Plug support for Fettle health-checks.
    """
  end

  def docs do
    [main: "readme", extras: ["README.md"]]
  end

  defp deps do
    [
      {:plug, "~> 1.11"},
      {:poison, "~> 4.0"},
      {:fettle, github: "Financial-Times/fettle", tag: "v1.1.0"},
      {:credo, "~> 1.5", only: [:dev, :test]},
      {:mix_test_watch, "~> 1.0", only: :dev, runtime: false},
      {:ex_doc, "~> 0.23.0", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0", only: [:dev], runtime: false},
      {:inch_ex, "~> 2.0", only: :docs}
    ]
  end
end
