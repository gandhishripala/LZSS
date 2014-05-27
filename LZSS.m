%    Data Compression: LZSS Method Implementation in Matlab
%    Copyright (C) 2014  Shripal A. Gandhi
%    Contact Email: shrigandhi92@gmail.com
%
%    This program is free software; you can redistribute it and/or modify
%    it under the terms of the GNU General Public License as published by
%    the Free Software Foundation; either version 2 of the License, or
%    (at your option) any later version.
%
%    This program is distributed in the hope that it will be useful,
%    but WITHOUT ANY WARRANTY; without even the implied warranty of
%    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%    GNU General Public License for more details.
%
%    You should have received a copy of the GNU General Public License along
%    with this program; if not, write to the Free Software Foundation, Inc.,
%    51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
%
clc;
clear all;
close all;

%Display the Token - Values can be True or False
disp_token = true;
%Display the String Covered in each Token - Values can be True or False
disp_char_string = true;
%Character _ will replace space during execution of Program. Don't use this character in the Input String
replace_space = '_';
%Number of Characters to Match
match_char_num = 2;
%Path to Input File
read_file = fopen('LZSS_Input.txt','r');
%Path to Output File
write_file = fopen('LZSS/LZSS_Output.txt','w');

%Don't Change anything from now Onwards

%Search Buffer
sbuffer = char();
%Look Ahead Buffer
labuffer = fread(read_file, '*char');

for i = 1:length(labuffer)
    if(strcmpi(' ', labuffer(i)))
        labuffer(i) = strrep(labuffer(i), ' ', replace_space);
    end
end

fclose(read_file);

clearvars read_file;

i = 1;
while i <= length(labuffer)
    compare_string = labuffer(i);
    searchresult = strfind(sbuffer, compare_string);
    if(~isempty(searchresult))
        %Inner Loop to Check if Consecutive Characters Match
        continue_loop = true;
        j = 1;
        while continue_loop && ((i+j-1) < length(labuffer))
            compare_string = strcat(compare_string, labuffer(i+j));
            searchresult = strfind(sbuffer, compare_string);
            if(~isempty(searchresult))
                continue_loop = true;
                j = j+1;
            else
                continue_loop = false;
            end
        end
        
        clearvars continue_loop;
        
        %Process the Matched String
        compare_string1 = compare_string(1:end-1);

        if((i+j-1) >= length(labuffer))
            compare_string1 = compare_string;
        end

        compare_string = compare_string1;
        clearvars compare_string1;

        if(~isempty(compare_string) && length(compare_string) >= match_char_num)
            searchresult = strfind(sbuffer, compare_string);
            output = 1;
        else
            output = 2;
        end
        
        clearvars j;
    else
        output = 2;
    end
    
    if output == 1
        token_gen = ['(' num2str(i-searchresult(1)) ', ' num2str(length(compare_string)) ')'];
        if disp_char_string && disp_token
            disp(['String: ' compare_string 9 9 9 'Token: ' token_gen]);
        elseif disp_token
            disp(token_gen);
        elseif disp_char_string
            disp(compare_string);
        end
    elseif output == 2
        token_gen = compare_string;
        if disp_char_string && disp_token
            disp(['String: ' compare_string 9 9 9 'Token: ' token_gen]);
        elseif disp_token
            disp(token_gen);
        elseif disp_char_string
            disp(compare_string);
        end
    end
    fwrite(write_file, token_gen, '*char');
    clearvars token_gen;
    clearvars output;
    clearvars searchresult;
    
    sbuffer = strcat(sbuffer, compare_string);
    i = i + length(compare_string);
    
    clearvars compare_string;
end
fclose(write_file);

clearvars write_file;
clearvars ans;
clearvars i;
clearvars replace_space;
clearvars disp_token;
clearvars disp_char_string;
clearvars match_char_num;
