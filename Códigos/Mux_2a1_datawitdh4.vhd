--Mux_2a1_datawidth4.vhd
--Conexión de 4 celdas básicas de mux (2 a 1, de 1 bit) "en paralelo" para lograr mux 2 a 1 con 4 bits de datawitdh
library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity mux_2a1_datawidth4 is
	port(
		entradaA:in std_logic_vector(3 downto 0);
		entradaB:in std_logic_vector(3 downto 0);
		selector:in std_logic;
		out1:out std_logic_vector(3 downto 0)
	);
end entity;

architecture mux_2a1_datawidth4_arch of mux_2a1_datawidth4 is 

begin

mux0: entity work.mux_2a1_datawidth1 port map(entradaA(0), entradaB(0), selector, out1(0));

mux1: entity work.mux_2a1_datawidth1 port map(entradaA(1), entradaB(1), selector, out1(1));

mux2: entity work.mux_2a1_datawidth1 port map(entradaA(2), entradaB(2), selector, out1(2));

mux3: entity work.mux_2a1_datawidth1 port map(entradaA(3), entradaB(3), selector, out1(3));

end;