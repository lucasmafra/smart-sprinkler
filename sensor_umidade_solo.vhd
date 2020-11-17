library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sensor_umidade_solo is
  generic (
    constant velocidade_simulacao: integer := 1
  );
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
end entity;


architecture arch of sensor_umidade_solo is
 signal s_fim_gera_trigger, s_conta_echo, s_zera, s_trigger, s_zera_medida, s_conta_echo_modulado: std_logic;

 component sensor_umidade_solo_uc is 
  port ( clock, reset, medir, echo, fim_gera_trigger	: in std_logic;
         trigger, conta_echo, pronto, zera, zera_medida: out std_logic;			
			db_estado: out std_logic_vector(4 downto 0)
			);
 end component;
 
 component sensor_umidade_solo_fd is
    port (
        clock, reset, conta_trigger, conta_echo, zera, zera_medida: in std_logic;        
        fim_gera_trigger: out std_logic;
        medida: out std_logic_vector(15 downto 0)
    );
end component;

component contador_m
    generic (
        constant M: integer;
        constant N: integer
    );
    port (
        clock, zera, conta: in STD_LOGIC;
        Q: out STD_LOGIC_VECTOR (N-1 downto 0);
        fim: out STD_LOGIC);
    end component;

begin

	 U1_sensor_umidade_solo_uc: sensor_umidade_solo_uc port map (i_clock, i_reset, i_medir, i_echo, s_fim_gera_trigger, s_trigger, s_conta_echo, o_pronto, s_zera, s_zera_medida, db_estado);
	 U2_sensor_umidade_solo_fd: sensor_umidade_solo_fd port map (i_clock, i_reset, s_trigger, s_conta_echo_modulado, s_zera, s_zera_medida, s_fim_gera_trigger, o_medida);	 	
	 U3: contador_m generic map (M => 2941, N => 12) port map (i_clock, s_zera, s_conta_echo, open, s_conta_echo_modulado);
	
	 o_trigger <= s_trigger;
	 db_medir <= i_medir;
	 
end arch;
