defmodule Cnpj do
  @moduledoc """
  Associa uma strutura de Cnpj, para validações.
  Os campos são:
    * `number` - Número do Cnpj ex: 69103604000160, 69.103.604/0001-60 ou 69.103.604000160
  """
  defstruct number: nil, tp_data: :cnpj
end
