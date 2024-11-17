library ieee;
use ieee.std_logic_1164.all;

entity sad_controle is
    port(
        clk, reset, enable, menor: in std_logic;
        read_mem, done, zi, ci, cpA, cpB, zsoma, csoma, csad_reg: out std_logic
        );
    end sad_controle;
    
architecture arch of sad_controle is
    type tipo_estado is (s0,s1,s2,s3,s4,s5);
    signal estado_atual, proximo_estado: tipo_estado;
begin

    process (clk, reset) --registrador
    begin
        if reset = '1' then
            estado_atual <= s0; --estado após o reset
        elsif (rising_edge(clk)) then
            estado_atual <= proximo_estado;
        end if;
    end process;

process (enable, menor, estado_atual) --lógica de próximo estado e saídas (verificar se dont care funciona no quartus)
    begin
        case estado_atual is
        
            when s0 =>
                read_mem <= '0';
                done <= '1';
                zi <= '-';
                ci <= '0';
                cpA <= '0';
                cpB <= '0';
                zsoma <= '-';
                csoma <= '0';
                csad_reg <= '0';
                
                if enable = '1' then
                    proximo_estado <= s1;
                else
                    proximo_estado <= s0;
                end if;
 
            when s1 =>
                read_mem <= '0';
                done <= '0';
                zi <= '1';
                ci <= '1';
                cpA <= '0';
                cpB <= '0';
                zsoma <= '1';
                csoma <= '1';
                csad_reg <= '0';
                proximo_estado <= s2;
                
            when s2 =>
                read_mem <= '0';
                done <= '0';
                zi <= '-';
                ci <= '0';
                cpA <= '0';
                cpB <= '0';
                zsoma <= '-';
                csoma <= '0';
                csad_reg <= '0';
                if menor = '1' then
                    proximo_estado <= s3;
                else
                    proximo_estado <= s5;
                end if;
                
            when s3 =>
                read_mem <= '1';
                done <= '0';
                zi <= '-';
                ci <= '0';
                cpA <= '1';
                cpB <= '1';
                zsoma <= '0';
                csoma <= '0';
                csad_reg <= '0';
                proximo_estado <= s4;
                
            when s4 =>
                read_mem <= '0';
                done <= '0';
                zi <= '0';
                ci <= '1';
                cpA <= '0';
                cpB <= '0';
                zsoma <= '0';
                csoma <= '1';
                csad_reg <= '0';
                proximo_estado <= s2;

             when s5 =>
                read_mem <= '0';
                done <= '0';
                zi <= '-';
                ci <= '0';
                cpA <= '0';
                cpB <= '0';
                zsoma <= '-';
                csoma <= '0';
                csad_reg <= '1';
                proximo_estado <= s0;
            
        end case;
    end process;
end arch;
