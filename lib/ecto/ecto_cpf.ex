if Code.ensure_loaded?(Ecto) do
  defmodule EctoCpf do
    @doc """
    Um tipo ecto para Cpf. Salva os dados como strings sem pontuação
    e devolve do banco igualmente sem pontuação.
    Aceita o struct Cpf e strings, pontuadas ou não.
    """

    use Ecto.Type

    def type, do: :string

    def cast(cpf) when is_binary(cpf) do
      if Cpfcnpj.valid?({:cpf, cpf}) do
        {:ok, Cpfcnpj.extract_digits(cpf)}
      else
        {:error, [cpf: "Invalid cpf"]}
      end
    end

    def cast(%Cpf{number: number}) do
      {:ok, Cpfcnpj.extract_digits(number)}
    end

    def cast(_), do: :error

    def load(cpf) when is_binary(cpf) do
      {:ok, %Cpf{number: cpf}}
    end

    def load(_), do: :error

    def dump(%Cpf{number: number}), do: {:ok, number}
    def dump(_), do: :error
  end
end
