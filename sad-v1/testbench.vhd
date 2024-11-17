library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
USE ieee.math_real.ALL;

entity testbench is
end testbench;

architecture tb of testbench is
  CONSTANT b_bits : natural := 8;
  CONSTANT n_bits : natural := 64;
  CONSTANT p_bits : natural := 1;
  signal clk, enable, reset : std_logic := '0'; --input
  signal mem_A, mem_B : std_logic_vector (b_bits*p_bits -1 downto 0); --input
  signal read_mem, done : std_logic := '0'; --output
  signal address : std_logic_vector (POSITIVE(ceil(real(log(real(n_bits/p_bits)) / log(2.0)))) - 1 downto 0); --output
  signal sad_value : std_logic_vector (b_bits + POSITIVE(ceil(real(log(real(n_bits)) / log(2.0)))) - 1 downto 0); --output
  signal finished : std_logic := '0';

  CONSTANT periodo_clk : TIME := 10 ns; --dúvida sobre o período de clk

begin

  DUV: entity work.sad --tirei a arquitetura porque nos slides não tinha
    generic map(B => b_bits, --incluí generic map pra ver se muda algo
                N => n_bits,
                P = p_bits)
    port map(clk => clk, 
             enable => enable, 
             reset => reset, 
             sample_ori => mem_A, 
             sample_can => mem_B, 
             read_mem => read_mem, 
             address => address, 
             sad_value => sad_value, 
             done => done );
    
    clk <= not clk after periodo_clk/2 when finished /= '1' else '0'; --dá pra usar o finished também
    
  process
  begin   

    --CASO DE TESTE 1: FUNCIONAMENTO DO RESET
    enable <= '1';
    reset <= '1';
    mem_A <= std_logic_vector(to_unsigned(0, mem_A'length));
    mem_B <= std_logic_vector(to_unsigned(255, mem_B'length));
    wait for periodo_clk*10; --DÚVIDA SE É SUFICIENTE
    assert(sad_value = "00000000000000") 
    report "Falha no primeiro teste - Reset não funciona" severity error;

    --CASO DE TESTE 2: FUNCIONAMENTO DO ENABLE
    enable <= '0';
    reset <= '0';
    mem_A <= std_logic_vector(to_unsigned(0, mem_A'length));
    mem_B <= std_logic_vector(to_unsigned(255, mem_B'length));
    wait for periodo_clk*10; 
    assert(sad_value = "00000000000000")
    report "Falha no segundo teste - Enable não funciona" severity error;

    --CASO DE TESTE 3: CÁLCULO DA SAD COM AMOSTRAS DE A VALENDO 255 E AMOSTRAS DE B VALENDO 0
    enable <= '1';
    reset <= '0';
    mem_A <= std_logic_vector(to_unsigned(255, mem_A'length));
    mem_B <= std_logic_vector(to_unsigned(0, mem_B'length));
    wait until done'event and done = '1'; --esperar por todo o tempo de execução da sad
    wait for periodo_clk; --contabilizar o tco do registrador sad_value
    assert(sad_value = "11111111111111")
    report "Falha no terceiro teste - Cálculo da SAD não funciona" severity error;

    --CASO DE TESTE 4: CÁLCULO DA SAD COM AMOSTRAS DE A VALENDO 0 E AMOSTRAS DE B VALENDO 255
    enable <= '1';
    reset <= '0';
    mem_A <= std_logic_vector(to_unsigned(0, mem_A'length));
    mem_B <= std_logic_vector(to_unsigned(255, mem_B'length));
    wait until done'event and done = '1'; --esperar por todo o tempo de execução da sad
    wait for periodo_clk; --contabilizar o tco do registrador sad_value
    assert(sad_value = "11111111111111")
    report "Falha no quarto teste - Cálculo da SAD não funciona" severity error;

    --CASO DE TESTE 5: CÁLCULO DA SAD COM AMOSTRAS DE A VALENDO 0 E AMOSTRAS DE B VALENDO 0
    enable <= '1';
    reset <= '0';
    mem_A <= std_logic_vector(to_unsigned(0, mem_A'length));
    mem_B <= std_logic_vector(to_unsigned(0, mem_B'length));
    wait until done'event and done = '1'; --esperar por todo o tempo de execução da sad
    wait for periodo_clk; --contabilizar o tco do registrador sad_value
    assert(sad_value = "00000000000000")
    report "Falha no quinto teste - Cálculo da SAD não funciona" severity error;

    wait for periodo_clk;
    assert false report "Teste finalizado" severity note;
    finished <= '1';
    wait;
  end process;
end tb;
