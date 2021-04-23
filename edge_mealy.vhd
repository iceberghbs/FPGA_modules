
library ieee;
use ieee.std_logic_1164.all;

entity edge_mealy is
	port(	clk: in std_logic;
			rst: in std_logic;
			u: in std_logic;
			y: out std_logic);
end edge_mealy;

architecture arch of edge_mealy is
	type state_type is (zero, one);
	signal state, state_n: state_type;
begin
	-- clock process
	process(clk,rst)
	begin
		if (rst='1') then
			state <= zero;
		elsif (rising_edge(clk)) then
			state <= state_n;
		end if;
	end process;
	
	-- next-state/output logic
	process(state,u)
	begin
		state_n <= state;
		y <= '0';
		case state is
        when zero=>
			if u= '1' then
				state_n <= one;
				y <= '1';
			end if;
		when one =>
			if u= '0' then
				state_n <= zero;
			end if;
		end case;
	end process;
end arch;
