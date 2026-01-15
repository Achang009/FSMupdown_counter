library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_FSMupdown_counter is
end tb_FSMupdown_counter;

architecture behavior of tb_FSMupdown_counter is

    component FSMupdown_counter
    Port (
        i_clk       : in  STD_LOGIC;
        i_reset     : in  STD_LOGIC;
        o_countup   : out STD_LOGIC_VECTOR(3 downto 0);
        o_countdown : out STD_LOGIC_VECTOR(3 downto 0)
    );
    end component;

    signal i_clk       : std_logic := '0';
    signal i_reset     : std_logic := '0';
    signal o_countup   : std_logic_vector(3 downto 0);
    signal o_countdown : std_logic_vector(3 downto 0);

    constant i_clk_period : time := 10 ns;

begin

    uut: FSMupdown_counter PORT MAP (
        i_clk       => i_clk,
        i_reset     => i_reset,
        o_countup   => o_countup,
        o_countdown => o_countdown
    );

    clk_process :process
    begin
        i_clk <= '0';
        wait for i_clk_period/2;
        i_clk <= '1';
        wait for i_clk_period/2;
    end process;

    stim_proc: process
    begin
        i_reset <= '1';
        wait for 20 ns;
        i_reset <= '0';

        wait for i_clk_period * 50;

        wait;
    end process;

end behavior;