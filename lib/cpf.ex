defmodule Cpf do
  @moduledoc """
  Associa uma strutura de cpf, para validações.
  Os campos são:
    * `number` - Número do cpf ex: 11144477735, 111.444.777-35 ou 111.444.77735
  """
  @type t :: %__MODULE__{}

  defstruct number: nil, tp_data: :cpf
end
