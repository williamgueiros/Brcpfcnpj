defmodule Brcpfcnpj.Mixfile do
  use Mix.Project

  def project do
    [
      app: :brcpfcnpj,
      version: "0.1.1",
      elixir: "~> 1.2",
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
      {:earmark, "~> 1.2", only: :dev},
      {:ex_doc, "~> 0.18", only: :dev},
      {:inch_ex, "~> 0.5.6", only: :docs}
    ]
  end

  defp description do
    """
    Colecao de funcoes para validacao e formatacao de CPF e CNPJ.

    Validation and format for brazilian id documents (CPF/CNPJ).
    """
  end

  defp package do
    [
      files: ~w(lib test config mix.exs README*),
      maintainers: ["William Gueiros"],
      licenses: ["Unlicense"],
      links: %{"GitHub" => "https://github.com/williamgueiros/Brcpfcnpj"}
    ]
  end
end
