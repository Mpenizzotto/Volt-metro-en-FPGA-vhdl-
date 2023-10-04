--fft_negado.vhd
 --FFT con salida común y negada, y reset asincrónico.
library IEEE;
use IEEE.std_logic_1164.all;

entity fft_negado is
	port(
			clk_i: in std_logic;	
			rst_i: in std_logic;		
			ena_i: in std_logic;		
			t_i: in std_logic;		
			q_o: buffer std_logic;
			q_o_negado : buffer std_logic		
					
		);	
end;

architecture fft_negado_arch of fft_negado is		

begin

	process(clk_i, ena_i)						--Definimos el funcionamiento del FF-T asíncrónico (sino los fft de la parte vertical quedane en undefined)
	begin
	if rst_i = '1' then			--si el reset esta en 1, a la salida forzamos un 0.
				q_o <= '0';	
		elsif rising_edge(clk_i) then		--Todo se descencadenará cuando detectemos el flanco ascendente
					
			if ena_i = '1' then		-- y ademas el eneable esta en 1...
				if t_i = '1' then		--si la entrada T esta en 1 --> Q=Q'
					q_o <= not q_o;
				end if;
			end if;
		end if;
	end process;	
q_o_negado<=not q_o; 
end; 	








 