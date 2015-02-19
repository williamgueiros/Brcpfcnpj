defmodule Brcpfcnpj do
	
    @doc ~S"""
    Valida Cpf, realiza a chamda ao modulo Cpfcnpj com aos metodos de formar correta.
	forca o desenvolvedor passar os parametros de forma correta

    ## Exemplos

		iex(3)> cpf = %Cpf{number: "11144477735"}
	%Cpf{number: "11144477735", tp_data: :cpf}
		iex(4)> Brcpfcnpj.cpf_valid?(cpf)        
	false

    """
	def cpf_valid?(cpf=%Cpf{}) do
		Cpfcnpj.valid?({cpf.tp_data,cpf.number})
	end

    @doc ~S"""
    Valida Cnpj, realiza a chamda ao modulo Cpfcnpj com aos metodos de formar correta.
	forca o desenvolvedor passar os parametros de forma correta

    ## Exemplos

		iex(7)> cnpj = %Cnpj{number: "69103604000160"}
	%Cnpj{number: "69103604000160", tp_data: :cnpj}
		iex(8)> Brcpfcnpj.cnpj_valid?(cnpj)           
	true

    """

	def cnpj_valid?(cnpj=%Cnpj{}) do
		Cpfcnpj.valid?({cnpj.tp_data,cnpj.number})
	end
	
    @doc ~S"""
    Valida o Cpf e retorna uma String do Cpf formatado 
	Caso seja invalido retorna nil

    ## Exemplos

		iex(7)> cnpj = %Cnpj{number: "69103604000160"}
	%Cnpj{number: "69103604000160", tp_data: :cnpj}
		iex(8)> Brcpfcnpj.cnpj_valid?(cnpj)           
	true

    """
	
	def cpf_format(cpf=%Cpf{}) do
		Cpfcnpj.format_number({cpf.tp_data,cpf.number})
	end
	
    @doc ~S"""
    Valida o Cnpj e retorna uma String do Cnpj formatado 
	Caso seja invalido retorna nil

    ## Exemplos

		iex(7)> cnpj = %Cnpj{number: "69103604000160"}
	%Cnpj{number: "69103604000160", tp_data: :cnpj}
		iex(8)> Brcpfcnpj.cnpj_valid?(cnpj)           
	true

    """
	
	def cnpj_format(cnpj=%Cnpj{}) do
		Cpfcnpj.format_number({cnpj.tp_data,cnpj.number})
	end
	
end
