library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

entity NI_DSDB_top is
port (
	sw	: in  std_logic_vector(7 downto 0);
	elvis_dio: in std_logic_vector(15 downto 0);
	btn	: in  std_logic_vector(3 downto 0);
	led	: out std_logic_vector(7 downto 0);
	sysclk_125mhz: in std_logic;
	sseg_ca: out std_logic;
	sseg_cb: out std_logic;
	sseg_cc: out std_logic;
	sseg_cd: out std_logic;
	sseg_ce: out std_logic;
	sseg_cf: out std_logic;
	sseg_cg: out std_logic;
	sseg_dp: out std_logic;
    sseg_an: out std_logic_vector(3 downto 0)
);
end NI_DSDB_top;

architecture dsdb_arch of NI_DSDB_Top is
    component to7seg is
        port (
            d3 	: in  std_logic_vector(3 downto 0); -- BCD digit 3 (Left)
            d2 	: in  std_logic_vector(3 downto 0); -- BCD digit 2 
            d1 	: in  std_logic_vector(3 downto 0); -- BCD digit 1 
            d0 	: in  std_logic_vector(3 downto 0); -- BCD digit 0 (Right)
            a  	: out std_logic_vector(3 downto 0); -- Anode
            c	: out std_logic_vector(6 downto 0); -- Cathode
            clk	: in  std_logic
        );
    end component;

    signal btn_buf: std_logic_vector(3 downto 0);
    -- btn_x: are buffered buttons that give pulses of exactly 1 clock period when pressed
    signal btn_x: std_logic_vector(3 downto 0); 
    signal CLK: std_logic;
    -- 7 segment displays: 4 BCDs
	signal ss3: std_logic_vector(3 downto 0);
	signal ss2: std_logic_vector(3 downto 0);
	signal ss1: std_logic_vector(3 downto 0);
	signal ss0: std_logic_vector(3 downto 0);
	signal sseg_cathode: std_logic_vector(7 downto 0);
    signal clk_divisor: std_logic_vector(26 downto 0); -- 0.9313 Hz

    -- Add your core as a component here
    component NI_DSDB_demo_core is
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
    end component;
