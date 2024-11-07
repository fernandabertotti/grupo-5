LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE ieee.math_real.ALL;

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
    SAD : OUT std_logic_vector(B + POSITIVE(ceil(real(log(real(N)) / log(2.0)))) - 1 DOWNTO 0);
    address : OUT std_logic_vector(POSITIVE(ceil(real(log(real(N/P)) / log(2.0)))) - 1 DOWNTO 0)
  );

END sad_operativo;

ARCHITECTURE arch OF sad_operativo IS

  --SIGNALS
  SIGNAL out_acc_cont : std_logic_vector(POSITIVE(ceil(real(log(real(N)) / log(2.0)))) DOWNTO 0);
  SIGNAL out_pA, out_pB : std_logic_vector(B - 1 DOWNTO 0); --saídas de pA e pB que serão entradas de absoluteDiff
  SIGNAL out_absDiff : std_logic_vector(B - 2 DOWNTO 0); --saída do absoluteDiff
  SIGNAL zeros_esquerda : std_logic_vector(POSITIVE(ceil(real(log(real(N)) / log(2.0)))) DOWNTO 0);
  SIGNAL in_acc_soma, out_acc_soma : std_logic_vector(B + POSITIVE(ceil(real(log(real(N)) / log(2.0)))) - 1 DOWNTO 0); --saída do absDiff concatenada com 0s à esquerda e entrada de SAD_reg
BEGIN
  --INSTANCIAÇÃO POR ENTIDADE
  ACC_CONT : ENTITY work.acumulador(arch)
      GENERIC MAP(N => POSITIVE(ceil(real(log(real(N)) / log(2.0)))) + 1) --deve ser capaz de representar o valor log2 de N
    PORT MAP(
      clk => clk, 
      rst => rst, 
      carga => ci, 
      sel_mux => zi, 
      valor_para_somar => (OTHERS => '1'), 
      acumulado => out_acc_cont
    );
 
      REG_PA : ENTITY work.registrador(arch)
          GENERIC MAP(N => B)
        PORT MAP(
          clk => clk, 
          rst => rst, 
          carga => cpA, 
          D => Mem_A, 
          Q => out_pA
        );

          REG_PB : ENTITY work.registrador(arch)
              GENERIC MAP(N => B)
            PORT MAP(
              clk => clk, 
              rst => rst, 
              carga => cpB, 
              D => Mem_B, 
              Q => out_pB
            );

              ABS_DIFF : ENTITY work.absoluteDiff(arch)
                  GENERIC MAP(N => B)
                PORT MAP(
                  a => out_pA, 
                  b => out_pB, 
                  s => out_absDiff
                );

                  ACC_SOMA : ENTITY work.acumulador(arch)
                      GENERIC MAP(N => B + POSITIVE(ceil(real(log(real(N)) / log(2.0)))))
                    PORT MAP(
                      clk => clk, 
                      rst => rst, 
                      carga => csoma, 
                      sel_mux => zsoma, 
                      valor_para_somar => in_acc_soma, 
                      acumulado => out_acc_soma
                    );

                      SAD_REG : ENTITY work.registrador(arch)
                          GENERIC MAP(N => B + POSITIVE(ceil(real(log(real(N)) / log(2.0)))))
                        PORT MAP(
                          clk => clk, 
                          rst => rst, 
                          carga => csad_reg, 
                          D => out_acc_soma, 
                          Q => SAD
                        );

                          --ACRESCENTAR ZEROS À ESQUERDA DA SAÍDA DE ABSDIFF
                          zeros_esquerda <= (OTHERS => '0');
                          in_acc_soma <= zeros_esquerda & out_absDiff; --concatenação

                          --OBTER SAÍDA DE CONTROLE MENOR
                          menor <= NOT (out_acc_cont(POSITIVE(ceil(real(log(real(N)) / log(2.0)))))); --MSB da saída do acumulador cont

                          --OBTER SAÍDA DE DADO ADDRESS
                          address <= out_acc_cont(POSITIVE(ceil(real(log(real(N)) / log(2.0)))) - 1 DOWNTO 0); --bits menos significativos da saída do acumulador cont

END arch;
