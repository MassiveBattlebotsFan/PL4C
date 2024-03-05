library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu_tb is
end entity alu_tb;


architecture behaviour of alu_tb is

    -- accumulator and data bus in
    signal acc_in, dat_in : std_logic_vector(7 downto 0);
    -- acc out
    signal acc_out : std_logic_vector(7 downto 0);
    -- acc clock and load
    signal acc_clock, acc_load : std_logic;
    -- mode bits
    signal mode_add, mode_sub, mode_xor, mode_and, mode_or, mode_not : std_logic;
    signal clk, rst : std_logic;

begin
    
    alu0 : entity work.alu(rtl)
        port map(
            acc_in => acc_in,
            acc_out => acc_out,
            dat_in => dat_in,
            acc_clock => acc_clock,
            acc_load => acc_load,
            mode_add => mode_add,
            mode_sub => mode_sub,
            mode_xor => mode_xor,
            mode_and => mode_and,
            mode_or => mode_or,
            mode_not => mode_not,
            clk => clk,
            rst => rst
        );
    
    
end architecture behaviour;