begin
    -- Create an instance of your component and port map devices
	core_inst: NI_DSDB_demo_core
	port map (
	   sw => sw,
	   elvis_dio => elvis_dio,
	   led => led,
	   btn => btn, -- don't need to buffer buttons in this lab
	   CLK => sysclk_125mhz,
	   ss3 => ss3,
	   ss2 => ss2,
	   ss1 => ss1,
	   ss0 => ss0
	);

    --
    -- STAY OFF: DO NOT MODIFY THE CODE BELOW --
    --
    -- Clock divisor
    CLK <= sysclk_125mhz;
    --CLK <= clk_divisor(0); -- IF YOU USE A SLOWER CLOCK
	process(sysclk_125mhz)
	begin
		if (sysclk_125mhz'event and sysclk_125mhz = '1') then
			clk_divisor <= clk_divisor + 1;
		end if;
	end process;

    -- handle buttons
    btn_x <= btn and not btn_buf;
    -- Buffer the button to generate a pulse of exactly 1 clock period
    process (CLK)
    begin
        if CLK'event and CLK = '1' then
            btn_buf <= btn;
        end if;
    end process;

    -- 7-segment display decoding
	to7seg_inst: to7seg
        port map (
            d3 => ss3,
            d2 => ss2,
            d1 => ss1,
            d0 => ss0,
            a => sseg_an,
            c => sseg_cathode(6 downto 0),
            clk => sysclk_125mhz
        );
    sseg_cathode(7) <= '1'; -- DP is OFF
    sseg_dp <= sseg_cathode(7);
    sseg_ca <= sseg_cathode(6);
    sseg_cb <= sseg_cathode(5);
    sseg_cc <= sseg_cathode(4);
    sseg_cd <= sseg_cathode(3);
    sseg_ce <= sseg_cathode(2);
    sseg_cf <= sseg_cathode(1);
    sseg_cg <= sseg_cathode(0);
end dsdb_arch;

----------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
-- 7-segment display controller (for NI DSDB Board)
entity to7seg is
	port (
		d3 	: in  std_logic_vector(3 downto 0); -- BCD digit 3 (Left)
		d2 	: in  std_logic_vector(3 downto 0); -- BCD digit 2 
		d1 	: in  std_logic_vector(3 downto 0); -- BCD digit 1 
		d0 	: in  std_logic_vector(3 downto 0); -- BCD digit 0 (Right)
		a  	: out std_logic_vector(3 downto 0); -- Anode
		c	: out std_logic_vector(6 downto 0); -- Cathode
		clk	: in  std_logic
	);
end to7seg;

architecture arch of to7seg is
	component to7seg_single
	port (
		d_in : in  std_logic_vector(3 downto 0);
		q  	 : out std_logic_vector(6 downto 0));
	end component;

	-- component: clock divider for 7 seg display
	component to7seg_clkdiv
	port (
		clk_in:  in  std_logic;
		clk_out: out std_logic);
	end component;

	-- signals
	-- the divided clock and the 1-bit counter (called flag)
	signal clk_div: std_logic;
    signal count: std_logic_vector(1 downto 0);
	-- decoded 7-segment q signals
	signal q0, q1, q2, q3: std_logic_vector(6 downto 0);
begin
	-- port maps
	-- clock divider, divide clock to scanning frequency
	to7seg_clkdiv_inst0: to7seg_clkdiv port map(clk_in => clk, clk_out => clk_div);
	-- 2 individual 7-seg decoder
	to7seg_single_inst3: to7seg_single port map(d_in => d3, q => q3);
	to7seg_single_inst2: to7seg_single port map(d_in => d2, q => q2);
	to7seg_single_inst1: to7seg_single port map(d_in => d1, q => q1);
	to7seg_single_inst0: to7seg_single port map(d_in => d0, q => q0);

	-- counting process for scanning
	process (clk_div)
	begin
		if (clk_div'event and clk_div = '1') then
			count <= count + 1;
		end if;
	end process;

    a <= "0111" when count = "11" else
         "1011" when count = "10" else
         "1101" when count = "01" else
         "1110";
    c <= q3 when count = "11" else
         q2 when count = "10" else
         q1 when count = "01" else
         q0;
end arch;

----------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
-- Standard BCD to 7-segment decoder (Common anode type)
-- Note: turn on a segment by giving '0' to cathode
entity to7seg_single is
    port(
		d_in	: in  std_logic_vector(3 downto 0);
		q  		: out std_logic_vector(6 downto 0));	 
END to7seg_single;

architecture arch of to7seg_single is
	signal qi: std_logic_vector(6 downto 0);	 
begin
	process(d_in)
	begin
		case d_in is
			when "0000" => qi <= "1111110";
			when "0001" => qi <= "0110000";
			when "0010" => qi <= "1101101";
			when "0011" => qi <= "1111001";
			when "0100" => qi <= "0110011";
			when "0101" => qi <= "1011011";
			when "0110" => qi <= "1011111";
			when "0111" => qi <= "1110000";
			when "1000" => qi <= "1111111";
			when "1001" => qi <= "1111011";
			when "1010" => qi <= "1110111";
			when "1011" => qi <= "0011111";
			when "1100" => qi <= "1001110";
			when "1101" => qi <= "0111101";
			when "1110" => qi <= "1001111";
			when "1111" => qi <= "1000111";
			when others => qi <= "0000000";
		end case;
	end process;	
    q <= not qi;
end arch;

----------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;
-- sysclk_125mhz: 125 MHz
-- to match the required refresh frequency 60 Hz to 1 kHz,
-- 17 bits: 953.7 Hz
-- 21 bits: 59.6 Hz
entity to7seg_clkdiv is
	generic (width: integer := 19);
	port (
		clk_in: in std_logic;
		clk_out: out std_logic);
end to7seg_clkdiv;

architecture arch of to7seg_clkdiv is
	signal count: std_logic_vector(width-1 downto 0);
begin
	process(clk_in)
	begin
		if (clk_in'event and clk_in = '1') then
			count <= count + 1;
		end if;
	end process;
	clk_out <= count(width-1); -- output the MSB
end arch;
