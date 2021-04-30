library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity SPI_PWM is
	port	(	SDA		:in std_logic;
				SCL		:in std_logic;
				CS	    :in std_logic;
				enable  :in std_logic;
				CLK50M	:in STD_logic;
				PWMOut	:out std_logic
			);
end SPI_PWM;

architecture Behave of SPI_PWM is
signal pulseCNT		:std_logic_vector(4 downto 0);
signal shiftREG		:std_logic_vector(15 downto 0);
signal shiftEnable	:std_logic;
signal PWMCNT       :std_logic_vector(14 downto 0):=(others=>'0');
signal Period       :std_logic_vector(14 downto 0);
signal Duty         :Std_logic_vector(14 downto 0);
begin

process(CS,SCL,pulseCNT)
begin
	if CS='1' then
		pulseCNT<="00000";  
		shiftEnable<='1';		
	else  -- CS='0'
		if SCL'event and SCL='1' and shiftEnable='1' then
			pulseCNT<=pulseCNT+1;
			shiftREG(15 downto 1)<=shiftREG(14 downto 0);
			shiftREG(0)<=SDA;
		end if;
	end if;

	if pulseCNT="10000" then
		shiftEnable<='0';
		
		if shiftREG(15)='1' then
			Period(14 downto 0)<=shiftREG(14 downto 0);
		else  -- ='0'
			Duty(14 downto 0)<=shiftREG(14 downto 0);
		end if;
	end if;
	
end process;

process(CLK50M)
begin
	if clk50M'event and clk50M='1' and enable='1' then
		PWMCNT<=PWMCNT+1;
		if PWMCNT=Period then
			PWMOut<='1';
			PWMCNT<=(OTHERS=>'0');
		elsif PWMCNT=Duty then
			PWMOut<='0';
		end if;
	end if;
end process;

end Behave;                                                   