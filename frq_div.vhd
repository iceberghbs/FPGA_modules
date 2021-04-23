----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/02/12 18:20:07
-- Design Name: 
-- Module Name: frq_div - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity frq_div is
    generic(n:integer:=2);  -- frq_div_coefficient
    Port (  clkin : in STD_LOGIC;
            clkout : out std_logic
            );
end frq_div;

architecture Behavioral of frq_div is
-- frequency divider: f_clkout = f_clkin/n
begin
    process(clkin) 
        variable count:integer range n downto 0:=n;
    begin
        if rising_edge(clkin) then 
            count:=count-1;
            if (count>=n/2) then  -- half clock period is n/2.
                clkout<='0';
            else
                clkout<='1';
            end if;
            if count<=0 then
                count:=n;
            end if;
        end if;
    end process;


end Behavioral;
