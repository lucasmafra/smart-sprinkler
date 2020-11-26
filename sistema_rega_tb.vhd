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
      i_umidade_solo_0: in std_logic;
      i_threshold_1: in std_logic;
      o_threshold_1: out std_logic;
      o_display_0: out std_logic_vector(6 downto 0);
      o_display_1: out std_logic_vector(6 downto 0);
      o_display_2: out std_logic_vector(6 downto 0)      
    );    
  end component;

  signal i_clock: std_logic := '0';
  signal i_reset: std_logic := '0';
  signal i_umidade_solo_0: std_logic := '1';
  signal i_threshold_1: std_logic := '0';
  signal o_threshold_1: std_logic;
  signal o_display_0: std_logic_vector(6 downto 0);
  signal o_display_1: std_logic_vector(6 downto 0);
  signal o_display_2: std_logic_vector(6 downto 0);
  signal simulando: std_logic := '0';    -- delimita o tempo de geração do clock
  constant periodoClock : time := 20 ns;  --  clock de 50MHz

begin
  -- Gerador de clock: executa enquanto 'simulando = 1', com o período especificado. 
  -- Quando simulando=0, clock é interrompido, bem como a simulação de eventos
  i_clock <= (simulando and (not i_clock)) after periodoClock/2;
    
  dut: sistema_rega
    generic map (
      velocidade_simulacao => 1000
    )
    port map (
      i_clock => i_clock,
      i_reset => i_reset,
      i_umidade_solo_0 => i_umidade_solo_0,
      i_threshold_1 => i_threshold_1,
      o_threshold_1 => o_threshold_1,
      o_display_0 => o_display_0,
      o_display_1 => o_display_1,
      o_display_2 => o_display_2
    );

  stimulus: process is
  begin     
    assert false report "Inicio da simulacao" severity note;
    simulando <= '1';
    
    i_reset <= '1';
    wait for 100* periodoClock;    
    i_reset <= '0';

    wait for 10*periodoClock;

    -- COMECA TRANSMISSAO DO CARACTERE 8
    i_umidade_solo_0 <= '0'; -- start bit do primeiro caractere (0x38);
    wait for 434*periodoClock;

    i_umidade_solo_0 <= '0'; -- digito menos significativo de 0x38;
    wait for 434*periodoClock;

    i_umidade_solo_0 <= '0';
    wait for 434*periodoClock;

    i_umidade_solo_0 <= '0';
  wait for 434*periodoClock;

    i_umidade_solo_0 <= '1';
    wait for 434*periodoClock;

    i_umidade_solo_0 <= '1';
    wait for 434*periodoClock;

    i_umidade_solo_0 <= '1';
    wait for 434*periodoClock;

    i_umidade_solo_0 <= '0';
    wait for 434*periodoClock;

    i_umidade_solo_0 <= '0'; -- digito mais significativo de 0x38;
    wait for 434*periodoClock;

    i_umidade_solo_0 <= '1'; -- primeiro stop bit de 0x38
    wait for 434*periodoClock;

    i_umidade_solo_0 <= '1'; -- segundo stopbit de 0x38
    wait for 434*periodoClock;
    -- FINALIZA TRANSMISSAO DO CARACTERE 8


    -- COMECA TRANSMISSAO DO CARACTERE 5
    i_umidade_solo_0 <= '0'; -- start bit do primeiro caractere (0x35);
    wait for 434*periodoClock;

    i_umidade_solo_0 <= '1'; -- digito menos significativo de 0x35;
    wait for 434*periodoClock;

    i_umidade_solo_0 <= '0';
    wait for 434*periodoClock;

    i_umidade_solo_0 <= '1';
    wait for 434*periodoClock;

    i_umidade_solo_0 <= '0';
    wait for 434*periodoClock;

    i_umidade_solo_0 <= '1';
    wait for 434*periodoClock;

    i_umidade_solo_0 <= '1';
    wait for 434*periodoClock;

    i_umidade_solo_0 <= '0';
    wait for 434*periodoClock;

    i_umidade_solo_0 <= '0'; -- digito mais significativo de 0x35;
    wait for 434*periodoClock;

    i_umidade_solo_0 <= '1'; -- primeiro stop bit de 0x35
    wait for 434*periodoClock;

    i_umidade_solo_0 <= '1'; -- segundo stopbit de 0x35
    wait for 434*periodoClock;
    -- FINALIZA TRANSMISSAO DO CARACTERE 5


    -- COMECA TRANSMISSAO DO CARACTERE 0
    i_umidade_solo_0 <= '0'; -- start bit do primeiro caractere (0x30);
    wait for 434*periodoClock;

    i_umidade_solo_0 <= '0'; -- digito menos significativo de 0x30;
    wait for 434*periodoClock;

    i_umidade_solo_0 <= '0';
    wait for 434*periodoClock;

    i_umidade_solo_0 <= '0';
    wait for 434*periodoClock;

    i_umidade_solo_0 <= '0';
    wait for 434*periodoClock;

    i_umidade_solo_0 <= '1';
    wait for 434*periodoClock;

    i_umidade_solo_0 <= '1';
    wait for 434*periodoClock;

    i_umidade_solo_0 <= '0';
    wait for 434*periodoClock;

    i_umidade_solo_0 <= '0'; -- digito mais significativo de 0x30;
    wait for 434*periodoClock;

    i_umidade_solo_0 <= '1'; -- primeiro stop bit de 0x30
    wait for 434*periodoClock;

    i_umidade_solo_0 <= '1'; -- segundo stopbit de 0x30
    wait for 434*periodoClock;
    -- FINALIZA TRANSMISSAO DO CARACTERE 0
    

    wait for 1000*periodoClock;

    assert o_display_0 = "0000000" report "Display 0 = 8" severity error;
    assert o_display_1 = "0010010" report "Display 1 = 5" severity error;
    assert o_display_2 = "1000000" report "Display 2 = 0" severity error;
      
    assert false report "Fim da simulacao" severity note;
    simulando <= '0';
    wait; -- fim da simulação
  end process;  
end tb;
