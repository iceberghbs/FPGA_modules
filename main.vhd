----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/03/01 20:51:59
-- Design Name: 
-- Module Name: main - Behavioral
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

entity main is
PORT(   Hsync, Vsync: OUT STD_LOGIC;      -- Horizontal and vertical sync pulses for VGA
          -- 4-bit colour values output to DAC on Basys 3 board
          vgaRed, vgaBlue, vgaGreen: OUT STD_LOGIC_VECTOR(3 downto 0);
          CLK: IN STD_LOGIC;                -- 50 MHz clock
          sw: IN unsigned(15 downto 8);     -- Switches for velocity input
          btnC, btnU, btnL, btnR: IN STD_LOGIC;         -- Pushbuttons for go and reset respectively
          seg: OUT STD_LOGIC_VECTOR(6 downto 0); -- 7-seg cathodes 
          an: OUT STD_LOGIC_VECTOR(3 downto 0)   -- 7-seg anodes       
          );
end main;

architecture Behavioral of main is
component pixel_generator
  Port (
        hcount, vcount : in unsigned(10 downto 0); 
        blank : in std_logic;
        btnU, btnC, btnL, btnR : in std_logic;
        sw : in unsigned(15 downto 8);
        vgaRed, vgaBlue, vgaGreen : out std_logic_vector(3 downto 0);
        points_output : out std_logic_vector(6 downto 0)
        );
end component;

component vga_controller_640_60
port(
   rst         : in std_logic;
   pixel_clk   : in std_logic;

   HS          : out std_logic;
   VS          : out std_logic;
   hcount      : out unsigned(10 downto 0);
   vcount      : out unsigned(10 downto 0);
   blank       : out std_logic
);
end component;

component binary_2_four_digits
  Port (clk : in std_logic;
        binary_data : in std_logic_vector(6 downto 0);
        seg : out std_logic_vector(6 downto 0);
        an : out std_logic_vector(3 downto 0) );
end component;

component frq_div
    generic( n : integer);  -- frq_div_coefficient
    Port (  clkin : in STD_LOGIC;
            clkout : out std_logic
            );
end component;

signal hcount : unsigned(10 downto 0);
signal vcount : unsigned(10 downto 0);
signal blank : std_logic;
signal points : std_logic_vector(6 downto 0);
signal clk_25Mhz : std_logic;

begin

-- generate 25Mhz pixel clock
uut_frq_div : frq_div
    generic map(n => 4)
    port map(clkin => CLK, clkout => clk_25Mhz);

-- clock: 25Mhz
-- the points you got are displayed on the four_digits.
uut_binary_2_four_digits: binary_2_four_digits
    port map(clk=>clk_25Mhz, binary_data=>points, seg=>seg, an=>an);

-- clock: 25Mhz
uut_vga_controller_640_60:vga_controller_640_60
    port map(rst=>btnU, pixel_clk=>clk_25Mhz, HS=>Hsync, VS=>Vsync,
                hcount=>hcount, vcount=>vcount, blank=>blank);

-- get control signal and drawing
uut_pixel_generator:pixel_generator
    port map(hcount=>hcount, vcount=>vcount, blank=>blank,
                btnU=>btnU, btnC=>btnC, btnL=>btnL, btnR=>btnR,
                sw=>sw, vgaRed=>vgaRed, vgaBlue=>vgaBlue, vgaGreen=>vgaGreen,
                points_output=>points);


end Behavioral;
