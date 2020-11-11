library ieee;
use ieee.std_logic_1164.all;

entity temporizador_tb is
end entity;

architecture tb of temporizador_tb is
  component temporizador
    generic (
      constant M: integer := 500000000;  -- duracao do sinal em '1'
      constant N: integer := 1000000000 -- periodo total
    );
    port (
      i_clock: in std_logic;
      i_reset: in std_logic;
      o_temporizador: out std_logic
    );
  end component;

  signal clk_in: std_logic := '0';
  signal rst_in: std_logic := '0';
  signal temporizador_out: std_logic;
  signal simulando: std_logic := '0';    -- delimita o tempo de geração do clock
  constant periodoClock : time := 20 ns;  --  clock de 50MHz
  
begin
  -- Gerador de clock: executa enquanto 'simulando = 1', com o período especificado. 
  -- Quando simulando=0, clock é interrompido, bem como a simulação de eventos
  clk_in <= (simulando and (not clk_in)) after periodoClock/2;
    
  dut: temporizador
    generic map (
      M => 2,
      N => 5
    )
    port map (
      i_clock => clk_in,
      i_reset => rst_in,
      o_temporizador => temporizador_out
    );

  stimulus: process is
  begin     
    assert false report "Inicio da simulacao" severity note;
    simulando <= '1';
    
    rst_in <= '1';
    wait for periodoClock;
    assert temporizador_out = '0' report "reset - temporizador = 0";
    
    rst_in <= '0';
    wait for periodoClock;

    assert temporizador_out = '1' report "clock #1 - temporizador = 1";

    wait for periodoClock/2;
    assert temporizador_out = '1' report "clock #2 - temporizador = 1";
    wait for periodoClock/2;

    wait for periodoClock/2;
    assert temporizador_out = '0' report "clock #3 - temporizador = 0";
    wait for periodoClock/2;
    
    wait for periodoClock/2;
    assert temporizador_out = '0' report "clock #4 - temporizador = 0";
    wait for periodoClock/2;
    
    wait for periodoClock/2;
    assert temporizador_out = '0' report "clock #5 - temporizador = 0";
    wait for periodoClock/2;
    
    wait for periodoClock/2;
    assert temporizador_out = '1' report "clock #6 - temporizador = 1";
    wait for periodoClock/2;
    
    wait for periodoClock/2;
    assert temporizador_out = '1' report "clock #7 - temporizador = 1";
    wait for periodoClock/2;
    
    wait for periodoClock/2;
    assert temporizador_out = '0' report "clock #8 - temporizador = 0";
    wait for periodoClock/2;
    
    wait for periodoClock/2;
    assert temporizador_out = '0' report "clock #9 - temporizador = 0";
    wait for periodoClock/2;
    
    wait for periodoClock/2;
    assert temporizador_out = '0' report "clock #10 - temporizador = 0";
    wait for periodoClock/2;
    
    assert false report "Fim da simulacao" severity note;
    simulando <= '0';
    wait; -- fim da simulação
  end process;
end tb;
