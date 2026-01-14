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

    constant max         : unsigned(3 downto 0) := "1111";
    constant min         : unsigned(3 downto 0) := "0000";
    constant C_MAX_COUNT : integer := 50000000; 

    signal state     : STD_LOGIC := '0'; 
    signal cntup     : unsigned(3 downto 0) := min;
    signal cntdown   : unsigned(3 downto 0) := min;
    signal r_div_cnt : integer range 0 to C_MAX_COUNT := 0;
    signal w_tick    : std_logic := '0';

begin
    freq: process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            r_div_cnt <= 0;
            w_tick    <= '0';
        elsif rising_edge(i_clk) then
            w_tick <= '0'; 
            if r_div_cnt = C_MAX_COUNT then
                r_div_cnt <= 0;
                w_tick    <= '1';
            else
                r_div_cnt <= r_div_cnt + 1;
            end if;
        end if;
    end process freq;

    FSM: process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            state <= '0';
        elsif rising_edge(i_clk) then
            if w_tick = '1' then
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
        end if;
    end process FSM;

    up_counter: process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            cntup <= min;
        elsif rising_edge(i_clk) then
            if w_tick = '1' then
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
        end if;
    end process up_counter;

    down_counter: process(i_clk, i_reset)
    begin
        if i_reset = '1' then
            cntdown <= max;
        elsif rising_edge(i_clk) then
            if w_tick = '1' then
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
        end if;
    end process down_counter;
    o_countup   <= std_logic_vector(cntup);
    o_countdown <= std_logic_vector(cntdown);
end Behavioral;

接腳設定
set_property PACKAGE_PIN G22 [get_ports {i_max[2]}]
set_property PACKAGE_PIN F22 [get_ports {i_max[3]}]
set_property PACKAGE_PIN H22 [get_ports {i_max[1]}]
set_property PACKAGE_PIN F21 [get_ports {i_max[0]}]
set_property PACKAGE_PIN H19 [get_ports {i_min[3]}]
set_property PACKAGE_PIN H18 [get_ports {i_min[2]}]
set_property PACKAGE_PIN M15 [get_ports {i_min[0]}]
set_property PACKAGE_PIN H17 [get_ports {i_min[1]}]
set_property PACKAGE_PIN T22 [get_ports {o_countdown[3]}]
set_property PACKAGE_PIN T21 [get_ports {o_countdown[2]}]
set_property PACKAGE_PIN U22 [get_ports {o_countdown[1]}]
set_property PACKAGE_PIN U21 [get_ports {o_countdown[0]}]
set_property PACKAGE_PIN V22 [get_ports {o_countup[3]}]
set_property PACKAGE_PIN W22 [get_ports {o_countup[2]}]
set_property PACKAGE_PIN U19 [get_ports {o_countup[1]}]
set_property PACKAGE_PIN U14 [get_ports {o_countup[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_max[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_max[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_max[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_max[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_min[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_min[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_min[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {i_min[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_countdown[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_countdown[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_countdown[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_countdown[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_countup[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_countup[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_countup[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {o_countup[0]}]

set_property PACKAGE_PIN Y9 [get_ports i_clk]
set_property PACKAGE_PIN P16 [get_ports i_reset]
set_property IOSTANDARD LVCMOS33 [get_ports i_clk]
set_property IOSTANDARD LVCMOS33 [get_ports i_reset]

                    
