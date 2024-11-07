library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
use ieee.std_logic_textio.all;
use std.textio.all;

entity sadv3-tb is
end sadv3-tb;

architecture tb of sadv3-tb is

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

  DUV : entity work.sad(arch)
    generic map(B => b_bits,
                N => n_bits,
                P => p_bits);
    port map(clk => clk, 
             enable => enable, 
             reset => reset, 
             sample_ori => mem_A, 
             sample_can => mem_B, 
             read_mem => read_mem, 
             done => done,
             address => address, 
             sad_value => sad_value);
                
