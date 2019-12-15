import random

for i in range(20):
    value = random.random()

    if value - 0.5 > 0:
        print("{}. +".format(i))
    else:
        print("{}. -".format(i))

