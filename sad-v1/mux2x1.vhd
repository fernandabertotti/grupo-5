LIBRARY IEEE;
USE IEEE.Std_Logic_1164.ALL;

ENTITY mux2x1 IS
    GENERIC (N : POSITIVE); --valor será definido na instanciação do componente
    PORT (
        F1 : IN std_logic_vector(N - 1 DOWNTO 0);
        F2 : IN std_logic_vector(N - 1 DOWNTO 0);
        sel : IN std_logic;
        F : OUT std_logic_vector(N - 1 DOWNTO 0)
    );
END mux2x1;

ARCHITECTURE arch OF mux2x1 IS
BEGIN
    F <= F1 WHEN sel = '0' ELSE --uso da estrutura de seleção condicional when else
         F2;
END arch;
