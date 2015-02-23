defmodule Brcpfcnpj.Mixfile do
  use Mix.Project

  def project do
    [app: :brcpfcnpj,
     version: "0.0.2",
     elixir: "~> 1.0",
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    []
  end
  
  defp description do
      """
      Valida Cpf/Cnpj e Formatar em String caso necessario
	  
	  Number format and Validate, to the documents brazilians (CPF/CNPJ)
      """
    end
	
  defp package do
     links: %{"GitHub" => "https://github.com/williamgueiros/Brcpfcnpj"]
  end	
end
