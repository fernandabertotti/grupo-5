# Atividade Prática III

Relatório da Atividade Prática III (AP3) de INE5406 em 2024.2. 

## Grupo 5

- Fernanda Bertotti Guedes (Matrícula 24100601)
- Laísa Ágathe Bridi Dacroce (Matrícula 24100598)

## Descrição dos circuitos

### Sum of Absolute Differences - V1 (SAD-V1)



#### Simulação

O período do ciclo de clock foi definido com base no valor de Fmax obtido no Quartus. O inverso da frequência de 210,66 Mhz resulta em um período de, aproximadamente, 4,75 ns. Utilizando o múltiplo de 10 imediatamente superior, optou-se por um período de 10 ns. O tempo de execução que baseou o arquivo de estímulos foi calculado com o número de ciclos estudado nos slides teóricos, multiplicado pelo período de 10 ns. Portanto, consideramos como sendo 1950 ns.
Na simulação, foram atribuídos os seguintes valores às entradas sample_ori e sample_can:

| sample_ori | sample_can | 
|:----------:|:----------:|
| 11111111 | 00000000 | 
| 00000000 | 11111111 | 
| 00000000 | 00000000 | 

Esperava-se que address aumentasse progressivamente em uma unidade até atingir o valor de N amostras da memória lidas por vez. Já para sad_value, esperava-se obter 11111111111111 nos dois primeiros casos de teste, e 00000000000000 no último caso.
Contudo, não foi possível observar o correto funcionamento do sistema, tendo em vista que as saídas address e sad_value permaneceram com o valor 0, isto é, não foram sensíveis às alterações dos valores das amostras. Inicialmente, acreditamos que isso se devesse ao uso de don't care no bloco de controle, porém, mesmo trocando essa estrutura o comportamento incorreto foi mantido.

### Sum of Absolute Differences - V3 (SAD-V3)

Na SAD-V3, quatro pares de amostras das matrizes A e B são lidos em paralelo. Por este motivo, é atribuído o valor 4 à constante P. Embora o circuito tenha sido desenvolvido com o objetivo de utilizar as constantes B, N e P para generalizar o número de bits dos componentes, encontramos dificuldade para generalizar a descrição do componente ADDERTREE utilizado no bloco operativo. A codificação deste módulo impõe a restrição de que P seja igual a 4, tendo em vista que adderTree possui 4 entradas, o que representa uma limitação do nosso circuito.

#### Circuito desenvolvido

Além dos componentes genéricos utilizados em SAD-V1, consta o seguinte módulo:

- adderTree: Calcula a soma de 4 entradas positivas de N bits sem ocorrer overflow.

No bloco operativo deste circuito, constatamos a necessidade (e conveniência) do uso da estrutura generate em três momentos: para criar os P registradores que armazenam o valor da entrada Mem_A, para criar os P registradores que armazenam o valor da entrada Mem_B, e para criar os P módulos de absoluteDiff. O tipo array serviu de auxílio para armazenar e indexar adequadamente os signals envolvidos nessa parcela do código.

#### Simulação

O período do ciclo de clock foi definido com base no valor de Fmax obtido no Quartus. O inverso da frequência de 116,54 Mhz resulta em um período de, aproximadamente, 8,58 ns. Utilizando o múltiplo de 10 imediatamente superior, optou-se por um período de 10 ns. O tempo de execução que baseou o arquivo de estímulos foi calculado com o número de ciclos estudado nos slides teóricos, multiplicado pelo período de 10 ns. Portanto, consideramos como sendo 510 ns.
Na simulação, foram atribuídos os seguintes valores às entradas sample_ori e sample_can:

| sample_ori | sample_can | 
|:----------:|:----------:|
| 11111111111111111111111111111111 | 00000000000000000000000000000000 | 
| 00000000000000000000000000000000 | 11111111111111111111111111111111 |  
| 00000000000000000000000000000000 | 00000000000000000000000000000000 | 

O comportamento esperado seria um aumento progressivo em uma unidade da saída address, até que atingisse o valor de N dividido por P. O comportamento esperado para sad_value seria correspondente ao descrito para SAD-V1.
Porém, também não foi possível observar o correto funcionamento do sistema, tendo em vista que as saídas address e sad_value permaneceram com o valor 0, isto é, não foram sensíveis às alterações dos valores das amostras. Após algumas alterações no código, por exemplo, tentando criar signals onde constam as saídas sad_value e address, o máximo que se chegou foi um SAD de 00000000000100 nos dois primeiros casos, ainda aquém do comportamento esperado. Acreditamos haver um erro na codificação do acumulador ou do somador, no entanto, não conseguimos identificar o problema a tempo.
