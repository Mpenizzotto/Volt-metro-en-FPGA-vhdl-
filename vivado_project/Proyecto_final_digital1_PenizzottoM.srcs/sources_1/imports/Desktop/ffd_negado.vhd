-- FLIP-FLOP TIPO D negado
library IEEE;
use IEEE.std_logic_1164.all;

entity ffd_negado is
	port(
			clk_i: in std_logic;	--Se define puertos:Clock				
			rst_i: in std_logic;	--Se define puertos:Reset
			ena_i: in std_logic;	--Se define puertos:Enable
			d_i:in std_logic;		--Se define puertos:Entrada	
			q_o: buffer std_logic;		--Se define puertos:Salida
			q_o_not: buffer std_logic		--Se define puertos:Salida
		);	
end;

architecture ffd_negado_arch of ffd_negado is		
begin
	process(clk_i)						--Definimos el funcionamiento del FF-D
	begin
		if rising_edge(clk_i) then		--Todo se descencadenará cuando detectemos el flanco ascendente
			if rst_i = '1' then			--si el reset esta en 1, a la salida forzamos un 0.
				q_o <= '0';		
			elsif ena_i = '1' then		--caso contrario, y ademas el eneable esta en 1, entonces Q = D
				q_o <= d_i;	
			end if;
		end if;
	end process;	
q_o_not<=not q_o; 
end; 	


