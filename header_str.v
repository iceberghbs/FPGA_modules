    function [7:0] toHexChar;
    input  [4:0]   num;
    begin
    case (num)
        0:  toHexChar =     "0";
        1:  toHexChar =     "1";
        2:  toHexChar =     "2";
        3:  toHexChar =     "3";
        4:  toHexChar =     "4";
        5:  toHexChar =     "5";
        6:  toHexChar =     "6";
        7:  toHexChar =     "7";
        8:  toHexChar =     "8";
        9:  toHexChar =     "9";
        10: toHexChar =     "a";
        11: toHexChar =     "b";
        12: toHexChar =     "c";
        13: toHexChar =     "d";
        14: toHexChar =     "e";
        15: toHexChar =     "f";
        default: ;
    endcase
    end
    endfunction   
    
    function [0:31] toNumStr;
    input [0:15] frame_index;
    begin
       toNumStr[0:7] = toHexChar((frame_index/1000)%10); 
       toNumStr[8:15] = toHexChar((frame_index/100)%10); 
       toNumStr[16:23] = toHexChar((frame_index/10)%10); 
       toNumStr[24:31] = toHexChar((frame_index)%10); 
    end
    endfunction