LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
use ieee.math_real.all;
use ieee.numeric_std.all;

ENTITY sad IS
	GENERIC (
		-- obrigatório ---
		-- defina as operações considerando o número B de bits por amostra
		B : POSITIVE := 8; -- número de bits por amostra
		-----------------------------------------------------------------------
		-- desejado (i.e., não obrigatório) ---
		-- se você desejar, pode usar os valores abaixo para descrever uma
		-- entidade que funcione tanto para a SAD v1 quanto para a SAD v3.
		N : POSITIVE := 64; -- número de amostras por bloco
		P : POSITIVE := 1 -- número de amostras de cada bloco lidas em paralelo
		-----------------------------------------------------------------------
	);
	PORT (
		-- ATENÇÃO: modifiquem a largura de bits das entradas e saídas que
		-- estão marcadas com DEFINIR de acordo com o número de bits B e
		-- de acordo com o necessário para cada versão da SAD (tentem utilizar
		-- os valores N e P descritos acima para criar apenas uma descrição
		-- configurável que funcione tanto para a SAD v1 quanto para a SAD v3).
		-- Não modifiquem os nomes das portas, apenas a largura de bits quando
		-- for necessário.
		clk : IN STD_LOGIC; -- ck
		enable : IN STD_LOGIC; -- iniciar
		reset : IN STD_LOGIC; -- reset
		sample_ori : IN STD_LOGIC_VECTOR (B*P-1 DOWNTO 0); -- Mem_A[end]
		sample_can : IN STD_LOGIC_VECTOR (B*P-1 DOWNTO 0); -- Mem_B[end]
		read_mem : OUT STD_LOGIC; -- read
		address : OUT STD_LOGIC_VECTOR (positive(ceil(real(log(real(N/P)) / log(2.0))))-1 DOWNTO 0); -- end
		sad_value : OUT STD_LOGIC_VECTOR (B+positive(ceil(real(log(real(N)) / log(2.0))))-1 DOWNTO 0); -- SAD
		done: OUT STD_LOGIC -- pronto
	);
END ENTITY; -- sad

ARCHITECTURE arch OF sad IS

	signal menor, zi, ci, cpA, cpB, zsoma, csoma, csad_reg: std_logic;
	
BEGIN
	CONTROLE: entity work.sad_controle(arch)
		port map (
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
			csad_reg => csad_reg);

	OPERATIVO: entity work.sad_operativo(arch)
		generic map (N => N,
			    B => B,
			    P => P)
		port map (clk => clk,
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
			  address => address);
	
END ARCHITECTURE; -- arch
