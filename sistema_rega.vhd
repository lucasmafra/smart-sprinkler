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
    i_umidade_solo_0: in std_logic;
    i_threshold_1: in std_logic;
    o_threshold_1: out std_logic;
    o_display_0: out std_logic_vector(6 downto 0);
    o_display_1: out std_logic_vector(6 downto 0);
    o_display_2: out std_logic_vector(6 downto 0)      
  );
end entity;

architecture arch of sistema_rega is

  component rx_serial is
    port(
      i_clock, i_reset: in std_logic;
      i_dado_serial: in std_logic;
      i_recebe_dado: in std_logic;
      o_dado_recebido: out std_logic_vector (7 downto 0);
      o_tem_dado: out std_logic;
      o_pronto: out std_logic;	
      db_recebe_dado: out std_logic;
      db_dado_serial: out std_logic;
      db_estado: out std_logic_vector(3 downto 0)
    );
  end component;

  
begin
  o_threshold_1 <= i_threshold_1;

  u_rx_serial: rx_serial
  port map (
    i_clock => i_clock,
    i_reset => i_reset,
    i_dado_serial => i_umidade_solo_0,
    i_recebe_dado => '1',
    o_dado_recebido => open,
    o_tem_dado => open,
    o_pronto => open,
    db_recebe_dado => open,
    db_dado_serial => open,
    db_estado => open
  );
  
end arch;
