if Code.ensure_compiled(Ecto) do
  defmodule Brcpfcnpj.Changeset do
    @moduledoc """
    Define funções para serem utilizadas em conjunto com a API de changeset do Ecto.
    """

    @type changeset :: Ecto.Changeset.t()
    @type error :: {atom, error_message}
    @type error_message :: String.t() | {String.t(), Keyword.t()}

    @doc """
    Valida se essa mudança é um cnpj válido. Aceita um ou mais fields

    ## Options

      * `:message` - A mensagem em caso de erro, o default é "Invalid Cnpj"

    ## Examples

        validate_cnpj(changeset, :cnpj)

        validate_cnpj(changeset, [:cnpj, :other_cnpj])

    """
    @spec validate_cnpj(changeset(), atom() | list(), Keyword.t()) :: changeset()
    def validate_cnpj(changeset, field), do: validate_cnpj(changeset, field, [])

    def validate_cnpj(changeset, field, opts) when is_atom(field) do
      validate(changeset, field, fn value ->
        if Brcpfcnpj.cnpj_valid?(value) do
          []
        else
          [{field, message(opts, {"Invalid Cnpj", validation: :cnpj})}]
        end
      end)
    end

    def validate_cnpj(changeset, fields, opts) when is_list(fields) do
      Enum.reduce(fields, changeset, fn field, acc_changeset ->
        validate_cnpj(acc_changeset, field, opts)
      end)
    end

    @doc """
    Valida se essa mudança é um cpf válido. Aceita um ou mais fields

    ## Options

      * `:message` - A mensagem em caso de erro, o default é "Invalid Cpf"

    ## Examples

        validate_cpf(changeset, :cpf)

        validate_cpf(changeset, [:cpf, :cnpj])

    """
    @spec validate_cpf(changeset(), atom() | list(), Keyword.t()) :: changeset()
    def validate_cpf(changeset, field), do: validate_cpf(changeset, field, [])

    def validate_cpf(changeset, field, opts) when is_atom(field) do
      validate(changeset, field, fn value ->
        if Brcpfcnpj.cpf_valid?(value) do
          []
        else
          [{field, message(opts, {"Invalid Cpf", validation: :cpf})}]
        end
      end)
    end

    def validate_cpf(changeset, fields, opts) when is_list(fields) do
      Enum.reduce(fields, changeset, fn field, acc_changeset ->
        validate_cpf(acc_changeset, field, opts)
      end)
    end

    defp validate(changeset, field, validator) do
      %{changes: changes, errors: errors} = changeset

      value = Map.get(changes, field)
      new = if is_nil(value), do: [], else: validator.(value)

      case new do
        [] ->
          changeset = %{changeset | errors: Keyword.delete(errors, field)}
          %{changeset | valid?: Enum.count(changeset.errors) == 0}
        [_ | _] -> %{changeset | errors: new ++ errors, valid?: false}
      end
    end

    defp message(opts, default) do
      message = Keyword.get(opts, :message, default)
      format_message(message)
    end

    defp format_message(msg = {_, _}), do: msg
    defp format_message(msg) when is_binary(msg), do: {msg, []}
  end
end
