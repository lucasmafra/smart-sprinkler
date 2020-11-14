library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controle_rega_tb is
end entity;

architecture tb of controle_rega_tb is
  component controle_rega
    port (
      i_clock: in std_logic;
      i_reset: in std_logic;
      i_ligar: in std_logic;
      o_abre_valvula: out std_logic;
      o_vaso: out std_logic_vector
    );    
  end component;

  signal clk_in: std_logic := '0';
  signal rst_in: std_logic := '0';
  signal ligar_in: std_logic := '0';
  signal abre_valvula_out: std_logic;
  signal vaso_out: std_logic_vector(1 downto 0);
  signal simulando: std_logic := '0';    -- delimita o tempo de geração do clock
  constant periodoClock : time := 20 ns;  --  clock de 50MHz
  
begin
  -- Gerador de clock: executa enquanto 'simulando = 1', com o período especificado. 
  -- Quando simulando=0, clock é interrompido, bem como a simulação de eventos
  clk_in <= (simulando and (not clk_in)) after periodoClock/2;
    
  dut: controle_rega
    port map (
      i_clock => clk_in,
      i_reset => rst_in,
      i_ligar => ligar_in,
      o_abre_valvula => abre_valvula_out,
      o_vaso => vaso_out
    );

  stimulus: process is
  begin     
    assert false report "Inicio da simulacao" severity note;
    simulando <= '1';
    
    rst_in <= '1';
    wait for periodoClock;    
    assert abre_valvula_out = '0' report "reset - abre_valvula = 0";
    assert vaso_out = "00" report "reset - vaso_out = 00";    
    rst_in <= '0';

    wait for 100 ns;

    ligar_in <= '1';
    wait for 100 ns;
    ligar_in <= '0';

    wait for 100 ns;
    assert abre_valvula_out = '1' report "Abre valvula pela primeira vez";
    assert vaso_out = "00" report "Vaso inicialmente eh 00";    

    wait for 500 ns;
    assert abre_valvula_out = '0' report "Fechou valvula pela primeira vez";
    assert vaso_out = "00" report "Vaso continua sendo o 00";

    wait for 600 ns;
    assert vaso_out = "01" report "Alterna para o vaso 01";    
    assert abre_valvula_out = '1' report "Abre valvula pela segunda vez";

    wait for 500 ns;
    assert abre_valvula_out = '0' report "Fechou valvula pela segunda vez";
    assert vaso_out = "01" report "Vaso continua sendo o 01";

    wait for 600 ns;
    assert vaso_out = "00" report "Retorna para o vaso 00";    
    assert abre_valvula_out = '1' report "Abre valvula pela terceira vez";

    wait for 500 ns;
    assert abre_valvula_out = '0' report "Fechou valvula pela terceira vez";
    
    assert false report "Fim da simulacao" severity note;
    simulando <= '0';
    wait; -- fim da simulação
  end process;
end tb;
