----------------------------------------------------------------------------------
-- Company:  Queen Mary University of London
-- Design Name: NI_DSDS_demo_core
-- Module Name: NI_DSDB_demo_core - Behavioral
-- Project Name: ECS527U Lab Test 1
-- Target Devices: NI DSDB Board
-- Tool Versions: Vivado 2017.03
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity NI_DSDB_demo_core is
    port (
        sw: in std_logic_vector(7 downto 0);
        elvis_dio: in std_logic_vector(15 downto 0);
        led: out std_logic_vector(7 downto 0);
        btn: in std_logic_vector(3 downto 0);
        CLK: in std_logic;
        ss3: out std_logic_vector(3 downto 0);
        ss2: out std_logic_vector(3 downto 0);
        ss1: out std_logic_vector(3 downto 0);
        ss0: out std_logic_vector(3 downto 0)
    );
end NI_DSDB_demo_core;

architecture structural of NI_DSDB_demo_core is

component Test1
port (
    X, Y: in  std_logic_vector(3 downto 0);
    SEL:  in  std_logic;
    S:    out std_logic_vector(3 downto 0);
    C:    out std_logic
    );
end component;

begin
    ss3 <= elvis_dio(7 downto 4);
    ss2 <= elvis_dio(3 downto 0);
    inst_Test1:Test1
        port map(X=>elvis_dio(7 downto 4), Y=>elvis_dio(3 downto 0),
                    SEL=>elvis_dio(8), S=>ss0, C=>led(0));
end structural;
