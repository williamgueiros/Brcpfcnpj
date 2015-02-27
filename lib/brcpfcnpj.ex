defmodule Brcpfcnpj do
	
    @doc ~S"""
    Valida Cpf, realiza a chamda ao modulo Cpfcnpj com aos metodos de formar correta.
	forca o desenvolvedor passar os parametros de forma correta

    ## Exemplos
	
		iex> cpf = %Cpf{number: "11144477735"}
		iex> Brcpfcnpj.cpf_valid?(cpf)        
		true

    """
	def cpf_valid?(cpf=%Cpf{}) do
		Cpfcnpj.valid?({cpf.tp_data,cpf.number})
	end

    @doc ~S"""
    Valida Cnpj, realiza a chamda ao modulo Cpfcnpj com aos metodos de formar correta.
	forca o desenvolvedor passar os parametros de forma correta

    ## Exemplos
		iex>cnpj = %Cnpj{number: "69103604000160"}
		iex> Brcpfcnpj.cnpj_valid?(cnpj)           
		true

    """

	def cnpj_valid?(cnpj=%Cnpj{}) do
		Cpfcnpj.valid?({cnpj.tp_data,cnpj.number})
	end
	
    @doc ~S"""
    Valida o Cpf e retorna uma String do Cpf formatado 
	Caso seja invalido retorna nil

    ## Exemplos
		iex>cpfOk = %Cpf{number: "11144477735"}
		iex>Brcpfcnpj.cpf_format(cpfOk)  
		"111.444.777-35"
		
		iex>cpfWrong = %Cpf{number: "11144477734"}
		iex>Brcpfcnpj.cpf_format(cpfWrong)  
		nil
    """
	
	def cpf_format(cpf=%Cpf{}) do
		Cpfcnpj.format_number({cpf.tp_data,cpf.number})
	end
	
    @doc ~S"""
    Valida o Cnpj e retorna uma String do Cnpj formatado 
	Caso seja invalido retorna nil

    ## Exemplos
		iex>cnpjOk = %Cnpj{number: "69103604000160"}
		iex>Brcpfcnpj.cnpj_format(cnpjOk)
		"69.103.604/0001-60"

		iex>cnpjWrong = %Cnpj{number: "69103604000161"}
		iex> Brcpfcnpj.cnpj_format(cnpjWrong)
		nil
    """
	
	def cnpj_format(cnpj=%Cnpj{}) do
		Cpfcnpj.format_number({cnpj.tp_data,cnpj.number})
	end
	
end
