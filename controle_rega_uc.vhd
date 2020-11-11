library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controle_rega_uc is
  port (
    i_clock: in std_logic;
    i_reset: in std_logic;
    i_valor_temporizador: in std_logic;
    i_fim_temporizador: in std_logic;
    i_girou_servomotor: in std_logic;
    o_alternar_vaso: out std_logic;
    o_abre_valvula: out std_logic;
    db_estado: out std_logic_vector(3 downto 0)
  );
end;

architecture arch of controle_rega_uc is

  type tipo_estado is (inicial, rega, repouso, alterna_vaso, espera_giro_servomotor);
  signal Eatual: tipo_estado;
  signal Eprox: tipo_estado;
  
begin
  -- memoria de estado
  process (i_reset, i_clock)
  begin
      if i_reset = '1' then
          Eatual <= inicial;
      elsif i_clock'event and i_clock = '1' then
          Eatual <= Eprox; 
      end if;
  end process;

  process(i_fim_temporizador, i_valor_temporizador, i_girou_servomotor, Eatual)
  begin
    case Eatual is
      when inicial => Eprox <= repouso;

      when repouso => if i_valor_temporizador = '1' then
                        Eprox <= rega;
                      elsif i_fim_temporizador = '1' then
                        Eprox <= alterna_vaso;
                      else
                        Eprox <= repouso;
                      end if;

      when rega => if i_valor_temporizador = '1' then
                     Eprox <= rega;
                   else
                     Eprox <= repouso;
                   end if;

      when alterna_vaso => Eprox <= espera_giro_servomotor;

      when espera_giro_servomotor => if i_girou_servomotor = '1' then
                                       Eprox <= repouso;
                                     else
                                       Eprox <= espera_giro_servomotor;
                                     end if;

      when others => Eprox <= inicial;
    end case;
  end process;

  -- logica de saida (Moore)

  with Eatual select
    o_alternar_vaso <= '1' when alterna_vaso, '0' when others;
		
  with Eatual select
    o_abre_valvula <= '1' when rega, '0' when others;

  with Eatual select
    db_estado <=
    "0000" when inicial,
    "0001" when repouso,
    "0010" when rega,
    "0011" when alterna_vaso,
    "0100" when espera_giro_servomotor,
    "1111" when others;
end arch;
