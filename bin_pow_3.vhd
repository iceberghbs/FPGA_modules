
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity bin_pow_3 is
    Generic ( N : integer := 16);
    Port ( clk : in std_logic;
           rst : in std_logic;
           start : in std_logic;
           u1 : in std_logic_vector (N-1 downto 0);
           u2 : in std_logic_vector (N-1 downto 0);
           y : out std_logic_vector (N-1 downto 0);
           done : out std_logic);
end bin_pow_3;

architecture arch of bin_pow_3 is
    
    signal r0, r0_n, r1, r1_n, r2, r2_n : std_logic_vector (N-1 downto 0);
    
    -- multiplier signals
    signal m1, m2, m3 : std_logic_vector (N-1 downto 0);
    
    -- adder signals
    signal s1, s2, s3 : std_logic_vector (N-1 downto 0);
    
    type state_type is (ST_IDLE, ST_ADD, ST_MUL0, ST_MUL1, ST_DONE);
	signal state, state_n: state_type;

begin

    process(clk, rst)
    begin
      if (rst = '1') then
         r0 <= (others => '0');
         r1 <= (others => '0');
         r2 <= (others => '0');
         state <= ST_IDLE;
      elsif(rising_edge(clk)) then
         r0 <= r0_n;
         r1 <= r1_n;
         r2 <= r2_n;
         state <= state_n;
      end if;
    end process;
    
    -- state machine process
    process(state,start,u1,u2,r0,r1,r2,s3,m3)
    begin
        -- default values
        state_n <= state;
        done <= '0';
        r0_n <= r0;
        r1_n <= r1;
        r2_n <= r2;
        
        -- if not explicitly used adder and multiplier are driven with 0 value
        s1 <= (others => '0');
        s2 <= (others => '0');
        m1 <= (others => '0');
        m2 <= (others => '0');        
        
        case state is
        when ST_IDLE =>
            
            r0_n <= u1;
            r1_n <= u2;
            
            if start = '1' then
                state_n <= ST_ADD;
            end if;
            
        when ST_ADD =>
            
            -- route r0 and r1 to the adder
            s1 <= r0;
            s2 <= r1;
            -- adder output is stored in r0
            r0_n <= s3;
            
            state_n <= ST_MUL0;
            
        when ST_MUL0 =>
            
            -- route r0 to multiplier to comput the square
            m1 <= r0;
            m2 <= r0;
            -- multiplier output is stored in r1
            r1_n <= m3;
            
            state_n <= ST_MUL1;
            
        when ST_MUL1 =>
            
            -- route r0 and r1 to multiplier
            m1 <= r0;
            m2 <= r1;
            -- multiplier output is stored in r2
            r2_n <= m3;
            
            state_n <= ST_DONE;
            
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
              
    -- adder
    adder0 : entity work.adder_so_sat
    generic map(N => N)
    port map (a1 => s1,
              a2 => s2,
              a3 => s3,
              ov => open);
    
    y <= r2;
    
end arch;
