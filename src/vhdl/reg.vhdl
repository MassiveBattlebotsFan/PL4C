library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity reg8 is
    port (
        -- data
        d : in std_logic_vector(7 downto 0);
        -- load
        ld : in std_logic;
        -- clear
        clr : in std_logic;
        -- clock
        clk : in std_logic;
        -- output
        q : out std_logic_vector(7 downto 0)
    );
end entity reg8;

entity reg8i is
    port (
        -- data
        d : in std_logic_vector(7 downto 0);
        -- load
        ld : in std_logic;
        -- clear
        clr : in std_logic;
        -- clock
        clk : in std_logic;
        -- increment direction
        ind : in std_logic;
        -- increment clock
        inc : in std_logic;
        -- output
        q : out std_logic_vector(7 downto 0)
    );
end entity reg8i;

entity reg16 is
    port (
        -- data
        d : in std_logic_vector(15 downto 0);
        -- load
        ld : in std_logic;
        -- clear
        clr : in std_logic;
        -- clock
        clk : in std_logic;
        -- increment direction
        ind : in std_logic;
        -- increment clock
        inc : in std_logic;
        -- output
        q : out std_logic_vector(15 downto 0)
    );
end entity reg16;

architecture rtl of reg8 is
    
begin
    
    main: process(clk, clr)
    begin
        if clr = '1' then
            q <= (others => '0');
        elsif rising_edge(clk) then
            if ld = '1' then
                q <= d;
            end if;
        end if;
    end process main;
    
end architecture rtl;

architecture rtl of reg8i is
    
begin
    
    main: process(clk, clr)
    begin
        if clr = '1' then
            q <= (others => '0');
        elsif rising_edge(clk) then
            if ld = '1' then
                q <= d;
            end if;
        end if;
    end process main;

    increment: process(inc)
    begin
        if rising_edge(inc) and clr = '0' and ld = '0' then
            q <= unsigned(q) + 1;
        end if;
    end process increment;
    
end architecture rtl;