library IEEE;
use IEEE.STD_LOGIC_1164.all;
 
entity mux_2to1 is
 port(
 
     A,B: in STD_LOGIC_VECTOR(7 downto 0);
     S0: in STD_LOGIC;
     Z: out STD_LOGIC_VECTOR(7 downto 0)
  );
end mux_2to1;
 
architecture bhv of mux_2to1 is
begin
process (A,B,S0) is
begin
  if (S0 ='0') then
      Z <= A;
  else
      Z <= B;
  end if;
 
end process;
end bhv;
