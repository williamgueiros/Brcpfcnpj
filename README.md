[![Build Status](https://travis-ci.org/williamgueiros/Brcpfcnpj.svg?branch=master)](https://travis-ci.org/williamgueiros/Brcpfcnpj)
[![Inline docs](http://inch-ci.org/github/williamgueiros/Brcpfcnpj.svg?branch=master)](http://inch-ci.org/github/williamgueiros/Brcpfcnpj)

# Brcpfcnpj

Coleção de funções para validação e formatação de CPF e CNPJ. Veja a
[documentação online](http://hexdocs.pm/brcpfcnpj/).

## Como usar

Adicione ao `mix.exs` do seu projeto:

```elixir
defp deps do
  [{:brcpfcnpj, "~> 0.1.0"}]
end
```

> Para Elixir `< 1.2` utilize a versão `0.0.11`. [Veja detalhes](https://github.com/williamgueiros/Brcpfcnpj/issues/5).

## Validação de CPF/CNPJ

As funções recebem `Strings` representando o número do CPF ou CNPJ e verificam a validade destes números usando dois
critérios:

1. O formato da String, que deve seguir o padrão `XX.XXX.XXX/XXXX-XXX`, onde `X` pode ser qualquer dígito de `0` a `9`,
sendo os traços `-`, barra `/` e pontos `.` opcionais.
2. O conteúdo numérico desta String, validado através do cálculo do `módulo 11` dos dígitos que compõem a String.

A função `Brcpfcnpj.cpf_valid?/1` verifica se uma String é um CPF válido:

```elixir
cpf = %Cpf{number: "11144477735"}
Brcpfcnpj.cpf_valid?(cpf) # ==> true

cpf = %Cpf{number: "111.444.777-35"}
Brcpfcnpj.cpf_valid?(cpf) # ==> true

````

A função `Brcpfcnpj.cnpj_valid?/1` verifica se uma String é um CNPJ válido:

```elixir
cnpj = %Cnpj{number: "69103604000160"}
Brcpfcnpj.cnpj_valid?(cnpj)# ==> true

cnpj = %Cnpj{number: "69.103.604/0001-60"}
Brcpfcnpj.cnpj_valid?(cnpj)# ==> true
````

## Formatando a String

As funções `Brcpfcnpj.cpf_format/1` e `Brcpfcnpj.cnpj_format` retornam a String válida no devido formato. Se a String
não for válida, as funções retornam nil.

```elixir
cpf = %Cpf{number: "11144477735"}
Brcpfcnpj.cpf_format(cpf)  # ==>"111.444.777-35"

cpf = %Cpf{number: "11144477734"}
Brcpfcnpj.cpf_format(cpf)  # ==> nil

````

```elixir
cnpj = %Cnpj{number: "69103604000160"}
Brcpfcnpj.cnpj_format(cnpj) # ==>"69.103.604/0001-60"

cnpj = %Cnpj{number: "69103604000161"}
Brcpfcnpj.cnpj_format(cnpj) # ==> nil
````

## Gerando números CPF e CNPJ

Use as funções `Brcpfcnpj.cpf_generate/1` e `Brcpfcnpj.cnpj_generate/1` para gerar CPFs e CNPJs válidos. O parâmetro
das funções indica se os números devem ser formatados.

```elixir
Brcpfcnpj.cpf_generate true
"468.535.974-78"

Brcpfcnpj.cnpj_generate true
"45.044.251/6215-69"
````

Sem formatação:

```elixir
Brcpfcnpj.cpf_generate
"02239513403"

Brcpfcnpj.cnpj_generate
"17463578863541"
````

## Ecto

O modulo `Brcpfcnpj.Changeset` contém algumas funções que podem ser utilizadas em conjunto com a API de Changesets
do Ecto.

```elixir
import Brcpfcnpj.Changeset

def changeset(model, params \\ :empty) do
  model
  |> cast(params, @required_fields, @optional_fields)
  |> validate_cnpj(:cnpj)
  |> validate_cpf(:cpf)
end
```

Por padrão esses validadores adicionam a mensagem "Invalid CNPJ/CPF" na lista de erros. Essa mensagem pode ser
configurada com o parâmetro `message`:

```elixir
validate_cnpj(:cnpj, message: "Cnpj Inválido")
```

Em caso de duvida [veja mais detalhes](https://github.com/williamgueiros/Brcpfcnpj/issues/3#issuecomment-191368591).

## Contribuições

* [Diogo Beda](https://github.com/diogobeda)
* [Tiago Henrique Engel](https://github.com/tiagoengel)
* [Prakash](https://github.com/prem-prakash)
* [João Thallis](https://github.com/joaothallis)

## Agradecimentos

Inspirado na gem [brcpfcnpj](https://github.com/tapajos/brazilian-rails/tree/master/brcpfcnpj).

