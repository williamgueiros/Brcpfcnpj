defmodule BrcpfcnpjTest do
	use ExUnit.Case
	doctest Brcpfcnpj
	doctest Cpfcnpj

	test "should return the formated cpf" do
		assert Brcpfcnpj.cpf_format(%Cpf{number: "11144477735"}) =="111.444.777-35"
	end
	test "should return the formated to wrong cpf" do
		assert Brcpfcnpj.cpf_format(%Cpf{number: "11144477731"}) ==nil
	end

	test "should return the formated cnpj" do
    assert Brcpfcnpj.cnpj_format(%Cnpj{number: "69103604000160"}) =="69.103.604/0001-60"
	end

	test "should return the formated to wrong cnpj" do
    assert Brcpfcnpj.cnpj_format(%Cnpj{number: "69103604000161"}) ==nil
	end

	test "should generate a valid cpf" do
		assert Brcpfcnpj.cpf_valid?(%Cpf{ number: Brcpfcnpj.cpf_generate })
	end

	test "should generate a valid cnpj" do
		assert Brcpfcnpj.cnpj_valid?(%Cnpj{ number: Brcpfcnpj.cnpj_generate })
	end

	test "should generate a formatted cpf" do
		assert Regex.match?(~r/(\d{3})[.]?(\d{3})[.]?(\d{3})[-]?(\d{2})/, Brcpfcnpj.cpf_generate(true))
	end

	test "should generate a formatted cnpj" do
		assert Regex.match?(~r/(\d{2})[.]?(\d{3})[.]?(\d{3})[\/]?(\d{4})[-]?(\d{2})/, Brcpfcnpj.cnpj_generate(true))
	end
end
