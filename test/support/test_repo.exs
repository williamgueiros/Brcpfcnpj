defmodule Brcpfcnpj.TestRepo do
  use Ecto.Repo,
    otp_app: :brcpfcnpj,
    adapter: Ecto.Adapters.Postgres
end

ecto_repo_config = [
  username: "postgres",
  password: "postgres",
  database: "brcpfcnpj_test",
  hostname: "localhost"
]

Application.put_env(:brcpfcnpj, Brcpfcnpj.TestRepo, ecto_repo_config)
Application.put_env(:brcpfcnpj, :ecto_repos, [Brcpfcnpj.TestRepo])

Mix.Tasks.Ecto.Drop.run([])
Mix.Tasks.Ecto.Create.run([])

Brcpfcnpj.TestRepo.start_link()
