----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 2021/03/27 13:06:59
-- Design Name: 
-- Module Name: fsm_lock - Behavioral
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

entity fsm_lock is
  Port (
        rst : in std_logic;
        clk : in std_logic;
        clk_1hz : in std_logic;
        sw : in std_logic_vector(3 downto 0);
        btn1, btn2, btn3 : in std_logic;
        d1, d0 : out std_logic_vector(3 downto 0);  -- 输出随机的两位的序号
        led_lock, led_emrg : out std_logic  -- 指示锁定和报警
         );
end fsm_lock;

architecture Behavioral of fsm_lock is

constant c4 : unsigned(3 downto 0) := "1001";  -- 9
constant c3 : unsigned(3 downto 0) := "0100";  -- 4
constant c2 : unsigned(3 downto 0) := "0011";  -- 3
constant c1 : unsigned(3 downto 0) := "0110";  -- 6
constant c0 : unsigned(3 downto 0) := "0100";  -- 4
signal c43210 : unsigned(19 downto 0):=c4&c3&c2&c1&c0;
signal c_emrg : unsigned(19 downto 0):=c0&c1&c2&c3&c4;  -- 定义安全码是组合锁密码的反序
signal c_random : unsigned(7 downto 0);  -- 随机值组合
signal c_random1 : unsigned(3 downto 0); -- 存随机的第一位的值
signal c_random2 : unsigned(3 downto 0);  -- 随机第二位的值

signal r4, r3, r2, r1, r0 : unsigned(3 downto 0);  -- 输入缓存的current state
signal r4_n, r3_n, r2_n, r1_n, r0_n : unsigned(3 downto 0);  -- 缓存的下一个状态
signal r43210 : unsigned(19 downto 0);  -- 组合锁的输入缓存组合
signal r10 : unsigned(7 downto 0);  -- 改进锁的输入缓存组合

signal half_min, two_min, five_min : std_logic := '0';  -- 等待时间的indicator
signal flag : std_logic := '0';  -- 为‘1’表示等待结束

type state_type is   -- 定义状态的所有状态
    (locked, unlocked, emrg, t4, t3, t2, t1, t0, u1, u0, 
        comp1, comp2, wait_30s, wait_2m, wait_5m);

signal state, state_n : state_type;  -- 状态机current state 和 next state

begin

    nx_state:process(clk, rst)  -- 状态机更新
    begin
      if (rst = '1') then  -- 初始化
         state <= locked;
         r4 <= (others=>'0');
         r3 <= (others=>'0');
         r2 <= (others=>'0');
         r1 <= (others=>'0');
         r0 <= (others=>'0');
      elsif rising_edge(clk) then  -- 上升沿更新
         state <= state_n;
         r4 <= r4_n;
         r3 <= r3_n;
         r2 <= r2_n;
         r1 <= r1_n;
         r0 <= r0_n;
      end if;
    end process;
    
    ramdom:process(clk, btn3)  -- 生成随机的两位
        variable cnt_o : unsigned(2 downto 0):="001";
        variable cnt_e : unsigned(2 downto 0):="010";
    begin
        if rising_edge(clk) then
            if cnt_o >= 5 then  -- 五以内奇数滚动
                cnt_o := "001";
            else
                cnt_o := cnt_o + 2;
            end if;
            if cnt_e = 4 then  -- 2或4滚动
                cnt_e := "010";
            else
                cnt_e := "100";
            end if;
        end if;
        
        if btn3='1' then  -- 取出按下按钮时滚动到的奇数值
            case cnt_o is
            when "001" =>
                c_random1 <= c4;
                d1 <= "0001";
            when "011" => 
                c_random1 <= c2;
                d1 <= "0011";
            when "101" => 
                c_random1 <= c0;
                d1 <= "0101";
            when others =>
                c_random1 <= c4;
                d1 <= "0001";
            end case;
            
            case cnt_e is  -- 取出按下按钮时的偶数值
            when "010" =>
                c_random2 <= c3;
                d0 <= "0010";
            when "100" => 
                c_random2 <= c1;
                d0 <= "0100";
            when others =>
                c_random2 <= c3;
                d0 <= "0010";
            end case;
            
        end if;
    end process;
    c_random <= c_random1 & c_random2;  -- 拼起来起来
    
    timer : process(clk_1hz, half_min, two_min, five_min)  -- 计时器，用于等待时间
        variable cnt : integer:=0;
    begin
        if half_min='1' then  -- 根据indicator确定等待时间
            if rising_edge(clk_1hz) then
                cnt := cnt + 1 ;
                if cnt=30 then
                    flag <= '1';
                    cnt := 0;
                end if;
            end if;
        elsif two_min='1' then
            if rising_edge(clk_1hz) then
                cnt := cnt + 1 ;
                if cnt=120 then
                    flag <= '1';
                    cnt := 0;
                end if;
            end if;
        elsif five_min='1' then
            if rising_edge(clk_1hz) then
                cnt := cnt + 1 ;
                if cnt=300 then
                    flag <= '1';
                    cnt := 0;
                end if;
            end if;
        else
            cnt := 0;
            flag <= '0';
        end if;
        
    end process;
    
    r43210 <= r4&r3&r2&r1&r0; 
    r10 <= r1&r0; 
    cu_state:process(state, btn1, btn2, btn3,  -- 状态机具体逻辑实现部分
                    r4, r3, r2, r1, r0, flag)
        variable try : integer;  -- 错误尝试次数
    begin
        -- default values
        state_n <= state;
        r4_n <= r4;
        r3_n <= r3;
        r2_n <= r2;
        r1_n <= r1;
        r0_n <= r0;
        
        case state is 
        
        when locked =>   -- 锁定状态
            half_min <= '0';  -- 等待置零
            two_min <= '0';
            five_min <= '0';
            
            if btn1='1' then  -- 根据按钮选择组合锁或改进锁
                state_n <= t4;
            elsif btn3='1' then
                state_n <= u1;
            end if;
            
            led_lock <= '1';  -- 锁定
            led_emrg <= '0';  -- 锁定状态下不报警
            try := 2;  -- 测试所需

        when unlocked =>   -- 解锁状态
            led_lock <= '0';  -- 解锁
            led_emrg <= '0';  -- 不报警
