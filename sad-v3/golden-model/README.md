# Gerador de Arquivo de Estímulos 

O script em Python `golden-model.py` gera um arquivo de estímulos, `estimulos.dat`, que contém valores aleatórios para as entradas e o cálculo da SAD para as saídas.

## Descrição do Código

O código gera 50 linhas, cada uma contendo 16 colunas com valores de 32 bits para as memórias A e B (4 valores de 8 bits para mem_A e 4 valores de 8 bits para mem_B concatenados) e uma última coluna para o valor calculado pela SAD.

## Como Executar

Para executar o arquivo `golden-model.py`, basta:
1. Fazer o download do arquivo `.zip` contendo o projeto.
2. Escolher ou criar uma pasta de destino e extrair o arquivo `.zip` nela.
3. Abrir um terminal e navegar até o diretório onde você extraiu o arquivo `.zip` utilizando o seguinte comando: "cd caminho/para/a/pasta".
4. Ainda no terminal, escrever o comando "python golden-model.py". Dessa forma, um arquivo `estimulos.dat` será gerado no mesmo diretório em que se encontra o projeto extraído.
