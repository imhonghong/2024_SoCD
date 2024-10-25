def stage2(input_str):
    # input str: 19-bit binary string, split to 1,2,7,5,5
    # output: 3-bit binary string
    input_list = str(input_str)
    pass1 = int(input_list[0])
    bonus1 = input_list[1:3]
    effort = input_list[3:10]
    hard = input_list[10:15]
    random2 = input_list[15:20]
    # convert every element from "str" list to "int" list
    effort = [int(i) for i in effort]
    hard = [int(i) for i in hard]
    random2 = [int(i) for i in random2]
    pass1 = bool(pass1)
    bonus1 = [int(i) for i in bonus1]

    effort_dec = int("".join(map(str, effort)), base=2)
    hard_dec = int("".join(map(str, hard)), base=2)
    bonus1_dec = int("".join(map(str, bonus1)), base=2)

    very_hard = hard_dec >= 16
    notso_hard = hard_dec < 3
    medium_hard = not(notso_hard or very_hard)
    if very_hard:
        additional_point = 7 if (random2[4-0] | random2[4-1]) else 0
    elif medium_hard:
        additional_point = random2[4-3]*4 + random2[4-4]
    else:
        additional_point = 0
    score = effort_dec + additional_point - hard_dec if effort_dec + additional_point < 128 else effort_dec + additional_point - hard_dec - 128
    pass_test = score >= 70
    pass_liver = (random2[4-0]|random2[4-4]) if effort_dec + bonus1_dec*4 >=80 else 1
    pass2 = pass1 and pass_test and pass_liver
    pass2 = int(pass2)
    if score > 94:
        bonus2 = "11"
    elif score > 87:
        bonus2 = "10"
    elif score > 80:
        bonus2 = "01"
    else:
        bonus2 = "00"
    output_str = bonus2 + str(pass2)
    return output_str



if __name__ == "__main__" :
    input_file = open("stage2_input.txt", "r")
    output_file = open("stage2_output.txt", "w")
    for line in input_file:
        input_str = line.strip()
        output_str = stage2(input_str)
        print(output_str, file=output_file)
    input_file.close()
    output_file.close()
    print("done")
