library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FSMupdown_counter is
    Port (
        i_clk       : in  STD_LOGIC;
        i_reset     : in  STD_LOGIC;
        o_countup   : out STD_LOGIC_VECTOR(3 downto 0);
        o_countdown : out STD_LOGIC_VECTOR(3 downto 0)
    );
end FSMupdown_counter;

architecture Behavioral of FSMupdown_counter is
 
    signal r_state   : STD_LOGIC := '0'; 
    signal r_cntup   : unsigned(3 downto 0) := (others => '0');
    signal r_cntdown : unsigned(3 downto 0) := (others => '0');
    constant c_max_count : integer := 50000000; 
    signal r_div_cnt     : integer range 0 to c_max_count := 0;
    signal w_tick        : std_logic := '0';

begin

    FREQ_DIVIDER: process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            r_div_cnt <= 0;
            w_tick    <= '0';
        elsif rising_edge(i_clk) then
            w_tick <= '0'; 
            if r_div_cnt = c_max_count then
                r_div_cnt <= 0;
                w_tick    <= '1';
            else
                r_div_cnt <= r_div_cnt + 1;
            end if;
        end if;
    end process FREQ_DIVIDER;

    FSM: process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            r_state <= '0';
        elsif rising_edge(i_clk) then
            if w_tick = '1' then
                case r_state is
                    when '0' =>
                        if r_cntup >= 15 then
                            r_state <= '1';
                        end if;

                    when '1' =>
                        if r_cntdown <= 0 then
                            r_state <= '0';
                        end if;
                    
                    when others =>
                        r_state <= '0';
                end case;
            end if;
        end if;
    end process FSM;

    up_counter: process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            r_cntup <= to_unsigned(0, 4);
        elsif rising_edge(i_clk) then
            if w_tick = '1' then
                if r_state = '0' then
                    if r_cntup >= 15 then
                        r_cntup <= to_unsigned(15, 4);
                    else
                        r_cntup <= r_cntup + 1;
                    end if;
                else
                    r_cntup <= to_unsigned(0, 4);
                end if;
            end if;
        end if;
    end process up_counter;

    down_counter: process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            r_cntdown <= to_unsigned(15, 4);
        elsif rising_edge(i_clk) then
            if w_tick = '1' then
                if r_state = '1' then
                    if r_cntdown <= 0 then
                        r_cntdown <= to_unsigned(0, 4);
                    else
                        r_cntdown <= r_cntdown - 1;
                    end if;
                else
                    r_cntdown <= to_unsigned(15, 4);
                end if;
            end if;
        end if;
    end process down_counter;
            o_countup   <= std_logic_vector(r_cntup);
            o_countdown <= std_logic_vector(r_cntdown);
end Behavioral;


