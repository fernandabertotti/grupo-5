LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY adder_unsigned IS --é unsigned porque somente é utilizado para valores positivos (ou após o abs ou pro reg cont)
    GENERIC (N : INTEGER);
    PORT (
        A, B : IN unsigned(N - 1 DOWNTO 0);
        result : OUT std_logic_vector(N - 1 DOWNTO 0)
    );
END adder_unsigned;

ARCHITECTURE arch OF adder_unsigned IS
    SIGNAL sum : unsigned(N DOWNTO 0);
BEGIN
    sum <= resize(A, N + 1) + resize(B, N + 1);
    result <= std_logic_vector(sum(N - 1 DOWNTO 0)); --desconsidera Cout do resultado da soma
END arch;
