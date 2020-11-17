library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity sensor_umidade_solo_uc is 
  port ( clock, reset, medir, echo, fim_gera_trigger	: in std_logic;
         trigger, conta_echo, pronto, zera, zera_medida: out std_logic;			
			db_estado: out std_logic_vector(4 downto 0)
			);
end;

architecture sensor_umidade_solo_uc of sensor_umidade_solo_uc is

    type tipo_estado is (inicial, gerando_trigger, esperando_echo, contando_echo, final);
    signal Eatual: tipo_estado;  -- estado atual
    signal Eprox:  tipo_estado;  -- proximo estado

begin 

  -- memoria de estado
  process (reset, clock)
  begin
      if reset = '1' then
          Eatual <= inicial;
      elsif clock'event and clock = '1' then
          Eatual <= Eprox; 
      end if;
  end process;

  -- logica de proximo estado
  process (medir, echo, fim_gera_trigger, Eatual) 
  begin

    case Eatual is
							
		when inicial => if medir = '1' then Eprox <= gerando_trigger;
                           else                Eprox <= inicial;
                           end if;

      when gerando_trigger =>   if fim_gera_trigger = '1' then Eprox <= esperando_echo;
										  else                           Eprox <= gerando_trigger;
										  end if;
	
		when esperando_echo => 	if echo = '1' then Eprox <= contando_echo;									   
									   else Eprox <= esperando_echo;
										end if;

      when contando_echo =>  if echo = '0' then Eprox <= final;									  
									  else               Eprox <= contando_echo;
                           end if;
		
		when final => 	Eprox <= inicial;
											
      when others => Eprox <= inicial;

    end case;
  end process;

  -- logica de saida (Moore)

  with Eatual select
      zera <= '1' when inicial, '0' when others;
		
  with Eatual select
      zera_medida <= '1' when gerando_trigger, '0' when others;
		
  with Eatual select
      trigger <= '1' when gerando_trigger, '0' when others;

  with Eatual select
      conta_echo <= '1' when contando_echo, '0' when others;

  with Eatual select
      pronto <= '1' when final, '0' when others;
	 
		
  with Eatual select
      db_estado <= 
		"00000" when inicial,
		"00001" when gerando_trigger,
		"00010" when esperando_echo,
		"00011" when contando_echo,
		"00100" when final,
		"11111" when others;

end sensor_umidade_solo_uc;
