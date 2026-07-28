defmodule CpfTest do
  @moduledoc false
  use ExUnit.Case

  test "should be invalid with malformed number" do
    cpfs = ~w{345.65.67.3 567.765-87698 345456-654-01 123456}

    Enum.each(cpfs, fn cpf ->
      assert Brcpfcnpj.cpf_valid?(cpf) == false
    end)
  end

  test "should be invalid with invalid number" do
    cpfs = ~w{23342345699 34.543.567-98 456.676456-87 333333333-33 00000000000 000.000.000-00}

    Enum.each(cpfs, fn cpf ->
      assert Brcpfcnpj.cpf_valid?(cpf) == false
    end)
  end

  test "should be valid with correct number" do
    cpfs = ~w{111.444.777-35 11144477735 111.444777-35 111444.777-35 111.444.77735}

    Enum.each(cpfs, fn cpf ->
      assert Brcpfcnpj.cpf_valid?(cpf) == true
    end)
  end

  test "should be invalid with a number longer than 11 chars, even if the first 11 char represent a valid cpf number" do
    cpfs = ~w{111.444.777-3500 11144477735AB}

    Enum.each(cpfs, fn cpf ->
      assert Brcpfcnpj.cpf_valid?(cpf) == false
    end)
  end

  test "should be invalid with nil input" do
    assert Brcpfcnpj.cpf_valid?(nil) == false
  end

  test "should not allow alphanumeric characters" do
    assert Brcpfcnpj.cpf_valid?("ABC34501D-84") == false
    assert Brcpfcnpj.cpf_valid?("ABC34501D84") == false
  end

  test "should be invalid when an 11-char string contains letters" do
    cpfs = ~w{
      0000invalid 0000INVALID 00000invali 000000nvali 0000000vali
      00000000ali 000000000li 0000000000i 000invalid0 00invalid00
      0invalid000 invalid0000 ifoobar0000
    }

    Enum.each(cpfs, fn cpf ->
      assert Brcpfcnpj.cpf_valid?(cpf) == false, "expected #{cpf} to be invalid"
    end)
  end
end
