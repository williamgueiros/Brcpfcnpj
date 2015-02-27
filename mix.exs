defmodule Brcpfcnpj.Mixfile do
  use Mix.Project

  def project do
    [app: :brcpfcnpj,
     version: "0.0.3",
     elixir: "~> 1.0",
     description: description,
     package: package,
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

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
     [files: ~w(lib test config mix.exs README*),
	 contributors: ["William Gueiros"],
	 licenses: ["Unlicense"],
	 links: %{"GitHub" => "https://github.com/williamgueiros/Brcpfcnpj"}]
  end	

end
