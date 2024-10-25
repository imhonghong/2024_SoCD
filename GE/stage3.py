def stage3(input_str):
    # input str: 12-bit binary string, split to 3,3,3,2,1
    # output_str = 1-bit binary string
    input_list = str(input_str)
    slide = input_list[:3]
    timing = input_list[3:6]
    luck3 = input_list[6:9]
    bonus2 = input_list[9:11]
    pass2 = input_list[11]
    # convert every element from "str" list to "int" list
    slide = [int(i) for i in slide]
    timing = [int(i) for i in timing]
    luck3 = [int(i) for i in luck3]
    bonus2 = [int(i) for i in bonus2]
    pass2 = int(pass2)
    # dec
    slide_dec = int("".join(map(str, slide)), base=2)
    timing_dec = int("".join(map(str, timing)), base=2)
    luck3_dec = int("".join(map(str, luck3)), base=2)
    bonus2_dec = int("".join(map(str, bonus2)), base=2)
    # logic
    fail0 = 0
    fail1 = 0
    accident0 = 1
    accident1 = 1
    accident2 = 1
    accident3 = 1
    if slide_dec == 0:
        fail0 = 0
    elif slide_dec <= 3:
        if slide[0]==luck3[0] and slide[1]==luck3[1] and slide[2]==luck3[2]:
            if bonus2_dec == 3:
                accident0 = 0
            else:
                accident0 = 1
        else:
            accident0 = 0
    elif slide_dec > 4:
        accident1 = slide[0]==luck3[0] and slide[1]==luck3[1] and slide[2]!=luck3[2]
    if timing_dec == 0:
        fail1 = 0
    elif timing_dec <= 3:
        if timing[0]==luck3[0] and timing[1] != luck3[1] and timing[2] == luck3[2]:
            if bonus2_dec >= 1 :
                accident2 = 0
            else :
                accident2 = 1
        else:
            accident2 = 0
    else:
        if timing[0] != luck3[0] and timing[1]==luck3[1] and timing[2]==luck3[2]:
            if bonus2_dec >= 2:
                accident3 = 0
            else:
                accident3 = 1
        else: 
            accident3 = 0

    bonus3 = (slide_dec>4 and accident1==0)
    bad = accident0*2 + accident1 + accident2*2 + accident3

    if pass2 and fail0 and fail1:
        if bad<=1:
            pass3 = 1
        else:
            if bonus3:
                pass3 = 1
            else:
                pass3 = 0
    else:
        pass3 = 0
    output_str = str(pass3)
    return output_str

if __name__ == "__main__" :
    input_file = open("stage3_input.txt", "r")
    output_file = open("stage3_output.txt", "w")
    for line in input_file:
        input_str = line.strip()
        output_str = stage3(input_str)
        print(output_str, file=output_file)
    input_file.close()
    output_file.close()
    print("done")
