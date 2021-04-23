LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

ENTITY deterator IS
	PORT (
		  a,b        :IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		  Qout,Rmdr  :OUT STD_LOGIC_VECTOR (7 DOWNTO 0));
END deterator;

ARCHITECTURE maxpll OF deterator IS
BEGIN
PROCESS(a,b)
	VARIABLE Avar,Bvar,Tmp,Tmp1: STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
Avar := a;
Bvar := b;
a_loop: FOR i IN 7 DOWNTO 0 LOOP
	Tmp:=STD_LOGIC_VECTOR(CONV_UNSIGNED(UNSIGNED(Avar(7 DOWNTO i)),8));  --使除数和被除数位数相等,不同则补零
	IF(Tmp >= Bvar)THEN    --当被除数大于除数时，商位置1
		Qout(i)<='1';
		Tmp1 := Tmp-Bvar;  -- 此时余数为被除数-除数
		IF(i/=0)THEN
			Avar(7 DOWNTO i) := Tmp1(7-i DOWNTO 0);
			Avar(i-1) := a(i-1);
		END IF;

	ELSE                   --否则商为置0
		Qout(i)<='0';
		Tmp1 := Tmp;       -- 此时商为被除数本身
	END IF;         
END LOOP a_loop;
Rmdr <= Tmp1; 
END process;
END maxpll;
