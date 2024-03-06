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
    signal dbus_in, dbus_out : std_logic_vector(7 downto 0);
    -- RCU clock + reset
    signal clk : std_logic := '0';

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
        dbus_in => dbus_in,
        dbus_out => dbus_out,
        clk => clk
    );

    main: process

        type pattern_type is record
            command : std_logic_vector(7 downto 0);
            dbus_in, dbus_out : std_logic_vector(7 downto 0);
            --rst : std_logic;
        end record pattern_type;

        type pattern_array is array (natural range <>) of pattern_type;

        -- RCU modes
        -- RCU register select
        -- bit layout is:
        -- 7 6 5 4 3 2 1 0
        -- 7: increment mode or txfer if not target ctr
        -- 6: increment sign or clear if not increment mode
        -- 3-5: source register (n/a if bit 6 or 7)
        -- 0-2: target register
        -- reg_select : in std_logic_vector(7 downto 0);
        -- 
        -- registers in order:
        -- ACC, BAK, VEC, CTR, INT, LB, UB, PG
        
        constant patterns : pattern_array := (
            ("01000001","00000000","--------"),
            ("00001000","10101010","--------"),
            ("10000001","--------","--------"),
            ("00000000","--------","10101010"),
            ("00000001","01010101","--------"),
            ("11001000","--------","--------"),
            ("00000000","--------","01010101"),
            ("00001001","--------","10101010")
        );

    begin
        
        for i in patterns'range loop
            
            alu_clk <= '0';
            alu_clr <= '0';
            alu_d <= (others => '0');
            alu_ld <= '0';
            dbus_in <= patterns(i).dbus_in;
            reg_inc_txfer <= patterns(i).command(7);
            reg_clr_ind <= patterns(i).command(6);
            reg_source <= patterns(i).command(5 downto 3);
            reg_target <= patterns(i).command(2 downto 0);
            --rst <= '1';
            clk <= '0';
            wait for 0.5 ns;
            --rst <= '0';
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