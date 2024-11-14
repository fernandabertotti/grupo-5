LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY sad_controle IS
    PORT (
        clk, reset, enable, menor : IN std_logic;
        read_mem, done, zi, ci, cpA, cpB, zsoma, csoma, csad_reg : OUT std_logic
    );
END sad_controle;
 
ARCHITECTURE arch OF sad_controle IS
    TYPE tipo_estado IS (s0, s1, s2, s3, s4, s5);
    SIGNAL estado_atual, proximo_estado : tipo_estado;
BEGIN
    PROCESS (clk, reset) --registrador
    BEGIN
        IF reset = '1' THEN
            estado_atual <= s0; --estado após o reset
        ELSIF (rising_edge(clk)) THEN
            estado_atual <= proximo_estado;
        END IF;
    END PROCESS;

    PROCESS (enable, menor, estado_atual) --lógica de próximo estado e saídas 
        BEGIN
            CASE estado_atual IS
 
                WHEN s0 => 
                    read_mem <= '0';
                    done <= '1';
                    zi <= '-'; --don't care
                    ci <= '0';
                    cpA <= '0';
                    cpB <= '0';
                    zsoma <= '-'; --don't care
                    csoma <= '0';
                    csad_reg <= '0';
 
                    IF enable = '1' THEN
                        proximo_estado <= s1;
                    ELSE
                        proximo_estado <= s0;
                    END IF;

                WHEN s1 => 
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
 
                WHEN s2 => 
                    read_mem <= '0';
                    done <= '0';
                    zi <= '-'; --don't care
                    ci <= '0';
                    cpA <= '0';
                    cpB <= '0';
                    zsoma <= '-'; --don't care
                    csoma <= '0';
                    csad_reg <= '0';
                    IF menor = '1' THEN
                        proximo_estado <= s3;
                    ELSE
                        proximo_estado <= s5;
                    END IF;
 
                WHEN s3 => 
                    read_mem <= '1';
                    done <= '0';
                    zi <= '-'; --don't care
                    ci <= '0';
                    cpA <= '1';
                    cpB <= '1';
                    zsoma <= '0';
                    csoma <= '0';
                    csad_reg <= '0';
                    proximo_estado <= s4;
 
                WHEN s4 => 
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

                WHEN s5 => 
                    read_mem <= '0';
                    done <= '0';
                    zi <= '-'; --don't care
                    ci <= '0';
                    cpA <= '0';
                    cpB <= '0';
                    zsoma <= '-'; --don't care
                    csoma <= '0';
                    csad_reg <= '1';
                    proximo_estado <= s0;
 
            END CASE;
        END PROCESS;
END arch;
