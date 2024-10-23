input_str = dec2bin(0:2^12-1);

fileID = fopen('stage3_input.txt', 'w');

for i = 1 :size(input_str, 1)
    fprintf(fileID, '%s\n', input_str(i,:));
end

fclose(fileID);