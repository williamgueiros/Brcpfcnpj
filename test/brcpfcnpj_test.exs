defmodule BrcpfcnpjTest do
  @moduledoc false
  use ExUnit.Case
  doctest Brcpfcnpj
  doctest Cpfcnpj

  test "should return the formated cpf" do
    assert Brcpfcnpj.cpf_format("11144477735") == "111.444.777-35"
  end

  test "should return the formated to wrong cpf" do
    assert Brcpfcnpj.cpf_format("11144477731") == nil
  end

  test "should return the formated cnpj" do
    assert Brcpfcnpj.cnpj_format("69103604000160") == "69.103.604/0001-60"
  end

  test "should return the formated to wrong cnpj" do
    assert Brcpfcnpj.cnpj_format("69103604000161") == nil
  end

  test "should generate a valid cpf" do
    assert Brcpfcnpj.cpf_valid?(Brcpfcnpj.cpf_generate())
  end

  test "should generate a valid cnpj" do
    assert Brcpfcnpj.cnpj_valid?(Brcpfcnpj.cnpj_generate())
  end

  test "should generate a formatted cpf" do
    cpf = Brcpfcnpj.cpf_generate(true)
    assert Regex.match?(~r/(\d{3})[.]?(\d{3})[.]?(\d{3})[-]?(\d{2})/, cpf)
    assert Brcpfcnpj.cpf_valid?(cpf)
  end

  test "should generate a formatted cnpj" do
    cnpj = Brcpfcnpj.cnpj_generate(true)
    assert Regex.match?(~r/(\d{2})[.]?(\d{3})[.]?(\d{3})[\/]?(\d{4})[-]?(\d{2})/, cnpj)
    assert Brcpfcnpj.cnpj_valid?(cnpj)
  end

  test "should generate a cpf" do
    cpf = Brcpfcnpj.cpf_generate()
    assert String.length(cpf) == 11
    assert Brcpfcnpj.cpf_valid?(cpf)
  end

  test "should generate a cnpj" do
    cnpj = Brcpfcnpj.cnpj_generate()
    assert String.length(cnpj) == 14
    assert Brcpfcnpj.cnpj_valid?(cnpj)
  end

  test "should always generate valid cpfs" do
    Enum.each(0..5000, fn _ ->
      assert Brcpfcnpj.cpf_valid?(Brcpfcnpj.cpf_generate())
    end)
  end

  test "should always generate valid cnpjs" do
    Enum.each(0..5000, fn _ ->
      assert Brcpfcnpj.cnpj_valid?(Brcpfcnpj.cnpj_generate())
    end)
  end
end
