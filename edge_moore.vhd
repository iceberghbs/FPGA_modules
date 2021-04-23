
library ieee;
use ieee.std_logic_1164.all;

entity edge_moore is
    port(	clk: in std_logic;
			rst: in std_logic;
			u: in std_logic;
			y: out std_logic);
end edge_moore;

architecture arch of edge_moore is
	type state_type is (zero, edge, one);
	signal state, state_n: state_type;
begin
    -- state register
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
                state_n <= edge;
            end if;
        when edge =>
            y <= '1';
            if u= '1' then
                state_n <= one;
            else
                state_n <= zero;
            end if;
        when one =>
            if u= '0' then
                state_n <= zero;
            end if;
        end case;
    end process;
end arch;
