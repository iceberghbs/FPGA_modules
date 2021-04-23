----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/04/07 21:27:09
-- Design Name: 
-- Module Name: FA_Adder - Behavioral
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

entity FP_Adder is
  Port (
        A, B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        S : OUT STD_LOGIC_VECTOR(31 DOWNTO 0) );
end FP_Adder;

architecture Behavioral of FP_Adder is
signal as, bs, ss : std_logic;
signal ae, be, exp_i, E : unsigned(7 downto 0);
signal am ,bm : unsigned(23 downto 0);
signal am1, bm1 : unsigned(24 downto 0);
signal sum_m : unsigned(24 downto 0);
--signal sum_hd_m : unsigned(23 downto 0);
signal hdb : std_logic;  -- hidden bit
signal hdb_ov : std_logic;  -- hidden bit overflow

signal M : unsigned(22 downto 0);

begin
    
    as <= A(31);
    bs <= B(31);
    ae <= unsigned(A(30 downto 23));
    be <= unsigned(B(30 downto 23));
    am <= unsigned('0' & A(22 downto 0)) when ae=0 else  -- concates hidden bit
            unsigned('1' & A(22 downto 0));
    bm <= unsigned('0' & B(22 downto 0)) when be=0 else
            unsigned('1' & B(22 downto 0));
    
    
    alignment:process(ae, be, am, bm)
        variable p : integer ;
    begin
        if ae>be then
            p := to_integer(ae - be);
            exp_i <= ae;
            am1 <= '0' & am;
            bm1 <= '0' & (bm srl p);
        elsif ae<be then
            p := to_integer(be - ae);
            exp_i <= be;
            am1 <= '0' & (am srl p);
            bm1 <= '0' & bm;
        else
            p := 0;
            exp_i <= ae;
            am1 <=  '0' & (am srl p);
            bm1 <=  '0' & bm;
        end if;
    end process;
    
    addition:process(am1, bm1, as, bs)
    
    begin
        if (as xor bs)='0' then
            sum_m <= am1 + bm1;
            ss <= as and bs; 
        else
            if am1>bm1 then
                sum_m <= am1 - bm1;
                ss <= as;
            else
                sum_m <= bm1 - am1;
                ss <= bs;
            end if;
        end if;
    end process;
    hdb <= sum_m(23);
    hdb_ov <= sum_m(24);
    
    normalization:process(hdb, hdb_ov, sum_m, exp_i, ss, E, M)
        variable exp_shift : integer;
        variable sum_hd_m : unsigned(23 downto 0);
    begin
        if hdb_ov='1' then
            sum_hd_m := (sum_m(23 downto 0) srl 1);
            M <= sum_hd_m(22 downto 0);
            E <= exp_i + 1;
--            exp_shift := -1;
        else
            if hdb='1' then
                M <= sum_m(22 downto 0);
                E <= exp_i;
            else
                if sum_m=0 then
                    exp_shift := 0;
                elsif sum_m(22 downto 1)=0 then
                    exp_shift := 23;
                elsif sum_m(22 downto 2)=0 then
                    exp_shift := 22;
                elsif sum_m(22 downto 3)=0 then
                    exp_shift := 21;
                elsif sum_m(22 downto 4)=0 then
                    exp_shift := 20;
                elsif sum_m(22 downto 5)=0 then
                    exp_shift := 19;
                elsif sum_m(22 downto 6)=0 then
                    exp_shift := 18;
                elsif sum_m(22 downto 7)=0 then
                    exp_shift := 17;
                elsif sum_m(22 downto 8)=0 then
                    exp_shift := 16;
                elsif sum_m(22 downto 9)=0 then
                    exp_shift := 15;
                elsif sum_m(22 downto 10)=0 then
                    exp_shift := 14;
                elsif sum_m(22 downto 11)=0 then
                    exp_shift := 13;
                elsif sum_m(22 downto 12)=0 then
                    exp_shift := 12;
                elsif sum_m(22 downto 13)=0 then
                    exp_shift := 11;
                elsif sum_m(22 downto 14)=0 then
                    exp_shift := 10;
                elsif sum_m(22 downto 15)=0 then
                    exp_shift := 9;
                elsif sum_m(22 downto 16)=0 then
                    exp_shift := 8;
                elsif sum_m(22 downto 17)=0 then
                    exp_shift := 7;
                elsif sum_m(22 downto 18)=0 then
                    exp_shift := 6;
                elsif sum_m(22 downto 19)=0 then
                    exp_shift := 5;
                elsif sum_m(22 downto 20)=0 then
                    exp_shift := 4;
                elsif sum_m(22 downto 21)=0 then
                    exp_shift := 3;
                elsif sum_m(22 downto 22)=0 then
                    exp_shift := 2;
                else
                    exp_shift := 1;
                end if;
                
                if exp_shift=0 then  -- zero
                    E <= (others=>'0');
                    M <= (others=>'0');
                elsif exp_shift>exp_i then  -- 0.M*2^(-126)
                    E <= (others=>'0');
                    sum_hd_m := (sum_m(23 downto 0) sll to_integer(exp_i));
                    M <= sum_hd_m(22 downto 0);
                else  -- 1.M*2^(E-127)
                    E <= exp_i - exp_shift;  
                    sum_hd_m := (sum_m(23 downto 0) sll exp_shift);
                    M <= sum_hd_m(22 downto 0);
                end if;
                
            end if;
        end if;
        
        if (ae=255 and am(22 downto 0)=0 and as='0') then  -- infinity
            if (be=255 and bm(22 downto 0)=0 and bs='0') then  -- infinity
                S <= "01111111100000000000000000000000";  -- infinity
            elsif (be=255 and bm(22 downto 0)=0 and bs='1') then  -- -infinity
                S <= "01111111100000000000000000000001";  -- NaN
            else  -- real number
                S <= "01111111100000000000000000000000";  -- infinity
            end if;
        elsif (ae=255 and am(22 downto 0)=0 and as='1') then  -- -infinity
            if (be=255 and bm(22 downto 0)=0 and bs='0') then  -- infinity
                S <= "01111111100000000000000000000001";  -- NaN
            elsif (be=255 and bm(22 downto 0)=0 and bs='1') then  -- -infinity
                S <= "11111111100000000000000000000000";  -- -infinity
            else  -- real number
                S <= "11111111100000000000000000000000";  -- -infinity
            end if;
        elsif (be=255 and bm(22 downto 0)=0 and bs='0') then  -- infinity
            if (ae=255 and am(22 downto 0)=0 and as='0') then  -- infinity
                S <= "01111111100000000000000000000000";  -- infinity
            elsif (ae=255 and am(22 downto 0)=0 and as='1') then  -- -infinity
                S <= "01111111100000000000000000000001";  -- NaN
            else  -- real number
                S <= "01111111100000000000000000000000";  -- infinity
            end if;
        elsif (be=255 and bm(22 downto 0)=0 and bs='1') then  -- -infinity
            if (ae=255 and am(22 downto 0)=0 and as='0') then  -- infinity
                S <= "01111111100000000000000000000001";  -- NaN
            elsif (ae=255 and am(22 downto 0)=0 and as='1') then  -- -infinity
                S <= "11111111100000000000000000000000";  -- -infinity
            else  -- real number
                S <= "11111111100000000000000000000000";  -- -infinity
            end if;
        else
            S <= std_logic_vector(ss & E & M);
        end if;
        
    end process;
    
--    S <= std_logic_vector(ss & E & M);
    
end Behavioral;
