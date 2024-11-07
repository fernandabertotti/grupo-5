LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY subtractor_signed IS
	GENERIC (N : POSITIVE);
	PORT (
		A, B : IN signed(N - 1 DOWNTO 0);
		S : OUT signed(N - 1 DOWNTO 0)
	);
END subtractor_signed;

ARCHITECTURE arch OF subtractor_signed IS
BEGIN
	S <= A - B;
END arch;
