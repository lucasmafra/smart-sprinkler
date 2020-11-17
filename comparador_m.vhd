library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparador_m is
  generic (
    constant N: integer -- numero de bits dos sinais a serem comparados
  );
  port (
    a: in std_logic_vector(N-1 downto 0);
    b: in std_logic_vector(N-1 downto 0);
    a_less_than_b: out std_logic
  );
end comparador_m;

architecture comparator_structural of comparador_m is 
begin
 a_less_than_b <= '1' when unsigned(a) < unsigned(b) else '0';
end comparator_structural;
