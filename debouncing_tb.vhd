library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity debouncing_tb is
end debouncing_tb;

architecture tb of debouncing_tb is
    
    constant N: integer := 8;
    signal delay: std_logic_vector(N-1 downto 0);
    signal u, y : std_logic;
    
    signal clk, rst : std_logic;
    -- Clock period definitions
    constant Ts : time := 10 ns;

begin

    db0 : entity work.debouncing
    generic map(N => N)
    port map (clk => clk,
              rst => rst,
              delay => delay,
              u => u,
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
        u <= '0';
        delay <= (others => '0');
        
        wait for 5*Ts;
        
        rst <= '0';
        delay <= std_logic_vector(to_unsigned(20,N));
        
        u <= '1';
        wait for 3*Ts;
        
        u <= '0';
        wait for 5*Ts;
        
        u <= '1';
        wait for 10*Ts;
        
        u <= '0';
        wait for 3*Ts;
        
        u <= '1';
        wait for 25*Ts;
        
        u <= '0';
        wait for 2*Ts;
        
        u <= '1';
        wait for 5*Ts;
        
        u <= '0';
        wait for 25*Ts;
                
        wait;
    end process;

end tb;