--Contador_BCD_completo.vhd

--Contador BCD completo. Va a usar 4 contadores BCD comunes, con una lógica para que uno vaya habilitando al otro.
--La señal o nodo donde están los 1's a contar se debe conectar al enable de este super contador.

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;



entity cont_BCD_completo is
port (
    clk: in std_logic;
    rst_gral: in std_logic;    					--Este es el reset de todo el sistema
    rst_window: in std_logic;    				--Por esta entrada el contador de ventana puede resetear a este contador BCD.
    ena: in std_logic;  
    BCD_out0: out std_logic_vector(3 downto 0); --en estas 4 salidas ponemos los 4 dígitos BCD por separado .Esto es lo que pasa al registro despues de todo.--
    BCD_out1: out std_logic_vector(3 downto 0);
    BCD_out2: out std_logic_vector(3 downto 0);
    BCD_out3: out std_logic_vector(3 downto 0);		
    flag: out std_logic   );
end entity;

architecture cont_BCD_completo_arch of cont_BCD_completo is

signal y0 :std_logic_vector(3 downto 0):="0000";			--Salidas para cada dígito BCD
signal y1 :std_logic_vector(3 downto 0):="0000";			
signal y2 :std_logic_vector(3 downto 0):="0000";		
signal y3 :std_logic_vector(3 downto 0):="0000";			--Esos valores 0000 que se ponen ahi corresponden por nomenclatura de lenguaje a valores iniciales.

signal flag0 :std_logic;
signal flag1 :std_logic;						
signal flag2 :std_logic;
signal flag3 :std_logic;

signal ena0 :std_logic;
signal ena1 :std_logic;
signal ena2 :std_logic;
signal ena3 :std_logic;

signal rst_comun :std_logic;



begin

	bcd0: entity work.cont_BCD port map(clk, rst_comun, ena0, y0, flag0);
	bcd1: entity work.cont_BCD port map(clk, rst_comun, ena1, y1, flag1);
	bcd2: entity work.cont_BCD port map(clk, rst_comun, ena2, y2, flag2);
	bcd3: entity work.cont_BCD port map(clk, rst_comun, ena3, y3, flag3);

ena0<=ena;								--El primer enable tiene que ser el general.
rst_comun<=rst_gral or rst_window;		--Ambos tipos de resets logran resetear los contadores BCD individuales.
										-- Se separan asi porque si se unen, el reset general quedaría conectado por hardware al reset de max cuenta de 3300.
										--Eso resetearía todo el sistema cuando la cuenta llegue a 3300 y no tiene que ser así.
	
--acá va la lógica que hace que un contador habilite al otro cuando llega  a la cuenta máxima.Dicha lógica me la facilitó Nico en la hoja que me dió. 
ena0<=ena;
ena1<= ena0 and flag0;
ena2<= ena1 and flag1;
ena3<= ena2 and flag2;

--Finalmente, pasamos las salidas de los contadores BCD por separado a la salida final:

BCD_out0<=y0;
BCD_out1<=y1;
BCD_out2<=y2;
BCD_out3<=y3;

end;