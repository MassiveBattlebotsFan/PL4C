library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity reg_generic is
    generic (
        register_width : integer := 8
    );
    port (
        -- data
        d : in std_logic_vector(register_width-1 downto 0);
        -- load
        ld : in std_logic;
        -- clear
        clr : in std_logic;
        -- clock
        clk : in std_logic;
        -- increment direction
        ind : in std_logic := '0';
        -- increment clock
        inc : in std_logic := '0';
        -- output
        q : out std_logic_vector(register_width-1 downto 0)
    );
end entity reg_generic;


architecture rtl of reg_generic is

begin
    
    main: process(clk, clr)
    begin
        if clr = '1' then
            q <= (others => '0');
        elsif rising_edge(clk) then
            if ld = '1' then
                q <= d;
            elsif inc = '1' then
                q <= std_logic_vector(to_unsigned(to_integer(unsigned( q )) + 1, 8)) when ind = '1' else std_logic_vector(to_unsigned(to_integer(unsigned( q )) - 1, 8));
            end if;
        end if;
    end process main;

end architecture rtl;