defmodule Brcpfcnpj do
  @moduledoc """
  Valida Cpf/Cnpj e formata em String caso necessário
  1. O formato da string, que deve seguir o padrão xx.xxx.xxx/xxxx-xx,
  onde 'x' pode ser qualquer dígito de 0 a 9 e os traços (-), barra (/)
  e pontos (.) *são opcionais*.
  2. O conteúdo numérico desta string, que é validado através do cálculo
  do 'módulo 11' dos dígitos que compõem a string.

  ## Examples

      iex> Brcpfcnpj.cpf_valid?(%Cpf{number: "111.444.777-35"})
      true
      iex> Brcpfcnpj.cpf_format(%Cpf{number: "11144477735"})
      "111.444.777-35"

  Com ou sem os caracteres especiais os mesmos serão validados
  """

  @doc """
  Valida Cpf, realiza a chamada ao modulo Cpfcnpj com a estrutura correta.
  Força o desenvolvedor passar os parâmetros de forma correta

  ## Examples

      iex> Brcpfcnpj.cpf_valid?(%Cpf{number: "11144477735"})
      true
      iex> Brcpfcnpj.cpf_valid?(%Cpf{number: "111.444.777-35"})
      true
      iex> Brcpfcnpj.cpf_valid?(%Cpf{number: "1127772-35"})
      false

  Com ou sem os caracteres especiais os mesmos serão validados
  """
  @spec cpf_valid?(%Cpf{number: String.t()}) :: boolean()
  def cpf_valid?(cpf = %Cpf{}) do
    Cpfcnpj.valid?({:cpf, cpf.number})
  end

  @doc """
  Valida Cnpj, realiza a chamada ao módulo Cpfcnpj com a estrutura correta.
  Força o desenvolvedor passar os parâmetros de forma correta

  ## Examples

      iex> Brcpfcnpj.cnpj_valid?(%Cnpj{number: "69103604000160"})
      true
      iex> Brcpfcnpj.cnpj_valid?(%Cnpj{number: "69.103.604/0001-60"})
      true
      iex> Brcpfcnpj.cnpj_valid?(%Cnpj{number: "69./0001-60"})
      false

  """
  @spec cnpj_valid?(%Cnpj{number: String.t()}) :: boolean()
  def cnpj_valid?(cnpj = %Cnpj{}) do
    Cpfcnpj.valid?({:cnpj, cnpj.number})
  end

  @doc """
  Valida o Cpf e retorna uma String do Cpf formatado.
  Caso seja inválido retorna `nil`

  ## Examples

      iex> Brcpfcnpj.cpf_format(%Cpf{number: "11144477735"})
      "111.444.777-35"
      iex> Brcpfcnpj.cpf_format(%Cpf{number: "11144477734"})
      nil

  """
  @spec cpf_format(%Cpf{number: String.t()}) :: String.t()
  def cpf_format(cpf = %Cpf{}) do
    Cpfcnpj.format_number({:cpf, cpf.number})
  end

  @doc """
  Valida o Cnpj e retorna uma String do Cnpj formatado.
  Caso seja inválido retorna `nil`

  ## Examples

      iex> Brcpfcnpj.cnpj_format(%Cnpj{number: "69103604000160"})
      "69.103.604/0001-60"
      iex> Brcpfcnpj.cnpj_format(%Cnpj{number: "69103604000161"})
      nil

  """
  @spec cnpj_format(%Cnpj{number: String.t()}) :: String.t()
  def cnpj_format(cnpj = %Cnpj{}) do
    Cpfcnpj.format_number({:cnpj, cnpj.number})
  end

  @doc """
  Responsavel por gerar um Cpf válido, formatado ou não.
  Caso seja passado o parâmetro true recebera o mesmo formatado
  """
  @spec cpf_generate(boolean() | nil) :: String.t()
  def cpf_generate(format \\ false) do
    cpf = Cpfcnpj.generate(:cpf)
    if format, do: Cpfcnpj.format_number({:cpf, cpf}), else: cpf
  end

  @doc """
  Responsavel por gerar um Cnpj válido, formatado ou não.
  Caso seja passado o parâmetro true recebera o mesmo formatado
  """
  @spec cnpj_generate(boolean() | nil) :: String.t()
  def cnpj_generate(format \\ false) do
    cnpj = Cpfcnpj.generate(:cnpj)
    if format, do: Cpfcnpj.format_number({:cnpj, cnpj}), else: cnpj
  end
end
