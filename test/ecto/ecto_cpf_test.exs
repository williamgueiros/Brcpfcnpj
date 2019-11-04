defmodule EctoCpfTest do
  use ExUnit.Case

  test "cast/1 string with punctuation" do
    assert {:ok, %Cpf{number: "84783639124"}} = EctoCpf.cast("847.836.391-24")
  end

  test "cast/1 string without punctuation" do
    assert {:ok, %Cpf{number: "84783639124"}} = EctoCpf.cast("84783639124")
  end

  test "cast/1 struct with punctuation" do
    assert {:ok, %Cpf{number: "84783639124"}} = EctoCpf.cast(%Cpf{number: "847.836.391-24"})
  end

  test "cast/1 struct without punctuation" do
    assert {:ok, %Cpf{number: "84783639124"}} = EctoCpf.cast(%Cpf{number: "84783639124"})
  end

  test "dump/1" do
    assert {:ok, "84783639124"} = EctoCpf.dump(%Cpf{number: "84783639124"})
  end

  test "load/1" do
    assert {:ok, %Cpf{number: "84783639124"}} = EctoCpf.load("84783639124")
  end
end
