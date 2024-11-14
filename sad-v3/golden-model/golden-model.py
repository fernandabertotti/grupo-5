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

        # Adiciona o valor de sad_value convertido para binário de 16 bits ao final da linha
        line_data.append(bin(sad_value)[2:].zfill(14))

        # Escreve todos os valores da linha no arquivo, separados por espaços
        file.write(" ".join(line_data) + "\n")

        

