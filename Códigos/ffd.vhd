--ffd.vhd
--FLIP-FLOP TIPO D sincrónico
library IEEE;
use IEEE.std_logic_1164.all;

entity ffd is
	port(
			clk_i: in std_logic;					
			rst_i: in std_logic;	
			ena_i: in std_logic;	
			d_i:in std_logic;		
			q_o: out std_logic		
		);	
end;

architecture ffd_arch of ffd is		
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
end; 	
