
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter32 is
   port(
      clk: in std_logic;
	  rst: in std_logic;
	  cnt_max: in std_logic_vector(31 downto 0);
      irt: out std_logic);
end counter32;

architecture arch of counter32 is

   signal cnt, cnt_n: unsigned(31 downto 0);
   
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
   cnt_n <= (others=>'0') when (cnt = unsigned(cnt_max)-1) else
			cnt + 1;
   
   -- irt logic
   irt <= '1' when (cnt = unsigned(cnt_max)-1) else
		  '0';
end arch;

