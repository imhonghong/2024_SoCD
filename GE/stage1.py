def binary_to_int(bin_list):
    """Convert binary list to integer."""
    return int("".join(map(str, bin_list)), 2)

def stage1(speed_bin, random1_bin, breakfast_bin, movement_bin, weather_bin):
    # Convert binary inputs to integers
    speed = binary_to_int(speed_bin)
    random1 = random1_bin
    breakfast = binary_to_int(breakfast_bin)
    movement = movement_bin
    weather = binary_to_int(weather_bin)  # Convert single-bit binary list to integer
    
    # Set speed bounds based on weather
    speed_LowerBound = 30 if weather else 20
    speed_UpperBound = 70 if weather else 50
    
    # Determine conditions for over speed, turtle speed, late, car accident, and no parking
    over_speed = 1 if speed > speed_UpperBound else 0
    turtle_speed = 1 if speed < speed_LowerBound else 0
    late = (random1[2] ^ random1[3]) if turtle_speed else 0
    car_accident = (random1[0] | random1[1]) if over_speed else 0
    no_parking = random1[4] & random1[2] & random1[0]
    
    # Determine if the pass is successful
    pass1 = not (car_accident or no_parking or late)
    
    # Initialize bonus1 to (2-bit) based on breakfast and movement conditions
    bonus1 = [0, 0]
    
    if breakfast == 1:  # 2'b01
        if over_speed:
            bonus1 = [0, int(any(movement))]
        else:
            bonus1 = [0, int(movement[0] ^ movement[1])]
    
    elif breakfast == 2:  # 2'b10
        if over_speed:
            bonus1 = [int(any(movement)), 0]
        elif turtle_speed:
            bonus1 = [int(movement[1] & random1[2]), 0]
        else:
            bonus1 = [int(movement[1] ^ movement[0] ^ random1[0]), 0]
    
    elif breakfast == 3:  # 2'b11
        if movement == [random1[3], random1[5]]:
            bonus1 = [1, 1]
        else:
            bonus1 = [0, 0]
    
    return bonus1, pass1

# Example Usage:
speed_bin = [1, 0, 1, 0, 0, 1, 1]       # 7-bit binary list for speed (45 in decimal)
random1_bin = [0, 1, 1, 1, 1, 1, 1]     # 7-bit binary list for random1
breakfast_bin = [1, 0]                  # 2-bit binary list for breakfast (2 in decimal)
movement_bin = [1, 0]                   # 2-bit binary list for movement
weather_bin = [1]                       # 1-bit binary list for weather (True)

bonus1, pass1 = stage1(speed_bin, random1_bin, breakfast_bin, movement_bin, weather_bin)
print("speed:", binary_to_int(speed_bin))
print("random1:", binary_to_int(random1_bin))
print("breakfast:", binary_to_int(breakfast_bin))
print("movement:", binary_to_int(movement_bin))
print("weather:", binary_to_int(weather_bin))
print("Bonus1:", bonus1)
print("Pass1:", pass1)
