# Allan Cravid Fernandes
# date - 29-10-2020


# codigo Python correspondente.

R_1 = eval(input("Insira um numero "))
R_2 = eval(input("Insira um numero (o expoente)"))

#########################################################
#                       Problema 1                      #
#########################################################
# 2^R2 = 2*2*2*2 (R2 vezes)

num = 2
acumulador = 2

while (R_2-1) > 0:
    acumulador = acumulador + num
    num = acumulador
    R_2 -= 1

res = acumulador
print(res)

#########################################################
#                       Problema 2                      #
#########################################################
# R1 * 2^R2 = 2^R2 + 2^R2 + 2^R2 + 2^R2...(R1 vezes)
acumulador = 0

while R_1 > 0:
        acumulador += res
        R_1 -= 1

print(acumulador)


    
    