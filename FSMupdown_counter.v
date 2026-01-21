library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FSMupdown_counter is
    Port (
        i_clk       : in  STD_LOGIC;
        i_reset     : in  STD_LOGIC;
        o_countup   : out STD_LOGIC_VECTOR(3 downto 0);
        o_countdown : out STD_LOGIC_VECTOR(3 downto 0)
    );
end FSMupdown_counter;

architecture Behavioral of FSMupdown_counter is

    constant max         : STD_LOGIC_VECTOR(3 downto 0) := "1111";
    constant min         : STD_LOGIC_VECTOR(3 downto 0) := "0000";

    signal state         : STD_LOGIC := '0';
    signal cntup         : STD_LOGIC_VECTOR(3 downto 0) := min;
    signal cntdown       : STD_LOGIC_VECTOR(3 downto 0) := max;
    
    signal bin_cnt       : STD_LOGIC_VECTOR(24 downto 0) := (others => '0');
    signal f_clk         : std_logic := '0';

begin

    frequency_divider: process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            bin_cnt <= (others => '0');
        elsif rising_edge(i_clk) then
            bin_cnt <= bin_cnt + 1;
        end if;
    end process frequency_divider;

    f_clk <= bin_cnt(24);

    FSM: process(f_clk, i_reset)
    begin
        if i_reset = '1' then
            state <= '0';
        elsif rising_edge(f_clk) then
            case state is
                when '0' =>
                    if cntup >= max then
                        state <= '1';
                    end if;
                when '1' =>
                    if cntdown <= min then
                        state <= '0';
                    end if; 
                when others =>
                    state <= '0';
            end case;
        end if;
    end process FSM;

    up_counter: process(f_clk, i_reset)
    begin
        if i_reset = '1' then
            cntup <= min;
        elsif rising_edge(f_clk) then
            if state = '0' then
                if cntup >= max then
                    cntup <= max;
                else
                    cntup <= cntup + 1;
                end if;
            else
                cntup <= min;
            end if;
        end if;
    end process up_counter;

    down_counter: process(f_clk, i_reset)
    begin
        if i_reset = '1' then
            cntdown <= max;
        elsif rising_edge(f_clk) then
            if state = '1' then
                if cntdown <= min then
                    cntdown <= min;
                else
                    cntdown <= cntdown - 1;
                end if;
            else
                cntdown <= max;
            end if;
        end if;
    end process down_counter;

    o_countup   <= cntup;
    o_countdown <= cntdown;

end Behavioral;
