import random

# gera valores aleatórios
# cálculo da sad:
# cálculo ABS

quantidade_numeros = 20
tamanho = 8
sad_value = 0
with open("estimulos.dat", "w") as file:
    for i in range(quantidade_numeros):
        coluna0 = ''.join(str(random.randint(0, 1)) for _ in range(1))  # enable
        coluna1 = ''.join(str(random.randint(0, 1)) for _ in range(1))  # reset
        coluna2 = ''.join(str(random.randint(0, 1)) for _ in range(tamanho))  # mem_A
        coluna3 = ''.join(str(random.randint(0, 1)) for _ in range(tamanho))  # mem_B

        print(f"{coluna0} {coluna1} {coluna2} {coluna3} {sad_value}")
        #cálculo ABS(pA - pB)
        absolute = bin(abs(int(coluna2,2)-int(coluna3,2)))[2:]
        print(f"{absolute}\n")

        sad_value += int(absolute,2)
        print(f"{bin(sad_value)[2:]}\n")
        #file.write(f"{coluna0} {coluna1} {coluna2} {coluna3} {sad_value}\n")

