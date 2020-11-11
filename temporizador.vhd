library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity temporizador is
  generic (
    constant M: integer := 500000000;  -- duracao do sinal em '1'
    constant N: integer := 1000000000 -- periodo total
  );
  port (
    i_clock: in std_logic;
    i_reset: in std_logic;
    o_temporizador: out std_logic;
    o_fim_temporizador: out std_logic
  );
end entity;

architecture arch of temporizador is
  signal IQ: integer range 0 to N-1;
  
begin
  process (i_clock,i_reset,IQ)
  begin
    if i_reset='1' then
      IQ <= 0;
      o_temporizador <= '0';
    elsif i_clock'event and i_clock='1' then
      if IQ=N-1 then IQ <= 0; 
      else IQ <= IQ + 1; 
      end if;
    end if;

    if IQ=N-1 then o_fim_temporizador <= '1'; 
    else o_fim_temporizador <= '0'; 
    end if;
    
    if IQ < M and i_reset = '0' then o_temporizador <= '1'; 
    else o_temporizador <= '0'; 
    end if;


  end process;
end arch;
