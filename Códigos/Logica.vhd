--Logica.vhd
--Este bloque controla al selector del multiplexor, y a las entradas font_col y font_row de la memoria ROM.

library IEEE;
use IEEE.std_logic_1164.all;

entity logica is

port(

	pixelY_ena :in std_logic; 		--Lo saca el gen sync horizontal. Lo tenemos que tomar acá para que funcione el contador auxiliar de Y.
	clk :in std_logic;
	rst :in std_logic;
	ena :in std_logic;
	cuenta_pixelX_real :in std_logic_vector(9 downto 0);
	cuenta_pixelY_real :in std_logic_vector(9 downto 0);	--Las unicas dos entradas que tiene este bloque son los contadores de pixel, con eso decide todo
	
	font_row :out std_logic_vector(2 downto 0);
	font_col :out std_logic_vector(2 downto 0);			--Salidas de fila y columna para decile a la ROM qué bit sacar.3 bits cada una de estas

	selector :out std_logic_vector(2 downto 0);			--Selector para el MUX

	

	registro_ena_VGA :buffer std_logic				--Este flag se activa cuando no se está barriendo ninguno de los casilleros principales. Le indica al registro principal que puede cambiar de valor.
								
--Pensar que el registro principal no puede cambiar de valor si la pantalla se está barriendo. Si cambia de valor, el multiplexor que está seleccionando qué salida del 
--registro mandar a la ROM se va a confundir, porque se le van a cambiar los valores mientras se los manda. Esto está muy relacionado con los tiempos de barrido de pantalla
--y de conteo de ventana. La pantalla tarda 1/60 Hz en barrerse toda (16,78ms), mientras que nuestro contador de 3300 tarda 3300x (1/25Mhz)= 0,132 ms. El valor del registro
-- cambia, de esta forma, 127 veces mientras se hace el barrido de un sólo frame !!!. Si contara hasta 330.000 esto no pasaría, pero son muchos flip flops eso. Prefiero el flag, 
-- que además, previene errores ocasionales de cambio de números durante los barridos

	);

end;

architecture logica_arch of logica is

--Señales de flags horizontales

signal flag_h_1cuadrante:  std_logic;			--Estos cuadrantes se refieren a los cuadrantes en los que se divide la pantalla
signal flag_h_2cuadrante:  std_logic;
signal flag_h_3cuadrante:  std_logic;
signal flag_h_4cuadrante:  std_logic;
signal flag_h_5cuadrante:  std_logic;

--Señales de flags verticales

signal flag_v_1cuadrante:  std_logic;
signal flag_v_2cuadrante:  std_logic;
signal flag_v_3cuadrante:  std_logic;
signal flag_v_4cuadrante:  std_logic;

--Flags combinados totales

signal flag_estoy_en_1cuadrante:  std_logic;
signal flag_estoy_en_2cuadrante:  std_logic;			--Estos cuadrantes se refieren sólo a aquellos donde se escriben caracteres.
signal flag_estoy_en_3cuadrante:  std_logic;
signal flag_estoy_en_4cuadrante:  std_logic;
signal flag_estoy_en_5cuadrante:  std_logic;

signal no_usado:  std_logic;
signal reset_aux:  std_logic;
signal flag_cuenta_en47: std_logic;
signal flag_cuenta_en688: std_logic;
signal flag_general_toggle: std_logic;
signal cont_aux_ena: std_logic;
signal cuenta_pixelX: std_logic_vector(9 downto 0);
signal rst_gralx	:std_logic;
signal rst_propiox :std_logic;


signal no_usado2:  std_logic;
signal reset_aux2:  std_logic;
signal flag_cuenta_en33: std_logic;
signal flag_cuenta_en513: std_logic;
signal flag_general_toggle2: std_logic;
signal cont_aux_ena2: std_logic;
signal cuenta_pixelY: std_logic_vector(9 downto 0);
signal rst_graly	:std_logic;
signal rst_propioy :std_logic;
signal nada :std_logic;



