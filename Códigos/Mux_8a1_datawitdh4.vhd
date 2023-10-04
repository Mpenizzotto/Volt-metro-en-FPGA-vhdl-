--Mux_8a1_datawitdh4.vhd
--Multiplexor final, que resulta de la combinación de los demás muxes, todos formados en primer lugar por el mux básico, 2 a 1 con 1 bit de datawtidth.
library IEEE;
use IEEE.std_logic_1164.all;
 
entity mux_8a1_datawidth4 is
	port(
		entrada0:in std_logic_vector(3 downto 0);
		entrada1:in std_logic_vector(3 downto 0);
		entrada2:in std_logic_vector(3 downto 0);
		entrada3:in std_logic_vector(3 downto 0);
		entrada4:in std_logic_vector(3 downto 0);
		entrada5:in std_logic_vector(3 downto 0);
		entrada6:in std_logic_vector(3 downto 0);
		entrada7:in std_logic_vector(3 downto 0);
		selector:in std_logic_vector(2 downto 0);
		out1:out std_logic_vector(3 downto 0)
	);
end entity;

architecture mux_8a1_datawidth4_arch of mux_8a1_datawidth4 is 

signal salida0, salida1, salida2, salida3: std_logic_vector(3 downto 0); 		--Para la 1ra columna de muxes
signal salida4, salida5: std_logic_vector(3 downto 0);							--Para la 2da columna de muxes

begin

---------------1ra columna de mux'es-----------------

mux0: entity work.mux_2a1_datawidth4 port map(entrada0, entrada1, selector(0), salida0);

mux1: entity work.mux_2a1_datawidth4 port map(entrada2, entrada3, selector(0), salida1);

mux2: entity work.mux_2a1_datawidth4 port map(entrada4, entrada5, selector(0), salida2);

mux3: entity work.mux_2a1_datawidth4 port map(entrada6, entrada7, selector(0), salida3);

---------------2da columna de mux'es-----------------

mux4: entity work.mux_2a1_datawidth4 port map(salida0, salida1, selector(1), salida4);

mux5: entity work.mux_2a1_datawidth4 port map(salida2, salida3, selector(1), salida5);

---------------3ra columna de mux'es-----------------

mux6: entity work.mux_2a1_datawidth4 port map(salida4, salida5, selector(2), out1);

end;


