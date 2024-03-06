library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rcu_tb is
end entity rcu_tb;

architecture behaviour of rcu_tb is
    
    signal reg_inc_txfer, reg_clr_ind : std_logic;
    signal reg_source, reg_target : std_logic_vector(2 downto 0);
    -- ACC passthrough for ALU
    signal alu_d : std_logic_vector(7 downto 0);
    signal alu_ld : std_logic;
    signal alu_clr : std_logic;
    signal alu_clk : std_logic;
    signal alu_q : std_logic_vector(7 downto 0);
    -- data bus
    signal dbus : std_logic_vector(7 downto 0);
    -- RCU clock + reset
    signal clk, rst : std_logic := '0';

begin
    
    rcu0 : entity work.rcu(rtl) port map (
        reg_inc_txfer => reg_inc_txfer,
        reg_clr_ind => reg_clr_ind,
        reg_source => reg_source,
        reg_target => reg_target,
        alu_d => alu_d,
        alu_ld => alu_ld,
        alu_clr => alu_clr,
        alu_clk => alu_clk,
        alu_q => alu_q,
        dbus => dbus,
        clk => clk,
        rst => rst
    );

    main: process
    begin
        wait;
    end process main;
    
end architecture behaviour;