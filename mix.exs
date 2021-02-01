defmodule Brcpfcnpj.Mixfile do
  use Mix.Project

  def project do
    [
      app: :brcpfcnpj,
      version: "0.2.3",
      elixir: "~> 1.7",
      description: description(),
      package: package(),
      deps: deps()
    ]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [
      {:earmark, "~> 1.4", only: [:dev, :docs], runtime: false},
      {:ex_doc, "~> 0.21.2", only: [:dev, :docs], runtime: false},
      {:inch_ex, "~> 2.0", only: :docs, runtime: false},
      {:credo, "~> 1.5", only: :dev, runtime: false},
      {:dialyxir, "~> 1.0.0-rc.7", only: :dev, runtime: false},
      {:ecto, "~> 3.0", optional: true}
    ]
  end

  defp description do
    """
    Coleção de funções para validacão e formatação de CPF e CNPJ.

    Validation and format for brazilian id documents (CPF/CNPJ).
    """
  end

  defp package do
    [
      files: ~w(lib test config mix.exs README*),
      maintainers: ["William Gueiros", "Vítor Trindade"],
      licenses: ["Unlicense"],
      links: %{"GitHub" => "https://github.com/williamgueiros/Brcpfcnpj"}
    ]
  end
end
