----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 29.01.2021 10:24:17
-- Design Name: 
-- Module Name: main3_final_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

library UNISIM;
use UNISIM.VComponents.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main3_final_tb is
--  Port ( );
end main3_final_tb;

architecture Behavioral of main3_final_tb is

Component main
	PORT( Hsync, Vsync: OUT STD_LOGIC;      -- Horizontal and vertical sync pulses for VGA
          -- 4-bit colour values output to DAC on Basys 3 board
          vgaRed, vgaBlue, vgaGreen: OUT STD_LOGIC_VECTOR(3 downto 0);
          CLK: IN STD_LOGIC;                -- 50 MHz clock
          sw: IN UNSIGNED(15 downto 8);     -- Switches for velocity input
          btnC, btnU: IN STD_LOGIC;         -- Pushbuttons for go and reset respectively
          seg: OUT STD_LOGIC_VECTOR(6 downto 0); -- 7-seg cathodes 
          an: OUT STD_LOGIC_VECTOR(3 downto 0)   -- 7-seg anodes       
          );	
	End Component;

Component tb_vga_driver
	PORT( 
	      clk_vga: IN STD_LOGIC;                -- 50 MHz clock
	      vs, hs: IN STD_LOGIC;      -- Horizontal and vertical sync pulses for VGA
          -- 4-bit colour values output to DAC on Basys 3 board
          red, green, blue: IN STD_LOGIC_VECTOR(3 downto 0)
        --  rst_n: STD_LOGIC    
          );	
	End Component;

signal clk_in : std_logic := '0';
signal clk_vga : std_logic := '0';
signal sw_in : UNSIGNED (15 downto 8) := (others => '0');
signal btnU_in, btnD_in, btnL_in, btnR_in, btnC_in  : STD_LOGIC := '0';
signal seg_out : STD_LOGIC_VECTOR(6 downto 0); 
signal dp_out : STD_LOGIC;
signal an_out : STD_LOGIC_VECTOR(3 downto 0);
signal Seg_output : integer;
signal red,green,blue: STD_LOGIC_VECTOR(3 downto 0);
signal vs,hs: STD_LOGIC;

constant clk_period : time := 10 ns;
constant clk_vga_period  : time := 40 ns;

  function Seg_2_Dec (
    Seg : in std_logic_vector(6 downto 0))
    return integer is
    variable v_TEMP : integer;
  begin
    if (Seg = "1000000") then
      v_TEMP := 0;
    elsif (Seg = "1111001" ) then
      v_TEMP := 1;
    elsif (Seg = "0100100" ) then
      v_TEMP := 2;
    elsif (Seg = "0110000" ) then
      v_TEMP := 3;
    elsif (Seg = "0011001" ) then
      v_TEMP := 4;
    elsif (Seg = "0010010" ) then
      v_TEMP := 5;
    elsif (Seg = "0000010" ) then
      v_TEMP := 6;
    elsif (Seg = "1111000" ) then
      v_TEMP := 7;
    elsif (Seg = "0000000" ) then
      v_TEMP := 8;
    elsif (Seg = "0010000" ) then
      v_TEMP := 9;
    elsif (Seg = "0000110" ) then
      v_TEMP := 99;
    end if;
    return (v_TEMP);
  end;


begin

sw_in <= "11110000"; -- change it as needed for your ball speed.

uut: main PORT MAP (
        sw => sw_in,
        clk => clk_in,
        btnU => btnU_in,
        vgaRed => red,
        vgaBlue => blue,
        vgaGreen => green,
        Hsync => hs,
        Vsync => vs,
       -- btnD => btnD_in,
       -- btnL => btnL_in,
      --  btnR => btnR_in,
        btnC => btnC_in,
        seg => seg_out,
    --    dp => dp_out,
        an => an_out
       );
       
uut2: tb_vga_driver PORT MAP (
        clk_vga => clk_vga,
        vs => vs,
        hs => hs,
        red => red,
        green => green,
        blue => blue
       );       
       
 Seg_output <= Seg_2_Dec(seg_out);     

clk_process :process
    begin
        clk_in <= '0';
        wait for clk_period/2;
        clk_in <= '1';
        wait for clk_period/2;
    end process;

VGA_clk_process :process
    begin
        clk_vga <= '0';
        wait for clk_vga_period/2;
        clk_vga <= '1';
        wait for clk_vga_period/2;
    end process;
-- please add you test processes here..
stim_proc: process
    begin
   -- wait for 10 ms;
  --  btnC_in <= '0';
   -- wait for 10 ms;
   -- btnC_in <= '1';
   -- wait for 15 ms;
   -- btnC_in <= '0';
    wait;
    end process;
    
    
    
end Behavioral;
