defmodule Brcpfcnpj.DataCase do
  use ExUnit.CaseTemplate
  @base_version 20_300_000_000_000

  using do
    quote do
      require Brcpfcnpj.TestRepo, as: Repo

      import Brcpfcnpj.DataCase
      import Ecto
      import Ecto.Query
      import Ecto.Changeset
      import Brcpfcnpj.Changeset
    end
  end

  def migrate(migration_name) do
    path = get_migrations_path_from(migration_name)
    args = ["--migrations-path", path, "--no-deps-check", "--no-compile", "--all"]

    Mix.Tasks.Ecto.Migrate.run(args)

    on_exit(fn ->
      Mix.Tasks.Ecto.Rollback.run(args)
    end)
  end

  defp get_migrations_path_from(:users) do
    Path.join(__DIR__, "users/migrations")
  end
end
