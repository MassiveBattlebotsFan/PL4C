library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dec is
    port (
        instruction : in std_logic_vector(7 downto 0);
        argument : in std_logic_vector(7 downto 0)
    );
end entity dec;