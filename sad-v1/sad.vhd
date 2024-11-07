LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.math_real.ALL;
USE ieee.numeric_std.ALL;

ENTITY sad IS
    GENERIC (
        B : POSITIVE := 8; 
        N : POSITIVE := 64; 
        P : POSITIVE := 1 
    );
    PORT (
        clk : IN STD_LOGIC; 
        enable : IN STD_LOGIC; 
        reset : IN STD_LOGIC; 
        sample_ori : IN STD_LOGIC_VECTOR (B * P - 1 DOWNTO 0); 
        sample_can : IN STD_LOGIC_VECTOR (B * P - 1 DOWNTO 0); 
        read_mem : OUT STD_LOGIC; 
        address : OUT STD_LOGIC_VECTOR (POSITIVE(ceil(real(log(real(N/P)) / log(2.0)))) - 1 DOWNTO 0); 
        sad_value : OUT STD_LOGIC_VECTOR (B + POSITIVE(ceil(real(log(real(N)) / log(2.0)))) - 1 DOWNTO 0); 
        done : OUT STD_LOGIC 
    );
END ENTITY; 

ARCHITECTURE arch OF sad IS

    SIGNAL menor, zi, ci, cpA, cpB, zsoma, csoma, csad_reg : std_logic;
 
BEGIN
    CONTROLE : ENTITY work.sad_controle(arch)
        PORT MAP(
            clk => clk, 
            reset => reset, 
            enable => enable, 
            menor => menor, 
            read_mem => read_mem, 
            done => done, 
            zi => zi, 
            ci => ci, 
            cpA => cpA, 
            cpB => cpB, 
            zsoma => zsoma, 
            csoma => csoma, 
            csad_reg => csad_reg
        );

            OPERATIVO : ENTITY work.sad_operativo(arch)
                    GENERIC MAP(
                    N => N, 
                    B => B, 
                    P => P)
                    PORT MAP(
                        clk => clk, 
                        rst => reset, 
                        Mem_A => sample_ori, 
                        Mem_B => sample_can, 
                        zi => zi, 
                        ci => ci, 
                        cpA => cpA, 
                        cpB => cpB, 
                        zsoma => zsoma, 
                        csoma => csoma, 
                        csad_reg => csad_reg, 
                        menor => menor, 
                        SAD => sad_value, 
                        address => address
                    );
 
END ARCHITECTURE;
