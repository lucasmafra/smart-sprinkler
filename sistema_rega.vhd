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
      o_final: out std_logic;
      db_recebe_dado: out std_logic;
      db_dado_serial: out std_logic;
      db_estado: out std_logic_vector(3 downto 0)
    );
  end component;

  component register_n is
    generic (
      constant N: integer
    );    
    port(
      i_clock: in std_logic;
      i_reset: in std_logic;
      i_enable: in std_logic;
      i_data: in std_logic_vector(N-1 downto 0);
      o_data: out std_logic_vector(N-1 downto 0)
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

  component mux_umidade_solo is
  port (
    i_caractere_contagem: in std_logic_vector(1 downto 0);
    i_tem_dado: in std_logic;
    o_enable_0: out std_logic;
    o_enable_1: out std_logic;
    o_enable_2: out std_logic
  );
  end component;

  component hexa7seg is
    port (
        hexa : in std_logic_vector(3 downto 0);
        sseg : out std_logic_vector(6 downto 0)
    );
  end component;
    
  signal s_tem_dado: std_logic;
  signal s_dado_recebido: std_logic_vector(7 downto 0);
  signal s_caractere_contagem: std_logic_vector(1 downto 0);
  signal s_enable_0: std_logic;
  signal s_enable_1: std_logic;
  signal s_enable_2: std_logic;
  signal s_final: std_logic;
  signal s_hexa_0: std_logic_vector(7 downto 0);
  signal s_hexa_1: std_logic_vector(7 downto 0);
  signal s_hexa_2: std_logic_vector(7 downto 0);
  
begin
  o_threshold_1 <= i_threshold_1;
  
  u_rx_serial: rx_serial
  port map (
    i_clock => i_clock,
    i_reset => i_reset,
    i_dado_serial => i_umidade_solo_0,
    i_recebe_dado => '1',
    o_dado_recebido => s_dado_recebido,
    o_tem_dado => s_tem_dado,
    o_pronto => open,
    o_final => s_final,
    db_recebe_dado => open,
    db_dado_serial => open,
    db_estado => open
  );

  u_register_0: register_n
  generic map (
    N => 8
  )
  port map (
    i_clock => i_clock,
    i_reset => i_reset,
    i_enable => s_enable_0,
    i_data => s_dado_recebido,
    o_data => s_hexa_0
  );

  u_register_1: register_n
  generic map (
    N => 8
  )
  port map (
    i_clock => i_clock,
    i_reset => i_reset,
    i_enable => s_enable_1,
    i_data => s_dado_recebido,
    o_data => s_hexa_1
  );

  u_register_2: register_n
  generic map (
    N => 8
  )
  port map (
    i_clock => i_clock,
    i_reset => i_reset,
    i_enable => s_enable_2,
    i_data => s_dado_recebido,
    o_data => s_hexa_2
  );

  u_mux_umidade_solo: mux_umidade_solo
  port map (
    i_caractere_contagem => s_caractere_contagem,
    i_tem_dado => s_tem_dado,
    o_enable_0 => s_enable_0,
    o_enable_1 => s_enable_1,
    o_enable_2 => s_enable_2
  );

  u_conta_caracteres: contador_m
  generic map (
    M => 3,
    N => 2
  )
  port map (
    clock => i_clock,
    zera => i_reset,
    conta => s_final,
    Q => s_caractere_contagem,
    fim => open
  );

  u_display_0: hexa7seg
  port map (
    hexa => s_hexa_0(3 downto 0),
    sseg => o_display_0
  );

  u_display_1: hexa7seg
  port map (
    hexa => s_hexa_1(3 downto 0),
    sseg => o_display_1
  );

  u_display_2: hexa7seg
  port map (
    hexa => s_hexa_2(3 downto 0),
    sseg => o_display_2
  );
  
end arch;
