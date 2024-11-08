LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY absoluteDiff IS
    GENERIC (N : POSITIVE);
    PORT (
        a : IN std_logic_vector(N - 1 DOWNTO 0);
        b : IN std_logic_vector(N - 1 DOWNTO 0);
        s : OUT std_logic_vector(N - 2 DOWNTO 0)
    );
END absoluteDiff;

ARCHITECTURE arch OF absoluteDiff IS
    SIGNAL a_menos_b, b_menos_a : signed(N - 1 DOWNTO 0);
    SIGNAL saida_mux : std_logic_vector(N - 1 DOWNTO 0);

BEGIN
    SUB1 : ENTITY work.subtractor_signed(arch)
            GENERIC MAP(N => N)
        PORT MAP(
            A => signed(a), 
            B => signed(b), 
            S => a_menos_b
        );

            SUB2 : ENTITY work.subtractor_signed(arch)
                    GENERIC MAP(N => N)
                PORT MAP(
                    A => signed(b), 
                    B => signed(a), 
                    S => b_menos_a
                );

                    MUX : ENTITY work.mux2x1(arch)
                            GENERIC MAP(N => N)
                        PORT MAP(
                            F1 => std_logic_vector(a_menos_b), 
                            F2 => std_logic_vector(b_menos_a), 
                            sel => a_menos_b(N - 1), 
                            F => saida_mux
                        );

                            s <= saida_mux(N - 2 DOWNTO 0);

END arch;
