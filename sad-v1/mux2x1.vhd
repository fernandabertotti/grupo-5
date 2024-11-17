library IEEE;
use IEEE.Std_Logic_1164.all;

entity mux2x1 is
generic (N : integer); --valor será definido na instanciação do componente
port (F1: in  std_logic_vector(N-1 downto 0);
	 F2: in  std_logic_vector(N-1 downto 0);
	 sel: in  std_logic;
	 F: out  std_logic_vector(N-1 downto 0));
end mux2x1;

architecture arch of mux2x1 is
begin
F <= F1 when sel = '0' else --uso da estrutura de seleção condicional when else
         F2;
end arch;
