library ieee;
use ieee.std_logic_1164.all;
use IEEE.NUMERIC_STD.ALL;

entity sort_tb is
end sort_tb;

architecture tb of sort_tb is
    
    constant N : integer := 16;    
    signal u1, u2, u3, u4, u5 : std_logic_vector (N-1 downto 0);
    signal y1, y2, y3, y4, y5 : std_logic_vector (N-1 downto 0);
    signal start, done : std_logic;    
    
    signal clk, rst : std_logic;
    -- Clock period definitions
    constant Ts : time := 83.33 ns;
    
begin
        
        s0 : entity work.sort
        port map (clk => clk,
                  rst => rst,
                  start => start,
                  u1 => u1,
                  u2 => u2,
                  u3 => u3,
                  u4 => u4,
                  u5 => u5,
                  y1 => y1,
                  y2 => y2,
                  y3 => y3,
                  y4 => y4,
                  y5 => y5,
                  done => done);
        
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
        u2 <= (others => '0');
        u3 <= (others => '0');
        u4 <= (others => '0');
        u5 <= (others => '0');
        start <= '0';
        
        wait for 3*Ts;
        
        rst <= '0';            
        u1 <= std_logic_vector(to_signed(29491,16));
        u2 <= std_logic_vector(to_signed(28491,16));
        u3 <= std_logic_vector(to_signed(27491,16));
        u4 <= std_logic_vector(to_signed(26491,16));
        u5 <= std_logic_vector(to_signed(25491,16));
        
        start <= '1';
        
        wait for Ts;
        
        start <= '0';
        
        wait for 10*Ts;
        
        u1 <= std_logic_vector(to_signed(25491,16));
        u2 <= std_logic_vector(to_signed(24491,16));
        u3 <= std_logic_vector(to_signed(26491,16));
        u4 <= std_logic_vector(to_signed(27491,16));
        u5 <= std_logic_vector(to_signed(28491,16));
        
        start <= '1';
        
        wait for Ts;
        
        start <= '0';

        wait;
    end process;

end tb;