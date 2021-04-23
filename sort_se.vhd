----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/03/11 20:21:28
-- Design Name: 
-- Module Name: sort_se - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sort_se is
    Generic ( N : integer := 16);
    Port ( clk : in std_logic;
           rst : in std_logic;
           start : in std_logic;
           u1 : in std_logic_vector (N-1 downto 0);
           u2 : in std_logic_vector (N-1 downto 0);
           u3 : in std_logic_vector (N-1 downto 0);
           u4 : in std_logic_vector (N-1 downto 0);
           u5 : in std_logic_vector (N-1 downto 0);           
           y1 : out std_logic_vector (N-1 downto 0);
           y2 : out std_logic_vector (N-1 downto 0);
           y3 : out std_logic_vector (N-1 downto 0);
           y4 : out std_logic_vector (N-1 downto 0);
           y5 : out std_logic_vector (N-1 downto 0);
           done : out std_logic);
end sort_se;

architecture Behavioral of sort_se is
    
    -- registers
    signal r0, r0_n, r1, r1_n, r2, r2_n, r3, r3_n, r4, r4_n : std_logic_vector (N-1 downto 0);
    signal r5, r5_n, r6, r6_n, r7, r7_n, r8, r8_n, r9, r9_n : std_logic_vector (N-1 downto 0);
    
    -- comp/swap signals
    signal ca1, ca2, ca3, ca4 : std_logic_vector (N-1 downto 0);
--    signal cb1, cb2, cb3, cb4 : std_logic_vector (N-1 downto 0);
--    signal sa, sb, s, s_n : std_logic;
    signal sa, s_o1, s_o2, s_e1, s_e2, s, s_n : std_logic;
    
--    type state_type is (ST_IDLE, ST_ODD, ST_EVEN, ST_DONE);
    type state_type is (ST_IDLE, ST_ODD1, ST_ODD2, ST_EVEN1, ST_EVEN2, ST_DONE);
	signal state, state_n: state_type;
	
begin

    process(clk, rst)
    begin
      if (rst = '1') then
         r0 <= (others => '0');
         r1 <= (others => '0');
         r2 <= (others => '0');
         r3 <= (others => '0');
         r4 <= (others => '0');
         r5 <= (others => '0');
         r6 <= (others => '0');
         r7 <= (others => '0');
         r8 <= (others => '0');
         r9 <= (others => '0');s <= '0';
         state <= ST_IDLE;
      elsif(rising_edge(clk)) then
         r0 <= r0_n;
         r1 <= r1_n;
         r2 <= r2_n;
         r3 <= r3_n;
         r4 <= r4_n;
         r5 <= r5_n;
         r6 <= r6_n;
         r7 <= r7_n;
         r8 <= r8_n;
         r9 <= r9_n;
         s <= s_n;
         state <= state_n;
      end if;
    end process;
    
    -- state machine process
    process(state,start,u1,u2,u3,u4,u5,r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,ca3,ca4,sa,s_o1,s_o2,s_e1,s_e2,s)
    begin
        -- default values
        state_n <= state;
        done <= '0';
        r0_n <= r0;
        r1_n <= r1;
        r2_n <= r2;
        r3_n <= r3;
        r4_n <= r4;
        r5_n <= r5;
        r6_n <= r6;
        r7_n <= r7;
        r8_n <= r8;
        r9_n <= r9;
        s_n <= s;        
        ca1 <= (others => '0');
        ca2 <= (others => '0');
--        cb1 <= (others => '0');
--        cb2 <= (others => '0');
                
        case state is
        when ST_IDLE =>
            
            r0_n <= u1;
            r1_n <= u2;
            r2_n <= u3;
            r3_n <= u4;
            r4_n <= u5;            
            
            if start = '1' then
                state_n <= ST_ODD1;
            end if;
            
        when ST_ODD1 =>
            
            -- first comp/swap
            ca1 <= r0;
            ca2 <= r1;
            r0_n <= ca3;
            r1_n <= ca4;
            s_o1 <= sa;
            
--            -- second comp/swap
--            cb1 <= r2;
--            cb2 <= r3;
--            r2_n <= cb3;
--            r3_n <= cb4;
            
            -- store swap flag
--            s_n <= sa or sb;
            
            state_n <= ST_ODD2;            

        when ST_ODD2 =>
            
            -- first comp/swap
            ca1 <= r2;
            ca2 <= r3;
            r2_n <= ca3;
            r3_n <= ca4;
            s_o2 <= sa;
            
            -- second comp/swap
--            cb1 <= r2;
--            cb2 <= r3;
--            r2_n <= cb3;
--            r3_n <= cb4;
            
            -- store swap flag
            s_n <= s_o1 or s_o2;
            
            state_n <= ST_EVEN1;            
            
        when ST_EVEN1 =>
            
            -- first comp/swap
            ca1 <= r1;
            ca2 <= r2;
            r1_n <= ca3;
            r2_n <= ca4;
            s_e1 <= sa;
            
            -- second comp/swap
--            cb1 <= r3;
--            cb2 <= r4;
--            r3_n <= cb3;
--            r4_n <= cb4;
            
            state_n <= ST_EVEN2;

        when ST_EVEN2 =>
            
            -- first comp/swap
            ca1 <= r3;
            ca2 <= r4;
            r3_n <= ca3;
            r4_n <= ca4;
            s_e2 <= sa;
            
--            -- second comp/swap
--            cb1 <= r3;
--            cb2 <= r4;
--            r3_n <= cb3;
--            r4_n <= cb4;
            
            -- clear swap flag
            s_n <= '0';
            
            -- check if complete
            if (s or s_e1 or s_e2) = '1' then
                state_n <= ST_ODD1;
            else
                state_n <= ST_DONE;
                r5_n <= r0;
                r6_n <= r1;
                r7_n <= r2;
                r8_n <= r3;
                r9_n <= r4;
            end if;
            
        when ST_DONE =>
            
            done <= '1';
            
            state_n <= ST_IDLE;
            
        end case;
    end process;
    
    -- comp/swap 1
    cs0 : entity work.comp_swap
    generic map(N => N)
    port map (u1 => ca1,
              u2 => ca2,
              y1 => ca3,
              y2 => ca4,
              s => sa);
                  
    -- comp/swap 2
--    cs1 : entity work.comp_swap
--    generic map(N => N)
--    port map (u1 => cb1,
--              u2 => cb2,
--              y1 => cb3,
--              y2 => cb4,
--              s => sb);
    
    y1 <= r5;
    y2 <= r6;
    y3 <= r7;
    y4 <= r8;
    y5 <= r9;
    
end Behavioral;
