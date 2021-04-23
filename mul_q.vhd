----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/02/24 09:30:58
-- Design Name: 
-- Module Name: mul_q - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mul_q is
generic( N : integer := 8);
Port (  m1 : in std_logic_vector (N-1 downto 0);
        m2 : in std_logic_vector (N-1 downto 0);
        m3 : out std_logic_vector (N-1 downto 0));
end mul_q;

architecture Behavioral of mul_q is
    signal m1i, m2i : signed(N-1 downto 0);
    signal m3i : signed(2N-1 downto 0);
begin
    m1i <= signed(m1);
    m2i <= signed(m2);
    m3i <= m1i*m2i;
    m3 <= std_logic_vector(m3i(2N-2 downto N-1));  -- q14 to q7
end Behavioral;
