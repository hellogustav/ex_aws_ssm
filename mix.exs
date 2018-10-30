defmodule ExAwsSsm.MixProject do
  use Mix.Project

  @name "ExAws.SSM"
  @version "2.0.4"
  @url "https://github.com/hellogustav/ex_aws_ssm"

  def project do
    [
      name: @name,
      app: :ex_aws_ssm,
      version: @version,
      elixir: "~> 1.5",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      description: description(),
      deps: deps(),
      docs: docs(),
      package: package()
    ]
  end

  defp description() do
    "#{@name} service package"
  end

  defp docs() do
    [
      main: @name,
      source_ref: "v#{@version}",
      source_url: @url,
      extras: [
        "README.md"
      ]
    ]
  end

  defp package() do
    [
      licenses: ["MIT"],
      maintainers: [
        "Goran Pedić"
      ],
      links: %{
        "GitHub" => @url
      }
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, ">= 0.0.0", only: :dev},
      {:hackney, ">= 0.0.0", only: [:dev, :test]},
      {:poison, ">= 0.0.0", only: [:dev, :test]},
      ex_aws()
    ]
  end

  defp ex_aws() do
    case System.get_env("AWS") do
      "LOCAL" -> {:ex_aws, path: "../ex_aws"}
      _ -> {:ex_aws, "~> 2.0.0"}
    end
  end
end
