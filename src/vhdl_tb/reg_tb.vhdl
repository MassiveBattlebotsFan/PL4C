library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity reg_tb is
end entity reg_tb;

architecture behaviour of reg_tb is
    
    signal reg8_d, reg8_q : std_logic_vector(7 downto 0);
    signal reg8_clk, reg8_clr, reg8_ld : std_logic;

    signal reg8i_d, reg8i_q : std_logic_vector(7 downto 0);
    signal reg8i_clk, reg8i_clr, reg8i_ld, reg8i_ind, reg8i_inc : std_logic;

begin
    
    reg8 : entity work.reg_generic(rtl)
        generic map (register_width => 8)
        port map(
            d => reg8_d,
            q => reg8_q,
            clk => reg8_clk,
            clr => reg8_clr,
            ld => reg8_ld
        );
    reg8i : entity work.reg_generic(rtl)
        generic map (register_width => 8)
        port map(
            d => reg8i_d,
            q => reg8i_q,
            clk => reg8i_clk,
            clr => reg8i_clr,
            ld => reg8i_ld,
            ind => reg8i_ind,
            inc => reg8i_inc
        );

    reg8_proc: process

        type pattern_type is record
            d : std_logic_vector(7 downto 0);
            clk, clr, ld : std_logic;
            q : std_logic_vector(7 downto 0);
            ind, inc : std_logic;
        end record pattern_type;

        type pattern_array is array (natural range <>) of pattern_type;
        
        constant reg8_patterns : pattern_array := (
            ("--------",'0','1','0',"00000000",'-','-'),
            ("01010101",'0','0','1',"00000000",'-','-'),
            ("01010101",'1','0','1',"01010101",'-','-'),
            ("10101010",'0','0','0',"01010101",'-','-'),
            ("10101010",'1','0','0',"01010101",'-','-'),
            ("10101010",'1','0','1',"01010101",'-','-'),
            ("10101010",'0','0','1',"01010101",'-','-'),
            ("10101010",'1','0','1',"10101010",'-','-'),
            ("10101010",'0','1','1',"00000000",'-','-'),
            ("10101010",'1','1','1',"00000000",'-','-')
        );

    begin

        for i in reg8_patterns'range loop
            reg8_d <= reg8_patterns(i).d;
            reg8_clk <= reg8_patterns(i).clk;
            reg8_clr <= reg8_patterns(i).clr;
            reg8_ld <= reg8_patterns(i).ld;
            wait for 1 ns;
            if reg8_patterns(i).q /= "--------" then
                assert reg8_q = reg8_patterns(i).q report "Bad Q" severity error;
            end if;
        end loop;
        
        assert false report "Test completed" severity note;
        wait;

    end process reg8_proc;

    reg8i_proc: process

        type pattern_type is record
            d : std_logic_vector(7 downto 0);
            clk, clr, ld : std_logic;
            q : std_logic_vector(7 downto 0);
            ind, inc : std_logic;
        end record pattern_type;

        type pattern_array is array (natural range <>) of pattern_type;

        constant reg8i_patterns : pattern_array := (
            ("--------",'0','1','0',"00000000",'1','0'),
            ("01010101",'0','0','1',"00000000",'1','0'),
            ("01010101",'1','0','1',"01010101",'1','0'),
            ("10101010",'0','0','0',"01010101",'1','0'),
            ("10101010",'1','0','0',"01010101",'1','0'),
            ("10101010",'1','0','1',"01010101",'1','0'),
            ("10101010",'0','0','1',"01010101",'1','0'),
            ("10101010",'1','0','1',"10101010",'1','0'),
            ("10101010",'0','1','1',"00000000",'1','0'),
            ("10101010",'1','1','1',"00000000",'1','0'),
            ("01010101",'0','0','1',"00000000",'1','0'),
            ("01010101",'1','0','1',"01010101",'1','0'),
            ("--------",'0','0','0',"01010101",'1','1'),
            ("--------",'1','0','0',"01010110",'1','1'),
            ("--------",'0','0','0',"01010110",'0','1'),
            ("--------",'1','0','0',"01010101",'0','1'),
            ("--------",'0','0','0',"01010101",'0','1'),
            ("10101010",'0','0','0',"01010101",'0','0'),
            ("10101010",'1','0','0',"01010101",'0','0'),
            ("10101010",'0','0','0',"01010101",'0','0'),
            ("11111111",'1','0','1',"11111111",'0','0'),
            ("11111111",'0','0','0',"11111111",'0','0'),
            ("--------",'1','0','0',"00000000",'1','1'),
            ("--------",'0','0','0',"00000000",'1','1')
        );

    begin
        
        for i in reg8i_patterns'range loop
            reg8i_d <= reg8i_patterns(i).d;
            reg8i_clk <= reg8i_patterns(i).clk;
            reg8i_clr <= reg8i_patterns(i).clr;
            reg8i_ld <= reg8i_patterns(i).ld;
            reg8i_ind <= reg8i_patterns(i).ind;
            reg8i_inc <= reg8i_patterns(i).inc;
            wait for 1 ns;
            if reg8i_patterns(i).q /= "--------" then
                assert reg8i_q = reg8i_patterns(i).q report "Bad Q" severity error;
            end if;
        end loop;
        
        assert false report "Test completed" severity note;
        wait;

    end process reg8i_proc;
    
    
    
end architecture behaviour;