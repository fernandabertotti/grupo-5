import random

with open("estimulos.dat", "w") as file:  
    for _ in range(50):
        mem_A = [[random.randint(0, 255) for _ in range(4)] for _ in range(16)]
        mem_B = [[random.randint(0, 255) for _ in range(4)] for _ in range(16)]

        sad_value = 0
        result = []

        for i in range(16):
            for j in range(4):
                abs_value = abs(mem_A[i][j] - mem_B[i][j])
                sad_value += abs_value
            for amostra in mem_A[i]:
                result.append(bin(amostra)[2:].zfill(8))
            for amostra in mem_B[i]:
                result.append(bin(amostra)[2:].zfill(8))
        result.append(bin(sad_value)[2:].zfill(14))

        grouped_result = " ".join("".join(result[i:i + 4]) for i in range(0, len(result), 4))

        file.write(grouped_result + "\n")  
