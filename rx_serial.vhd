-- rx_serial.vhd
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rx_serial is
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
end entity;

architecture arch_rx_serial of rx_serial is
    signal s_reset: std_logic;
    signal s_zera, s_conta, s_desloca, s_fim, s_tick, s_pronto_rx, s_tem_dado: std_logic;
	 signal s_dado_recebido: std_logic_vector(7 downto 0);
     
    component rx_serial_uc port ( clock, reset, fim, tick, i_serial, i_recebe_dado: in std_logic;
         zera, conta, desloca, pronto, o_tem_dado: out std_logic;			
			db_estado: out std_logic_vector(3 downto 0)
			);
    end component;
	 	
    component rx_serial_fd port (
        clock, reset: in std_logic;
        zera, conta, desloca, i_serial: in std_logic;
        dados_ascii: out std_logic_vector (7 downto 0);
        fim: out std_logic);
    end component;
	 
	 component contador_m_half 
	 generic (
        constant M: integer := 10;  -- modulo do contador
        constant N: integer := 4    -- numero de bits da saida
    );
	 port (
        clock, zera, conta: in std_logic;
        Q: out std_logic_vector (N - 1 downto 0);
        fim: out std_logic);
    end component;
	 
	 component mux_2to1
	port(
 
     A,B: in STD_LOGIC_VECTOR(7 downto 0);
     S0: in STD_LOGIC;
     Z: out STD_LOGIC_VECTOR(7 downto 0)
  );
		end component;
      
begin

    -- sinais reset e partida mapeados na GPIO (ativos em alto)
    s_reset <= i_reset;

    U1: rx_serial_uc port map (i_clock, s_reset, s_fim, s_tick, i_dado_serial,
		                         i_recebe_dado,
                               s_zera, s_conta, s_desloca, s_pronto_rx, s_tem_dado, db_estado);

    U2: rx_serial_fd port map (i_clock, s_reset, s_zera, s_conta, s_desloca, 
                               i_dado_serial, s_dado_recebido, s_fim);

	 U3: contador_m_half generic map (M => 434, N  => 9)
	 port map (i_clock, s_zera, '1', open, s_tick);
	 
	 U4: mux_2to1 port map ("00000000", s_dado_recebido, s_tem_dado, o_dado_recebido);
	 
	 o_pronto <= s_pronto_rx;
	
	 o_tem_dado <= s_tem_dado;
	 
	 db_recebe_dado <= i_recebe_dado;
	 db_dado_serial <= i_dado_serial;
	 
	 
end arch_rx_serial;
