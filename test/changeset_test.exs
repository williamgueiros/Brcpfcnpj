defmodule ChangesetTest do
  use ExUnit.Case
  import Brcpfcnpj.Changeset

  defp cast(changes) do
    %{
      changes: changes,
      errors: [],
      valid?: true
    }
  end

  test "changeset with invalid cnpj" do
    changeset = cast(%{cnpj: "1234"}) |> validate_cnpj(:cnpj)
    refute changeset.valid?
    %{errors: errors} = changeset
    assert errors[:cnpj] == "Invalid Cnpj"
  end

  test "changeset with valid cnpj" do
    changeset = cast(%{cnpj: Brcpfcnpj.cnpj_generate()}) |> validate_cnpj(:cnpj)
    assert changeset.valid?
  end

  test "changeset with invalid cpf" do
    changeset = cast(%{cpf: "1234"}) |> validate_cpf(:cpf)
    refute changeset.valid?
    %{errors: errors} = changeset
    assert errors[:cpf] == "Invalid Cpf"
  end

  test "changeset with valid cpf" do
    changeset = cast(%{cpf: Brcpfcnpj.cpf_generate()}) |> validate_cpf(:cpf)
    assert changeset.valid?
  end

  test "custon error message" do
    changeset =
      cast(%{cnpj: "1234", cpf: "123"})
      |> validate_cnpj(:cnpj, message: "Cnpj Inválido")
      |> validate_cpf(:cpf, message: "Cpf Inválido")

    %{errors: errors} = changeset
    assert errors[:cnpj] == "Cnpj Inválido"
    assert errors[:cpf] == "Cpf Inválido"
  end
end
