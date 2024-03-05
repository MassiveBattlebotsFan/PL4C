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
    signal mode_add, mode_sub, mode_xor, mode_and, mode_or, mode_not, mode_shl, mode_shr : std_logic;
    signal clk, rst, clr : std_logic;

begin
    
    acc : entity work.reg_generic(rtl)
        generic map(register_width => 8)
        port map(
            q => acc_in,
            d => acc_out,
            ld => acc_load,
            clk => acc_clock,
            clr => clr,
            ind => '0',
            inc => '0'
        );

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
            mode_shl => mode_shl,
            mode_shr => mode_shr,
            clk => clk,
            rst => rst
        );
    
        main: process

            type pattern_type is record
                -- accumulator and data bus in
                dat_in : std_logic_vector(7 downto 0);
                acc_out : std_logic_vector(7 downto 0);
                -- mode bits
                mode_add, mode_sub, mode_xor, mode_and, mode_or, mode_not, mode_shl, mode_shr : std_logic;
                rst, clr : std_logic;
            end record pattern_type;

            type pattern_array is array (natural range <>) of pattern_type;

            constant patterns : pattern_array := (
                ("--------","--------",'-','-','-','-','-','-','0','0','1','1'),
                ("00000000","ZZZZZZZZ",'0','0','0','0','0','0','0','0','1','0'),
                ("00000001","00000001",'1','0','0','0','0','0','0','0','0','0'),
                ("00000011","00000100",'1','0','0','0','0','0','0','0','0','0'),
                ("00000001","00000100",'0','0','0','0','0','0','0','0','0','0'),
                ("00000001","00000011",'0','1','0','0','0','0','0','0','0','0'),
                ("01101001","01101011",'0','0','0','0','1','0','0','0','0','0'),
                ("00001111","01100100",'0','0','1','0','0','0','0','0','0','0'),
                ("11110000","01100000",'0','0','0','1','0','0','0','0','0','0'),
                ("--------","10011111",'0','0','0','0','0','1','0','0','0','0'),
                ("--------","ZZZZZZZZ",'0','0','0','0','0','0','0','0','1','0'),
                ("--------","10011111",'0','0','0','0','0','0','0','0','0','0'),
                ("00000010","01111100",'0','0','0','0','0','0','1','0','0','0'),
                ("00000010","00011111",'0','0','0','0','0','0','0','1','0','0')
            );

        begin

            for i in patterns'range loop
                dat_in <= patterns(i).dat_in;
                mode_add <= patterns(i).mode_add;
                mode_sub <= patterns(i).mode_sub;
                mode_xor <= patterns(i).mode_xor;
                mode_and <= patterns(i).mode_and;
                mode_or <= patterns(i).mode_or;
                mode_not <= patterns(i).mode_not;
                mode_shl <= patterns(i).mode_shl;
                mode_shr <= patterns(i).mode_shr;
                rst <= patterns(i).rst;
                clr <= patterns(i).clr;
                clk <= '0';
                wait for 0.5 ns;
                clk <= '1';
                wait for 0.5 ns;
                if patterns(i).acc_out /= "--------" then
                    assert acc_out = patterns(i).acc_out report "Bad acc out" severity error;
                end if;
            end loop;

            assert false report "Test completed" severity note;

            wait;

        end process main;
    
end architecture behaviour;