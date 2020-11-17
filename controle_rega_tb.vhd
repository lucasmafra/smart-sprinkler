library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controle_rega_tb is
end entity;

architecture tb of controle_rega_tb is
  component controle_rega
    generic (
      constant velocidade_simulacao: integer := 1
    );
    port (
      i_clock: in std_logic;
      i_reset: in std_logic;
      i_ligar: in std_logic;
      i_echo_sensor_0: in std_logic;
      i_echo_sensor_1: in std_logic;
      o_abre_valvula: out std_logic;
      o_vaso: out std_logic_vector;
      o_trigger_sensor_0: out std_logic;
      o_trigger_sensor_1: out std_logic
    );    
  end component;

  signal clk_in: std_logic := '0';
  signal rst_in: std_logic := '0';
  signal ligar_in: std_logic := '0';
  signal echo_sensor_0_in: std_logic := '0';
  signal echo_sensor_1_in: std_logic := '0';
  signal abre_valvula_out: std_logic;
  signal vaso_out: std_logic_vector(1 downto 0);
  signal trigger_sensor_0_out: std_logic;
  signal trigger_sensor_1_out: std_logic;
  signal simulando: std_logic := '0';    -- delimita o tempo de geração do clock
  constant periodoClock : time := 20 ns;  --  clock de 50MHz
  
begin
  -- Gerador de clock: executa enquanto 'simulando = 1', com o período especificado. 
  -- Quando simulando=0, clock é interrompido, bem como a simulação de eventos
  clk_in <= (simulando and (not clk_in)) after periodoClock/2;
    
  dut: controle_rega
    generic map (
      velocidade_simulacao => 1000
    )
    port map (
      i_clock => clk_in,
      i_reset => rst_in,
      i_ligar => ligar_in,
      i_echo_sensor_0 => echo_sensor_0_in,
      i_echo_sensor_1 => echo_sensor_1_in,
      o_abre_valvula => abre_valvula_out,
      o_vaso => vaso_out,
      o_trigger_sensor_0 => trigger_sensor_0_out,
      o_trigger_sensor_1 => trigger_sensor_1_out
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

    wait for 1 ms;

    ligar_in <= '1';
    wait for periodoClock;
    ligar_in <= '0';

    wait for periodoClock;
    assert trigger_sensor_0_out = '1' report "should trigger sensor 0";
    assert trigger_sensor_1_out = '0' report "should not trigger sensor 1";

    assert false report "Fim da simulacao" severity note;
    simulando <= '0';
    wait; -- fim da simulação
  end process;
end tb;
