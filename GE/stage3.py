def stage3(slide_bin, timing_bin, luck3_bin, bonus2_bin, pass2):
    # Convert binary inputs to integers
    slide = binary_to_int(slide_bin)
    timing = binary_to_int(timing_bin)
    luck3 = binary_to_int(luck3_bin)
    bonus2 = binary_to_int(bonus2_bin)

    # Initialize accident and fail variables
    accident0 = accident1 = accident2 = accident3 = 0
    fail0 = fail1 = 0

    # Slide quality logic
    if slide == 0:
        fail0 = 0
    elif slide <= 3:
        accident0 = 1 if (slide ^ luck3) == 0 and bonus2 != 3 else 0
    elif slide > 4:
        accident1 = 1 if (slide ^ luck3) == 1 else 0
    else:
        accident0 = accident1 = 0

    # Report time logic
    if timing == 0:
        fail1 = 0
    elif timing <= 3:
        accident2 = 1 if (timing ^ luck3) == 2 and bonus2 < 1 else 0
    else:
        accident3 = 1 if (timing ^ luck3) == 4 and bonus2 < 2 else 0

    # Calculate bonus3
    bonus3 = 1 if (slide > 4 and accident1 == 0) else 0

    # Calculate 'bad' as the weighted sum of accidents
    bad = accident0 * 2 + accident1 + accident2 * 2 + accident3

    # Determine pass3
    pass3 = 0
    if pass2 and not fail0 and not fail1:
        if bad <= 1:
            pass3 = 1
        elif bonus3:
            pass3 = 1

    return pass3

# Utility function to convert binary list to integer
def binary_to_int(bin_list):
    """Convert binary list to integer."""
    return int("".join(map(str, bin_list)), 2)

# Example Usage:
slide_bin = [0, 1, 1]       # 3-bit binary list for slide (3 in decimal)
timing_bin = [0, 1, 1]      # 3-bit binary list for timing (3 in decimal)
luck3_bin = [1, 0, 1]       # 3-bit binary list for luck3 (5 in decimal)
bonus2_bin = [1, 1]         # 2-bit binary list for bonus2 (3 in decimal)
pass2 = 1               # Boolean for pass2

pass3 = stage3(slide_bin, timing_bin, luck3_bin, bonus2_bin, pass2)
print("Slide:", binary_to_int(slide_bin))
print("Timing:", binary_to_int(timing_bin))
print("Luck3:", binary_to_int(luck3_bin))
print("Bonus2:", binary_to_int(bonus2_bin))
print("Pass2:", pass2)
print("Pass3:", pass3)
