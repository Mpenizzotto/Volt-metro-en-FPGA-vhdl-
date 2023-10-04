--ffd_negado.vhd
-- FLIP-FLOP TIPO D con salida negada, reset sincrónico
library IEEE;
use IEEE.std_logic_1164.all;

entity ffd_negado is
	port(
			clk_i: in std_logic;				
			rst_i: in std_logic;	
			ena_i: in std_logic;	
			d_i:in std_logic;		
			q_o: buffer std_logic;		
			q_o_not: buffer std_logic		
		);	
end;

architecture ffd_negado_arch of ffd_negado is		
begin
	process(clk_i)						
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


