library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rcu is
    port (
        -- RCU modes
        -- mode_read, mode_write, mode_inc, mode_dec, mode_txfer, mode_clear : in std_logic := '0';
        -- RCU register select
        -- bit layout is:
        -- 7 6 5 4 3 2 1 0
        -- 7: increment mode (only applicable to ctr?)
        -- 6: increment sign
        -- 3-5: source register (n/a in inc mode)
        -- 0-2: target register
        reg_select : in std_logic_vector(7 downto 0);
        -- ACC passthrough for ALU
        alu_d : in std_logic_vector(7 downto 0);
        alu_ld : in std_logic;
        alu_clr : in std_logic;
        alu_clk : in std_logic;
        alu_q : out std_logic_vector(7 downto 0);
        -- data bus
        dbus : inout std_logic_vector(7 downto 0);
        -- RCU clock + reset
        clk, rst : in std_logic := '0'
    );
end entity rcu;

architecture rtl of rcu is
    
    -- ACC
    signal acc_d, acc_q : std_logic_vector(7 downto 0);
    signal acc_ld, acc_clr, acc_clk : std_logic;
    
    type reg_conn_type is record
        d, q : std_logic_vector(7 downto 0);
        ld, clr, clk : std_logic;
    end record reg_conn_type;

    type reg_conn_array is array (natural range <>) of reg_conn_type;

    signal reg_conn : reg_conn_array(0 to 6);

    -- CTR increment and increment direction
    signal ctr_inc, ctr_ind : std_logic;

begin
    
    -- ACC register is special
    -- registers:
    -- ACC, BAK, VEC, CTR, INT, LB, UB, PG
    
    reg_acc : entity work.reg_generic(rtl)
        generic map(register_width => 8)
        port map(
            d => acc_d,
            ld => acc_ld,
            clr => acc_clr,
            clk => acc_clk,
            q => acc_q,
            ind => '0',
            inc => '0'
        );
    
    gen_reg: for i in 0 to 6 generate
        ctr_gen: if i = 2 generate
            reg_ctr : entity work.reg_generic(rtl)
            generic map(register_width => 8)
            port map(
                d => reg_conn(i).d,
                ld => reg_conn(i).ld,
                clr => reg_conn(i).clr,
                clk => reg_conn(i).clk,
                q => reg_conn(i).q,
                ind => ctr_ind,
                inc => ctr_inc
            );
        end generate ctr_gen;

        all_but_ctr_gen: if i /= 2 generate    
            regx : entity work.reg_generic(rtl)
                generic map(register_width => 8)
                port map(
                    d => reg_conn(i).d,
                    ld => reg_conn(i).ld,
                    clr => reg_conn(i).clr,
                    clk => reg_conn(i).clk,
                    q => reg_conn(i).q,
                    ind => '0',
                    inc => '0'
                );
        end generate all_but_ctr_gen;
    end generate gen_reg;  
    
    main: process(clk, rst)
    begin
        if rst = '1' then
            acc_d <= (others => 'Z');
            acc_ld <= 'Z';
            acc_clr <= 'Z';
            acc_clk <= 'Z';
            acc_q <= 'Z';
            reg_reset_gen: for i in 0 to 6 generate
                
            end generate reg_reset_gen;

        elsif rising_edge(clk) then
            
        end if;
    end process main;
    
end architecture rtl;