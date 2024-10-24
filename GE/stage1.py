
def stage1(input_str):
    # input str: 19-bit binary string, split to 7,7,2,2,1
    # output: 3-bit binary string
    input_list = str(input_str)
    speed = input_list[:7]
    random1 = input_list[7:14]
    breakfast = input_list[14:16]
    movement = input_list[16:18]
    weather = input_list[18]
    # convert every element from "str" list to "int" list
    speed = [int(i) for i in speed]
    speed_dec = int("".join(map(str, speed)), base=2)
    random1 = [int(i) for i in random1]
    breakfast = [int(i) for i in breakfast]
    movement = [int(i) for i in movement]
    weather = int(weather)
    # pass logic
    speed_Lowerbound = 30 if weather == 1 else 20
    speed_Upperbound = 70 if weather == 1 else 50
    over_speed = speed_dec > speed_Upperbound
    turtle_speed = speed_dec < speed_Lowerbound
    late = (random1[6-2] ^ random1[6-3]) if turtle_speed else 0
    car_accident = (random1[6-0] ^ random1[6-1]) if over_speed else 0
    no_parking = random1[6-4] and random1[6-2] and random1[6-0]
    pass1 = not (late or car_accident or no_parking)
    pass1 = int(pass1)
    # breakfast logic
    if breakfast==[0,0]:
        bonus1 = [0,0]
    elif breakfast==[0,1]:
        bonus1 = [0, movement[0] or movement[1]] if over_speed else [0, movement[0] ^ movement[1]]
    elif breakfast==[1,0]:
        if over_speed:
            bonus1 = [movement[0] or movement[1], 0]
        elif turtle_speed:
            bonus1 = [movement[0] and random1[6-2], 0]
        else:
            bonus1 = [movement[0] ^ movement[1], 0]
    else:
        bonus1 = [1,1] if (movement[1]==random1[6-3] and movement[0]==random1[6-5]) else [0,0]
    # output str = bonus1[0], bonus1[1], pass1
    output_str = str(bonus1[0]) + str(bonus1[1]) + str(pass1)
    return output_str

# read input_str from stage1_input.txt
if __name__ == "__main__" :

    input_file = open("stage1_input.txt", "r")
    output_file = open("stage1_output.txt", "w")
    # read line by line from input file
    
    for line in input_file:
        input_str = line.strip()
        output_str = stage1(input_str)
        print(output_str, file=output_file)
    input_file.close()
    output_file.close()
    print("done")
