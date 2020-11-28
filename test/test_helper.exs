{:ok, _} = Application.ensure_all_started(:ecto)
{:ok, _} = Application.ensure_all_started(:ecto_sql)
{:ok, _} = Application.ensure_all_started(:postgrex)

Code.require_file("support/test_repo.exs", __DIR__)
ExUnit.start()
