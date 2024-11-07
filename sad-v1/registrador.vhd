LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY registrador IS
    GENERIC (N : INTEGER); --o valor do generic será definido na instanciação desse componente
    PORT (
        clk, rst, carga : IN std_logic;
        D : IN std_logic_vector(N - 1 DOWNTO 0);
        Q : OUT std_logic_vector(N - 1 DOWNTO 0)
    );
END registrador;

ARCHITECTURE arch OF registrador IS
BEGIN
    PROCESS (rst, clk)
    BEGIN
        IF (rst = '1') THEN
            Q <= (OTHERS => '0'); --others é uma palavra-chave para representar todos os valores de índices que não foram especificados
        ELSIF (rising_edge(clk) AND carga = '1') THEN
            Q <= D;
        END IF;
    END PROCESS;
END arch;
