library IEEE;
use IEEE.std_logic_1164.all;

entity FA is
port (
    A, B, Cin: in std_logic;
    S, Cout: out std_logic);
end FA;

architecture behav of FA is
begin
    Cout <= (A and B) or (B and Cin) or (A and Cin);
    S <= A xor B xor Cin;
end behav;
