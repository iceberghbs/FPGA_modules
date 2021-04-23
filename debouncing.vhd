
library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity debouncing is
    generic(N: integer := 10);
    port(	clk: in std_logic;
			rst: in std_logic;
			u: in std_logic;
			delay : in std_logic_vector(N-1 downto 0);
			y: out std_logic);
end debouncing;

architecture arch of debouncing is
	type state_type is (zero, wait0, wait1, one);
	signal state, state_n: state_type;
	
	signal cnt, cnt_n: unsigned(N-1 downto 0);
begin
    -- state register
    process(clk,rst)
    begin
        if (rst='1') then
            state <= zero;
            cnt <= (others => '0');
        elsif (rising_edge(clk)) then
            state <= state_n;
            cnt <= cnt_n;
        end if;
    end process;
    -- next-state/output logic
    process(state,u,cnt,delay)
    begin
        state_n <= state;
        cnt_n <= (others => '0');
        
        case state is
        when zero =>
            y <= '0';
            if u= '1' then
                state_n <= wait0;
            end if;
            
        when wait0 =>
            
            y <= '0';
            
            -- check next state
            if u = '0' then
                state_n <= zero;
            elsif cnt = unsigned(delay) then
                state_n <= one;
            end if;
            
            -- increment counter
            cnt_n <= cnt + 1;
            
        when wait1 =>
            
            y <= '1';
            
            -- check next state
            if u = '1' then
                state_n <= one;
            elsif cnt = unsigned(delay) then
                state_n <= zero;
            end if;
            
            -- increment counter
            cnt_n <= cnt + 1;
            
        when one =>
            y <= '1';
            if u= '0' then
                state_n <= wait1;
            end if;
        end case;
    end process;
end arch;
