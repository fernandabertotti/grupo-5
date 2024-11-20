import random

with open("estimulos.dat", "w") as file:  
    for _ in range(50):
        mem_A = [[random.randint(0, 255) for _ in range(4)] for _ in range(16)]
        mem_B = [[random.randint(0, 255) for _ in range(4)] for _ in range(16)]

        sad_value = 0
        result = []

        for row_A, row_B in zip(mem_A, mem_B):
            for value_A, value_B in zip(row_A, row_B):
                sad_value += abs(value_A - value_B)
            result.extend(bin(value)[2:].zfill(8) for value in row_A)
            result.extend(bin(value)[2:].zfill(8) for value in row_B)

        result.append(bin(sad_value)[2:].zfill(14))

        grouped_result = " ".join("".join(result[i:i + 4]) for i in range(0, len(result), 4))
        file.write(grouped_result + "\n")