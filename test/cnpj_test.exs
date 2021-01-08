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

  test "should be invalid when starting with zeroes and order > 0300" do
    assert Brcpfcnpj.cnpj_valid?(%Cnpj{number: "00010000030160"}) == false
  end

  test "should be invalid for basic orders" do
    assert Brcpfcnpj.cnpj_valid?(%Cnpj{number: "11111111030180"}) == false
    assert Brcpfcnpj.cnpj_valid?(%Cnpj{number: "22222222030180"}) == false
    assert Brcpfcnpj.cnpj_valid?(%Cnpj{number: "33333333030180"}) == false
    assert Brcpfcnpj.cnpj_valid?(%Cnpj{number: "44444444030180"}) == false
    assert Brcpfcnpj.cnpj_valid?(%Cnpj{number: "55555555030180"}) == false
    assert Brcpfcnpj.cnpj_valid?(%Cnpj{number: "66666666030180"}) == false
    assert Brcpfcnpj.cnpj_valid?(%Cnpj{number: "77777777030180"}) == false
    assert Brcpfcnpj.cnpj_valid?(%Cnpj{number: "88888888030180"}) == false
    assert Brcpfcnpj.cnpj_valid?(%Cnpj{number: "99999999030180"}) == false
  end
end
