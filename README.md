# Atividade Prática III

Relatório da Atividade Prática III (AP3) de INE5406 em 2024.2. 

## Grupo 5

- Fernanda Bertotti Guedes (Matrícula 24100601)
- Laísa Ágathe Bridi Dacroce (Matrícula 24100598)

## Descrição dos circuitos

### Sum of Absolute Differences - V1 (SAD-V1)

Tendo em vista os erros identificados na entrega anterior, foram desenvolvidas adaptações na arquitetura do circuito:

- Retirada do arquivo subtractor_signed e utilização da função abs da biblioteca numeric_std para realização das diferenças absolutas com um bit a mais nas entradas no módulo absoluteDiff;
- Inclusão do estado_atual na lista de sensibilidade do process do registrador, para gerar a lógica de transição entre os estados;
- Adequação do valor somado no registrador cont para 1, com uso da função to_unsigned, no bloco operativo.

O efeito dessas mudanças consta nos dados do arquivo relatorio.json, que descreve um número menor, se comparado à entrega anterior, nos campos "total combinational funtions" e "Fmax".

#### Simulação

Para a simulação, foi elaborado um testbench com os cenários previamente testados no arquivo estimulos.do, visando cobrir testes do reset, enable e cálculo da SAD. 
Contudo, não foi possível verificar o funcionamento do circuito a partir do testbench, pois no ModelSim houve um "Error loading design", conforme mostra a imagem abaixo.

![Mensagem de erro no ModelSim](https://github.com/user-attachments/assets/40944da7-74e4-46df-b3da-9c5f2b703bdf)

### Sum of Absolute Differences - V3 (SAD-V3)

#### Circuito desenvolvido

A arquitetura da SAD-V3 foi adequada da mesma forma que a SAD-V1.

#### Simulação

Para o teste da SAD-V3, foi gerado um arquivo com um conjunto aleatório de dados através da linguagem Python, a ser lido pelo testbench.
