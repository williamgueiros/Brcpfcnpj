defmodule Cpfcnpj do
	@moduledoc ~S"""
	Modulo responsavel pro realizar todos os calculos de validacao
	
	exemplos:
	
        iex>Cpfcnpj.valid?({:cnpj,"69.103.604/0001-60"})
        true
        iex>Cpfcnpj.valid?({:cpf,"111.444.777-35"})       
        true
	
	Com ou sem os caracteres especiais os mesmos serao validados
	"""
	@division 11
	
	@cpf_legth 11
    @cpf_algs_1 [10, 9, 8, 7, 6, 5, 4, 3, 2,0,0]
    @cpf_algs_2 [11, 10, 9, 8, 7, 6, 5, 4, 3, 2,0]
	@cpf_regex  ~r/(\d{3})?(\d{3})?(\d{3})?(\d{2})/
	
	@cnpj_legth 14
    @cnpj_algs_1 [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2,0,0]
    @cnpj_algs_2 [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2,0]
	@cnpj_regex ~r/(\d{2})?(\d{3})?(\d{3})?(\d{4})?(\d{2})/
	
	def valid?(number_in) do
		if check_number(number_in) != :error, do: type_checker(number_in), else: false
	end
	
    defp check_number(tp_cpfcnpj) do
		cpfcnpj=String.replace(elem(tp_cpfcnpj,1), ~r/[\.\/-]/, "")
		
		all_equal = String.replace(cpfcnpj, String.at(cpfcnpj, 0), "")
		|>String.length
		
		case tp_cpfcnpj do
			{:cpf,_} ->
				if String.length(cpfcnpj) != @cpf_legth or all_equal == 0 do
					:error 
				end
			{:cnpj,_} ->
				if String.length(cpfcnpj) != @cnpj_legth or all_equal == 0 do
					:error
				end
		end
    end
	
	defp type_checker(tp_cpfcnpj) do
		cpfcnpj=String.replace(elem(tp_cpfcnpj,1), ~r/[^0-9]/, "")
		first_char_valid = character_valid(cpfcnpj,{elem(tp_cpfcnpj,0),:first})
		second_char_valid = character_valid(cpfcnpj,{elem(tp_cpfcnpj,0),:second})
		verif = first_char_valid <> second_char_valid
		verif == String.slice(cpfcnpj,-2,2)
	end
	
    defp mult_sum(algs, cpfcnpj) do
		mult = cpfcnpj |> String.codepoints |> Enum.with_index
		|> Enum.map fn {k, v} -> String.to_integer(k) * Enum.at(algs,v) end
		Enum.reduce(mult, 0, &+/2)
    end

	defp character_calc(remainder) do
		if remainder < 2, do: 0, else: @division - remainder
    end
	
    defp character_valid(cpfcnpj,valid_type) do
		case valid_type do
			{:cpf,:first} -> array=@cpf_algs_1
			{:cnpj,:first} -> array=@cnpj_algs_1
			{:cpf,:second} -> array=@cpf_algs_2
			{:cnpj,:second} -> array=@cnpj_algs_2
		end
		
		mult_sum(array, cpfcnpj)
		|> rem(@division)
		|> character_calc 
		|> Integer.to_string
    end

    @doc ~S"""
    Valida o Cpf/Cnpj e retorna uma String com o mesmo formatado
	Caso seja invalido retorna nil

    ## Exemplos
        iex> Cpfcnpj.format_number({:cnpj,"69.103.604/0001-60"})
        "69.103.604/0001-60"

    """
	def format_number(number_in) do
		if valid?(number_in)do
			tp_cpfcnpj={elem(number_in,0),String.replace(elem(number_in,1), ~r/[^0-9]/, "")}
			case tp_cpfcnpj do
				{:cpf,cpf} ->
					Regex.replace(@cpf_regex, cpf,"\\1.\\2.\\3-\\4")
				{:cnpj,cnpj} ->
					Regex.replace(@cnpj_regex, cnpj,"\\1.\\2.\\3/\\4-\\5")
			end
		else
			nil
		end
		
	end
end