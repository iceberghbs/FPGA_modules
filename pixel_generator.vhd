----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/03/01 21:20:26
-- Design Name: 
-- Module Name: pixel_generator - Behavioral
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

entity pixel_generator is
  Port (
        hcount, vcount : in unsigned(10 downto 0); -- from vga_controller
        blank : in std_logic;
        btnU, btnC, btnL, btnR : in std_logic;  -- game controller
        sw : in unsigned(15 downto 8);  -- speed of the ball
        vgaRed, vgaBlue, vgaGreen : out std_logic_vector(3 downto 0);
        points_output : out std_logic_vector(6 downto 0)  -- points you got in the game
        );
end pixel_generator;

architecture Behavioral of pixel_generator is

constant LEFT_MOST : integer := 0;
constant RIGHT_MOST : integer := 639;
constant TOP : integer := 0;
constant BOTTOM : integer := 479;

constant BAR_SIZE_W : integer := 60;
constant BAR_SIZE_H : integer := 20;
constant BALL_R : integer := 20;

constant BAR_COLOR : std_logic_vector(11 downto 0) := "000011110000";  -- blue
constant BALL_COLOR : std_logic_vector(11 downto 0) := "000000001111";  -- green
constant BACK_GROUND : std_logic_vector(11 downto 0) := "000000000000";  -- black

constant BAR_LEFT_DEFAULT_POSITION : integer := LEFT_MOST;
constant BAR_RIGHT_DEFAULT_POSITION : integer := BAR_LEFT_DEFAULT_POSITION + BAR_SIZE_W-1;
constant BAR_BOTTOM : integer := BOTTOM;
constant BAR_TOP : integer := BAR_BOTTOM - BAR_SIZE_H+1;

constant BALL_DEFAULT_POSITION_X : integer :=30;
constant BALL_DEFAULT_POSITION_Y : integer :=30;

constant BAR_SPEED : integer := 20;
-- the horizontal speed and vertical speed of the ball.
-- they are update by a register every frame.
signal ball_speed_h : integer;
signal ball_speed_h_reg : integer;
signal ball_speed_v : integer;
signal ball_speed_v_reg : integer;

-- position of the bar 
signal bar_left : integer;
signal bar_right : integer;

-- position and next position of the ball
signal cx : integer;
signal cy : integer;
signal cx_reg : integer;
signal cy_reg : integer;

-- temp signal when drawing the ball
signal dx, dy : integer;
signal dx2,dy2 : integer ;

signal ball_on :std_logic;
signal bar_on :std_logic;

signal set_go : std_logic:='0';  -- default mode is 'set'.
signal clk_frame : std_logic;  -- one pulse per frame
signal points : unsigned(6 downto 0):=(others=>'0');
signal points_reg : unsigned(6 downto 0):=(others=>'0');
signal point_flag : std_logic:='0';  -- a rising edge when the ball hits the bar and bounce back

signal x : integer;
signal y : integer;

