
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity temp_cond_p is
    Generic ( N : integer := 8);
    Port ( clk : in std_logic;
           rst : in std_logic;
           temp_raw : in std_logic_vector (N-1 downto 0);
           temp_c : out std_logic_vector (N-1 downto 0));
end temp_cond_p;

architecture Behavioral of temp_cond_p is

    signal a, b : std_logic_vector(N-1 downto 0);
    
    -- registers
    signal r0, r0_n, r1, r1_n : std_logic_vector (N-1 downto 0);

begin
    
    -- clock process
    process(clk, rst)
    begin
      if (rst = '1') then
         r0 <= (others => '0');
         r1 <= (others => '0');
      elsif(rising_edge(clk)) then
         r0 <= r0_n;
         r1 <= r1_n;
      end if;
    end process;

    -- define constants
    a <= std_logic_vector(to_signed(89,N)); -- 0.6923 Q7
    b <= std_logic_vector(to_signed(43,N)); -- 0.3077 Q7
    
    -- adder
    adder0 : entity work.adder_so_sat
    generic map(N => N)
    port map (a1 => b,
              a2 => r0,
              a3 => r1_n,
              ov => open);
    
    -- multiplier       
    mul0 : entity work.mul_q
    generic map(N => N)
    port map (m1 => a,
              m2 => temp_raw,
              m3 => r0_n);
    
    -- r1 is the output register
    temp_c <= r1;
    
end Behavioral;
