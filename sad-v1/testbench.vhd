library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sadv1-tb is
end sadv1-tb;

architecture tb of sadv1-tb is
  CONSTANT b_bits : natural := 8;
  CONSTANT n_bits : natural := 64;
  CONSTANT p_bits : natural := 1;
  signal clk, enable, reset : std_logic := '0'; --input
  signal sample_ori, sample_can : std_logic_vector (b_bits*p_bits -1 downto 0); --input
  signal read_mem, done : std_logic := '0'; --output
  signal address : std_logic_vector (n_bits-2 downto 0); --output
  signal sad_value : std_logic_vector (14 downto 0); --output

  CONSTANT periodo_clk : TIME := 10 ns;
begin

  DUV: entity work.sad(arch)
  
  
