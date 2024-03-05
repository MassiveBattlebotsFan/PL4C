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
        if to_x01(clr) = '1' then
            q <= (others => '0');
        elsif rising_edge(clk) then
            if to_x01(ld) = '1' then
                q <= d;
            elsif to_x01(inc) = '1' then
                q <= std_logic_vector(to_unsigned(to_integer(unsigned( q )) + 1, 8)) when to_x01(ind) = '1' else std_logic_vector(to_unsigned(to_integer(unsigned( q )) - 1, 8));
            end if;
        end if;
    end process main;

end architecture rtl;