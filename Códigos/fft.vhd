--fft.vhd
-- FLIP-FLOP TIPO T sin salida negada, reset sincrónico
library IEEE;
use IEEE.std_logic_1164.all;

entity fft is
	port(
			clk_i: in std_logic;					
			rst_i: in std_logic;	
			ena_i: in std_logic;	
			t_i: in std_logic;		
			q_o: buffer std_logic		
					
		);	
end;

architecture fft_arch of fft is		

begin

	process(clk_i)						
	begin
		if rising_edge(clk_i) then		--Todo se descencadenará cuando detectemos el flanco ascendente
			if rst_i = '1' then			--si el reset esta en 1, a la salida forzamos un 0.
				q_o <= '0';		
			elsif ena_i = '1' then		--caso contrario, y ademas el eneable esta en 1...
				if t_i = '1' then		--si la entrada T esta en 1 --> Q=Q'
					
					q_o <= not q_o;
				end if;
			end if;
		end if;
	end process;	 
end; 	
