# Gerador de Arquivo de Estímulos (estimulos.dat)

O script em Python `golden-model.py` gera um arquivo de estímulos, `estimulos.dat`, que contém valores aleatórios para as entradas e o cálculo da SAD para a saída.

## Descrição do Código

O código executa os seguintes passos:
1. Determina os valores das variáveis `linhas` (representa o número de linhas do arquivo), `numero_colunas` (representa o número de colunas de cada linha com os valores de entrada) e `numero_bits` (representa o número de bits das entradas).
2. Gera valores decimais aleatórios para `mem_A` e `mem_B` e os armazena em uma lista, `line_data`, no formato binário com o número correto de bits, utilizando as funções bin() e zfill(numero_bits). A lista guarda os valores de uma linha. 
3. Calcula a diferença absoluta entre `mem_A`e `mem_B` e adiciona ao valor acumulado da SAD, `sad_value`, o qual é armazenado ao final da lista `line_data`.
4. Escreve todos os valores, separados por espaço, de `line_data` no arquivo de saída `estimulos.dat`.

## Como Executar
