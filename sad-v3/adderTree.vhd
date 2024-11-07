LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY adderTree IS
    GENERIC (N : POSITIVE);
    PORT (
        a, b, c, d : IN unsigned(n - 1 DOWNTO 0);
        s : OUT unsigned(n + 1 DOWNTO 0)
    );
END adderTree;

ARCHITECTURE arch OF adderTree IS
    SIGNAL temp1, temp2 : unsigned(n DOWNTO 0);
BEGIN
    temp1 <= resize(a, n + 1) + resize(b, n + 1);
    temp2 <= resize(c, n + 1) + resize(d, n + 1);
    s <= resize(temp1, n + 2) + resize(temp2, n + 2);
END arch;
