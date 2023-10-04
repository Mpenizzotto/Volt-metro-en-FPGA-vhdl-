--registro_n.vhd

library IEEE;
use IEEE.std_logic_1164.all;

entity registro_n is

generic(N:natural); --no aclaro el número N acá, se va a definir cuando se implemente el contador de cuenta variable

port(
	clk: in std_logic;
	ena: in std_logic;
	rst:in std_logic;
	d_in: in std_logic_vector((N-1)downto 0) := (others => '0');		--va a tener N entradas D--
	q_out: out std_logic_vector((N-1)downto 0):= (others => '0')		--y N salidas Q también
);
end;

architecture registro_n_arch of registro_n is
begin


	process(clk)						--Definimos el funcionamiento del FF-D
	begin
		if rising_edge(clk) then		--Todo se descencadenará cuando detectemos el flanco ascendente
			if rst = '1' then			--si el reset esta en 1, a la salida forzamos un 0.
				q_out <= (N-1 downto 0 => '0');		
			elsif ena = '1' then		--caso contrario, y ademas el eneable esta en 1, entonces Q = D
				q_out <= d_in;	
			end if;
		end if;
	end process;	 
end; 	

