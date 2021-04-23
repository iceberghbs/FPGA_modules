----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/02/21 16:01:29
-- Design Name: 
-- Module Name: adder_so_sat - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity adder_so_sat is
    generic( N : integer:=3);
    Port ( a1 : in STD_LOGIC_VECTOR (N-1 downto 0);
       a2 : in STD_LOGIC_VECTOR (N-1 downto 0);
       a3 : out STD_LOGIC_VECTOR (N-1 downto 0);
       ov : out STD_LOGIC);
end adder_so_sat;

architecture Behavioral of adder_so_sat is
    signal a1i, a2i, a3i : signed(N downto 0);
    signal ovi : std_logic;
begin
-- input extention
    a1i <= signed(a1(N-1) & a1);
    a2i <= signed(a2(N-1) & a2);
-- sum
    a3i <= a1i + a2i;
    ovi <= std_logic(a3i(N) xor a3i(N-1));
-- saturation
    a3 <= std_logic_vector(a3i(N-1 downto 0)) ;
--    when ovi = '0' else
--    "01111111" when a3i > 7 else
--    "1001" when a3i < -7;
    ov <= ovi;

end Behavioral;
