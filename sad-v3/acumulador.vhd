library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity acumulador is
generic (N : positive);
port(
	clk, rst, carga, sel_mux: in std_logic; --entradas dos registradores e seletor do mux
	valor_para_somar: in std_logic_vector(N-1 downto 0); --entrada do acumulador
	acumulado: out std_logic_vector(N-1 downto 0) --saída do acumulador
);
end acumulador;

architecture arch of acumulador is
  signal mux_in0: std_logic_vector(N-1 downto 0); -- entrada do multiplexador quando seletor é 0
  signal mux_out: std_logic_vector(N-1 downto 0); -- saída do multiplexador
  signal reg_in: std_logic_vector(N-1 downto 0); -- entrada do registrador
  signal valor_ja_acumulado: std_logic_vector(N-1 downto 0); -- saída do registrador
  signal adder_out: std_logic_vector(N-1 downto 0); -- saída do somador

begin
	MUX : entity work.mux2x1(arch)
		generic map (N => N)
		port map(
  			F1 => adder_out,
  			F2 => (others => '0'),
  			sel => sel_mux,
  			F => mux_out
			);

	REG: entity work.registrador(arch)
		generic map (N => N)
		port map(
			clk => clk,
			rst => rst,
			carga => carga,
			D => mux_out,
			Q => valor_ja_acumulado); 

	SOMADOR: entity work.adder_unsigned(arch)
		generic map (N => N)
		port map(
			A => unsigned(valor_para_somar),
			B => unsigned(valor_ja_acumulado),
			result => adder_out);

	acumulado <= valor_ja_acumulado; 

end arch;