begin
--Creo contador auxiliar, para arreglar mi error de contar pixeles desde 0 en el borde negro. 
--Necesito que este contador cuente solamente cuando el contador original llegue a 47.
rst_gralx<= rst or rst_propiox;

contador_pixel_aux_X: entity work.contador_pixelX_aux port map(clk, (rst_gralx) , cont_aux_ena, cuenta_pixelX,no_usado,reset_aux);		--invocamos un contador de ventana sólo para que cuente pixelX

flag_cuenta_en47<= ((not cuenta_pixelX_real(9)) and (not cuenta_pixelX_real(8)) and (not cuenta_pixelX_real(7)) and (not cuenta_pixelX_real(6)) and ( cuenta_pixelX_real(5)) and ( not cuenta_pixelX_real(4)) and ( cuenta_pixelX_real(3)) and ( cuenta_pixelX_real(2)) and ( cuenta_pixelX_real(1)) and ( cuenta_pixelX_real(0)) );

flag_cuenta_en688<= cuenta_pixelX_real(9) and (not cuenta_pixelX_real(8)) and cuenta_pixelX_real(7) and (not cuenta_pixelX_real(6)) and cuenta_pixelX_real(5) and ( cuenta_pixelX_real(4)) and ( not cuenta_pixelX_real(3)) and (not cuenta_pixelX_real(2)) and ( not cuenta_pixelX_real(1)) and ( not cuenta_pixelX_real(0)); --está puesto a propósito 1 ciclo más que el reset del propio contador, asi primero se resetea, luego se inhabilita.

flag_general_toggle<= flag_cuenta_en47 or flag_cuenta_en688;
--A este contador lo va a activar un flag de cuenta en 48 de la cuenta original, y el flag va a perdurar en el tiempo gracias al siguiente fft.
--Vamos a resetear contador con el mismo flag en 688, es lo mejor, y con un retardo de 1clk por ffd. Entonces, primero se inhabilita, luego se resetea.
ffd_auxX: entity work.ffd port map(clk, rst, ena, flag_cuenta_en688 ,rst_propiox );	

fft_conteo_pantallaX: entity work.fft port map(clk, rst, flag_general_toggle,'1' ,cont_aux_ena);

--repetir procedimiento para Y.

rst_graly<= rst or rst_propioy;

--Cuidado, toda la parte Y tiene que moverse con el clock de Y, o sea, pixelYena. Pero su versión sincronizada!!!!

contador_pixel_aux_Y: entity work.contador_pixelY_aux port map(pixelY_ena, (rst_graly) , cont_aux_ena2, cuenta_pixelY,reset_aux2);	--invocamos un contador de ventana sólo para que cuente pixelY

ffd_auxY: entity work.ffd port map(pixelY_ena, rst, ena, flag_cuenta_en513 ,rst_propioy );	

flag_cuenta_en33<= ((not cuenta_pixelY_real(9)) and (not cuenta_pixelY_real(8)) and (not cuenta_pixelY_real(7)) and (not cuenta_pixelY_real(6)) and ( cuenta_pixelY_real(5)) and (not cuenta_pixelY_real(4)) and (not cuenta_pixelY_real(3)) and (not cuenta_pixelY_real(2)) and (not cuenta_pixelY_real(1)) and (  not cuenta_pixelY_real(0)) );

flag_cuenta_en513<= (( cuenta_pixelY_real(9)) and (not cuenta_pixelY_real(8)) and (not cuenta_pixelY_real(7)) and (not cuenta_pixelY_real(6)) and (not cuenta_pixelY_real(5)) and (not cuenta_pixelY_real(4)) and (not cuenta_pixelY_real(3)) and (not cuenta_pixelY_real(2)) and (not cuenta_pixelY_real(1)) and (  cuenta_pixelY_real(0)) ); --Esta en 513, uno más que el reset que lo voy a poner en 512

flag_general_toggle2<= flag_cuenta_en33 or flag_cuenta_en513;
--A este contador lo va a activar un flag de cuenta en 48 de la cuenta original, y el flag va a perdurar en el tiempo gracias al siguiente fft.


