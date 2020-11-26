-- rx_serial_fd.vhd
--

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity rx_serial_fd is
    port (
        clock, reset: in std_logic;
        zera, conta, desloca, i_serial: in std_logic;
        dados_ascii: out std_logic_vector (7 downto 0);
        fim: out std_logic
    );
end rx_serial_fd;

architecture rx_serial_fd_arch of rx_serial_fd is
    signal s_dado: std_logic_vector (7 downto 0);
     
    component deslocador_n
    generic (
        constant N: integer 
    );
    port (
        clock, reset: in std_logic;
        carrega, desloca, entrada_serial: in std_logic; 
        dados: in  std_logic_vector (N-1 downto 0);
        saida: out std_logic_vector (N-1 downto 0));
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

    U1: deslocador_n generic map (N => 8)  port map (clock, reset, '0', desloca, i_serial, "00000000", s_dado);

    U2: contador_m generic map (M => 9, N => 4) port map (clock, zera, conta, open, fim);

    dados_ascii <= s_dado;
    
end rx_serial_fd_arch;
