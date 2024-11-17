library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;

entity adder_unsigned is --é unsigned porque somente é utilizado para valores positivos (ou após o abs ou pro reg cont)
generic (N : integer);
port (A, B: in unsigned(N-1 downto 0);
	result: out std_logic_vector(N-1 downto 0));
end adder_unsigned;

architecture arch of adder_unsigned is
	signal sum: unsigned(N downto 0);
begin
	sum <= resize(A, N+1) + resize(B, N+1); 
	result <= std_logic_vector(sum(N-1 downto 0)); --desconsidera Cout do resultado da soma
end arch;
