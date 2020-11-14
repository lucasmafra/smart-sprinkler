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
    o_abre_valvula: out std_logic;
    o_vaso: out std_logic_vector
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
      i_valor_temporizador: in std_logic;
      i_fim_temporizador: in std_logic;
      i_girou_servomotor: in std_logic;
      o_alternar_vaso: out std_logic;
      o_abre_valvula: out std_logic;
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

  signal s_temporizador: std_logic;
  signal s_reset_temporizador: std_logic;
  signal s_fim_temporizador: std_logic;
  signal s_alternar_vaso: std_logic;
  
begin
  s_reset_temporizador <= i_reset or i_ligar;

  temporizador_0: temporizador
    generic map (
     M => 100000000 / velocidade_simulacao, -- 2s
     N => 250000000 / velocidade_simulacao -- 5s
    )
    port map (
      i_clock => i_clock,
      i_reset => s_reset_temporizador,
      o_temporizador => s_temporizador,
      o_fim_temporizador => s_fim_temporizador
    );

  controle_rega_uc_0: controle_rega_uc
    port map (
      i_clock => i_clock,
      i_reset => i_reset,
      i_ligar => i_ligar,
      i_valor_temporizador => s_temporizador,
      i_fim_temporizador => s_fim_temporizador,
      i_girou_servomotor => '1',
      o_alternar_vaso => s_alternar_vaso,
      o_abre_valvula => o_abre_valvula,
      db_estado => open
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
      Q => o_vaso,
      fim => open
    );
end arch;
