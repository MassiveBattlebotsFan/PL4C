library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu is
    port (
        -- accumulator and data bus in
        acc_in, dat_in : in std_logic_vector(7 downto 0);
        -- acc out
        acc_out : out std_logic_vector(7 downto 0);
        -- acc clock and load
        acc_clock, acc_load : out std_logic;
        -- mode bits
        mode_add, mode_sub, mode_xor, mode_and, mode_or, mode_not, mode_shift : in std_logic;
        -- ALU clock and reset
        clk, rst : in std_logic
    );
end entity alu;

architecture rtl of alu is
    
begin
    
    operation: process(clk, rst)
    begin
        if rst = '1' then
            acc_out <= (others => 'Z');
            acc_load <= 'L';
            acc_clock <= 'L';
        else
            acc_load <= 'H';
            if rising_edge(clk) then
                if mode_add = '1' then
                    acc_out <= std_logic_vector(to_unsigned(to_integer(unsigned(acc_in)) + to_integer(unsigned(dat_in)), 8));
                elsif mode_sub = '1' then
                    acc_out <= std_logic_vector(to_unsigned(to_integer(unsigned(acc_in)) - to_integer(unsigned(dat_in)), 8));
                elsif mode_xor = '1' then
                    acc_out <= acc_in xor dat_in;
                elsif mode_and = '1' then
                    acc_out <= acc_in and dat_in;
                elsif mode_or = '1' then
                    acc_out <= acc_in or dat_in;
                elsif mode_shift = '1' then
                    acc_out <= std_logic_vector(shift_left(unsigned(acc_in),to_integer(unsigned(dat_in)))) when mode_not = '0' else std_logic_vector(shift_right(unsigned(acc_in),to_integer(unsigned(dat_in))));
                elsif mode_not = '1' then
                    acc_out <= not acc_in;
                else acc_out <= acc_in;
                end if;
                acc_clock <= 'H';
            else
                acc_clock <= 'L';
            end if;
        end if;
    end process operation;
    
end architecture rtl;