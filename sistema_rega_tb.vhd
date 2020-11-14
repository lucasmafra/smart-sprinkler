library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sistema_rega_tb is
end entity;

architecture tb of sistema_rega_tb is
  component sistema_rega
    generic (
      constant velocidade_simulacao: integer := 1
    );
    port (
      i_clock: in std_logic;
      i_reset: in std_logic;
      i_ligar: in std_logic;
      o_abre_valvula: out std_logic;
      o_pwm: out std_logic
    );    
  end component;

  signal clk_in: std_logic := '0';
  signal rst_in: std_logic := '0';
  signal ligar_in: std_logic := '0';
  signal abre_valvula_out: std_logic;
  signal pwm_out: std_logic;
  signal simulando: std_logic := '0';    -- delimita o tempo de geração do clock
  constant periodoClock : time := 20 ns;  --  clock de 50MHz
  
begin
  -- Gerador de clock: executa enquanto 'simulando = 1', com o período especificado. 
  -- Quando simulando=0, clock é interrompido, bem como a simulação de eventos
  clk_in <= (simulando and (not clk_in)) after periodoClock/2;
    
  dut: sistema_rega
    generic map (
      velocidade_simulacao => 1000
    )
    port map (
      i_clock => clk_in,
      i_reset => rst_in,
      i_ligar => ligar_in,
      o_abre_valvula => abre_valvula_out,
      o_pwm => pwm_out
    );

  stimulus: process is
  begin     
    assert false report "Inicio da simulacao" severity note;
    simulando <= '1';
    
    rst_in <= '1';
    wait for periodoClock;    
    assert abre_valvula_out = '0' report "reset - abre_valvula = 0";
    rst_in <= '0';

    wait for 1 ms;

    ligar_in <= '1';
    wait for 1 ms;
    ligar_in <= '0';

    wait for 1 ms;
    assert abre_valvula_out = '1' report "Abre valvula pela primeira vez";

    wait for 1.1 ms;
    assert abre_valvula_out = '0' report "Fechou valvula pela primeira vez";

    wait for 3 ms;
    assert abre_valvula_out = '1' report "Abre valvula pela segunda vez";

    wait for 2.1 ms;
    assert abre_valvula_out = '0' report "Fechou valvula pela segunda vez";

    wait for 3 ms;
    assert abre_valvula_out = '1' report "Abre valvula pela terceira vez";

    wait for 2 ms;
    assert abre_valvula_out = '0' report "Fechou valvula pela terceira vez";
    
    assert false report "Fim da simulacao" severity note;
    simulando <= '0';
    wait; -- fim da simulação
  end process;
end tb;
