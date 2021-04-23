library IEEE;
use IEEE.std_logic_1164.all;

entity Test1 is
port (
    X, Y: in  std_logic_vector(3 downto 0);
    SEL:  in  std_logic;
    S:    out std_logic_vector(3 downto 0);
    C:    out std_logic
    );
end Test1;

architecture Test1_arch of Test1 is

component FA
port (
    A, B, Cin: in std_logic;
    S, Cout: out std_logic);
end component;

signal Xi : std_logic_vector(3 downto 0);
signal K : std_logic_vector(3 downto 0);
signal mux1, mux0 : std_logic_vector(3 downto 0);
signal outi : std_logic_vector(4 downto 0);

begin
    Xi <= not X;
    outi(0) <= '1'; -- carry in LSB is '1'
-- the last digit of my student ID is 8, k=8+1=9
    K <= "1001";
-- two mux2to1
    mux1 <= Y when SEL='1' else
            Xi when SEL='0' else
            (others=>'Z');
    mux0 <= K when SEL='1' else
            Y when SEL='0' else
            (others=>'Z');
            
    ripple_adder:for n in 0 to 3 generate 
        uut_FA:FA port map(A=>mux1(n), B=>mux0(n), 
                            Cin=>outi(n), S=>S(n), 
                            Cout=>outi(n+1));
        end generate;
    C <= outi(4);  -- carry out MSB
    
end Test1_arch;
