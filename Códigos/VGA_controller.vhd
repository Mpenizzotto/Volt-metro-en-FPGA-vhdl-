--VGA_controller.vhd
--Bloque que se encarga de generar las señales de video, así como también de llevar la cuenta de pixeles X e Y.
library IEEE;
use IEEE.std_logic_1164.all;

entity VGA_controller is

port(
	clk: in std_logic;
	rst: in std_logic;	
	ena: in std_logic;
	
	red_i :in std_logic;
	green_i :in std_logic;
	blue_i :in std_logic;

	hsync :out std_logic;
	vsync :out std_logic;

	red_o :out std_logic;
	green_o :out std_logic;
	blue_o :out std_logic;

	cuenta_pixelX: out std_logic_vector (9 downto 0);
	cuenta_pixelY: out std_logic_vector (9 downto 0);
	
	h_vidon :buffer std_logic;				--estas no van al monitor, sino que son para testeo en testbench nomas.
	v_vidon :buffer std_logic;
	 pixelY_ena_sync_o :out std_logic

	);
end;

architecture VGA_controller_arch of VGA_controller is

signal pixelY_ena :std_logic; 
signal vid_on_completo :std_logic; 
signal pixelY_ena_sync :std_logic; 
signal pixelY_ena_sync2 :std_logic;


begin

--comienzo invocando a los generadores de señal y de cuenta X e Y

generador_sync_horizontal: entity work.generador_sync_horizontal port map(clk, rst, ena, pixelY_ena, cuenta_pixelX, hsync, h_vidon );

ffd_sync: entity work.ffd port map(clk, rst, ena, pixelY_ena ,pixelY_ena_sync );		--este ffd es para sincronizar "pixelYena" para que actúe de clock para la parte vertical.
ffd_sync2: entity work.ffd port map(clk, rst, ena, pixelY_ena_sync ,pixelY_ena_sync2 );	-- Usamos 2, porque en simulacion la parte vertical estaba 1 clock adelantada.

generador_sync_vertical: entity work.generador_sync_vertical port map(pixelY_ena_sync2, rst, ena, cuenta_pixelY, vsync, v_vidon );		--el clock de la parte verical es "pixelYena" pero sincronizado.
												
--Armo vid_on_completo

vid_on_completo<=h_vidon and v_vidon;

--saco los colores a la salida a partir de aplicar la condición a los de la entrada

red_o<= red_i and vid_on_completo;
green_o<= green_i and vid_on_completo;
blue_o<= blue_i and vid_on_completo;

pixelY_ena_sync_o<=pixelY_ena_sync;
end;