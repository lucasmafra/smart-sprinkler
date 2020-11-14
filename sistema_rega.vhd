library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sistema_rega is
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
end entity;

architecture arch of sistema_rega is
  
  component controle_rega is
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
  end component;

  component controle_servo is
    generic (
      constant velocidade_simulacao: integer := 1
    );
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

  signal s_vaso: std_logic_vector(1 downto 0);

begin
  controle_rega_0: controle_rega
    generic map (
      velocidade_simulacao => velocidade_simulacao
    )
    port map (
      i_clock => i_clock,
      i_reset => i_reset,
      i_ligar => i_ligar,
      o_abre_valvula => o_abre_valvula,
      o_vaso => s_vaso
    );
      
  controle_servo_0: controle_servo
    generic map (
      velocidade_simulacao => velocidade_simulacao
    )
    port map (
      i_clock => i_clock,
      i_reset => i_reset,
      i_posicao => s_vaso,
      o_pwm => o_pwm,
      db_reset => open,
      db_pwm => open,
      db_posicao => open
    );
end arch;
