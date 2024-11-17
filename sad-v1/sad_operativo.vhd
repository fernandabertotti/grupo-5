library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity sad_operativo is
  generic(N : positive;
	 B : positive;
	 P : positive); 
	port (  
		clk, rst : in std_logic;
		
		-- ENTRADAS DE DADOS
		Mem_A : in std_logic_vector(B*P-1 downto 0);
		Mem_B : in std_logic_vector(B*P-1 downto 0);

		--ENTRADAS DE CONTROLE
		zi, ci, cpA, cpB, zsoma, csoma, csad_reg : in std_logic;

		-- SAÍDA DE CONTROLE
		menor : out std_logic;

		-- SAIDAS DE DADOS
		SAD : out std_logic_vector(B+positive(ceil(real(log(real(N)) / log(2.0))))-1 DOWNTO 0);
		address : out std_logic_vector(positive(ceil(real(log(real(N/P)) / log(2.0))))-1 DOWNTO 0)
	);

end sad_operativo;

architecture arch of sad_operativo is

	--SIGNALS
	signal out_acc_cont: std_logic_vector(positive(ceil(real(log(real(N)) / log(2.0)))) downto 0);
	signal out_pA, out_pB: std_logic_vector(B-1 downto 0); --saídas de pA e pB que serão entradas de absoluteDiff
	signal out_absDiff: std_logic_vector(B-1 downto 0); --saída do absoluteDiff
	signal in_acc_soma, out_acc_soma: std_logic_vector(B+positive(ceil(real(log(real(N)) / log(2.0))))-1 downto 0); --saída do absDiff concatenada com 0s à esquerda e entrada de SAD_reg
begin
	
	--INSTANCIAÇÃO POR ENTIDADE 
	ACC_CONT: entity work.acumulador(arch)
		generic map(N => positive(ceil(real(log(real(N)) / log(2.0))))+1) --deve ser capaz de representar o valor log2 de N
		port map(
			clk => clk,
			rst => rst,
			carga => ci,
			sel_mux => zi,
			valor_para_somar => std_logic_vector(to_unsigned(1, out_acc_cont'length)),
			acumulado => out_acc_cont);
	
	REG_PA: entity work.registrador(arch)
		generic map(N => B)
		port map(
			clk => clk,
			rst => rst,
			carga => cpA,
			D => Mem_A,
			Q => out_pA);

	REG_PB: entity work.registrador(arch)
		generic map(N => B)
		port map(
			clk => clk,
			rst => rst,
			carga => cpB,
			D => Mem_B,
			Q => out_pB);

	ABS_DIFF: entity work.absoluteDiff(arch)
		generic map(N => B)
		port map(
			a => out_pA,
			b => out_pB,
			s => out_absDiff);

	ACC_SOMA: entity work.acumulador(arch)
		generic map(N => B+positive(ceil(real(log(real(N)) / log(2.0)))))
		port map(
			clk => clk,
			rst => rst,
			carga => csoma,
			sel_mux => zsoma,
			valor_para_somar => in_acc_soma,
			acumulado => out_acc_soma);

	SAD_REG: entity work.registrador(arch)
		generic map(N => B+positive(ceil(real(log(real(N)) / log(2.0)))))
		port map(
			clk => clk,
			rst => rst,
			carga => csad_reg,
			D => out_acc_soma,
			Q => SAD);

	--ACRESCENTAR ZEROS À ESQUERDA DA SAÍDA DE ABSDIFF
	in_acc_soma <= std_logic_vector(resize(unsigned(out_absDiff), SAD'length));

	--OBTER SAÍDA DE CONTROLE MENOR
	menor <= not (out_acc_cont(positive(ceil(real(log(real(N)) / log(2.0)))))); --MSB da saída do acumulador cont

	--OBTER SAÍDA DE DADO ADDRESS
	address <= out_acc_cont(positive(ceil(real(log(real(N)) / log(2.0))))-1 DOWNTO 0); --bits menos significativos da saída do acumulador cont

end arch;
