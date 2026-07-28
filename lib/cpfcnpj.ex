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
  @cnpj_regex ~r/([0-9A-Za-z]{2})[.]?([0-9A-Za-z]{3})[.]?([0-9A-Za-z]{3})[\/]?([0-9A-Za-z]{4})[-]?([0-9A-Za-z]{2})/

  @digit_regex ~r/^\d+$/

  @cnpj_characters 48..57
                   |> Enum.to_list()
                   |> Kernel.++(Enum.to_list(65..90))
                   |> Enum.map(&List.wrap(&1))

  @cnpj_character_to_value_map %{
    "0" => 0,
    "1" => 1,
    "2" => 2,
    "3" => 3,
    "4" => 4,
    "5" => 5,
    "6" => 6,
    "7" => 7,
    "8" => 8,
    "9" => 9,
    "A" => 17,
    "B" => 18,
    "C" => 19,
    "D" => 20,
    "E" => 21,
    "F" => 22,
    "G" => 23,
    "H" => 24,
    "I" => 25,
    "J" => 26,
    "K" => 27,
    "L" => 28,
    "M" => 29,
    "N" => 30,
    "O" => 31,
    "P" => 32,
    "Q" => 33,
    "R" => 34,
    "S" => 35,
    "T" => 36,
    "U" => 37,
    "V" => 38,
    "W" => 39,
    "X" => 40,
    "Y" => 41,
    "Z" => 42
  }

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
  defp check_number({type, string}) do
    cpfcnpj = String.replace(string, ~r/[\.\/-]/, "")
    cpfcnpj_with_only_valid_characters = replace_invalid_characters(type, string)

    all_equal? =
      cpfcnpj
      |> String.replace(String.at(cpfcnpj, 0), "")
      |> String.length()
      |> Kernel.==(0)

    correct_length = check_length(type, cpfcnpj)
    correct_length_only_valid = check_length(type, cpfcnpj_with_only_valid_characters)
    correct_length and correct_length_only_valid and not all_equal?
  end

  defp check_length(:cpf, cpf), do: String.length(cpf) == @cpf_length
  defp check_length(:cnpj, cnpj), do: String.length(cnpj) == @cnpj_length

  # Checks validation digits
  defp type_checker({type, string}) do
    cpfcnpj = replace_invalid_characters(type, string)
    first_char_valid = character_valid(cpfcnpj, {type, :first})
    second_char_valid = character_valid(cpfcnpj, {type, :second})
    verif = first_char_valid <> second_char_valid
    verif == String.slice(cpfcnpj, -2, 2)
  end

  # Checks special cases
  defp special_checker({:cpf, _}) do
    true
  end

  defp special_checker(tp_cpfcnpj = {:cnpj, _}) do
    cnpj = String.replace(elem(tp_cpfcnpj, 1), ~r/[\.\/-]/, "")

    order = String.slice(cnpj, 8..11)

    first_three_digits = String.slice(cnpj, 0..2)

    basic = String.slice(cnpj, 0..7)

    cond do
      order == "0000" ->
        false

      Regex.match?(@digit_regex, order) and String.to_integer(order) > 300 and
        first_three_digits == "000" and
          basic != "00000000" ->
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
      |> Enum.map(fn {k, v} -> cnpj_alphanumeric_translation(k) * Enum.at(algs, v) end)

    Enum.reduce(mult, 0, &+/2)
  end

  defp character_calc(remainder) do
    if remainder < 2, do: 0, else: @division - remainder
  end

  defp character_valid(cpfcnpj, valid_type) do
    valid_type
    |> case do
      {:cpf, :first} -> @cpf_algs_1
      {:cnpj, :first} -> @cnpj_algs_1
      {:cpf, :second} -> @cpf_algs_2
      {:cnpj, :second} -> @cnpj_algs_2
    end
    |> mult_sum(cpfcnpj)
    |> rem(@division)
    |> character_calc()
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
  def format_number({:cpf, string}) do
    if valid?({:cpf, string}) do
      string
      |> String.replace(~r/[^0-9A-Z]/, "")
      |> then(&Regex.replace(@cpf_regex, &1, "\\1.\\2.\\3-\\4"))
    else
      nil
    end
  end

  def format_number({:cnpj, string}) do
    if valid?({:cnpj, string}) do
      string
      |> String.replace(~r/[^0-9A-Za-z]/, "")
      |> then(&Regex.replace(@cnpj_regex, &1, "\\1.\\2.\\3/\\4-\\5"))
    else
      nil
    end
  end

  @doc """
  Gerador de cpf/cnpj concatenado com o dígito verificador.
  """
  @spec generate(:cpf | :cnpj) :: String.t()
  def generate(tp_cpfcnpj) do
    numbers = random_characters(tp_cpfcnpj)
    first_valid_char = character_valid(numbers, {tp_cpfcnpj, :first})
    second_valid_char = character_valid(numbers <> first_valid_char, {tp_cpfcnpj, :second})

    result = numbers <> first_valid_char <> second_valid_char

    # Chance de gerar um inválido seguindo esse algoritmo é baixa o suficiente que
    # vale a pena simplesmente retentar caso o resultado for inválido
    if valid?({tp_cpfcnpj, result}) do
      result
    else
      generate(tp_cpfcnpj)
    end
  end

  def random_characters(:cpf) do
    random_digit_generator = fn -> Enum.random(0..9) end

    random_digit_generator
    |> Stream.repeatedly()
    |> Enum.take(@cpf_length - 2)
    |> Enum.join()
  end

  def random_characters(:cnpj) do
    random_digit_generator = fn ->
      Enum.random(@cnpj_characters)
    end

    random_digit_generator
    |> Stream.repeatedly()
    |> Enum.take(@cnpj_length - 2)
    |> Enum.join()
  end

  # Cnpj pode ter caracteres alfanuméricos, cpf não
  defp replace_invalid_characters(:cnpj, cnpj) do
    String.replace(cnpj, ~r/[^a-zA-Z0-9]/, "")
  end

  defp replace_invalid_characters(:cpf, cpf) do
    String.replace(cpf, ~r/[^0-9]/, "")
  end

  defp cnpj_alphanumeric_translation(string) do
    Map.get(@cnpj_character_to_value_map, String.upcase(string, :ascii))
  end
end
