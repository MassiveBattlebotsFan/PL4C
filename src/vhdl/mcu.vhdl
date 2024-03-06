library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mcu is
    port (
        -- RCU bank interface
        upper_bank, lower_bank : in std_logic_vector(7 downto 0);
        -- Memory page
        page : in std_logic_vector(7 downto 0);
        -- Address
        address : in std_logic_vector(7 downto 0);
        -- Data bus
        dbus_in : in std_logic_vector(7 downto 0);
        dbus_out : out std_logic_vector(7 downto 0);
        -- RCU mode and clock pins
        mode_bit, mode_rw, clk, rst : in std_logic := '0';
        -- RAM address and data bus
        ram_addr : out std_logic_vector(31 downto 0) := "00000000000000001111111111111100";
        ram_data_read : in std_logic_vector(7 downto 0);
        ram_data_write : out std_logic_vector(7 downto 0);
        ram_write_en, ram_clock : out std_logic
    );
end entity mcu;

architecture rtl of mcu is
    
begin
    
    main: process(clk, rst, mode_bit, mode_rw, page, address, upper_bank, lower_bank)
    begin
        if clk = '0' then
            
            ram_clock <= '0';
            ram_write_en <= '0';
            
        elsif rising_edge(clk) then

            ram_write_en <= '1' when mode_rw = '1' else '0';
            if mode_rw = '1' then
                -- write on a 1
                -- set RAM address based on mode bit
                ram_addr(31 downto 16) <= upper_bank & lower_bank when mode_bit = '1' else "0000000000000000";
                ram_addr(15 downto 0) <= page & address;
                ram_data_write <= dbus_in;
            else
                ram_addr(31 downto 16) <= upper_bank & lower_bank when mode_bit = '1' else "0000000000000000";
                ram_addr(15 downto 0) <= page & address;
            end if;
            ram_clock <= '1';

        end if;
    end process main;
    dbus_out <= (others => 'Z') when rst = '1' else ram_data_read;
            
end architecture rtl;
