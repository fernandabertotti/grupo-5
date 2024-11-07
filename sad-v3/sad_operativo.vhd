LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.math_real.ALL;
USE ieee.numeric_std.ALL;

ENTITY sad_operativo IS
    GENERIC (
        N : POSITIVE;
        B : POSITIVE;
        P : POSITIVE
    );
    PORT (
        clk, rst : IN std_logic;
 
        -- ENTRADAS DE DADOS
        Mem_A : IN std_logic_vector(B * P - 1 DOWNTO 0);
        Mem_B : IN std_logic_vector(B * P - 1 DOWNTO 0);

        --ENTRADAS DE CONTROLE
        zi, ci, cpA, cpB, zsoma, csoma, csad_reg : IN std_logic;

        -- SAÍDA DE CONTROLE
        menor : OUT std_logic;

        -- SAIDAS DE DADOS
        SAD : OUT std_logic_vector(B + POSITIVE(ceil(log2(real(N)))) - 1 DOWNTO 0);
        address : OUT std_logic_vector(POSITIVE(ceil(log2(real(N/P)))) - 1 DOWNTO 0)
    );

END sad_operativo;

ARCHITECTURE arch OF sad_operativo IS

    --SIGNALS
    TYPE out_reg_array IS ARRAY (0 TO P - 1) OF std_logic_vector(B - 1 DOWNTO 0); --array para armazenar as saídas dos registradores
    SIGNAL out_pA, out_pB : out_reg_array; --saídas de pAs e pBs

    TYPE out_absdiff_array IS ARRAY (0 TO P - 1) OF std_logic_vector(B - 1 DOWNTO 0); --array para armazenar as saídas dos absoluteDiffs concatenadas com 0 à esquerda
    SIGNAL out_absdiff : out_absdiff_array; --saídas de absDiffs

    SIGNAL out_acc_cont : std_logic_vector(POSITIVE(ceil(log2(real(N/P)))) DOWNTO 0); --deve ter tamanho (log2 de N/P) + 1
    SIGNAL zeros_esquerda : std_logic_vector(POSITIVE(ceil(log2(real(N)))) - 3 DOWNTO 0); --(log2 de N) -2
    SIGNAL in_add0, in_add1, in_add2, in_add3 : unsigned(B - 1 DOWNTO 0); --entradas da adderTree
    SIGNAL out_adderTree : unsigned(B + 1 DOWNTO 0); --saída de adderTree, a ser concatenada com zeros à esquerda
    SIGNAL in_acc_soma, out_acc_soma : std_logic_vector(B + POSITIVE(ceil(log2(real(N)))) - 1 DOWNTO 0); --saída de adderTree concatenada com zeros à esquerda e saída do acc soma
BEGIN
    --INSTANCIAÇÃO POR ENTIDADE
    ACC_CONT : ENTITY work.acumulador(arch)
            GENERIC MAP(N => POSITIVE(ceil(log2(real(N/P)))) + 1)
        PORT MAP(
            clk => clk, 
            rst => rst, 
            carga => ci, 
            sel_mux => zi, 
            valor_para_somar => (OTHERS => '1'), 
            acumulado => out_acc_cont
        );

            --USO DO GENERATE PARA GERAR OS P REGISTRADORES QUE ARMAZENAM A ENTRADA MEM_A
            gen_regA : FOR i IN 0 TO P - 1 GENERATE
                REG_PA : ENTITY work.registrador(arch)
                        GENERIC MAP(N => B)
                    PORT MAP(
                        clk => clk, 
                        rst => rst, 
                        carga => cpA, 
                        D => Mem_A((i + 1) * B - 1 DOWNTO i * B), 
                        Q => out_pA(i)
                    );
            END GENERATE;

            --USO DO GENERATE PARA CRIAR OS P REGISTRADORES QUE ARMAZENAM A ENTRADA MEM_B
            gen_regB : FOR i IN 0 TO P - 1 GENERATE
                REG_PB0 : ENTITY work.registrador(arch)
                        GENERIC MAP(N => B)
                    PORT MAP(
                        clk => clk, 
                        rst => rst, 
                        carga => cpB, 
                        D => Mem_B((i + 1) * B - 1 DOWNTO i * B), 
                        Q => out_pB(i)
                    );
            END GENERATE;

            --USO DO GENERATE PARA CRIAR OS P MÓDULOS ABSOLUTEDIFF
            gen_abs_diff : FOR i IN 0 TO P - 1 GENERATE
                ABS_DIFF : ENTITY work.absoluteDiff(arch)
                        GENERIC MAP(N => B)
                    PORT MAP(
                        a => out_pA(i), 
                        b => out_pB(i), 
                    s => out_absdiff(i)(B - 2 DOWNTO 0)); -- saída de absdiff sem 0 concatenado
                        --Concatenando 0 à esquerda
                        out_absdiff(i) <= '0' & out_absdiff(i)(B - 2 DOWNTO 0);
            END GENERATE;

            ADDERTREE : ENTITY work.adderTree(arch) --DÚVIDA: como seria possível deixar mais genérico? Para essa solução funcionar, sempre teria que ter ao menos 4 operandos
                    GENERIC MAP(N => B)
                PORT MAP(
                    a => unsigned(out_absdiff(0)), 
                    b => unsigned(out_absdiff(1)), 
                    c => unsigned(out_absdiff(2)), 
                    d => unsigned(out_absdiff(3)), 
                    s => out_adderTree
                );

                    ACC_SOMA : ENTITY work.acumulador(arch)
                            GENERIC MAP(N => B + POSITIVE(ceil(log2(real(N)))))
                        PORT MAP(
                            clk => clk, 
                            rst => rst, 
                            carga => csoma, 
                            sel_mux => zsoma, 
                            valor_para_somar => in_acc_soma, 
                            acumulado => out_acc_soma
                        );

                            SAD_REG : ENTITY work.registrador(arch)
                                    GENERIC MAP(N => B + POSITIVE(ceil(log2(real(N)))))
                                PORT MAP(
                                    clk => clk, 
                                    rst => rst, 
                                    carga => csad_reg, 
                                    D => out_acc_soma, 
                                    Q => SAD
                                );

                                    --ACRESCENTAR ZEROS À ESQUERDA DA SAÍDA DE ADDERTREE
                                    zeros_esquerda <= (OTHERS => '0');
                                    in_acc_soma <= zeros_esquerda & std_logic_vector(out_adderTree); --concatenação

                                    --OBTER SAÍDA DE CONTROLE MENOR
                                    menor <= NOT (out_acc_cont(POSITIVE(ceil(log2(real(N/P)))))); --MSB da saída do acumulador cont

                                    --OBTER SAÍDA DE DADO ADDRESS
                                    address <= out_acc_cont(POSITIVE(ceil(log2(real(N/P)))) - 1 DOWNTO 0); --bits menos significativos da saída do acumulador cont

END arch;
