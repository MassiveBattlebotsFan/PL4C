library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu is
    port (
        -- accumulator and data bus
        acc_in, dat_in : std_logic_vector(7 downto 0);
        
    );
end entity alu;