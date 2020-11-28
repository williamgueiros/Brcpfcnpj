defmodule EctoCpfTest do
  use Brcpfcnpj.DataCase

  setup_all do
    migrate(:users)
    :ok
  end

  describe "Ecto.Type" do
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

  describe "Ecto.Repo" do
    defmodule User do
      use Ecto.Schema

      @primary_key {:id, :id, autogenerate: true}
      schema "users" do
        field :name, :string
        field :cpf, EctoCpf
      end

      @doc false
      def changeset(schema = %User{}, attrs) do
        schema
        |> cast(attrs, [:name, :cpf])
        |> validate_required([:name, :cpf])
        |> validate_cpf(:cpf)
      end

      @doc false
      def changeset(attrs), do: changeset(%User{}, attrs)
    end

    test "insert/1 can insert field using type EctoCpf" do
      cpf = Brcpfcnpj.cpf_generate()

      attrs = %{
        name: "Abgobaldo",
        cpf: cpf
      }

      assert %Ecto.Changeset{valid?: true} = changeset = User.changeset(attrs)
      assert %User{cpf: %Cpf{number: ^cpf}} = Repo.insert!(changeset)
    end

    test "get!/1 can select user and returns field using type EctoCpf" do
      cpf = Brcpfcnpj.cpf_generate()

      attrs = %{
        name: "Abgobaldo",
        cpf: cpf
      }

      assert %Ecto.Changeset{valid?: true} = changeset = User.changeset(attrs)
      assert %User{id: user_id, cpf: %Cpf{number: ^cpf}} = Repo.insert!(changeset)
      assert %User{cpf: %Cpf{number: ^cpf}} = Repo.get!(User, user_id)
    end

    test "update!/1 can update user's cpf and returns field using type EctoCpf" do
      cpf = Brcpfcnpj.cpf_generate()

      attrs = %{
        name: "Abgobaldo",
        cpf: cpf
      }

      new_cpf = Brcpfcnpj.cpf_generate()

      assert %Ecto.Changeset{valid?: true} = changeset = User.changeset(attrs)
      assert %User{id: user_id, cpf: %Cpf{number: ^cpf}} = Repo.insert!(changeset)
      assert user = %User{cpf: %Cpf{number: ^cpf}} = Repo.get!(User, user_id)

      assert %Ecto.Changeset{valid?: true} = changeset = User.changeset(user, %{cpf: new_cpf})
      assert %User{id: ^user_id, cpf: %Cpf{number: ^new_cpf}} = Repo.update!(changeset)
    end
  end
end
