defmodule Brcpfcnpj do
  @moduledoc ~S"""
  Valida Cpf/Cnpj e Formatar em String caso necessario
  1. O formato da string, que deve seguir o padrão xx.xxx.xxx/xxxx-xx,
	onde 'x' pode ser qualquer dígito de 0 a 9 e os traços (-), barra (/)
	e pontos (.) *são opcionais*.
  2. O conteúdo numérico desta string, que é validado através do cálculo
	do 'módulo 11' dos dígitos que compõem a string.

  exemplos:

      iex>Brcpfcnpj.cpf_valid?(%Cpf{number: "111.444.777-35"})
      true
      iex>Brcpfcnpj.cpf_format(%Cpf{number: "11144477735"})
      "111.444.777-35"

  Com ou sem os caracteres especiais os mesmos serao validados
  """

  @doc ~S"""
  Valida Cpf, realiza a chamda ao modulo Cpfcnpj com a estrutura correta.
  forca o desenvolvedor passar os parametros de forma correta

  exemplos:

      iex>Brcpfcnpj.cpf_valid?(%Cpf{number: "11144477735"})
      true
      iex>Brcpfcnpj.cpf_valid?(%Cpf{number: "111.444.777-35"})
      true

  Com ou sem os caracteres especiais os mesmos serao validados
  """

  def cpf_valid?(cpf = %Cpf{}) do
    Cpfcnpj.valid?({cpf.tp_data, cpf.number})
  end

  @doc ~S"""
  Valida Cnpj, realiza a chamda ao modulo Cpfcnpj com a estrutura correta.
  forca o desenvolvedor passar os parametros de forma correta

  Exemplos

      iex>Brcpfcnpj.cnpj_valid?(%Cnpj{number: "69103604000160"})
      true
      iex>Brcpfcnpj.cnpj_valid?(%Cnpj{number: "69.103.604/0001-60"})
      true

  """

  def cnpj_valid?(cnpj = %Cnpj{}) do
    Cpfcnpj.valid?({cnpj.tp_data, cnpj.number})
  end

  @doc ~S"""
  Valida o Cpf e retorna uma String do Cpf formatado
  Caso seja invalido retorna nil

  Exemplos

      iex>Brcpfcnpj.cpf_format(%Cpf{number: "11144477735"})
      "111.444.777-35"
      iex>Brcpfcnpj.cpf_format(%Cpf{number: "11144477734"})
      nil
  """

  def cpf_format(cpf = %Cpf{}) do
    Cpfcnpj.format_number({cpf.tp_data, cpf.number})
  end

  @doc ~S"""
  Valida o Cnpj e retorna uma String do Cnpj formatado
  Caso seja invalido retorna nil

  Exemplos

      iex>Brcpfcnpj.cnpj_format(%Cnpj{number: "69103604000160"})
      "69.103.604/0001-60"
      iex> Brcpfcnpj.cnpj_format(%Cnpj{number: "69103604000161"})
      nil
  """

  def cnpj_format(cnpj = %Cnpj{}) do
    Cpfcnpj.format_number({cnpj.tp_data, cnpj.number})
  end

  @doc """
  Responsavel por gerar um Cpf válido, formatado ou não
  Caso seja passado o parametro true recebera o mesmo formatado
  """

  def cpf_generate(format \\ false) do
    tp_data = %Cpf{}.tp_data
    cpf = Cpfcnpj.generate(tp_data)
    if format, do: Cpfcnpj.format_number({tp_data, cpf}), else: cpf
  end

  @doc """
  Responsavel por gerar um Cnpj válido, formatado ou não
  Caso seja passado o parametro true recebera o mesmo formatado
  """

  def cnpj_generate(format \\ false) do
    tp_data = %Cnpj{}.tp_data
    cnpj = Cpfcnpj.generate(tp_data)
    if format, do: Cpfcnpj.format_number({tp_data, cnpj}), else: cnpj
  end
end
