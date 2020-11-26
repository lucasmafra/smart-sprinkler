-- rx_serial_uc.vhd
--

library ieee;
use ieee.std_logic_1164.all;

entity rx_serial_uc is 
  port ( clock, reset, fim, tick, i_serial, i_recebe_dado: in std_logic;
         zera, conta, desloca, pronto, o_tem_dado, o_final: out std_logic;			
			db_estado: out std_logic_vector(3 downto 0)
			);
end;

architecture rx_serial_uc of rx_serial_uc is

    type tipo_estado is (inicial, startbit, espera, recepcao, espera_ler_dado, final, stopbit_1, stopbit_2);
    signal Eatual: tipo_estado;  -- estado atual
    signal Eprox:  tipo_estado;  -- proximo estado

begin 

  -- memoria de estado
  process (reset, clock)
  begin
      if reset = '1' then
          Eatual <= inicial;
      elsif clock'event and clock = '0' then
          Eatual <= Eprox; 
      end if;
  end process;

  -- logica de proximo estado
  process (i_serial, tick, fim, i_recebe_dado, Eatual) 
  begin

    case Eatual is

      when inicial =>      if i_serial = '0' then Eprox <= startbit;
                           else                Eprox <= inicial;
                           end if;

      when startbit =>  if tick = '1' then Eprox <= espera;
			else Eprox <= startbit;
			end if;
	
		when espera => 	if tick = '1'then Eprox <= recepcao;
								elsif fim = '1' then Eprox <= stopbit_1;
								else Eprox <= espera;
								end if;

      when recepcao =>  if tick = '1' and fim = '0' then Eprox <= recepcao;
                        elsif fim='0' then Eprox <= espera;
                        else            Eprox <= stopbit_1;
                        end if;
		
      when stopbit_1 => 	Eprox <= stopbit_2;
                                
      when stopbit_2 =>		Eprox <= espera_ler_dado;
                                
      when espera_ler_dado =>  if i_recebe_dado = '1' and tick = '1' then Eprox <= final;
								      
                               else            Eprox <= espera_ler_dado;
                               end if;

      when final =>        Eprox <= inicial;
									
      when others =>       Eprox <= inicial;

    end case;
  end process;

  -- logica de saida (Moore)

  with Eatual select
      zera <= '1' when inicial, '0' when others;

  with Eatual select
      desloca <= '1' when recepcao, '0' when others;

  with Eatual select
      conta <= '1' when recepcao, '0' when others;

  with Eatual select
      pronto <= '1' when espera_ler_dado, '0' when others;
	
  with Eatual select
      o_tem_dado <= '1' when espera_ler_dado, '0' when others;

  with Eatual select
      o_final <= '1' when final, '0' when others;
		
  
    with Eatual select
      db_estado <= 
		"0000" when inicial,
		"0001" when startbit,
		"0010" when espera,
		"0011" when recepcao,
		"0100" when stopbit_1,
		"0101" when stopbit_2,
		"0110" when espera_ler_dado,
		"0111" when final,
		"1111" when others;

end rx_serial_uc;