fft_conteo_pantallaY: entity work.fft_negado port map(pixelY_ena, rst, flag_general_toggle2 ,'1' ,nada, cont_aux_ena2);

--Lo primero que tiene que hacer este bloque es saber qué digito elegir en el selector.
--Dividimos la pantalla en casillas de 128 x 128 pixeles. Entran 5 casillas horizontales, y 3,75 verticales.
--En binario, se avanza de a 128 mirando en el bit 7 en adelante de un número cualquiera.
--Entonces, con mirar bits 7, 8 y 9 del contador horizontal, por ejemplo, ya podemos saber si estamos en el 1er, 2do, 3er, 4to o 5to cuadrante.
--Empecemos aplicando esta condición al contador de pixel horizontal X


flag_h_1cuadrante<= ((not cuenta_pixelX(9)) and (not cuenta_pixelX(8)) and (not cuenta_pixelX(7))); 	--Este flag se pone en 1 sii los bits 9, 8 y 7 son exactamente 000, lo que significa que uno está en el 1er cuadrante horizontal

flag_h_2cuadrante<=(not cuenta_pixelX(9)) and (not cuenta_pixelX(8)) and cuenta_pixelX(7); 	--Este flag se pone en 1 sii los bits 9, 8 y 7 son exactamente 001, lo que significa que uno está en el 2do cuadrante horizontal

flag_h_3cuadrante<=(not cuenta_pixelX(9)) and ( cuenta_pixelX(8)) and (not cuenta_pixelX(7)); 	--Este flag se pone en 1 sii los bits 9, 8 y 7 son exactamente 010, lo que significa que uno está en el 3er cuadrante horizontal

flag_h_4cuadrante<=(not cuenta_pixelX(9)) and ( cuenta_pixelX(8)) and ( cuenta_pixelX(7)); 	--Este flag se pone en 1 sii los bits 9, 8 y 7 son exactamente 011, lo que significa que uno está en el 4to cuadrante horizontal

flag_h_5cuadrante<=( cuenta_pixelX(9)) and ( not cuenta_pixelX(8)) and ( not cuenta_pixelX(7)); 	--Este flag se pone en 1 sii los bits 9, 8 y 7 son exactamente 100, lo que significa que uno está en el 5to cuadrante horizontal

--Condiciones verticales:


flag_v_1cuadrante<=(not cuenta_pixelY(9)) and (not cuenta_pixelY(8)) and (not cuenta_pixelY(7)); 	--Este flag se pone en 1 sii los bits 9, 8 y 7 son exactamente 000, lo que significa que uno está en el 1er cuadrante vertical

flag_v_2cuadrante<=(not cuenta_pixelY(9)) and (not cuenta_pixelY(8)) and cuenta_pixelY(7); 	--Este flag se pone en 1 sii los bits 9, 8 y 7 son exactamente 001, lo que significa que uno está en el 2do cuadrante vertical

flag_v_3cuadrante<=(not cuenta_pixelY(9)) and ( cuenta_pixelY(8)) and (not cuenta_pixelY(7)); 	--Este flag se pone en 1 sii los bits 9, 8 y 7 son exactamente 010, lo que significa que uno está en el 3er cuadrante vertical

flag_v_4cuadrante<=(not cuenta_pixelY(9)) and ( cuenta_pixelY(8)) and ( cuenta_pixelY(7)); 	--Este flag se pone en 1 sii los bits 9, 8 y 7 son exactamente 011, lo que significa que uno está en el 4to cuadrante vertical

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Flags combinados: si por ejemplo flag_h_1cuadrante y flag_v_1cuadrante están ambos activados, evidentemente estamos en el 1er casillero.

flag_estoy_en_1cuadrante<=flag_h_1cuadrante and flag_v_2cuadrante;
flag_estoy_en_2cuadrante<=flag_h_2cuadrante and flag_v_2cuadrante;			--el cuadrante vertical siempre tiene que ser 2 para estar en el deseado, para mostrar la medición.
flag_estoy_en_3cuadrante<=flag_h_3cuadrante and flag_v_2cuadrante;
flag_estoy_en_4cuadrante<=flag_h_4cuadrante and flag_v_2cuadrante;
flag_estoy_en_5cuadrante<=flag_h_5cuadrante and flag_v_2cuadrante; 

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Pasamos los resultados a "selector" según una sencilla tabla de verdad.

