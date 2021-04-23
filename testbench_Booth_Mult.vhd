----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/04/12 10:44:50
-- Design Name: 
-- Module Name: testbench - Behavioral
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

entity testbench is
--  Port ( );
end testbench;

architecture Behavioral of testbench is

component Booth_Mult
  Port (
        In_1, In_2 : in std_logic_vector(7 downto 0);
        clk : in std_logic;
        ready : in std_logic;
        done : out std_logic;
        S : out std_logic_vector(15 downto 0) ); 
end component;

constant clk_period : time := 10ns;  -- 100Mhz
signal clk : std_logic;
signal In_1, In_2 : std_logic_vector(7 downto 0);
signal ready : std_logic;
signal done : std_logic:='0';
signal S : std_logic_vector(15 downto 0);

begin

    uut : Booth_Mult
        port map(In_1=>In_1, In_2=>In_2, clk=>clk, ready=>ready,
                    done=>done, S=>S);
    
    clock : process
    begin
        wait for clk_period/2;
            clk <= '0';
        wait for clk_period/2;
            clk <= '1';
    end process;

    stim: process
    begin
    
        wait for 100ns;
            ready <= '1';
            In_1 <= std_logic_vector(to_signed(3, 8));
            In_2 <= std_logic_vector(to_signed(-7, 8));
            wait for 50ns;
            ready <= '0';
            
        wait for 200ns;
            ready <= '1';
            In_1 <= std_logic_vector(to_signed(-7, 8));
            In_2 <= std_logic_vector(to_signed(3, 8));
            wait for 50ns;
            ready <= '0';
    
        wait for 200ns;
            ready <= '1';
            In_1 <= std_logic_vector(to_signed(1, 8));
            In_2 <= std_logic_vector(to_signed(1, 8));
            wait for 50ns;
            ready <= '0';
            
        wait for 200ns;
            ready <= '1';
            In_1 <= std_logic_vector(to_signed(2, 8));
            In_2 <= std_logic_vector(to_signed(3, 8));
            wait for 50ns;
            ready <= '0';
            
        wait for 200ns;
            ready <= '1';
            In_1 <= std_logic_vector(to_signed(-2, 8));
            In_2 <= std_logic_vector(to_signed(2, 8));
            wait for 50ns;
            ready <= '0';
            
        wait;
    end process;
end Behavioral;
