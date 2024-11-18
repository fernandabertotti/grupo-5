LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

entity registrador is
    generic (N : integer);
	port( 
    clk, rst, carga : in std_logic;
    D: in std_logic_vector(N-1 downto 0);
    Q: out std_logic_vector(N-1 downto 0)
    );
end registrador;

architecture arch of registrador is
begin
    process (rst,clk)
    begin
        if (rst = '1') then 
            Q <= (others => '0'); --others é uma palavra-chave para representar todos os valores de índices que não foram especificados
        elsif (rising_edge(clk) and carga = '1') then
            Q <= D;
        end if;
    end process;
end arch;