selector(2)<=(  (not flag_estoy_en_1cuadrante) and (not flag_estoy_en_2cuadrante) and (not flag_estoy_en_3cuadrante) and  flag_estoy_en_4cuadrante and (not flag_estoy_en_5cuadrante) ) or ( (not flag_estoy_en_1cuadrante) and (not flag_estoy_en_2cuadrante) and (not flag_estoy_en_3cuadrante) and  (not flag_estoy_en_4cuadrante) and  flag_estoy_en_5cuadrante  )	;					--lo correcto sería ponerle los demás negados , todos en una and gigante, y luego una OR con otro minitermino. Pero solo hay 1 minitermino, y no es necesario poner
selector(1)<=(  (not flag_estoy_en_1cuadrante) and ( flag_estoy_en_2cuadrante) and (not flag_estoy_en_3cuadrante) and  (not flag_estoy_en_4cuadrante) and (not flag_estoy_en_5cuadrante))  or (  (not flag_estoy_en_1cuadrante) and (not flag_estoy_en_2cuadrante) and ( flag_estoy_en_3cuadrante) and  (not flag_estoy_en_4cuadrante) and (not flag_estoy_en_5cuadrante)  );
selector(0)<=(( flag_estoy_en_1cuadrante) and (not flag_estoy_en_2cuadrante) and (not flag_estoy_en_3cuadrante) and  (not flag_estoy_en_4cuadrante) and (not flag_estoy_en_5cuadrante)) or ( (not flag_estoy_en_1cuadrante) and (not flag_estoy_en_2cuadrante) and ( flag_estoy_en_3cuadrante) and  (not flag_estoy_en_4cuadrante) and (not flag_estoy_en_5cuadrante) ) or ((not flag_estoy_en_1cuadrante) and (not flag_estoy_en_2cuadrante) and (not flag_estoy_en_3cuadrante) and  (not flag_estoy_en_4cuadrante) and ( flag_estoy_en_5cuadrante));

--Estos bits del selector se hicieron sumando miniterminos de la tabla de verdad, de cada posibilidad de cada casilla. Pero sólo se tomaron en cuenta algunas posibilidades viables.
--El caso en que ninguna casilla esté activa (todos los flags en cero) ocurre cuando se está barriendo una parte de la pantalla que simplemente tiene que ir en azul. Se le asigno el 000 del selector.
--Se hizo esto porque, si por alguna otra razón todos los flags quedan en cero en alguna parte de la pantallla no considerada, también se pondrá color azul alli

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Sobre el font row y font col: Vamos a tomar los bits 4, 5 y 6 (contando desde 0) de los contadores de pixeles, porque estos avanzan cada 16, dejando inmóvil cada pixelito pensado para 8x8 16 veces en cada pasada, lo cual aumenta el tamaño a 128x128.
font_row(2)<=cuenta_pixelY(6);
font_row(1)<=cuenta_pixelY(5);
font_row(0)<=cuenta_pixelY(4);

font_col(2)<=cuenta_pixelX(6);
font_col(1)<=cuenta_pixelX(5);
font_col(0)<=cuenta_pixelX(4);

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Finalmente, activamos el flag "registro_ena" cuando los 5 flags de cuadrantes de caracteres esten apagados, indicando que el registro puede en ese momento cambiar, que no va a haber error en pantalla.
--No es necesario tratar de retener este valor en un ff, porque va a estar activo un buen tiempo, tal que ocurran varios otros enables del contador de ventana durante este tiempo de registro_ena activo.

registro_ena_VGA<=(not flag_estoy_en_1cuadrante) and (not flag_estoy_en_2cuadrante) and (not flag_estoy_en_3cuadrante) and  (not flag_estoy_en_4cuadrante) and (not flag_estoy_en_5cuadrante);

end;