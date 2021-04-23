----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/02/10 23:30:19
-- Design Name: 
-- Module Name: four_digits - Behavioral
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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity four_digits is
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
end four_digits;

architecture Behavioral of four_digits is
-- this is a 4-digits LED controller.
-- with this part, the 4-digits LED now can display 4 different numbers.
signal seg_3 : std_logic_vector(6 downto 0);
signal seg_2 : std_logic_vector(6 downto 0);
signal seg_1 : std_logic_vector(6 downto 0);
signal seg_0 : std_logic_vector(6 downto 0);

begin
    one_digit_3 : entity work.one_digit(Behavioral)  -- decoder for digit 3
        port map (digit => d3, seg => seg_3);

    one_digit_2 : entity work.one_digit(Behavioral)  -- decoder for digit 2
        port map (digit => d2, seg => seg_2);

    one_digit_1 : entity work.one_digit(Behavioral)  -- decoder for digit 1
        port map (digit => d1, seg => seg_1);

    one_digit_0 : entity work.one_digit(Behavioral)  -- decoder for digit 0
        port map (digit => d0, seg => seg_0);
    
    process(ck)
    variable cnt : std_logic_vector(1 downto 0):="00";  -- a variable helps to refresh
    begin
    
        if (ck'event and ck='1') then  -- the central button now acts like a clock
            cnt := cnt + 1;
        end if;

        case cnt is  -- mux41: we connect the 4 decoder for sigal digit and seg bus with a 4 to 1 multiplexer.
            when "00"=> seg<=seg_3;
            when "01"=> seg<=seg_2;
            when "10"=> seg<=seg_1;
            when "11"=> seg<=seg_0;
            when others=> null;
        end case;

        case cnt is  -- sequential pulse generator: corresponding digit lights
            when "00"=> an<="0111";
            when "01"=> an<="1011";
            when "10"=> an<="1101";
            when "11"=> an<="1110";
            when others=> null;
        end case;
        
--        case cnt is  -- pulse generator: the dot point between min and sec is now activated
--            when "00"=> dp<='1';
--            when "01"=> dp<='0';
--            when "10"=> dp<='1';
--            when "11"=> dp<='1';
--            when others=> null;
--        end case;

        end process;
    
end Behavioral;
