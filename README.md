#Brcpfcnpj
=========

** Valida Cpf/Cnpj e Formatar em String caso necessario **

##Validar Cpf/Cnpj

Foi inspirado na Gem * [brcpfcnpj](https://github.com/tapajos/brazilian-rails/tree/master/brcpfcnpj) 

Recebem strings representando números de cpf/cnpj e verificam a validade destes números usando dois critérios:

1. O formato da string, que deve seguir o padrão xx.xxx.xxx/xxxx-xx, onde 'x' pode ser qualquer dígito de 0 a 9 e os traços (-), barra (/) e pontos (.) *são opcionais*.
2. O conteúdo numérico desta string, que é validado através do cálculo do 'módulo 11' dos dígitos que compõem a string.

### Validando numeros de cpf
```Elixir
cpf = %Cpf{number: "11144477735"}
Brcpfcnpj.cpf_valid?(cpf) # ==> true

cpf = %Cpf{number: "111.444.777-35"}
Brcpfcnpj.cpf_valid?(cpf) # ==> true
 
````
### Validando numero de cnpj
```Elixir
cnpj = %Cnpj{number: "69103604000160"}
Brcpfcnpj.cnpj_valid?(cnpj)# ==> true

cnpj = %Cnpj{number: "69.103.604/0001-60"}
Brcpfcnpj.cnpj_valid?(cnpj)# ==> true
````

##Formatando a String
Existe a possibilidade de alem de validar, ter o retorno da String formatada.
Caso a mesmas seja valida terá o retorno da String em seu divido formato 69.103.604/0001-60.
caso contratio tera de retorno nil.


```Elixir
cpf = %Cpf{number: "11144477735"}      
Brcpfcnpj.cpf_format(cpf)  # ==>"111.444.777-35"

cpf = %Cpf{number: "11144477734"}
Brcpfcnpj.cpf_format(cpf)  # ==> nil
 
````

```Elixir
cnpj = %Cnpj{number: "69103604000160"}
Brcpfcnpj.cnpj_format(cnpj) # ==>"69.103.604/0001-60"

cnpj = %Cnpj{number: "69103604000161"}
Brcpfcnpj.cnpj_format(cnpj) # ==> nil
````

#### Todo

Pretendo acessentar o suporte ao [ecto](https://github.com/elixir-lang/ecto), para o tipo de dado CPF e CNPJ, assim que possivel.
Tenho que estudar se e possivel