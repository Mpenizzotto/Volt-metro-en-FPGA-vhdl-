--Generador_senial_sync_horizontal.vhd
--En este archivo se crea una entidad que va a generar las señales horizontales necesarias para mandar al monitor.
library IEEE;
use IEEE.std_logic_1164.all;

entity generador_sync_horizontal is

port(
	clk: in std_logic;
	rst: in std_logic;	
	ena: in std_logic;	
	pixelY_ena: out std_logic;
	cuenta_pixelX :buffer std_logic_vector(9 downto 0):= (others => '0');		--La cuenta de pixel X debe salir afuera. Uso 10 bits porque asi con eso llego a 800 												--(despues lo adapto a un número mas comodo de bits para llegar a solo 800 (o no) ).
	h_sync: out std_logic;				
	h_vidon: out std_logic		);
end;

architecture generador_sync_horizontal_arch of generador_sync_horizontal is

--Todos los calculos de timings de clocks en las señales se hacen tomando el cero no en donde lo pone Miguel en su presentacion, sino en el comienzo del primer back porch.

signal reg_ena: std_logic;		 
signal cont_pixelY_ena: std_logic;		--Esta variable y la siguiente se usan para "llenar" unas salidas del contador que se va a usar, que no sirven aquí.
signal rst_contX:  std_logic;
signal flag_aux_hsync:  std_logic;			--estas dos señales flag se usan para mandarle al fft de hsync como entrada T
signal flag_aux_h_vidon:  std_logic;			
signal flag_cuenta_en0:  std_logic;		--se activa cuando el contador está en 000000... Es para levantar h_sync en ese caso.	
signal flag_cuenta_en48:  std_logic;		--se activa cuando el contador está en 48b. Sirve para activar el h_vid_on.	
signal flag_cuenta_en688_frontp:  std_logic;		--se activa cuando el contador está en 688b. Sirve para desactivar el h_vid_on, en el comienzo del front porch
signal flag_cuenta_en704_frontp:  std_logic;		--se activa cuando el contador está en 704b. Sirve para desactivar el h_sync, al finalizar el front porch.
	

begin

pixelY_ena<=cont_pixelY_ena; 				--saco el habilitador de contador de pixel Y afuera.

contador_ventana_pixelX: entity work.contador_pixelX port map(clk, rst, ena, cuenta_pixelX,cont_pixelY_ena,rst_contX);		--invocamos un contador de ventana sólo para que cuente pixelX

--Listo, en "cuenta_pixelX" ya tenemos el valor de cuenta de pixel X. 

--A continuación genero las señales de video de X, que dependen sólo del contador X:

--Comienzo invocando al flip flop tipo T, para h_sync:

fft_hsync: entity work.fft port map(clk, rst, flag_aux_hsync, '1',h_sync);													

flag_aux_hsync<= flag_cuenta_en0 or flag_cuenta_en704_frontp;			--OReo los dos flags importantes para el hsync

--Creo otro para el h_vid_on

fft_h_vidon: entity work.fft port map(clk, rst, flag_aux_h_vidon,'1' ,h_vidon);

flag_aux_h_vidon<= flag_cuenta_en48 or flag_cuenta_en688_frontp;

--------------------------------------------------------------------------------

--Comenzamos con la definicion de los flags comparadores usados arriba:


flag_cuenta_en0<=  ( (not rst) and (not cuenta_pixelX(9)) and (not cuenta_pixelX(8)) and (not cuenta_pixelX(7)) and (not cuenta_pixelX(6)) and (not cuenta_pixelX(5)) and (not cuenta_pixelX(4)) and (not cuenta_pixelX(3)) and (not cuenta_pixelX(2)) and (not cuenta_pixelX(1)) and (not cuenta_pixelX(0)) );

--El número 47 en binario  es 101111

flag_cuenta_en48<= ((not cuenta_pixelX(9)) and (not cuenta_pixelX(8)) and (not cuenta_pixelX(7)) and (not cuenta_pixelX(6)) and ( cuenta_pixelX(5)) and ( not cuenta_pixelX(4)) and ( cuenta_pixelX(3)) and ( cuenta_pixelX(2)) and ( cuenta_pixelX(1)) and ( cuenta_pixelX(0)) );

--El número 687 en binario es 1010101111
flag_cuenta_en688_frontp<= cuenta_pixelX(9) and (not cuenta_pixelX(8)) and cuenta_pixelX(7) and (not cuenta_pixelX(6)) and cuenta_pixelX(5) and (not cuenta_pixelX(4)) and ( cuenta_pixelX(3)) and ( cuenta_pixelX(2)) and ( cuenta_pixelX(1)) and ( cuenta_pixelX(0));

--El número 703 en binario es  1010111111
flag_cuenta_en704_frontp<= cuenta_pixelX(9) and (not cuenta_pixelX(8)) and cuenta_pixelX(7) and ( not cuenta_pixelX(6)) and ( cuenta_pixelX(5)) and ( cuenta_pixelX(4)) and ( cuenta_pixelX(3)) and ( cuenta_pixelX(2)) and ( cuenta_pixelX(1)) and ( cuenta_pixelX(0));

end;