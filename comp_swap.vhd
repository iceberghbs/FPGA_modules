
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity comp_swap is
    Generic( N : integer := 16);
    Port ( u1 : in std_logic_vector (N-1 downto 0);
           u2 : in std_logic_vector (N-1 downto 0);
           y1 : out std_logic_vector (N-1 downto 0);
           y2 : out std_logic_vector (N-1 downto 0);
           s : out std_logic);
end comp_swap;

architecture arch of comp_swap is

begin

	process(u1,u2)
    begin
      if (u1 > u2) then
         y1 <= u2;
         y2 <= u1;
         s <= '1';         
      else
         y1 <= u1;
         y2 <= u2;
         s <= '0';
      end if;
    end process;
    
end arch;
