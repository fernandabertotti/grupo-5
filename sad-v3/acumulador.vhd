
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY acumulador IS
    GENERIC (N : POSITIVE);
    PORT (
        clk, rst, carga, sel_mux : IN std_logic; --entradas dos registradores e seletor do mux
        valor_para_somar : IN std_logic_vector(N - 1 DOWNTO 0); --entrada do acumulador
        acumulado : OUT std_logic_vector(N - 1 DOWNTO 0) --saída do acumulador
    );
END acumulador;

ARCHITECTURE arch OF acumulador IS
    SIGNAL mux_in0 : std_logic_vector(N - 1 DOWNTO 0); -- entrada do multiplexador quando seletor é 0
    SIGNAL mux_out : std_logic_vector(N - 1 DOWNTO 0); -- saída do multiplexador
    SIGNAL reg_in : std_logic_vector(N - 1 DOWNTO 0); -- entrada do registrador
    SIGNAL valor_ja_acumulado : std_logic_vector(N - 1 DOWNTO 0); -- saída do registrador
    SIGNAL adder_out : std_logic_vector(N - 1 DOWNTO 0); -- saída do somador

BEGIN
    MUX : ENTITY work.mux2x1(arch)
            GENERIC MAP(N => N)
        PORT MAP(
            F1 => adder_out, 
            F2 => (OTHERS => '0'), 
            sel => sel_mux, 
            F => mux_out
        );

            REG : ENTITY work.registrador(arch)
                    GENERIC MAP(N => N)
                PORT MAP(
                    clk => clk, 
                    rst => rst, 
                    carga => carga, 
                    D => mux_out, 
                    Q => valor_ja_acumulado
                );

                    SOMADOR : ENTITY work.adder_unsigned(arch)
                            GENERIC MAP(N => N)
                        PORT MAP(
                            A => unsigned(valor_para_somar), 
                            B => unsigned(valor_ja_acumulado), 
                            result => adder_out
                        );

                            acumulado <= valor_ja_acumulado;

END arch;
