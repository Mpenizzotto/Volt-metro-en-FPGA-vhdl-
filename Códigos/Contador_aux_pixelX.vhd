library IEEE;
use IEEE.std_logic_1164.all;



--Este contador sera armado de manera gen�rica, de manera que pueda escalar en flip flops y en n�mero de cuenta final. No es BCD, es binario comun.El par�metro N se debe tocar para modificar la cuenta final.Usa el circuito que paso Nico
--Este contador contar� hasta 800, que es la cantidad de pixeles que habr� en X. 

entity contador_pixelX_aux is
generic(N: natural:=10	);	--el n�mero N es la cantidad de bits, o tambi�n de flip flops, que va a tener este contador.Se necesitan 12 bits para el n�mero 3300 en binario.

port(
		clk_cont: in std_logic;
		rst_gral: in std_logic;	
		ena_cont: in std_logic;
		out1: out std_logic_vector (N-1 downto 0):= (others => '0');	--Ponemos como salida el n�mero de la cuenta para verificar el correcto funcionamiento
		pixelY_ena :out std_logic;									
		rst_contX: buffer std_logic		);--Hay que ponerlo como buffer porque en un momento se auto-lee para resetear al mismo contador binario. Sale afuera solo por motivo de testing

end;

architecture contador_pixelX_aux_arch of contador_pixelX_aux is


signal d_in_aux: std_logic_vector(N-1 downto 0):= (others => '0');										
signal q_o_aux: std_logic_vector(N-1 downto 0):= (others => '0');		
signal and_aux: std_logic_vector(N downto 0):= (others => '0');			
signal max_cuenta :std_logic; 
signal rst_cont :std_logic; 					--para que funcione el reset propio.
signal rst_propio :std_logic;			---agrego reset particular porque lo necesito
signal rst_aux :std_logic;

begin

rst_aux <= rst_gral;

rst_cont <= (rst_aux or rst_propio);

reg_contador: entity work.registro_n					--s�lo hay que declarar un regn, porque dentro ya tiene los n vectores declarados.
generic map(
	N=>N
)
port map(
			clk_cont, ena_cont, rst_cont, d_in_aux, q_o_aux);
			



		
			
--Aplicamos las compuertas del circuito de contador de Nico:

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

--cuenta en 645. Primero se inhabilita, luego resetea sin ffd
																							
max_cuenta<=q_o_aux(9) and (not q_o_aux(8)) and q_o_aux(7) and (not q_o_aux(6)) and (not q_o_aux(5)) and (not q_o_aux(4)) and (not q_o_aux(3)) and ( q_o_aux(2)) and (not q_o_aux(1)) and ( q_o_aux(0));
--max cuenta entonces es 1 (durante 1 tick de clk) s� se lleg� a la max cuenta, si no, es cero.--

--ffd_aux: entity work.ffd port map(clk_cont, rst_gral, ena_cont, max_cuenta ,rst_contX );		--comento este retardo porque parece no tener sentido ac�. De �ltima volver a ponerlo.

pixelY_ena<= rst_contX;		

rst_propio<= max_cuenta;     --recordar poner el rst-propio as� funca el tema de no mezclarlo con el rst general.El reset se realiza un clock despues que se alcanza la max cuenta de 800.
		

						

end;
