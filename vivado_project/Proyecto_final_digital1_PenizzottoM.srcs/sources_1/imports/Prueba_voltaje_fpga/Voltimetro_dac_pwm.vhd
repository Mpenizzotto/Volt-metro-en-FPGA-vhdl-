library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity dac_pwm is
	generic(
		N: natural := 8
	);
    port (
        clk     : in std_logic;
        rst     : in std_logic;
        pwm_in  : in std_logic_vector (N-1 downto 0) := (N-1 downto 0 => '0');
        pwm_out : out std_logic
    );
end dac_pwm;

architecture dac_pwm_arq of dac_pwm is
    signal  pwm_accumulator : std_logic_vector(N downto 0);
begin
    process(clk)
    begin
        if rising_edge(clk) then
        	if rst = '1' then
				pwm_accumulator  <= (N downto 0 => '0');
			else
	            pwm_accumulator  <=  std_logic_vector(unsigned('0' & pwm_accumulator(N-1 downto 0)) + unsigned('0' & pwm_in));
	        end if;
        end if;
    end process;

    pwm_out <= pwm_accumulator(N);
end dac_pwm_arq;