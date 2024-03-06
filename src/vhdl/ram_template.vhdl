library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ram_template is
    port (
        data_in : in std_logic_vector(7 downto 0);
        data_out : out std_logic_vector(7 downto 0);
        addr : in std_logic_vector(31 downto 0);
        write_en, clk : in std_logic
    );
end entity ram_template;

architecture rtl of ram_template is
    
    type RAMtype is array (0 to 65535) of std_logic_vector(7 downto 0);
    signal RAM1 : RAMtype := (others => (others => '0'));
    
begin
    
    main: process(all)
        variable addr_in : natural range 0 to 65535;
    begin
        addr_in := to_integer(unsigned(addr(15 downto 0)));
        if rising_edge(clk) then
            if write_en = '1' then
                RAM1(addr_in) <= data_in;
            end if;
            data_out <= RAM1(addr_in);
        end if;
    end process main;
    
end architecture rtl;