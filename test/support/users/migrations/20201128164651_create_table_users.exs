defmodule Brcpfcnpj.TestRepo.Migrations.CreateTableUsers do
  use Ecto.Migration

  def up do
    create table(:users) do
      add(:name, :string)
      add(:cpf, :string)
    end
  end

  def down do
    drop(table(:users))
  end
end
