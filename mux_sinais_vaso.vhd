library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_sinais_vaso is
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
end entity;

architecture arch of mux_sinais_vaso is
begin
  process (i_medir, i_pronto_0, i_pronto_1, i_medida_0, i_medida_1, vaso) is
  begin
    if (vaso = "00") then
      o_medir_vaso_0 <= i_medir;
      o_medir_vaso_1 <= '0';
      o_pronto <= i_pronto_0;
      o_medida <= i_medida_0;
    else
      o_medir_vaso_0 <= '0';
      o_medir_vaso_1 <= i_medir;
      o_pronto <= i_pronto_1;
      o_medida <= i_medida_1;
    end if;
  end process;
end arch;
