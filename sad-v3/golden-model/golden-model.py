import random

linhas = 50
numero_colunas = 64  # Cada linha terá 64 valores de mem_A e 64 valores de mem_B
numero_bits = 8

with open("estimulos.dat", "w") as file:
    for i in range(linhas):
        sad_value = 0  # Reseta o acumulador SAD a cada nova linha
        line_data = []  # Armazena todos os valores para essa linha

        for j in range(numero_colunas):
            mem_A = random.randint(0, 255)
            mem_B = random.randint(0, 255)

            # Adiciona valores binários de 8 bits para mem_A e mem_B na lista de dados da linha
            line_data.append(bin(mem_A)[2:].zfill(8))
            line_data.append(bin(mem_B)[2:].zfill(8))

            # Cálculo ABS(mem_A - mem_B)
            absolute = abs(mem_A - mem_B)
            # Adiciona ao valor acumulado de SAD
            sad_value += absolute

        # Armazena as variáveis de 32 bits resultantes
        vars_32bits = []  # Lista para armazenar as variáveis de 32 bits geradas

        # Processa line_data em blocos de 8 valores
        for k in range(0, len(line_data) -1, 8): 
            bloco = line_data[k:k+8]  # Seleciona um bloco de 8 valores

            # Concatena valores de índices pares e ímpares
            var_par = "".join(bloco[idx] for idx in range(0, 8, 2))  # Índices pares
            var_impar = "".join(bloco[idx] for idx in range(1, 8, 2))  # Índices ímpares

            # Adiciona as variáveis concatenadas à lista
            vars_32bits.append(var_par)
            vars_32bits.append(var_impar)

        # Adiciona o valor de sad_value convertido para binário de 14 bits ao final
        vars_32bits.append(bin(sad_value)[2:].zfill(14))

        # Escreve todos os valores processados no arquivo, separados por espaços
        file.write(" ".join(vars_32bits) + "\n")
