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
    assert errors[:cnpj] == {"Invalid Cnpj", validation: :cnpj}
  end

  test "changeset with valid cnpj" do
    changeset = cast(%{cnpj: Brcpfcnpj.cnpj_generate()}) |> validate_cnpj(:cnpj)
    assert changeset.valid?
  end

  test "changeset with invalid cpf" do
    changeset = cast(%{cpf: "1234"}) |> validate_cpf(:cpf)
    refute changeset.valid?
    %{errors: errors} = changeset
    assert errors[:cpf] == {"Invalid Cpf", validation: :cpf}
  end

  test "changeset with valid cpf" do
    changeset = cast(%{cpf: Brcpfcnpj.cpf_generate()}) |> validate_cpf(:cpf)
    assert changeset.valid?
  end

  test "custom error message (string only)" do
    changeset =
      cast(%{cnpj: "1234", cpf: "123"})
      |> validate_cnpj(:cnpj, message: "Cnpj Inválido")
      |> validate_cpf(:cpf, message: "Cpf Inválido")

    %{errors: errors} = changeset
    assert errors[:cnpj] == {"Cnpj Inválido", []}
    assert errors[:cpf] == {"Cpf Inválido", []}
  end

  test "custom error message (addicional info)" do
    changeset =
      cast(%{cnpj: "1234", cpf: "123"})
      |> validate_cnpj(:cnpj, message: {"Cnpj Inválido", additional: "info"})
      |> validate_cpf(:cpf, message: {"Cpf Inválido", additional: "info"})

    %{errors: errors} = changeset
    assert errors[:cnpj] == {"Cnpj Inválido", [additional: "info"]}
    assert errors[:cpf] == {"Cpf Inválido", [additional: "info"]}
  end

  test "changeset with list of invalid cnpj fields" do
    changeset =
      cast(%{my_cnpj: "12345", other_cnpj: "846864"})
      |> validate_cnpj([:my_cnpj, :other_cnpj])

    refute changeset.valid?
    %{errors: errors} = changeset
    assert errors[:my_cnpj] == {"Invalid Cnpj", validation: :cnpj}
    assert errors[:other_cnpj] == {"Invalid Cnpj", validation: :cnpj}
  end

  test "changeset with a list of valid cnpj fields" do
    changeset =
      cast(%{my_cnpj: Brcpfcnpj.cnpj_generate(), other_cnpj: Brcpfcnpj.cnpj_generate()})
      |> validate_cnpj([:my_cnpj, :other_cnpj])

    assert changeset.valid?
  end

  test "changeset with list of invalid cpf fields" do
    changeset =
      cast(%{my_cpf: "12345", other_cpf: "846864"})
      |> validate_cpf([:my_cpf, :other_cpf])

    refute changeset.valid?
    %{errors: errors} = changeset
    assert errors[:my_cpf] == {"Invalid Cpf", validation: :cpf}
    assert errors[:other_cpf] == {"Invalid Cpf", validation: :cpf}
  end

  test "changeset with a list of valid cpf fields" do
    changeset =
      cast(%{my_cpf: Brcpfcnpj.cpf_generate(), other_cpf: Brcpfcnpj.cpf_generate()})
      |> validate_cpf([:my_cpf, :other_cpf])

    assert changeset.valid?
  end
end
