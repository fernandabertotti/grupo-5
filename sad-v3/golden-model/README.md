# Gerador de Arquivo de Estímulos (estimulos.dat)

O script em Python `golden-model.py` gera um arquivo de estímulos, `estimulos.dat`, que contém valores aleatórios para as entradas e o cálculo da SAD para as saídas.

## Descrição do Código

O código executa os seguintes passos:
1. Determina os valores das variáveis `linhas` (representa o número de linhas do arquivo), `numero_colunas` (representa o número de valores que cada memória possui em uma linha) e `numero_bits` (representa o número de bits das entradas). Dessa forma, basta alterar o valor das variáveis para determinar o formato das memórias, sem mexer no restante do código.
2. Gera valores decimais aleatórios para `mem_A` e `mem_B` e os armazena em uma lista, `line_data`, no formato binário com o número correto de bits, utilizando as funções bin() e zfill(numero_bits). A lista guarda os valores de uma linha. 
3. Calcula a diferença absoluta entre `mem_A`e `mem_B` e adiciona ao valor acumulado da SAD, `sad_value`, o qual é armazenado ao final da lista `line_data`.
4. Escreve todos os valores, separados por espaço, de `line_data` no arquivo de saída `estimulos.dat` e repete os passos 2,3 e 4 até o final do número de linhas definido no passo 1.

## Como Executar

Para executar o arquivo `golden-model.py` basta:
1. Fazer o download do arquivo `.zip` contendo o projeto.
2. Escolher ou criar uma pasta de destino e extrair o arquivo `.zip` nela.
3. Abrir um terminal e navegar até o diretório onde você extraiu o arquivo `.zip` utilizando o seguinte comando: "cd caminho/para/a/pasta".
4. Ainda no terminal, escrever o comando "python golden-model.py". Dessa forma, um arquivo `estimulos.dat` será gerado no mesmo diretório em que se encontra o projeto extraído.
