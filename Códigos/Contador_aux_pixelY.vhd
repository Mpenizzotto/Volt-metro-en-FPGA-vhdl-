library IEEE;
use IEEE.std_logic_1164.all;


--Este contador sera armado de manera genérica, de manera que pueda escalar en flip flops y en número de cuenta final. No es BCD, es binario comun.El parámetro N se debe tocar para modificar la cuenta final.Usa el circuito que paso Nico


entity contador_pixelY_aux is
generic(N: natural:=10	);	--el número N es la cantidad de bits, o también de flip flops, que va a tener este contador.Se necesitan 10 bits para el número525 en binario.

port(
		clk_cont: in std_logic;
		rst_gral: in std_logic;	
		ena_cont: in std_logic;
		out1: out std_logic_vector (N-1 downto 0):= (others => '0'); --Ponemos como salida el número de la cuenta para verificar el correcto funcionamiento
		--pixelY_ena :out std_logic;									
		rst_contY: buffer std_logic		);--Hay que ponerlo como buffer porque en un momento se auto-lee para resetear al mismo contador binario.

end;

architecture contador_pixelY_aux_arch of contador_pixelY_aux is


signal d_in_aux: std_logic_vector(N-1 downto 0):= (others => '0');										
signal q_o_aux: std_logic_vector(N-1 downto 0):= (others => '0');		
signal and_aux: std_logic_vector(N downto 0):= (others => '0');			--por cómo se van calculando los and_aux, siempre se calcula uno más para la vuelta siguiente. Al terminar la ronda de k ir de 0 a 11, este vector tiene 1 mas, entonces tiene de0 a 12 posiciones.
signal max_cuenta :std_logic; 
signal rst_cont :std_logic; 					--para que funcione el reset propio.
signal rst_propio :std_logic;			---agrego reset particular porque lo necesito
signal rst_aux :std_logic;

begin

rst_aux <= rst_gral;

rst_cont <= (rst_aux or rst_propio);

reg_contador: entity work.registro_n		--sólo hay que declarar un regn, porque dentro ya tiene los n vectores declarados.
generic map(
	N=>N
)
port map(
			clk_cont, ena_cont, rst_cont, d_in_aux, q_o_aux);
			
			
--A continuación recorremos los vectores de flip flops y aplicamos las compuertas del circuito del contador de nico--

and_aux(0)<=ena_cont and '1';

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
d_in_aux(0)<=q_o_aux(0) xor and_aux(0) ;	
and_aux(1)<=q_o_aux(0) and and_aux(0);	

d_in_aux(1)<=q_o_aux(1) xor and_aux(1) ;	
and_aux(2)<=q_o_aux(1) and and_aux(1);	

d_in_aux(2)<=q_o_aux(2) xor and_aux(2) ;	
and_aux(3)<=q_o_aux(2) and and_aux(2);	

d_in_aux(3)<=q_o_aux(3) xor and_aux(3) ;	
and_aux(4)<=q_o_aux(3) and and_aux(3);	

d_in_aux(4)<=q_o_aux(4) xor and_aux(4) ;	
and_aux(5)<=q_o_aux(4) and and_aux(4);	

d_in_aux(5)<=q_o_aux(5) xor and_aux(5) ;	
and_aux(6)<=q_o_aux(5) and and_aux(5);	

d_in_aux(6)<=q_o_aux(6) xor and_aux(6) ;	
and_aux(7)<=q_o_aux(6) and and_aux(6);	

d_in_aux(7)<=q_o_aux(7) xor and_aux(7) ;	
and_aux(8)<=q_o_aux(7) and and_aux(7);	

d_in_aux(8)<=q_o_aux(8) xor and_aux(8) ;	
and_aux(9)<=q_o_aux(8) and and_aux(8);	

d_in_aux(9)<=q_o_aux(9) xor and_aux(9) ;	
and_aux(10)<=q_o_aux(9) and and_aux(9);	

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

out1<=q_o_aux;		--out1 es para simulacion nomas, no necesitamos sacar la salida total afuera.

--la cuenta llega a 485
max_cuenta<=(( not q_o_aux(9)) and ( q_o_aux(8)) and ( q_o_aux(7)) and ( q_o_aux(6)) and (  q_o_aux(5)) and ( not q_o_aux(4)) and ( not q_o_aux(3)) and ( q_o_aux(2)) and ( not q_o_aux(1)) and (  q_o_aux(0)) );

rst_propio<= max_cuenta;     --recordar poner el rst-propio así funca el tema de no mezclarlo con el rst general.El reset se realiza un clock despues que se alcanza la max cuenta de 525.
										

end;
