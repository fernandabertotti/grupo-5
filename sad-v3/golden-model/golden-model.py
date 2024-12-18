import random

with open("estimulos.dat", "w") as file:  
    for _ in range(50): #Escrever as 50 linhas de teste da SAD
        mem_A = [[random.randint(0, 255) for _ in range(4)] for _ in range(16)] #Criar matriz mem_A
        mem_B = [[random.randint(0, 255) for _ in range(4)] for _ in range(16)] #Criar matriz mem_B

        sad_value = 0 #Zerar o valor de sad_value a cada linha de teste
        result = [] #Lista para armazenar cada linha do arquivo de estímulos

        #Percorrer as matrizes e realizar o cálculo da SAD, adicionando os valores na lista de resultados
        for row_A, row_B in zip(mem_A, mem_B):
            for value_A, value_B in zip(row_A, row_B):
                sad_value += abs(value_A - value_B)
            result.extend(bin(value)[2:].zfill(8) for value in row_A)
            result.extend(bin(value)[2:].zfill(8) for value in row_B)

        #Adiciona último valor da lista que corresponde ao resultado esperado da SAD
        result.append(bin(sad_value)[2:].zfill(14))

        #Agrupa os valores de mem_A e mem_B tomados 4 a 4 e escreve no arquivo de estímulos
        grouped_result = " ".join("".join(result[i:i + 4]) for i in range(0, len(result), 4))
        file.write(grouped_result + "\n")
