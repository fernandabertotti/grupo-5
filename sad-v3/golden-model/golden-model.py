import random
#gera valores aleatórios de 8 bits (memória)
#50 pares de blocos 8x8
quantidade_numeros = 50
tamanho = 8
with open("estimulos.dat","w") as file:
    for _ in range(quantidade_numeros):
        numero = ''.join(str(random.randint(0,1))for _ in range(tamanho))
        file.write(numero + "\n")
