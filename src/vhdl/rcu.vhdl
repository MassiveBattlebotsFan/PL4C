library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rcu is
    port (
        -- RCU modes
        -- RCU register select
        -- bit layout is:
        -- 7 6 5 4 3 2 1 0
        -- 7: increment mode or txfer if not target ctr
        -- 6: increment sign or clear if not increment mode
        -- 3-5: source register (n/a if bit 6 or 7)
        -- 0-2: target register
        -- reg_select : in std_logic_vector(7 downto 0);

        reg_inc_txfer, reg_clr_ind : in std_logic;
        reg_source, reg_target : in std_logic_vector(2 downto 0);

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
    
    type reg_conn_type is record
        d, q : std_logic_vector(7 downto 0);
        ld, clr, clk : std_logic;
    end record reg_conn_type;

    type reg_conn_array is array (natural range <>) of reg_conn_type;

    signal reg_conn : reg_conn_array(0 to 7);

    -- CTR increment and increment direction
    signal ctr_inc, ctr_ind : std_logic;
    -- swap register
    signal reg_swap : std_logic_vector(7 downto 0);

begin
    
    -- ACC register is special
    -- registers:
    -- ACC, BAK, VEC, CTR, INT, LB, UB, PG
    
    gen_reg: for i in 0 to 7 generate
        ctr_gen: if i = 3 generate
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

        all_but_ctr_gen: if i /= 3 generate    
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
    
    main: process(clk,rst,alu_d,alu_ld,alu_clr,alu_clk)
    begin
        if rst = '1' then
            
            reg_conn(0).d <= alu_d;
            reg_conn(0).ld <= alu_ld;
            reg_conn(0).clr <= alu_clr;
            reg_conn(0).clk <= alu_clk;
            
            for i in 1 to 7 loop
                reg_conn(i).d <= (others => 'Z');
                reg_conn(i).ld <= '0';
                reg_conn(i).clr <= '0';
                reg_conn(i).clk <= '0';
            end loop;

            ctr_ind <= '0';
            ctr_inc <= '0';

            dbus <= (others => 'Z');

        elsif rising_edge(clk) then
            
            if to_x01(reg_inc_txfer) = '0' then
                -- if both these bits are 0 we're in read or write mode
                if reg_clr_ind = '0' then
                    -- if equivalent then read mode
                    if reg_source = reg_target then
                        reg_conn(to_integer(unsigned(reg_target))).ld <= '0';
                        reg_conn(to_integer(unsigned(reg_target))).clr <= '0';
                        reg_conn(to_integer(unsigned(reg_target))).clk <= '0';
                        dbus <= reg_conn(to_integer(unsigned(reg_target))).q;
                    else
                        reg_conn(to_integer(unsigned(reg_target))).clr <= '0';
                        reg_conn(to_integer(unsigned(reg_target))).d <= dbus;
                        reg_conn(to_integer(unsigned(reg_target))).ld <= '1';
                        reg_conn(to_integer(unsigned(reg_target))).clk <= '1';
                    end if;
                else
                    -- clr mode set, clear source + target register
                    reg_conn(to_integer(unsigned(reg_source))).clr <= '1';
                    reg_conn(to_integer(unsigned(reg_target))).clr <= '1';
                end if;
            else
                -- either in increment or transfer mode
                -- increment if source = target, tx otherwise
                if reg_source = reg_target then
                    ctr_ind <= reg_clr_ind;
                    ctr_inc <= '1';
                    reg_conn(3).ld <= '0';
                    reg_conn(3).clr <= '0';
                    reg_conn(3).clk <= '1';
                else
                    -- transfer or swap mode
                    if reg_clr_ind = '1' then
                        -- swap mode
                        reg_conn(to_integer(unsigned(reg_source))).ld <= '1';
                        reg_conn(to_integer(unsigned(reg_source))).clr <= '0';
                        reg_conn(to_integer(unsigned(reg_target))).ld <= '1';
                        reg_conn(to_integer(unsigned(reg_target))).clr <= '0';

                        reg_swap <= reg_conn(to_integer(unsigned(reg_source))).q;
                        reg_conn(to_integer(unsigned(reg_source))).d <= reg_conn(to_integer(unsigned(reg_target))).q;
                        reg_conn(to_integer(unsigned(reg_target))).d <= reg_swap;
                        
                        reg_conn(to_integer(unsigned(reg_source))).clk <= '1';
                        reg_conn(to_integer(unsigned(reg_target))).clk <= '1';
                    else
                        -- transfer mode
                        reg_conn(to_integer(unsigned(reg_target))).ld <= '1';
                        reg_conn(to_integer(unsigned(reg_target))).clr <= '0';
                        reg_conn(to_integer(unsigned(reg_target))).d <= reg_conn(to_integer(unsigned(reg_source))).q;
                        reg_conn(to_integer(unsigned(reg_target))).clk <= '1';
                    end if;
                end if;
            end if;
        end if;
    end process main;

    alu_q <= reg_conn(0).q;

end architecture rtl;