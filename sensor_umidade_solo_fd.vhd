-- sensor_umidade_solo_fd.vhd
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sensor_umidade_solo_fd is
    port (
        clock, reset, conta_trigger, conta_echo, zera, zera_medida: in std_logic;        
        fim_gera_trigger: out std_logic;
        medida: out std_logic_vector(15 downto 0)
    );
end sensor_umidade_solo_fd;

architecture sensor_umidade_solo_fd_arch of sensor_umidade_solo_fd is    
	 signal s_dig3, s_dig2, s_dig1, s_dig0: std_logic_vector(3 downto 0);
	 
    component contador_bcd_4digitos is 
    port ( clock, zera, conta:     in  std_logic;
           dig3, dig2, dig1, dig0: out std_logic_vector(3 downto 0);
           fim:                    out std_logic
    );
    end component;

	 component contador_m
    generic 
    (
        constant M: integer;
        constant N: integer
    );
    port 
    (
        clock, zera, conta: in  std_logic;
        Q:                  out std_logic_vector (N-1 downto 0);
        fim:                out std_logic
    );
    end component;
begin 
    U1_contador_trigger: contador_m generic map (M => 500, N => 9) port map (clock, zera, conta_trigger, open, fim_gera_trigger);
	 
	 U2_contador_echo: contador_bcd_4digitos port map (
	   clock, 
		zera_medida, 
		conta_echo,
      s_dig3, 
		s_dig2, 
		s_dig1, 
		s_dig0,
      open
	 );	 
	 
	 medida <= s_dig3 & s_dig2 & s_dig1 & s_dig0;
	 
end sensor_umidade_solo_fd_arch;
