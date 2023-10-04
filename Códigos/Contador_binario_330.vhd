--Contador_binario_330.vhd
--Es el contador que se encarga de generar la ventana de tiempo. Cuenta hasta 3300.
library IEEE;
use IEEE.std_logic_1164.all;

--Este contador sera armado de manera genérica, de manera que pueda escalar en flip flops y en número de cuenta final. 
--Este contador contará la ventana de tiempo en la que el contador de 1's del sigma delta debe actual.Finalizada la misma, lo resetea.
--La ventana es de 3300, al ritmo dado por el clk del sistema.

entity contador1_ventana is
generic(N: natural:=12	);	--el número N es la cantidad de bits, o también de flip flops, que va a tener este contador.Se necesitan 12 bits para el número 3300 en binario.

port(
		clk_cont: in std_logic;
		rst_gral: in std_logic;	
		ena_cont: in std_logic;
		out1: out std_logic_vector (N-1 downto 0):= (others => '0');	--Ponemos como salida el número de la cuenta para verificar el correcto funcionamiento
		reg_ena :out std_logic;									
		bcd_rst: buffer std_logic		);				--Hay que ponerlo como buffer porque en un momento se auto-lee para resetear al mismo contador binario.

end;

architecture contador1_ventana_arch of contador1_ventana is

--Creo señales como variables, en forma de vectores, para luego asignárselo en el portm map al registro que instancie acá.
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

reg_contador: entity work.registro_n					--sólo hay que declarar un regn, porque dentro ya tiene los n flip flops declarados.
generic map(
	N=>N
)
port map(
			clk_cont, ena_cont, rst_cont, d_in_aux, q_o_aux);
		
--Pasamos a aplicar las compuertas del circuito de contador brindado por Nico--

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

d_in_aux(10)<=q_o_aux(10) xor and_aux(10) ;	
and_aux(11)<=q_o_aux(10) and and_aux(10);

d_in_aux(11)<=q_o_aux(11) xor and_aux(11) ;	
and_aux(12)<=q_o_aux(11) and and_aux(11);


------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

out1<=q_o_aux;		--Sacamos el valor de conteo afuera. out1 es para simulacion nomas, no necesitamos sacar la salida total afuera.

--Ponemos el comparador de cuenta máxima en el número 3300
max_cuenta<=(q_o_aux(11)and q_o_aux(10) and (not q_o_aux(9)) and (not q_o_aux(8)) and q_o_aux(7)and q_o_aux(6) and q_o_aux(5) and (not q_o_aux(4)) and (not q_o_aux(3)) and q_o_aux(2) and (not q_o_aux(1)) and (not q_o_aux(0)));

--max cuenta entonces es 1 (durante 1 tick de clk) sí se llegó a la max cuenta, si no, es cero.--

ffd_aux: entity work.ffd port map(clk_cont, rst_gral, ena_cont, max_cuenta ,bcd_rst );	--se retarda 1 clk la señal de reset, tanto propio como del contador BCD  de 1's

reg_ena<= max_cuenta;		--Sí se debe realizar una habilitación instantánea de registro completo (via reg_ena)		

rst_propio<= bcd_rst;     --recordar poner el rst-propio así funca el tema de no mezclarlo con el rst general.

end;