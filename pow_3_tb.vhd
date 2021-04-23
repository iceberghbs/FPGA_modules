library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity pow_3_tb is
end pow_3_tb;

architecture tb of pow_3_tb is

    signal u1, u2, y : std_logic_vector (7 downto 0);
    
    signal clk, rst : std_logic;
    -- Clock period definitions
    constant Ts : time := 83.33 ns;
    
begin

    p0 : entity work.pow_3
    port map (clk => clk,
              rst => rst,
              u1 => u1,
              u2 => u2,
              y => y);
        
        -- Clock process definitions
       process
       begin
        clk <= '0';
        wait for Ts/2;
        clk <= '1';
        wait for Ts/2;
       end process;
    
    stimuli : process
    begin
        
        rst <= '1';
        u1 <= (others => '0');
        
        wait for 1us;
        
        rst <= '0';            
        u1 <= std_logic_vector(to_signed(19,8)); -- 0.15
        u2 <= std_logic_vector(to_signed(90,8)); -- 0.7     y = 0.6141 ->  79

        wait;
    end process;

end tb;