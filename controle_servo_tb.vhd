-- controle_servo_tb.vhd
--

library ieee;
use ieee.std_logic_1164.all;

entity controle_servo_tb is
end entity;

architecture tb of controle_servo_tb is

  -- Componente a ser testado (Device Under Test -- DUT)
  component controle_servo
      port (
      i_clock    : in  std_logic;
      i_reset    : in  std_logic;
      i_posicao  : in  std_logic_vector(1 downto 0);  
      o_pwm      : out std_logic;
		db_reset   : out std_logic;
		db_pwm     : out std_logic;
		db_posicao : out std_logic_vector(1 downto 0)
		);
  end component;

  ---- Declaração de sinais para conectar o componente
  signal clk_in: std_logic := '0';
  signal rst_in: std_logic := '0';
  signal posicao_in: std_logic_vector (1 downto 0) := "00";
  signal pwm_out: std_logic;

  -- Configuracoes do clock
  signal simulando: std_logic := '0';    -- delimita o tempo de geração do clock
  constant periodoClock : time := 20 ns;  --  clock de 50MHz
  
begin
  -- Gerador de clock: executa enquanto 'simulando = 1', com o período especificado. 
  -- Quando simulando=0, clock é interrompido, bem como a simulação de eventos
  clk_in <= (simulando and (not clk_in)) after periodoClock/2;
  
  ---- DUT
  dut_tx: controle_servo
          port map
          (
              i_clock =>        clk_in,
              i_reset =>        rst_in,
              i_posicao =>      posicao_in,
              o_pwm =>          pwm_out,
              db_reset => open,
				  db_pwm => open,
				  db_posicao => open
          );

  ---- Gera sinais de estimulo
  stimulus: process is
  begin

    -- inicio da simulacao
    assert false report "Inicio da simulacao" severity note;
    simulando <= '1';
	 
    -->> Caso de teste 1: posicao 00 <<--
    rst_in <= '1';
	 posicao_in <= "00";
	 wait for periodoClock;
	 rst_in <= '0'; 
    wait for 55000 * periodoClock;
	 	 
	 -->> Caso de teste 2: posicao 01 <<--
    rst_in <= '1';
	 posicao_in <= "01";
	 wait for periodoClock;
	 rst_in <= '0'; 
    wait for 70000 * periodoClock;
	 
	 -->> Caso de teste 3: posicao 10 <--
    rst_in <= '1';
	 posicao_in <= "10";
	 wait for periodoClock;
	 rst_in <= '0'; 
    wait for 90000 * periodoClock;
	 
	 -->> Caso de teste 4: posicao 11 <--
    rst_in <= '1';
	 posicao_in <= "11";
	 wait for periodoClock;
	 rst_in <= '0'; 
    wait for 105000 * periodoClock;
  
    -- final do testbench
    assert false report "Fim da simulacao" severity note;
    simulando <= '0';
    
    wait; -- fim da simulação
  end process;


end architecture;
