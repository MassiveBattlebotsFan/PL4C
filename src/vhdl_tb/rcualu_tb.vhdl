library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rcualu_tb is
end entity rcualu_tb;

architecture behaviour of rcualu_tb is
    
    signal reg_inc_txfer, reg_clr_ind : std_logic;
    signal reg_source, reg_target : std_logic_vector(2 downto 0);
    -- ACC passthrough for ALU
    signal alu_d : std_logic_vector(7 downto 0);
    signal alu_ld : std_logic;
    signal alu_clr : std_logic;
    signal alu_rclk : std_logic;
    signal alu_q : std_logic_vector(7 downto 0);
    -- data bus
    signal dbus_in, dbus_out : std_logic_vector(7 downto 0);
    -- ALU mode stuff
    signal mode_add, mode_sub, mode_xor, mode_and, mode_or, mode_not, mode_shl, mode_shr : std_logic;
    -- RCU clock + reset
    signal rcu_clk, alu_clk, rcu_en, alu_en, clk, rst : std_logic := '0';

begin
    
    rcu0 : entity work.rcu(rtl) port map (
        reg_inc_txfer => reg_inc_txfer,
        reg_clr_ind => reg_clr_ind,
        reg_source => reg_source,
        reg_target => reg_target,
        alu_d => alu_d,
        alu_ld => alu_ld,
        alu_clr => alu_clr,
        alu_clk => alu_rclk,
        alu_q => alu_q,
        dbus_in => dbus_in,
        dbus_out => dbus_out,
        clk => rcu_clk
    );
    alu0 : entity work.alu(rtl)
        port map(
            acc_in => alu_q,
            acc_out => alu_d,
            dat_in => dbus_out,
            acc_clock => alu_rclk,
            acc_load => alu_ld,
            mode_add => mode_add,
            mode_sub => mode_sub,
            mode_xor => mode_xor,
            mode_and => mode_and,
            mode_or => mode_or,
            mode_not => mode_not,
            mode_shl => mode_shl,
            mode_shr => mode_shr,
            clk => alu_clk,
            rst => rst
        );

    main: process

        type pattern_type is record
            alu_en, rcu_en : std_logic;
            command : std_logic_vector(7 downto 0);
            dbus_in : std_logic_vector(7 downto 0);
            -- mode bits
            alu_mode : std_logic_vector(7 downto 0);
            --rst : std_logic;
            dbus_out : std_logic_vector(7 downto 0);
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
        --
        -- ALU mode bits:
        -- mode_add, mode_sub, mode_xor, mode_and, mode_or, mode_not, mode_shl, mode_shr
        constant patterns : pattern_array := (
            ('0','1',"01001000","00000000","00000000","--------"),
            ('0','1',"01011010","00000000","00000000","--------"),
            ('0','1',"00000010","00000100","00000000","--------"),
            ('0','1',"11010011","00000000","00000000","--------"),
            ('0','1',"00001000","00000001","00000000","--------"),
            ('0','1',"00000001","00000001","00000000","--------"),
            ('1','1',"00001001","00000000","10000000","--------"),
            ('1','1',"00001001","00000000","00000010","--------"),
            ('0','1',"10000000","00000000","00000000","--------"),
            ('0','1',"00011011","00000000","00000000","--------"),
            ('0','1',"00000000","00000000","00000000","--------"),
            ('0','1',"00001001","00000000","00000000","--------")
        );

    begin
        
        for i in patterns'range loop
            
            dbus_in <= patterns(i).dbus_in;
            reg_inc_txfer <= patterns(i).command(7);
            reg_clr_ind <= patterns(i).command(6);
            reg_source <= patterns(i).command(5 downto 3);
            reg_target <= patterns(i).command(2 downto 0);
            mode_add <= patterns(i).alu_mode(7);
            mode_sub <= patterns(i).alu_mode(6);
            mode_xor <= patterns(i).alu_mode(5);
            mode_and <= patterns(i).alu_mode(4);
            mode_or <= patterns(i).alu_mode(3);
            mode_not <= patterns(i).alu_mode(2);
            mode_shl <= patterns(i).alu_mode(1);
            mode_shr <= patterns(i).alu_mode(0);
            alu_clr <= 'L';
            rcu_en <= patterns(i).rcu_en;
            alu_en <= '0';
            clk <= '0';
            wait for 0.5 ns;
            clk <= '1';
            wait for 0.25 ns;
            alu_en <= patterns(i).alu_en;
            wait for 0.25 ns;
            
            if patterns(i).dbus_out /= "--------" then
                assert dbus_out = patterns(i).dbus_out report "Data bus in bad state" severity error;
            end if;
        end loop;
        
        assert false report "Test completed" severity note;
        wait;

    end process main;
    
    rcu_clk <= clk when rcu_en = '1' else '0';
    alu_clk <= clk when alu_en = '1' else '0';
    rst <= not to_x01(alu_en);

end architecture behaviour;