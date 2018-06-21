defmodule CnpjTest do
  use ExUnit.Case

  test "should be invalid with invalid number" do
    cnpjs = ~w{69103604020160 00000000000000 69.103.604/0001-61 01618211000264 11111111111111}

    Enum.each(cnpjs, fn cnpj ->
      assert Brcpfcnpj.cnpj_valid?(%Cnpj{number: cnpj}) == false
    end)
  end

  test "should be invalid with a number longer than 14 chars, even if the first 14 represent a valid number" do
    cnpjs = ~w{691036040001-601 69103604000160a 69103604000160ABC 6910360400016000}

    Enum.each(cnpjs, fn cnpj ->
      assert Brcpfcnpj.cnpj_valid?(%Cnpj{number: cnpj}) == false
    end)
  end

  test "should be valid with correct number" do
    cnpjs =
      ~w{69103604000160 69.103.604/0001-60 01518211/000264 01.5182110002-64 00.000.000/1447-89}

    Enum.each(cnpjs, fn cnpj ->
      assert Brcpfcnpj.cnpj_valid?(%Cnpj{number: cnpj}) == true
    end)
  end

  test "should be invalid with nil input" do
    assert Brcpfcnpj.cnpj_valid?(%Cnpj{number: nil}) == false
  end
end
