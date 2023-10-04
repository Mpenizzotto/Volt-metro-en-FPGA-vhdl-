--Contador_BCD.vhd
--Contador BCD singular.
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity cont_BCD is
  port(
    clk: in std_logic;
    rst: in std_logic;    
    ena: in std_logic;    
    y: buffer std_logic_vector(3 downto 0);	--Buffer porque en algún lado se autolee esta salida	
    flag_max: out std_logic   				
  );
end entity;

architecture cont_BCD_arch of cont_BCD is
	signal q, d: std_logic_vector(3 downto 0) := "0000";
begin
	ffd0: entity work.ffd port map(clk, rst, ena, d(0), q(0));
	ffd1: entity work.ffd port map(clk, rst, ena, d(1), q(1));
	ffd2: entity work.ffd port map(clk, rst, ena, d(2), q(2));
    ffd3: entity work.ffd port map(clk, rst, ena, d(3), q(3));


	d(3) <=  (  ( q(2) and q(1) and q(0) ) or (  q(3) and (not q(1)) and (not q(0))  )   );
	
	d(2) <=  (  ( (not q(2)) and q(1) and q(0) )or ( q(2) and (not q(1)) ) or (  q(2) and (not q(0))  )	);		--hago las conexiones según la resolución de los Karnaugh
	
	d(1) <= (   (  (not q(3)) and (not q(1)) and q(0) )or (  q(1) and (not q(0)) )   );

	d(0) <= not q(0);

	y <= q;


flag_max<= (  y(3) and (not y(2)) and (not y(1)) and y(0) );

--flag_max vale entonces 1 si se alcanzó la cuenta máxima, de otra forma vale cero.
end;


