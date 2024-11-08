import random

#gera valores aleatórios 
#cálculo da sad
quantidade_numeros = 50
tamanho = 8
with open("estimulos.dat","w") as file:
    for i in range(quantidade_numeros):
        coluna0 = ''.join(str(random.randint(0,1)) for _ in range (1)) #enable 
        coluna1 = ''.join(str(random.randint(0,1)) for _ in range (1)) #reset
        coluna2 = ''.join(str(random.randint(0, 1)) for _ in range(tamanho)) #mem_A
        coluna3 = ''.join(str(random.randint(0, 1)) for _ in range(tamanho)) #mem_B
            
        arquivo.write(f"{coluna0} {coluna1} {coluna2} {coluna3}\n")
        
