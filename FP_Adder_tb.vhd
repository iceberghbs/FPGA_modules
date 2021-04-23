----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/04/07 21:57:18
-- Design Name: 
-- Module Name: FA_Adder_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FP_Adder_tb is
--  Port ( );
end FP_Adder_tb;

architecture Behavioral of FP_Adder_tb is
component FP_Adder
  Port (
        A, B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        S : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) );
end component;

signal A, B, S : STD_LOGIC_VECTOR(31 DOWNTO 0);

begin
    uut : FP_Adder
        port map(A=>A, B=>B, S=>S);

    stim:process
    begin
    
    wait for 100ns;
        A <= "01000010110010001011001100110011";  -- 100.35
        B <= "01000001110011001010001111010111";  -- 25.58
    wait for 100ns;
        A <= "00111111100000000000000000000000";  -- 1.0
        B <= "00111111100000000000000000000000";  -- -1.0
    wait for 100ns;
        A <= "01000001111100100000000000000000";  -- 15.125
        B <= "01000010010110100000000000000000";  -- 42.375
    wait for 100ns;
        A <= "01000010110010001011001100110011";  -- 100.35
        B <= "11000010110010001011001100110011";  -- -100.35
    wait for 100ns;
        A <= "00111111100000000000000000000000";  -- 1.0
        B <= "00111111100000000000000000000000";  -- 1.0
    wait for 100ns;
        A <= "00111111110000000000000000000000";  -- 1.5
        B <= "00111111110000000000000000000000";  -- 1.5

 -- about infinity
    wait for 100ns;
        A <= "01111111100000000000000000000000";  -- infinity
        B <= "00111111110000000000000000000000";  -- 1.5
        
    wait for 100ns;
        A <= "00111111110000000000000000000000";  -- 1.5
        B <= "11111111100000000000000000000000";  -- -infinity
        
    wait for 100ns;
        A <= "01111111100000000000000000000000";  -- infinity
        B <= "01111111100000000000000000000000";  -- infinity
        
    wait for 100ns;
        A <= "11111111100000000000000000000000";  -- -infinity
        B <= "11111111100000000000000000000000";  -- -infinity
        
    wait for 100ns;
        A <= "01111111100000000000000000000000";  -- infinity
        B <= "11111111100000000000000000000000";  -- -infinity

    wait ;
    end process;
    
end Behavioral;