--            try := 2;  -- 测试所需，否则这句应该注释
            
        when emrg =>   -- 报警状态
            led_lock <= '0';  -- 解锁
            led_emrg <= '1';  -- 报警
--            try := 2;
            
        when wait_30s =>   -- 等30秒
            half_min <= '1';
            if flag='1' then
                state_n <= locked;
            end if;

        when wait_2m =>   -- 等两分钟
            two_min <= '1';
            if flag='1' then
                state_n <= locked;
                two_min <= '0';
            end if;

        when wait_5m =>   -- 5分钟 
            five_min <= '1';
            if flag='1' then
                state_n <= locked;
                five_min <= '0';
            end if;
            
        when t4 =>   -- 读取最高位的输入（第一位
            if rising_edge(btn2) then
                r4_n <= unsigned(sw(3 downto 0));
                state_n <= t3;
            end if;
            
        when t3 =>   -- 读第二位
            if btn1='1' then
                state_n <= t4;
            elsif rising_edge(btn2) then
                r3_n <= unsigned(sw(3 downto 0));
                state_n <= t2;
            end if;

        when t2 =>   -- 三
            if btn1='1' then
                state_n <= t4;
            elsif rising_edge(btn2) then
                r2_n <= unsigned(sw(3 downto 0));
                state_n <= t1;
            end if;
            
        when t1 =>   -- 四
            if btn1='1' then
                state_n <= t4;
            elsif rising_edge(btn2) then
                r1_n <= unsigned(sw(3 downto 0));
                state_n <= t0;
            end if;
            
        when t0 =>   -- 五
            if btn1='1' then
                state_n <= t4;
            elsif rising_edge(btn2) then
                r0_n <= unsigned(sw(3 downto 0));
                state_n <= comp1;
            end if;
            
        when u1 =>   -- 改进锁读取第一位
            if rising_edge(btn2) then
                r1_n <= unsigned(sw(3 downto 0));
                state_n <= u0;
            end if;

        when u0 =>   -- 改进锁读取第二位
            if btn3='1' then
                state_n <= u1;
            elsif rising_edge(btn2) then
                r0_n <= unsigned(sw(3 downto 0));
                state_n <= comp2;
            end if;

        when comp1 =>  -- 组合锁比对
            if rising_edge(btn2) then
                if r43210=c43210 then
                    state_n <= unlocked;
                elsif r43210=c_emrg then
                    state_n <= emrg;
                else 
--                    if try<5 then 
                        try := try+1; 
--                    else 
--                        try := 5;
--                    end if;
                    
                    if try=3 then  -- 根据错误次数决定是否进入等待以及等待时间
                        state_n <= wait_30s;
                    elsif try=4 then
                        state_n <= wait_2m;
                    elsif try>=5 then
                        state_n <= wait_5m;
                    else
                        state_n <= t4;
                    end if;
                end if;
            end if;
            
        when comp2 =>  -- 改进锁比对
            if rising_edge(btn2) then
                if r10=c_random then
                    state_n <= unlocked;
                else
--                    if try<5 then 
                        try := try+1; 
--                    else 
--                        try := 5;
--                    end if;
                    
                    if try=3 then  -- 根据错误次数决定是否进入等待以及等待时间
                        state_n <= wait_30s;
                    elsif try=4 then
                        state_n <= wait_2m;
                    elsif try>=5 then
                        state_n <= wait_5m;
                    else
                        state_n <= u1;
                    end if;    
                end if;
            end if;
            
        end case;
        
    end process;

end Behavioral;
