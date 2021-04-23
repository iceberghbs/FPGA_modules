
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Booth_Mult is
  Port (
        In_1, In_2 : in std_logic_vector(7 downto 0);
        clk : in std_logic;
        ready : in std_logic;
        done : out std_logic;
        S : out std_logic_vector(15 downto 0) ); 
end Booth_Mult;

architecture Behavioral of Booth_Mult is

signal multiplicand, multiplier : unsigned(7 downto 0);
signal A, M : unsigned(7 downto 0);
signal Q : unsigned(8 downto 0);
signal AQ, AQ_n: unsigned(16 downto 0);  -- A&Q, A&Q_next
signal AQ_t : unsigned(17 downto 0);

begin
    
    multiplicand <= unsigned(In_1);
    multiplier <= unsigned(In_2);
    
    update:process(clk)
        variable cnt : integer;  -- counting variable
    begin
        if rising_edge(clk) then
            if ready='1' then
                cnt := 0;
                done <= '0';
                M <= multiplicand;
                AQ(8 downto 1) <= multiplier;  -- initialize Q register
                AQ(16 downto 9) <= (others=>'0');  -- initialize A register
                AQ(0) <= '0';  -- initialize implicit bit
            else
                if cnt < 8 then  -- repeat 8 times
                    cnt := cnt + 1;
                    AQ <= AQ_n;  -- update A&Q
                else
                    done <= '1';
                end if;
            end if;
        end if;
    end process;

-- addition/subtraction
    A <= AQ(16 downto 9) + M when Q(1)='0' and Q(0)= '1' else
        AQ(16 downto 9) - M when Q(1)='1' and Q(0)= '0' else
        AQ(16 downto 9);
    Q <= AQ(8 downto 0);

-- arithmically shift
    AQ_t <= '0'&A&Q when A(7)='0' else
            '1'&A&Q;
    AQ_n <= AQ_t(17 downto 1);

-- result
    S <= std_logic_vector(AQ(16 downto 1));
    
end Behavioral;
