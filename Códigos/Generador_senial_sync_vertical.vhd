--Generador_senial_sync_vertical.vhd
--En este archivo se crea una entidad que va a generar las señales verticales necesarias para mandar al monitor: vsync y v_vidon
library IEEE;
use IEEE.std_logic_1164.all;

entity generador_sync_vertical is

port(
	clk: in std_logic;
	rst: in std_logic;	
	ena: in std_logic;	
	cuenta_pixelY :buffer std_logic_vector(9 downto 0):= (others => '0');			--La cuenta de pixel Y sale afuera. Usa 10 bits para llegar a 525	
	v_sync: out std_logic;				
	v_vidon: out std_logic	
	);						
end;							

architecture generador_sync_vertical_arch of generador_sync_vertical is

--Todos los calculos de timings de clocks en las señales aquí abajo se hacen tomando el cero no en donde lo pone Miguel en su presentacion, sino en el comienzo del primer back porch.

signal reg_ena: std_logic;		 

signal rst_contY:  std_logic;		--Esta variable y la siguiente se usan para "llenar" unas salidas del contador que se va a usar, que no sirven aquí.
signal rst_contY2:  std_logic;
signal rst_contY3:  std_logic;
signal flag_aux_vsync:  std_logic;	--estas dos señales flag se usan para mandarle al fft de vsync como entrada T
signal flag_aux_v_vidon:  std_logic;
signal flag_cuenta_en0:  std_logic;		--se activa cuando el contador está en 000000... Es para levantar vsync en ese caso.	
signal flag_cuenta_en33:  std_logic;		--se activa cuando el contador está en 33b. Sirve para activar el v_vid_on.	
signal flag_cuenta_en513_frontp:  std_logic;		--se activa cuando el contador está en 513b. Sirve para desactivar el v_vid_on, en el comienzo del front porch
signal flag_cuenta_en523_frontp:  std_logic;		--se activa cuando el contador está en 523b. Sirve para desactivar el v_sync, al finalizar el front porch.
signal nada:  std_logic;		--para ponerle a la salida no negada del fft_negado que maneja a vsync.
signal nada2:  std_logic;


begin


contador_ventana_pixelY: entity work.contador_pixelY port map(clk, rst, ena, cuenta_pixelY,rst_contY);		--invocamos un contador de ventana sólo para que cuente pixelY

--Listo, en "cuenta_pixelY" ya tenemos el valor de cuenta de pixel Y. 

--A continuación genero las señales de video de Y, 
--Comienzo invocando al flip flop tipo T, para v_sync. Estos fft se habilitan por enable.
fft_vsync: entity work.fft_negado port map(clk, rst, flag_aux_vsync, '1', v_sync, nada );

flag_aux_vsync<= flag_cuenta_en0 or flag_cuenta_en523_frontp;			--OReo los dos flags importantes para el vsync

--Creo otro fft para el v_vid_on
fft_h_vidon: entity work.fft_negado port map(clk, rst, flag_aux_v_vidon,'1' ,v_vidon, nada2);

flag_aux_v_vidon<= flag_cuenta_en33 or flag_cuenta_en513_frontp;		--OReo los dos flags importantes para el v_vidon

--------------------------------------------------------------------------------

--Comenzamos con la definicion de los flags comparadores usados arriba:


flag_cuenta_en0<=  ( (not cuenta_pixelY(9)) and (not cuenta_pixelY(8)) and (not cuenta_pixelY(7)) and (not cuenta_pixelY(6)) and (not cuenta_pixelY(5)) and (not cuenta_pixelY(4)) and (not cuenta_pixelY(3)) and (not cuenta_pixelY(2)) and (not cuenta_pixelY(1)) and (not cuenta_pixelY(0)) );-- andeamos el enable para arreglar el caso de la cuenta Y en 000 inicualmente, que el flanco de cuenta en 0 nunca se ve

--El número 33 en binario  es  10000

flag_cuenta_en33<= ((not cuenta_pixelY(9)) and (not cuenta_pixelY(8)) and (not cuenta_pixelY(7)) and (not cuenta_pixelY(6)) and ( cuenta_pixelY(5)) and (not cuenta_pixelY(4)) and (not cuenta_pixelY(3)) and (not cuenta_pixelY(2)) and (not cuenta_pixelY(1)) and (   cuenta_pixelY(0)) );

--El número 513 en binario es 1000000001
flag_cuenta_en513_frontp<= (( cuenta_pixelY(9)) and (not cuenta_pixelY(8)) and (not cuenta_pixelY(7)) and (not cuenta_pixelY(6)) and (not cuenta_pixelY(5)) and (not cuenta_pixelY(4)) and (not cuenta_pixelY(3)) and (not cuenta_pixelY(2)) and (not cuenta_pixelY(1)) and ( cuenta_pixelY(0)) );

--El número 523 en binario es  1000001011
flag_cuenta_en523_frontp<= (( cuenta_pixelY(9)) and (not cuenta_pixelY(8)) and (not cuenta_pixelY(7)) and (not cuenta_pixelY(6)) and (not cuenta_pixelY(5)) and (not cuenta_pixelY(4)) and ( cuenta_pixelY(3)) and (not cuenta_pixelY(2)) and ( cuenta_pixelY(1)) and ( cuenta_pixelY(0)) );

end;

