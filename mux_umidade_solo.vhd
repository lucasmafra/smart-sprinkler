library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mux_umidade_solo is
  port (
    i_caractere_contagem: in std_logic_vector(1 downto 0);
    i_tem_dado: in std_logic;
    o_enable_0: out std_logic;
    o_enable_1: out std_logic;
    o_enable_2: out std_logic
  );
end entity;

architecture arch of mux_umidade_solo is
begin
  process (i_caractere_contagem, i_tem_dado) is
  begin
    if i_caractere_contagem = "00" and i_tem_dado = '1' then
      o_enable_0 <= '1';
      o_enable_1 <= '0';
      o_enable_2 <= '0';
    elsif i_caractere_contagem = "01" and i_tem_dado = '1' then
      o_enable_0 <= '0';
      o_enable_1 <= '1';
      o_enable_2 <= '0';
    elsif i_caractere_contagem = "10" and i_tem_dado = '1' then
      o_enable_0 <= '0';
      o_enable_1 <= '0';
      o_enable_2 <= '1';
    else
      o_enable_0 <= '0';
      o_enable_1 <= '0';
      o_enable_2 <= '0';
    end if;       
  end process;
end arch;
