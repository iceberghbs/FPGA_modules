----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/02/26 14:55:59
-- Design Name: 
-- Module Name: binary_2_four_digits - Behavioral
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

entity binary_2_four_digits is
  Port (clk : in std_logic;
        binary_data : in std_logic_vector(6 downto 0);
        seg : out std_logic_vector(6 downto 0);
        an : out std_logic_vector(3 downto 0) );
end binary_2_four_digits;

architecture Behavioral of binary_2_four_digits is
component four_digits
  Port (
      d3 : in std_logic_vector(3 downto 0);
      d2 : in std_logic_vector(3 downto 0);
      d1 : in std_logic_vector(3 downto 0);
      d0 : in std_logic_vector(3 downto 0);
      ck : in std_logic;
      seg : out std_logic_vector(6 downto 0);
      an : out std_logic_vector(3 downto 0)
--        dp : out std_logic
      );
end component;

signal d3 : std_logic_vector(3 downto 0):="0000";
signal d2 : std_logic_vector(3 downto 0):="0000";
signal d1 : std_logic_vector(3 downto 0):="0000";
signal d0 : std_logic_vector(3 downto 0):="0000";
signal dec_data : integer:=0;

begin
dec_data <= to_integer(unsigned(binary_data));

d2 <= std_logic_vector(to_unsigned(dec_data/100, 4));
d1 <= std_logic_vector(to_unsigned((dec_data/10) rem 10, 4));
d0 <= std_logic_vector(to_unsigned(dec_data rem 10, 4));

uut_four_digits : four_digits
    port map ( d3=>d3, d2=>d2, d1=>d1, d0=>d0,
                ck => clk, seg => seg, an => an); 


end Behavioral;
