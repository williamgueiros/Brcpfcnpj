defmodule CpfTest do
  use ExUnit.Case

  test "should be invalid with malformed number" do
    cpfs = ~w{345.65.67.3 567.765-87698 345456-654-01 123456}

    Enum.each(cpfs, fn cpf ->
      assert Brcpfcnpj.cpf_valid?(%Cpf{number: cpf}) == false
    end)
  end

  test "should be invalid with invalid number" do
    cpfs = ~w{23342345699 34.543.567-98 456.676456-87 333333333-33 00000000000 000.000.000-00}

    Enum.each(cpfs, fn cpf ->
      assert Brcpfcnpj.cpf_valid?(%Cpf{number: cpf}) == false
    end)
  end

  test "should be valid with correct number" do
    cpfs = ~w{111.444.777-35 11144477735 111.444777-35 111444.777-35 111.444.77735}

    Enum.each(cpfs, fn cpf ->
      assert Brcpfcnpj.cpf_valid?(%Cpf{number: cpf}) == true
    end)
  end

  test "should be invalid with a number longer than 11 chars, even if the first 11 char represent a valid cpf number" do
    cpfs = ~w{111.444.777-3500 11144477735AB}

    Enum.each(cpfs, fn cpf ->
      assert Brcpfcnpj.cpf_valid?(%Cpf{number: cpf}) == false
    end)
  end

  test "should be invalid with nil input" do
    assert Brcpfcnpj.cpf_valid?(%Cpf{number: nil}) == false
  end
end
