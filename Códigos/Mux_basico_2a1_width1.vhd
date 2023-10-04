--Mux_basico_2a1_witdh1.vhd
--Este es el más simple de los MUX. 2 entradas, una salida, un select. El ancho de bits de las entradas es 1. 
--Aumentar el ancho de bits es muy fácil, solamente se ponen más de estos MUX "en paralelo".
--Lo que no es tan fácil es aumentarle la cantidad de entradas, pero en otro archivo se explica mejor.
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity mux_2a1_datawidth1 is
	port(
		entradaA :in std_logic;
		entradaB :in std_logic;
		selector :in std_logic;
		out1 :out std_logic
	);
end entity;

architecture mux_2a1_datawidth1_arch of mux_2a1_datawidth1 is 


begin

out1<=((not selector) and entradaA) or ( selector and entradaB);

end;
	
