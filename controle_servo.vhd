-- controle_servo.vhd - descrição rtl
--
-- gera saída com modulacao o_pwm
--
-- parametros: CONTAGEM_MAXIMA e i_posicao_o_pwm
--             (clock a 50MHz ou 20ns)

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity controle_servo is
  generic (
    constant velocidade_simulacao: integer := 1
  );
  port (
    i_clock    : in  std_logic;
    i_reset    : in  std_logic;
    i_posicao  : in  std_logic_vector(1 downto 0);  
    o_pwm      : out std_logic;
    db_reset   : out std_logic;
    db_pwm     : out std_logic;
    db_posicao : out std_logic_vector(1 downto 0)
  );
end controle_servo;

architecture rtl of controle_servo is

  constant CONTAGEM_MAXIMA : integer := 1000000 / velocidade_simulacao;  -- valor para frequencia da saida de 4KHz 
                                               -- ou periodo de 25us
  signal contagem     : integer range 0 to CONTAGEM_MAXIMA-1;
  signal i_posicao_o_pwm  : integer range 0 to CONTAGEM_MAXIMA-1;
  signal s_i_posicao    : integer range 0 to CONTAGEM_MAXIMA-1;
  signal s_pwm: std_logic;
  
begin

  process(i_clock,i_reset,i_posicao)
  begin
    -- inicia contagem e i_posicao
    if(i_reset='1') then
      contagem    <= 0;
      s_pwm         <= '0';
      i_posicao_o_pwm <= s_i_posicao;
    elsif(rising_edge(i_clock)) then
        -- saida
        if(contagem < i_posicao_o_pwm) then
          s_pwm  <= '1';
        else
          s_pwm  <= '0';
        end if;
        -- atualiza contagem e i_posicao
        if(contagem=CONTAGEM_MAXIMA-1) then
          contagem   <= 0;
          i_posicao_o_pwm <= s_i_posicao;
        else
          contagem   <= contagem + 1;
        end if;
    end if;
  end process;

  process(i_posicao)
  begin
    case i_posicao is
      when "00" =>    s_i_posicao <= 50000 / velocidade_simulacao;  -- pulso de  1 ms
      when "01" =>    s_i_posicao <=    100000 / velocidade_simulacao;  -- pulso de 2 ms
      when "10" =>    s_i_posicao <=    83500 / velocidade_simulacao;  -- pulso de 1.67 ms
      when others =>    s_i_posicao <=   100000 / velocidade_simulacao;  -- pulso de 2ms
    end case;
  end process;
  
  o_pwm <= s_pwm;
  
  db_reset <= i_reset;
  db_pwm <= s_pwm;
  db_posicao <= i_posicao;
  
  
end rtl;
