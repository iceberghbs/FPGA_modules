
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pwm is
    generic(N: integer := 8);
    port(clk: in std_logic;
        rst: in std_logic;
        duty: in std_logic_vector(N-1 downto 0);
        y: out std_logic);
end pwm;

architecture arch of pwm is

   signal cnt, cnt_n: unsigned(N-1 downto 0);
   
begin
   -- clock process
   process(clk,rst)
   begin
      if(rst='1') then
         cnt <= (others=>'0');
      elsif(rising_edge(clk)) then
         cnt <= cnt_n;
      end if;
   end process;
   
   -- next-state logic
   cnt_n <= cnt + 1;
   
   -- output logic   
   y <= '1' when (cnt < unsigned(duty)) else
		'0';
end arch;

