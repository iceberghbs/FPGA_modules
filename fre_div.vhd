----------------------------------------------------------------------------------
-- Company: ESSEX  -- Engineer: Xinlu Zhang
-- Create Date: 2021/02/15 10:23:46
-- Design Name: countdown timer
-- Module Name: fre_div - Behavioral

--INTRODUCTION:
--This file mainly realizes the frequency division function.
--Detect the original clock signal, add once in every rising edge , 
-- and return to 0 when a certain value is reached
-- By counting to a certain value, the signal clock is assigned. 
-- Among them:
--1khz is used for the display of the seven-segment digital tube, 
--1hz is used for the clock used for countdown
-------------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
library UNISIM;
use UNISIM.VComponents.all;

entity fre_div is 
    GENERIC ( DIV: integer := 2);
    PORT (ck_in : IN STD_LOGIC;
           ck_out: out std_logic );
end fre_div;

architecture Behavioral of fre_div is
signal ck_outi : STD_LOGIC:=ck_in;
signal ck_out_n : STD_LOGIC:='0'; -- use to create different clk 
begin
    --assign 
    ck_out_n <= NOT ck_outi;
    process(ck_in)
    -- set local variable get the quick assignment.
        variable cnt: INTEGER range 0 to DIV-1;
        begin
            if rising_edge(ck_in) then 
                cnt := cnt + 1; -- count
                if cnt = DIV-1 then 
                     ck_outi <= ck_out_n;
                     cnt := 0;
                end if;
            end if;
    end process;        
    ck_out <= ck_outi;     

end Behavioral;
