library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sensor_umidade_solo_tb is
end entity;

architecture tb of sensor_umidade_solo_tb is
  component sensor_umidade_solo
    port(
      i_clock: in std_logic;
      i_reset: in std_logic;
      i_medir: in std_logic;
      i_echo: in std_logic;
      o_trigger: out std_logic;
      o_medida: out std_logic_vector(15 downto 0);
      o_pronto: out std_logic;
      db_estado: out std_logic_vector(4 downto 0);
      db_medir: out std_logic
    );
   end component;

  signal clk_in: std_logic := '0';
  signal rst_in: std_logic := '0';
  signal medir_in: std_logic := '0';
  signal echo_in: std_logic := '0';
  signal trigger_out: std_logic;
  signal medida_out: std_logic_vector(15 downto 0);
  signal pronto_out: std_logic;
  signal simulando: std_logic := '0';    -- delimita o tempo de geração do clock
  constant periodoClock : time := 20 ns;  --  clock de 50MHz

begin
  -- Gerador de clock: executa enquanto 'simulando = 1', com o período especificado. 
  -- Quando simulando=0, clock é interrompido, bem como a simulação de eventos
  clk_in <= (simulando and (not clk_in)) after periodoClock/2;
    
  dut: sensor_umidade_solo
    port map (
      i_clock => clk_in,
      i_reset => rst_in,
      i_medir => medir_in,
      i_echo => echo_in,
      o_trigger => trigger_out,
      o_medida => medida_out,
      o_pronto => pronto_out,
      db_estado => open,
      db_medir => open
    );

  stimulus: process is
  begin     
    assert false report "Inicio da simulacao" severity note;
    simulando <= '1';
    
    rst_in <= '1';
    wait for periodoClock;    
    assert medida_out = "0000000000000000" report "reset - o_medida = 0";
    assert pronto_out = '0' report "reset - o_pronto = 0";    
    rst_in <= '0';

    wait for periodoClock;
    medir_in <= '1';
    wait for periodoClock;

    assert trigger_out = '1' report "should send trigger";
    wait for 5 us;
    assert trigger_out = '1' report "trigger_out should last for 10us";
    wait for 5 us;
    assert trigger_out = '0' report "trigger_out should only last for 10us";

    echo_in <= '1';
    wait for 122 us;
    echo_in <= '0';

    wait for periodoClock;

    assert medida_out = "0110000100000000" report "should measure 61% for pulse of 122us";
    assert pronto_out = '1' report "pronto_out should be 1 when measurement is ready";
      
    assert false report "Fim da simulacao" severity note;
    simulando <= '0';
    wait; -- fim da simulação
  end process;
end tb;

