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
  signal mem_A, mem_B : std_logic_vector (b_bits*p_bits -1 downto 0); --input
  signal read_mem, done : std_logic := '0'; --output
  signal address : std_logic_vector (POSITIVE(ceil(real(log(real(n_bits/p_bits)) / log(2.0)))) - 1 downto 0); --output
  signal sad_value : std_logic_vector (b_bits + POSITIVE(ceil(real(log(real(n_bits)) / log(2.0)))) - 1 downto 0); --output

  CONSTANT periodo_clk : TIME := 10 ns; --dúvida sobre o período de clk
begin

  DUV: entity work.sad(arch)
    generic map(B => b_bits,
                N => n_bits,
                P => p_bits)
    port map(clk => clk, 
             enable => enable, 
             reset => reset, 
             sample_ori => mem_A, 
             sample_can => mem_B, 
             read_mem => read_mem, 
             address => address, 
             sad_value => sad_value, 
             done => done );
    
    clk <= not clk after periodo_clk/2; --dá pra usar o finished também
  process
  begin   
    enable <= std_logic := '0';
    reset <= std_logic := '0';
    mem_A <= std_logic_vector(to_unsigned(0, mem_A'length));
    mem_B <= std_logic_vector(to_unsigned(1, mem_B'length));
    wait for periodo_clk;
    assert(sad_value = "00000000000000")
    report "Falha no primeiro teste" severity error;

    enable <= std_logic := '1';
    reset <= std_logic := '0';
    mem_A <= std_logic_vector(to_unsigned(0, mem_A'length));
    mem_B <= std_logic_vector(to_unsigned(1, mem_B'length));
    wait for periodo_clk;
    assert(sad_value = "00000011111111")
    report "Falha no segundo teste" severity error;

    enable <= std_logic := '1';
    reset <= std_logic := '1';
    mem_A <= std_logic_vector(to_unsigned(0, mem_A'length));
    mem_B <= std_logic_vector(to_unsigned(1, mem_B'length));
    wait for periodo_clk;
    assert(sad_value = "00000000000000")
    report "Falha no terceiro teste" severity error;
    
    enable <= std_logic := '1';
    reset <= std_logic := '0';
    mem_A <= std_logic_vector(to_unsigned(1, mem_A'length));
    mem_B <= std_logic_vector(to_unsigned(0, mem_B'length));
    wait for periodo_clk;
    assert(sad_value = "00000011111111")
    report "Falha no quarto teste" severity error;

    enable <= std_logic := '1';
    reset <= std_logic := '0';
    mem_A <= std_logic_vector(to_unsigned(1, mem_A'length));
    mem_B <= std_logic_vector(to_unsigned(1, mem_B'length));
    wait for periodo_clk;
    assert(sad_value = "00000111111111")
    report "Falha no quinto teste" severity error;

    enable <= std_logic := '1';
    reset <= std_logic := '0';
    mem_A <= std_logic_vector(to_unsigned(0, mem_A'length));
    mem_B <= std_logic_vector(to_unsigned(0, mem_B'length));
    wait for periodo_clk;
    assert(sad_value = "00000111111111")
    report "Falha no sexto teste" severity error;
    
    wait;
  end process;
end tb;
