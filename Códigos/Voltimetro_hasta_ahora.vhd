--Voltimetro_hasta_ahora.vhd
--Este es el archivo que junta todos mis módulos. No es el top level igualmente.
library IEEE;
use IEEE.std_logic_1164.all;


entity Voltimetro_hasta_ahora is
port(
	clk: in std_logic;									--clk, rst y ena generales.
	rst: in std_logic;
	ent_unos :in std_logic;				--aka "data_volt_in_i"entrada de unos en el ffd externo.
	sal_unos  :out std_logic;			--salida para la realim, aka data_volt_out_o.
	hsync :buffer std_logic;
	vsync :buffer std_logic;			--salidas pertenecientes al VGA controller, las sacamos para monitoreo nomas.
	red_out :out std_logic;
	grn_out :out std_logic;				--sacamos las salidas de colores para testearlas.
	blu_out :out std_logic
	

	);
	
end;

architecture Voltimetro_hasta_ahora_arch of Voltimetro_hasta_ahora is



signal entrada_caracter_vacio: std_logic_vector(3 downto 0):="1100";		--la dir el caracter vacio, según ROM, es 1100		
signal entrada_caracter_punto: std_logic_vector(3 downto 0):="1010";		--la dir el caracter punto, según ROM, es 1010
signal entrada_caracter_volt: std_logic_vector(3 downto 0):="1011";		--la dir el caracter volt, según ROM, es 1011

signal entrada_aux1:std_logic_vector(3 downto 0):=(others => '0');		--entradas auxiliares para completar con algo las entradas del mux no usadas
signal entrada_aux2: std_logic_vector(3 downto 0):=(others => '0');		--entradas auxiliares para completar con algo las entradas del mux no usadas
signal h_vidon : std_logic;
signal v_vidon : std_logic;



signal salida_cont_binario_prueba: std_logic_vector(11 downto 0):= (others => '0');
signal out_mux: std_logic_vector(3 downto 0);		--Salida del mux sacada desde el voltímetro hasta ahora

signal bcd0 :std_logic_vector(3 downto 0);		--sirven de salida del contador BCD, como también de entrada de registro completo.
signal bcd1 :std_logic_vector(3 downto 0);
signal bcd2 :std_logic_vector(3 downto 0);
signal bcd3 :std_logic_vector(3 downto 0); 

--signal salida_cont_binario: std_logic_vector(11 downto 0);

signal reg_ena_ventana: std_logic;			--Los enables que lleva el registro completo.
signal reg_ena_VGA: std_logic;
signal bcd_rst: std_logic;				--y el reset que le manda al contador de 1's BCD


signal bcd0_outr :std_logic_vector(3 downto 0);		--Se usan para la salida del registro completo
signal bcd1_outr :std_logic_vector(3 downto 0);
signal bcd2_outr :std_logic_vector(3 downto 0);
signal bcd3_outr :std_logic_vector(3 downto 0);

signal font_col :std_logic_vector(2 downto 0);		--Señales auxiliares para la ROM y Logica
signal font_row :std_logic_vector(2 downto 0);		--Señales auxiliares para la ROM y Logica
signal rom_out :std_logic;

signal cuenta_pixelX :std_logic_vector(9 downto 0);		--Señales auxiliares para Logica y VGA
signal cuenta_pixelY :std_logic_vector(9 downto 0);		--Señales auxiliares para Logica y VGA

signal pixelY_ena :std_logic; 				

signal selector: std_logic_vector (2 downto 0);		--los cables del selector para interconectar logica y MUX.
signal blu_i :std_logic :=('1');					--Representa el fondo azul

signal enable_BCD :std_logic;				--es la salida Q del ffd externo, que se conecta al enable del contador BCD para que el mismo cuente.

signal ena :std_logic :=('1');				--El top_level de Nico no tien enable, así que fijo mi enable a 1.

begin

ffd_externo: entity work.ffd_negado port map(clk, rst, ena, ent_unos,enable_BCD, sal_unos);

contador_BCD_completo: entity work.cont_BCD_completo port map(clk, rst, bcd_rst, enable_BCD, bcd0,bcd1,bcd2,bcd3);

contador1_ventana: entity work.contador1_ventana port map(clk, rst, ena, salida_cont_binario_prueba,reg_ena_ventana,bcd_rst);

registro_completo: entity work.registro_completo port map(clk, ena, rst, reg_ena_ventana, reg_ena_VGA, bcd0, bcd1, bcd2, bcd3, bcd0_outr, bcd1_outr, bcd2_outr, bcd3_outr);

mux8a1: entity work.mux_8a1_datawidth4 port map(entrada_caracter_vacio, bcd3_outr, entrada_caracter_punto, bcd2_outr,bcd1_outr, entrada_caracter_volt, entrada_aux1, entrada_aux2,selector, out_mux); 

ROM: entity work.ROM_caracteres port map(out_mux, font_row, font_col, rom_out);

logica: entity work.logica port map(pixelY_ena, clk, rst, ena, cuenta_pixelX, cuenta_pixelY, font_row, font_col, selector, reg_ena_VGA);

VGA: entity work.VGA_controller port map(clk, rst, ena, rom_out, rom_out, blu_i, hsync, vsync,red_out, grn_out, blu_out, cuenta_pixelX, cuenta_pixelY, h_vidon, v_vidon, pixelY_ena);


end;


