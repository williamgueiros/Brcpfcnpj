defmodule Cpfcnpj do
  @moduledoc """
  Módulo responsável por realizar todos os cálculos de validação.

  ## Examples

      iex>Cpfcnpj.valid?({:cnpj,"69.103.604/0001-60"})
      true
      iex>Cpfcnpj.valid?({:cpf,"111.444.777-35"})
      true

  Com ou sem os caracteres especiais os mesmos serão validados
  """
  @division 11

  @cpf_length 11
  @cpf_algs_1 [10, 9, 8, 7, 6, 5, 4, 3, 2, 0, 0]
  @cpf_algs_2 [11, 10, 9, 8, 7, 6, 5, 4, 3, 2, 0]
  @cpf_regex ~r/(\d{3})?(\d{3})?(\d{3})?(\d{2})/

  @cnpj_length 14
  @cnpj_algs_1 [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2, 0, 0]
  @cnpj_algs_2 [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2, 0]
  @cnpj_regex ~r/(\d{2})?(\d{3})?(\d{3})?(\d{4})?(\d{2})/

  @doc """
  Valida cpf/cnpj caracteres especias não são levados em consideração.

  ## Examples

      iex>Cpfcnpj.valid?({:cnpj,"69.103.604/0001-60"})
      true

  """
  @spec valid?({:cpf | :cnpj, String.t()}) :: boolean()
  def valid?(number_in) do
    check_number(number_in) and type_checker(number_in) and special_checker(number_in)
  end

  defp check_number({_, nil}) do
    false
  end

  # Checks length and if all are equal
  defp check_number(tp_cpfcnpj) do
    cpfcnpj = String.replace(elem(tp_cpfcnpj, 1), ~r/[\.\/-]/, "")

    all_equal? =
      cpfcnpj
      |> String.replace(String.at(cpfcnpj, 0), "")
      |> String.length()
      |> Kernel.==(0)

    correct_lenght? =
      case tp_cpfcnpj do
        {:cpf, _} ->
          String.length(cpfcnpj) == @cpf_length

        {:cnpj, _} ->
          String.length(cpfcnpj) == @cnpj_length
      end

    correct_lenght? and not all_equal?
  end

  # Checks validation digits
  defp type_checker(tp_cpfcnpj) do
    cpfcnpj = String.replace(elem(tp_cpfcnpj, 1), ~r/[^0-9]/, "")
    first_char_valid = character_valid(cpfcnpj, {elem(tp_cpfcnpj, 0), :first})
    second_char_valid = character_valid(cpfcnpj, {elem(tp_cpfcnpj, 0), :second})
    verif = first_char_valid <> second_char_valid
    verif == String.slice(cpfcnpj, -2, 2)
  end

  # Checks special cases
  defp special_checker({:cpf, _}) do
    true
  end

  defp special_checker({:cnpj, _} = tp_cpfcnpj) do
    cnpj = String.replace(elem(tp_cpfcnpj, 1), ~r/[\.\/-]/, "")

    order = String.slice(cnpj, 8..11)

    first_three_digits = String.slice(cnpj, 0..2)

    basic = String.slice(cnpj, 0..7)

    not_allowed_basics = basic in ~w<
      11111111
      22222222
      33333333
      44444444
      55555555
      66666666
      77777777
      88888888
      99999999 >

    cond do
      not_allowed_basics ->
        false

      order == "0000" ->
        false

      String.to_integer(order) > 300 and first_three_digits == "000" and basic != "00000000" ->
        false

      true ->
        true
    end
  end

  defp mult_sum(algs, cpfcnpj) do
    mult =
      cpfcnpj
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.map(fn {k, v} -> String.to_integer(k) * Enum.at(algs, v) end)

    Enum.reduce(mult, 0, &+/2)
  end

  defp character_calc(remainder) do
    if remainder < 2, do: 0, else: @division - remainder
  end

  defp character_valid(cpfcnpj, valid_type) do
    array =
      case valid_type do
        {:cpf, :first} -> @cpf_algs_1
        {:cnpj, :first} -> @cnpj_algs_1
        {:cpf, :second} -> @cpf_algs_2
        {:cnpj, :second} -> @cnpj_algs_2
      end

    mult_sum(array, cpfcnpj)
    |> rem(@division)
    |> character_calc
    |> Integer.to_string()
  end

  @doc """
  Valida o Cpf/Cnpj e retorna uma String com o mesmo formatado.
  Caso seja inválido retorna `nil`

  ## Examples
      iex> Cpfcnpj.format_number({:cnpj,"69.103.604/0001-60"})
      "69.103.604/0001-60"

  """
  @spec format_number({:cpf | :cnpj, String.t()}) :: String.t() | nil
  def format_number(number_in) do
    if valid?(number_in) do
      tp_cpfcnpj = {elem(number_in, 0), String.replace(elem(number_in, 1), ~r/[^0-9]/, "")}

      case tp_cpfcnpj do
        {:cpf, cpf} ->
          Regex.replace(@cpf_regex, cpf, "\\1.\\2.\\3-\\4")

        {:cnpj, cnpj} ->
          Regex.replace(@cnpj_regex, cnpj, "\\1.\\2.\\3/\\4-\\5")
      end
    else
      nil
    end
  end

  @doc """
  Gerador de cpf/cnpj concatenado com o dígito verificador.
  """
  @spec generate(:cpf | :cnpj) :: String.t()
  def generate(tp_cpfcnpj) do
    numbers = random_numbers(tp_cpfcnpj)
    first_valid_char = character_valid(numbers, {tp_cpfcnpj, :first})
    second_valid_char = character_valid(numbers <> first_valid_char, {tp_cpfcnpj, :second})

    numbers <> first_valid_char <> second_valid_char
  end

  defp random_numbers(tp_cpfcnpj) do
    random_digit_generator = fn -> Enum.random(0..9) end

    random_digit_generator
    |> Stream.repeatedly()
    |> Enum.take(if(tp_cpfcnpj == :cpf, do: @cpf_length, else: @cnpj_length) - 2)
    |> Enum.join()
  end
end
