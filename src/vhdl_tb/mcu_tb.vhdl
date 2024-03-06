library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mcu_tb is
end entity mcu_tb;

architecture behaviour of mcu_tb is
    
    signal upper_bank, lower_bank, page, address : std_logic_vector(7 downto 0);
    signal dbus_in, dbus_out : std_logic_vector(7 downto 0);
    signal mode_bit, mode_rw, clk, rst : std_logic;
    -- RAM stuff
    signal ram_addr : std_logic_vector(31 downto 0);
    signal ram_data_read, ram_data_write : std_logic_vector(7 downto 0);
    signal ram_write_en, ram_clock : std_logic;

begin
    
    mcu0 : entity work.mcu(rtl) port map(
        upper_bank => upper_bank,
        lower_bank => lower_bank,
        page => page,
        address => address,
        dbus_in => dbus_in,
        dbus_out => dbus_out,
        mode_bit => mode_bit,
        mode_rw => mode_rw,
        clk => clk,
        rst => rst,
        ram_addr => ram_addr,
        ram_data_write => ram_data_write,
        ram_data_read => ram_data_read,
        ram_write_en => ram_write_en,
        ram_clock => ram_clock
    );

    ram0 : entity work.ram_template(rtl) port map(
        data_in => ram_data_write,
        data_out => ram_data_read,
        write_en => ram_write_en,
        clk => ram_clock,
        addr => ram_addr
    );

    main: process

        type pattern_type is record
            upper_bank, lower_bank, page, address : std_logic_vector(7 downto 0);
            dbus_in : std_logic_vector(7 downto 0);
            mode_bit, mode_rw, rst : std_logic;
            dbus_out : std_logic_vector(7 downto 0);
        end record pattern_type;

        type pattern_array is array (natural range <>) of pattern_type;
        
        constant patterns : pattern_array := (
            ("00000000","00000000","00000000","00000000","00000000",'0','0','1',"--------"),
            ("10010000","00001001","00000000","00000001","01101010",'0','0','0',"--------"),
            ("10010000","00001001","00000000","00000010","00000101",'0','1','0',"--------"),
            ("10010000","00001001","00010100","11100110","00101100",'1','0','0',"--------"),
            ("10010000","00001001","00010100","11100111","01001110",'1','1','0',"--------"),
            ("00000000","00000000","00000000","00000010","00000000",'0','0','0',"--------")
        );

    begin
        
        for i in patterns'range loop
            
            upper_bank <= patterns(i).upper_bank;
            lower_bank <= patterns(i).lower_bank;
            page <= patterns(i).page;
            address <= patterns(i).address;
            dbus_in <= patterns(i).dbus_in;
            mode_bit <= patterns(i).mode_bit;
            mode_rw <= patterns(i).mode_rw;
            --rst <= patterns(i).rst;

            rst <= '1';
            clk <= '0';
            wait for 0.5 ns;
            rst <= '0';
            clk <= '1';
            wait for 0.5 ns;
            --wait for 0.5 ns;
            
            if patterns(i).dbus_out /= "--------" then
                assert dbus_out = patterns(i).dbus_out report "Data bus in bad state" severity error;
            end if;
        end loop;
        
        assert false report "Test completed" severity note;
        wait;

    end process main;
    
end architecture behaviour;