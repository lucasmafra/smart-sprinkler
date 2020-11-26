library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;

entity register_n is
  generic (
    constant N: integer
  );
  port(
    i_clock: in std_logic;
    i_reset: in std_logic;
    i_enable: in std_logic;
    i_data: in std_logic_vector(N-1 downto 0);
    o_data: out std_logic_vector(N-1 downto 0)
  );
end register_n;

architecture behv of register_n is
begin
    process(i_clock, i_reset, i_enable, i_data)
    begin
      if i_reset='1' then o_data <= std_logic_vector(to_unsigned(0, o_data'length));
      elsif (i_clock='1' and i_clock'event and i_enable='1') then
        o_data <= i_data;
      end if;
    end process;	
end behv;
