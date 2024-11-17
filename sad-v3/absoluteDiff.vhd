library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity absoluteDiff is
    generic (N: positive);
    port (
      a: IN std_logic_vector(N-1 DOWNTO 0);
      b: in std_logic_vector(N-1 downto 0);
      s: OUT std_logic_vector(N-1 DOWNTO 0));
end absoluteDiff;

architecture arch of absoluteDiff is
    signal operacao: std_logic_vector(N downto 0);

begin
    operacao <= std_logic_vector(abs(signed(resize(unsigned(a), N+1))-signed(resize(unsigned(b), N+1))));
	 s <= operacao(N-1 downto 0);
    
end arch;    
