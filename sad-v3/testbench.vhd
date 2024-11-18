library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity testbench is
end testbench;

architecture tb of testbench is

  CONSTANT b_bits : natural := 8;
  CONSTANT n_bits : natural := 64;
  CONSTANT p_bits : natural := 4;
  signal clk, enable, reset : std_logic := '0';
  signal mem_A, mem_B : std_logic_vector (b_bits*p_bits -1 downto 0);
  signal read_mem, done : std_logic := '0';
  signal address: std_logic_vector (positive(ceil(log2(real(n_bits/p_bits))))-1 downto 0);
  signal sad_value : std_logic_vector (b_bits + positive(ceil(log2(real(n_bits))))-1 downto 0);

  CONSTANT periodo_clk : time := 10 ns;
begin

  DUV : entity work.sad
    port map(clk => clk, 
             enable => enable, 
             reset => reset, 
             sample_ori => mem_A, 
             sample_can => mem_B, 
             read_mem => read_mem, 
             done => done,
             address => address, 
             sad_value => sad_value);
				 
  stim: process is
    file arquivo_de_estimulos : text open read_mode is "../../estimulos.dat";
    variable linha_de_estimulos: line;
    variable espaco: character;
    variable valor_de_memA: bit_vector(b_bits*p_bits -1 downto 0);
    variable valor_de_memB: bit_vector(b_bits*p_bits -1 downto 0);
    variable valor_de_saida: bit_vector(b_bits + positive(ceil(log2(real(n_bits))))-1 downto 0);
    begin

   while not endfile(arquivo_de_estimulos) loop
			readline(arquivo_de_estimulos, linha_de_estimulos);
			for i in 1 to 16 loop
				read(linha_de_estimulos, valor_mem_a);
				read(linha_de_estimulos, espaco);
				read(linha_de_estimulos, valor_mem_b);
				
				Mem_A <= to_stdlogicvector(valor_mem_a);
				Mem_B <= to_stdlogicvector(valor_mem_b);
				
				wait for period*3;
			end loop;
			read(linha_de_estimulos, espaco);
			read(linha_de_estimulos, valor_de_saida);
			wait for period*3;
			assert (SAD = to_stdlogicvector(valor_de_saida))
			report
			"Sad incorreta! "
			severity error;
		end loop;

		wait for period;
		assert false report "Test done." severity note;
		wait;
	end process;
end tb;
