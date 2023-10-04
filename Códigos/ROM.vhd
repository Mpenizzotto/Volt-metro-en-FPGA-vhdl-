--ROM.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ROM_caracteres is
   
     port(
         --clk: in std_logic;
         char_address: in std_logic_vector(3 downto 0);			--los 4 bits de salida del MUX según se quiera gaficar 1er digito, 2do digito, etc.
         font_row, font_col: in std_logic_vector(2 downto 0);	--3 bits de fila, y 3 de columna. Ambos cubren del 0 al 7 para graficar según fila y columna que se esté en el momento.
         rom_out: out std_logic					-- salida de la ROM.
     );
end; 

architecture ROM_caracteres_arch of ROM_caracteres is
    type rom_type is array (0 to 127) of std_logic_vector(7 downto 0);	--Necesito 2^4 caracteres distintos (16), multiplicado por 8, porque necesito 8 vectores por caracter.
										-- Finalmente, la cantidad dicha anteriormente, 2^4 , multiplicar por 8,para que sean vecotres de 8 bits c/u
    signal char_address_aux: std_logic_vector(6 downto 0);

    --definicion
    constant memoria_ROM: rom_type:=(

-- "0"
	"00000000",
	"00011000",
	"00100100",
	"00101100",
	"00110100",
	"00100100",
	"00011000",
	"00000000",

-----------------------------------------------------
-- "1"
	"00000000",
	"00001000",
	"00001100",
	"00001000",
	"00001000",
	"00001000",
	"00011100",
	"00000000",

-----------------------------------------------------
--"2"
	"00000000",
	"00011000",
	"00100100",
	"00100000",
	"00010000",
	"00001000",
	"00111100",
	"00000000",

-----------------------------------------------------
--"3"
	"00000000",
	"00011000",
	"00100100",
	"00010000",
	"00100000",
	"00100100",
	"00011000",
	"00000000",

-----------------------------------------------------
--"4"
	"00000000",
	"00110000",
	"00101000",
	"00100100",
	"00111100",
	"00100000",
	"00100000",
	"00000000",

-----------------------------------------------------
--"5"
	"00000000",
	"00111100",
	"00000100",
	"00011100",
	"00100000",
	"00100000",
	"00011000",
	"00000000",

-----------------------------------------------------
--"6"
	"00000000",
	"00011000",
	"00000100",
	"00011100",
	"00100100",
	"00100100",
	"00011000",
	"00000000",

-----------------------------------------------------
--"7"
	"00000000",
	"00111100",
	"00100000",
	"00010000",
	"00001000",
	"00000100",
	"00000100",
	"00000000",

-----------------------------------------------------
--"8"
	"00000000",
	"00011000",
	"00100100",
	"00011000",
	"00100100",
	"00100100",
	"00011000",
	"00000000",

-----------------------------------------------------
--"9"
	"00000000",
	"00011000",
	"00100100",
	"00111000",
	"00100000",
	"00100000",
	"00011000",
	"00000000",

-----------------------------------------------------
--"."
	"00000000",	--Para que esto funcione a la salida del MUX, la entrada dedicada al caracter "punto" del mismo MUX tiene que tener el número siguiente a 9 en BCD, 	pero en binario. Es decir, 1010
	"00000000",
	"00000000",
	"00000000",
	"00000000",
	"00011000",
	"00011000",
	"00000000",

-----------------------------------------------------
--"V"
	"00000000",		--Para que esto funcione a la salida del MUX, la entrada dedicada al punto del mismo MUX tiene que tener dos números más que el 9 en BCD, pero en binario. Es decir, 1011
	"00100010",
	"00100010",
	"00100010",
	"00100010",
	"00010100",
	"00001000",
	"00000000",
-----------------------------------------------------
--Vacio
	"00000000",	--Para que esto funcione a la salida del MUX, la entrada dedicada al punto del mismo MUX tiene que tener tres números más que el 9 en BCD, pero en binario. Es decir, 1100
	"00000000",
	"00000000",
	"00000000",
	"00000000",
	"00000000",
	"00000000",
	"00000000",
-----------------------------------------------------
	"00000000",
	"00000000",
	"00000000",
	"00000000",
	"00000000",
	"00000000",
	"00000000",
	"00000000",
-----------------------------------------------------	
	"00000000",
	"00000000",
	"00000000",
	"00000000",
	"00000000",
	"00000000",
	"00000000",
	"00000000",
-----------------------------------------------------	
	"00000000",
	"00000000",
	"00000000",
	"00000000",
	"00000000",
	"00000000",
	"00000000",
	"00000000"
	);
	
begin
     char_address_aux <= char_address & font_row;	--al hacer esto me queda el número de fila bien escrito, es decir, respecto a un cero establecido al principio de la memoria.
     rom_out <= memoria_ROM(to_integer(unsigned(char_address_aux)))(to_integer(unsigned(font_col)));		--grafico digitos desde arriba hacia abajo
--Es necesario aclarar que no se busca la info del dígito a partir de los primeros 4 bits del caracter que viene del MuX, usandolo como direccion
--Lo que se hace en realidad es tomar el dígito BCD y concatenarle el valor de la fila, de 3 bits. De esta manera, el dígito BCD queda en el 3 bit en adelante (contando desde cero), de manera que
--este BCD allí colocado va sumando de a 8 unidades. Así, logra selecciónar correctamente el vector de datos a tomar, para que luego el selector de columna termine de seleccionar bien el bit a mandar.
end ;