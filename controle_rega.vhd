library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controle_rega is
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
    o_vaso: out std_logic_vector(1 downto 0);
    o_trigger_sensor_0: out std_logic;
    o_trigger_sensor_1: out std_logic
  );
end entity;

architecture arch of controle_rega is
  component temporizador is
    generic (
      constant M: integer;  -- duracao do sinal em '1'
      constant N: integer -- periodo total
    );
    port (
      i_clock: in std_logic;
      i_reset: in std_logic;
      o_temporizador: out std_logic;
      o_fim_temporizador: out std_logic
    );
  end component;

  component controle_rega_uc is
    port (
      i_clock: in std_logic;
      i_reset: in std_logic;
      i_ligar: in std_logic;
      i_fim_rega: in std_logic;
      i_fim_repouso: in std_logic;
      i_girou_servomotor: in std_logic;
      i_medida_pronta: in std_logic;
      i_abaixo_threshold: in std_logic;
      o_medir: out std_logic;
      o_repousando: out std_logic;
      o_alternar_vaso: out std_logic;
      o_abre_valvula: out std_logic;
      o_conta_espera_giro_servomotor: out std_logic;
      db_estado: out std_logic_vector(3 downto 0)
    ); 
  end component;

  component contador_m is
    generic (
        constant M: integer := 50;  -- modulo do contador
        constant N: integer := 6    -- numero de bits da saida
    );
    port (
        clock, zera, conta: in std_logic;
        Q: out std_logic_vector (N-1 downto 0);
        fim: out std_logic
    );
  end component;

  component sensor_umidade_solo is
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
    
  component mux_sinais_vaso is
    port (
      i_medir: in std_logic;
      i_pronto_0: in std_logic;
      i_pronto_1: in std_logic;
      i_medida_0: in std_logic_vector(15 downto 0);
      i_medida_1: in std_logic_vector(15 downto 0);
      vaso: in std_logic_vector(1 downto 0);
      o_medir_vaso_0: out std_logic;
      o_medir_vaso_1: out std_logic;
      o_pronto: out std_logic;
      o_medida: out std_logic_vector(15 downto 0)
    );
  end component;

  component comparador_m is
    generic (
      constant N: integer -- numero de bits dos sinais a serem comparados
    );
    port (
      a: in std_logic_vector(N-1 downto 0);
      b: in std_logic_vector(N-1 downto 0);
      a_less_than_b: out std_logic
    );
  end component;


  signal s_temporizador: std_logic;
  signal s_reset_temporizador: std_logic;
  signal s_fim_temporizador: std_logic;
  signal s_alternar_vaso: std_logic;
  signal s_conta_espera_giro_servomotor: std_logic;
  signal s_girou_servomotor: std_logic;
  signal s_abre_valvula: std_logic;
  signal s_fim_rega: std_logic;
  signal s_fim_repouso: std_logic;
  signal s_repousando: std_logic;
  signal s_medir_vaso_0: std_logic;
  signal s_medida_vaso_0: std_logic_vector(15 downto 0);
  signal s_pronto_vaso_0: std_logic;
  signal s_medir_vaso_1: std_logic;
  signal s_medida_vaso_1: std_logic_vector(15 downto 0);
  signal s_pronto_vaso_1: std_logic;
  signal s_medida_pronta: std_logic;
  signal s_medir: std_logic;
  signal s_umidade_solo: std_logic_vector(15 downto 0);
  signal s_vaso: std_logic_vector(1 downto 0);
  signal s_abaixo_threshold: std_logic;

begin
  s_reset_temporizador <= i_reset or i_ligar;
  o_abre_valvula <= s_abre_valvula;
  o_vaso <= s_vaso;
 
  sensor_umidade_solo_0: sensor_umidade_solo
    port map (
      i_clock => i_clock,
      i_reset => i_reset,
      i_medir => s_medir_vaso_0,
      i_echo => i_echo_sensor_0,
      o_trigger => o_trigger_sensor_0,
      o_medida => s_medida_vaso_0,
      o_pronto => s_pronto_vaso_0,
      db_estado => open,
      db_medir => open
    );

  sensor_umidade_solo_1: sensor_umidade_solo
    port map  (
      i_clock => i_clock,
      i_reset => i_reset,
      i_medir => s_medir_vaso_1,
      i_echo => i_echo_sensor_1,
      o_trigger => o_trigger_sensor_1,
      o_medida => s_medida_vaso_1,
      o_pronto => s_pronto_vaso_1,
      db_estado => open,
      db_medir => open
    );

  controle_rega_uc_0: controle_rega_uc
    port map (
      i_clock => i_clock,
      i_reset => i_reset,
      i_ligar => i_ligar,
      i_fim_rega => s_fim_rega,
      i_fim_repouso => s_fim_repouso,
      i_girou_servomotor => s_girou_servomotor,
      i_medida_pronta => s_medida_pronta,
      i_abaixo_threshold => s_abaixo_threshold,
      o_medir => s_medir,
      o_repousando => s_repousando,
      o_alternar_vaso => s_alternar_vaso,
      o_abre_valvula => s_abre_valvula,
      o_conta_espera_giro_servomotor => s_conta_espera_giro_servomotor,
      db_estado => open
    );

  mux_sinais_vaso_instance: mux_sinais_vaso
    port map (
      i_medir => s_medir,
      i_pronto_0 => s_pronto_vaso_0,
      i_pronto_1 => s_pronto_vaso_1,
      i_medida_0 => s_medida_vaso_0,
      i_medida_1 => s_medida_vaso_1,
      vaso => s_vaso,
      o_medir_vaso_0 => s_medir_vaso_0,
      o_medir_vaso_1 => s_medir_vaso_1,
      o_pronto => s_medida_pronta,
      o_medida => s_umidade_solo
    );


  comparador_threshold: comparador_m
    generic map(
      N => 16
    )
    port map (
      a => s_umidade_solo,
      b => "1000000000000000", -- threshold hardcoded in 80%
      a_less_than_b => s_abaixo_threshold
    );
    
  contador_vaso_0: contador_m
    generic map (
      M => 2,
      N => 2
    )
    port map (
      clock => i_clock,
      zera => i_reset,
      conta => s_alternar_vaso,
      Q => s_vaso,
      fim => open
    );

  contador_rega_0: contador_m
    generic map (
      M => 50000000 / velocidade_simulacao, -- rega por 1s,
      N => 32
    )
    port map (
      clock => i_clock,
      zera => i_reset,
      conta => s_abre_valvula,
      Q => open,
      fim => s_fim_rega
    );

  contador_repouso_0: contador_m
    generic map (
      M => 50000000 / velocidade_simulacao, -- repousa por 1s,
      N => 32
    )
    port map (
      clock => i_clock,
      zera => i_reset,
      conta => s_repousando,
      Q => open,
      fim => s_fim_repouso
    );

  contador_espera_giro_servomotor_0: contador_m
    generic map (
      M => 25000000 / velocidade_simulacao, -- espera 500ms para servomotor girar,
      N => 32
    )
    port map (
      clock => i_clock,
      zera => i_reset,
      conta => s_conta_espera_giro_servomotor,
      Q => open,
      fim => s_girou_servomotor
    );
end arch;
