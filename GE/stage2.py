def binary_to_int(bin_list):
    """Convert binary list to integer."""
    return int("".join(map(str, bin_list)), 2)

def stage2(pass1, bonus1_bin, effort_bin, hard_bin, random2_bin):
    # Convert binary inputs to integers
    bonus1 = binary_to_int(bonus1_bin)
    effort = binary_to_int(effort_bin)
    hard = binary_to_int(hard_bin)
    random2 = random2_bin

    # Determine very_hard, notso_hard, medium_hard based on the 'hard' input
    very_hard = 1 if hard >= 16 else 0
    notso_hard = 1 if hard < 3 else 0
    medium_hard = 1 if not (very_hard or notso_hard) else 0

    # Define hard_rate based on very_hard and medium_hard
    hard_rate = (very_hard << 1) | medium_hard
    
    # Calculate additional_point based on hard_rate and random2
    additional_point = 0
    if hard_rate == 2:  # 2'b10
        additional_point = 7 if (random2[0] or random2[1]) else 0
    elif hard_rate == 1:  # 2'b01
        additional_point = (random2[3] << 2) | (random2[4] << 0)

    # Calculate score
    score = effort - hard + additional_point

    # Calculate pass_test and pass_liver
    pass_test = 1 if score >= 70 else 0
    pass_liver = 1 if (effort - (bonus1 << 2)) > 80 else (random2[4] or random2[5])

    # Calculate pass2 as the AND of pass_test, pass_liver, and pass1
    pass2 = pass_test and pass_liver and pass1

    # Calculate bonus2 based on score
    if score > 94:
        bonus2 = [1, 1]  # 2'b11
    elif score > 87:
        bonus2 = [1, 0]  # 2'b10
    elif score > 80:
        bonus2 = [0, 1]  # 2'b01
    else:
        bonus2 = [0, 0]  # 2'b00

    return bonus2, pass2

# Example Usage:
pass1 = True
bonus1_bin = [1, 0]                 # 2-bit binary list for bonus1
effort_bin = [1, 1, 0, 1, 1, 0, 1]  # 7-bit binary list for effort (45 in decimal)
hard_bin = [1, 0, 0, 1, 1]          # 5-bit binary list for hard (19 in decimal)
random2_bin = [0, 1, 1, 0, 1, 0, 1] # 7-bit binary list for random2

bonus2, pass2 = stage2(pass1, bonus1_bin, effort_bin, hard_bin, random2_bin)
print("pass1:", pass1)
print("bonus1:", binary_to_int(bonus1_bin))
print("effort:", binary_to_int(effort_bin))
print("hard:", binary_to_int(hard_bin))
print("random2:", binary_to_int(random2_bin))
print("Bonus2:", bonus2)
print("Pass2:", pass2)