begin

    mode_switching : process(btnU, btnC)
    begin
        if btnU='1' then
            set_go <= '0';
        elsif rising_edge(btnC) then
            set_go <= '1';
        end if;
    end process;

    -- bar circuit
    bar_update: process(set_go, btnU, btnL, btnR, clk_frame)
    variable bar_left_reg : integer;
    variable bar_right_reg : integer;
    begin
        if btnU='1' then  -- reset
            bar_left_reg := BAR_LEFT_DEFAULT_POSITION;
            bar_right_reg := BAR_RIGHT_DEFAULT_POSITION;
        elsif rising_edge(clk_frame) and set_go='1' then
            if btnL='1' then  -- move left when there is space
                if bar_left - BAR_SPEED >= LEFT_MOST then
                    bar_left_reg := bar_left - BAR_SPEED;
                    bar_right_reg := bar_right - BAR_SPEED;
                else  -- next to the wall
                    bar_left_reg := LEFT_MOST;
                    bar_right_reg := LEFT_MOST + BAR_SIZE_W - 1;
                end if;
            elsif btnR='1' then  -- move right
                if bar_right + BAR_SPEED <= RIGHT_MOST then
                    bar_left_reg := bar_left + BAR_SPEED;
                    bar_right_reg := bar_right + BAR_SPEED;
                else  -- next to the wall
                    bar_left_reg := RIGHT_MOST - BAR_SIZE_W + 1;
                    bar_right_reg := RIGHT_MOST;
                end if;
            end if;
        end if;
        bar_left <= bar_left_reg;  -- update
        bar_right <= bar_right_reg;
    end process;
    
    -- ball circuits
    ball_update: process(btnU, set_go, clk_frame)
    begin
        if btnU='1' then  -- rst
            cx <= BALL_DEFAULT_POSITION_X;
            cy <= BALL_DEFAULT_POSITION_Y;
            ball_speed_h <= to_integer(sw(15 downto 12));
            ball_speed_v <= to_integer(sw(11 downto 8));
        elsif rising_edge(clk_frame) and set_go='1' then
            cx <= cx_reg;
            cy <= cy_reg;
            ball_speed_h <= ball_speed_h_reg;
            ball_speed_v <= ball_speed_v_reg;
        end if;
    end process;
    
    -------------------------------- ball_reg update -------------------------------------------
    -- determine speed of the ball in next frame
    -- the ball will bounce back, when hitting the wall or bar, while hitting the BOTTOM will stop.
    ball_speed_h_reg <= - ball_speed_h when (cx_reg = RIGHT_MOST - BALL_R or cx_reg = LEFT_MOST + BALL_R) else
                        0 when cy_reg = BOTTOM - BALL_R else
                        ball_speed_h;

    ball_speed_v_reg <= - ball_speed_v when (cy_reg = TOP + BALL_R or cy_reg = BAR_TOP - BALL_R) else
                        0 when cy_reg = BOTTOM - BALL_R else
                        ball_speed_v;
    -- determine next position of the ball by current position and speed.
    cx_reg <= RIGHT_MOST - BALL_R when (cx + ball_speed_h + BALL_R >= RIGHT_MOST) else
                LEFT_MOST + BALL_R when (cx + ball_speed_h - BALL_R <= LEFT_MOST) else
                cx + ball_speed_h;

    cy_reg <= TOP + BALL_R when cy + ball_speed_v - BALL_R <= TOP else
                BAR_TOP - BALL_R when (cx+ball_speed_h+BALL_R>=BAR_LEFT and cx+ball_speed_h-BALL_R<=BAR_RIGHT 
                and cy+ball_speed_v+BALL_R>=BAR_TOP) else
                BOTTOM - BALL_R when cy + ball_speed_v + BALL_R >= BOTTOM else
                cy + ball_speed_v;
                
    -- points counting
    point_flag <= '1' when cy_reg = BAR_TOP - BALL_R else 
                    '0';
    process(point_flag, btnU)
    begin
        if btnU='1' then
            points <= (others=>'0');
        elsif rising_edge(point_flag) then
            points <= points_reg;
        end if;
    end process;
    points_reg <= points + 1;
    points_output <= std_logic_vector(points);
    
    -- convert to coordinates
    x <= to_integer(hcount);
    y <= to_integer(vcount);
    
    -- frame pulse
    clk_frame <= '1' when y>BOTTOM else
                '0';
    
    -- ball_generation
    dx <= x - cx when x > cx else cx - x;
    dy <= y - cy when y > cy else cy - y;
    dx2 <= dx * dx;
    dy2 <= dy * dy;
    ball_on <= '1' when (dx2 + dy2 < BALL_R) else '0';
    
--     bar_generation
    bar_on <= '1' when (x>=bar_left and x<=bar_right and y>=bar_top and y<=bar_bottom) else
                '0';
    
    -- vga generation
    vgaRed <=   (others=>'0') when blank='1' else
                BALL_COLOR(11 downto 8) when ball_on='1' else
                BAR_COLOR(11 downto 8) when bar_on='1' else
                BACK_GROUND(11 downto 8);
              
    vgaBlue <=  (others=>'0') when blank='1' else
                BALL_COLOR(7 downto 4) when ball_on='1' else
                BAR_COLOR(7 downto 4) when bar_on='1' else
                BACK_GROUND(7 downto 4);
                        
    vgaGreen <= (others=>'0') when blank='1' else
                BALL_COLOR(3 downto 0) when ball_on='1' else
                BAR_COLOR(3 downto 0) when bar_on='1' else
                BACK_GROUND(3 downto 0);

end Behavioral;
