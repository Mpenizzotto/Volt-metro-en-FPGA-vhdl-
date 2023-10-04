--Registro_completo.vhd
--Este registro queda compuesto por 4 "registros n" de 4 bits c/u, para poder representar en BCD a 3300.
--Se asignan las mismas salidas y entradas de cada registro n con las mismas del registro completo.
--Por lo que no es necesario declarar señales.

library IEEE;
use IEEE.std_logic_1164.all;


entity registro_completo is

	port(
	clk: in std_logic;
	ena: in std_logic;
	rst: in std_logic;
	reg_ena_ventana: in std_logic;				--Estos son los dos enables que conlleva este registro. Uno por el contador ventaana, el otro por el barrido de pantalla de VGA.
	reg_ena_VGA: in std_logic;					--Luego hacen un "and" entre ellos y forman lo que sería el enable del registro.

	BCD_in0: in std_logic_vector(3 downto 0);
	BCD_in1: in std_logic_vector(3 downto 0);
	BCD_in2: in std_logic_vector(3 downto 0);
	BCD_in3: in std_logic_vector(3 downto 0);

	BCD_out0: out std_logic_vector(3 downto 0);
	BCD_out1: out std_logic_vector(3 downto 0);
	BCD_out2: out std_logic_vector(3 downto 0);
	BCD_out3: out std_logic_vector(3 downto 0)
	);
end entity;

architecture registro_completo_arch of registro_completo is

signal reg_ena: std_logic;

begin

reg_ena<=reg_ena_ventana and reg_ena_VGA and ena;
reg_bcd0: entity work.registro_n					
generic map(
	N=>4					 
)						
port map(clk, reg_ena, rst, BCD_in0, BCD_out0);

reg_bcd1: entity work.registro_n					
generic map(
	N=>4
)
port map(clk, reg_ena, rst, BCD_in1, BCD_out1);

reg_bcd2: entity work.registro_n					
generic map(
	N=>4
)
port map(clk, reg_ena, rst, BCD_in2, BCD_out2);

reg_bcd3: entity work.registro_n					
generic map(
	N=>4
)
port map(clk, reg_ena, rst, BCD_in3, BCD_out3);

end;