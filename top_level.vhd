library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library lpm;
use lpm.lpm_components.all;

entity top_level is
	port(
		clk_50mhz : in std_logic;
		hex_out : out std_logic_vector(6 downto 0);
		hex_ctrl : out std_logic_vector(3 downto 0);
		hex_dot : out std_logic;
		hex_pt : out std_logic
	);
end entity;

architecture dataflow of top_level is
	component hex_display is
		port(
			clk : in std_logic;
			a : in std_logic_vector(15 downto 0);
			hex_out : out std_logic_vector(6 downto 0);
			hex_ctrl : out std_logic_vector(3 downto 0);
			hex_dot : out std_logic;
			hex_pt : out std_logic
		);
	end component;
	for DISPLAY: hex_display use entity work.hex_display(decimal);
	signal a : std_logic_vector(15 downto 0) := X"0000";
	signal clk2, clk3 : std_logic;
begin
	
	CLK_DELAY_1: lpm_counter generic map(lpm_width=>12) --22
		port map(clock => clk_50mhz, cout => clk2);
	
	CLK_DELAY_2: lpm_counter generic map(lpm_width=>22) --22
		port map(clock => clk_50mhz, cout => clk3);
	
	TEXT_PROC: process(clk3)
		variable count : integer range 0 to 9999;
	begin
		if rising_edge(clk3) then
			a <= std_logic_vector(to_unsigned(count, 16));
			count := count + 1;
			if(count = 9999) then
				count := 0;
			end if;
		end if;
	end process;
	
	DISPLAY : hex_display
	port map(
		clk => clk2,
		a => a,
		hex_out => hex_out,
		hex_ctrl => hex_ctrl,
		hex_dot => hex_dot,
		hex_pt => hex_pt
	);

end architecture;