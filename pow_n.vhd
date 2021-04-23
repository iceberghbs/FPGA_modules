
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity pow_n is
    Generic ( N : integer := 16;
              Ne : integer := 4);
    Port ( clk : in std_logic;
           rst : in std_logic;
           start : in std_logic;
           u1 : in std_logic_vector (N-1 downto 0);
           exp : in std_logic_vector (Ne-1 downto 0);
           y : out std_logic_vector (N-1 downto 0);
           done : out std_logic);
end pow_n;

architecture arch of pow_n is
    
    -- registers
    signal r0, r0_n, r1, r1_n, r2, r2_n : std_logic_vector (N-1 downto 0);
    signal r3, r3_n : std_logic_vector (Ne-1 downto 0);
    
    -- counter
    signal cnt, cnt_n : unsigned (Ne-1 downto 0);
    
    -- multiplier signals
    signal m1, m2, m3 : std_logic_vector (N-1 downto 0);
    
    type state_type is (ST_IDLE, ST_MUL, ST_DONE);
	signal state, state_n: state_type;

begin

    process(clk, rst)
    begin
      if (rst = '1') then
         r0 <= (others => '0');
         r1 <= (others => '0');
         r2 <= (others => '0');
         r3 <= (others => '0');
         cnt <= (others => '0');
         state <= ST_IDLE;
      elsif(rising_edge(clk)) then
         r0 <= r0_n;
         r1 <= r1_n;
         r2 <= r2_n;
         r3 <= r3_n;
         cnt <= cnt_n;
         state <= state_n;
      end if;
    end process;
    
    -- state machine process
    process(state,start,u1,r0,r1,r2,r3,m3,cnt,exp)
    begin
        -- default values
        state_n <= state;
        done <= '0';
        r0_n <= r0;
        r1_n <= r1;
        r2_n <= r2;
        r3_n <= r3;
        
        cnt_n <= (others => '0');
        m1 <= (others => '0');
        m2 <= (others => '0');        
        
        case state is
        when ST_IDLE =>
            
            r0_n <= u1;
            r1_n <= u1;
            r3_n <= exp;
            
            if start = '1' then
                state_n <= ST_MUL;
            end if;
            
        when ST_MUL =>
            
            -- route r0 and r1 to multiplier
            m1 <= r0;
            m2 <= r1;
            -- multiplier output is stored in r1
            r1_n <= m3;
            -- increment counter
            cnt_n <= cnt+1;
            
            -- check if at the end of multiplication
            if(cnt = (unsigned(r3)-2)) then
                state_n <= ST_DONE;
                r2_n <= m3;
            end if;
            
        when ST_DONE =>
            
            done <= '1';
            
            state_n <= ST_IDLE;
            
        end case;
    end process;
    
    -- multiplier
    mul0 : entity work.mul_q
    generic map(N => N)
    port map (m1 => m1,
              m2 => m2,
              m3 => m3);
    
    y <= r2;
    
end arch;
