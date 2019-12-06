library ieee; 
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library lpm;
use lpm.lpm_components.all;

entity hex_display is
	port(
		clk : in std_logic;
		a : in std_logic_vector(15 downto 0);
		hex_out : out std_logic_vector(6 downto 0);
		hex_ctrl : out std_logic_vector(3 downto 0);
		hex_dot : out std_logic;
		hex_pt : out std_logic
	);
end entity;

architecture hexadecimal of hex_display is
	procedure hex_map (
		signal input : in std_logic_vector(3 downto 0);
		signal output : out std_logic_vector(6 downto 0) ) is
	begin
		case input is
			when "0000" => output <= "0111111"; -- "0"     
			when "0001" => output <= "0000110"; -- "1" 
			when "0010" => output <= "1011011"; -- "2" 
			when "0011" => output <= "1001111"; -- "3" 
			when "0100" => output <= "1100110"; -- "4" 
			when "0101" => output <= "1101101"; -- "5" 
			when "0110" => output <= "1111101"; -- "6" 
			when "0111" => output <= "0000111"; -- "7" 
			when "1000" => output <= "1111111"; -- "8"     
			when "1001" => output <= "1101111"; -- "9" 
			when "1010" => output <= "1110111"; -- a
			when "1011" => output <= "1111100"; -- b
			when "1100" => output <= "0111001"; -- C
			when "1101" => output <= "1011110"; -- d
			when "1110" => output <= "1111001"; -- E
			when "1111" => output <= "1110001"; -- F
		end case;
	end procedure;
	signal not_hex_out : std_logic_vector(6 downto 0);
begin
	
	hex_pt <= '1';
	hex_dot <= '1';
	
	HEX_PROC : process(clk, a)
		variable count : integer range 0 to 3 := 0;
	begin
		if rising_edge(clk) then
			hex_out <= (others => '0');
			case count is
				when 0 =>
					hex_map (input => a(3 downto 0), output => not_hex_out);
					count := count + 1;
					hex_ctrl <= "0001";
				when 1 =>
					hex_map (input => a(7 downto 4), output => not_hex_out);
					count := count + 1;
					hex_ctrl <= "1000";
				when 2 =>
					hex_map (input => a(11 downto 8), output => not_hex_out);
					count := count + 1;
					hex_ctrl <= "0100";
				when 3 =>
					hex_map (input => a(15 downto 12), output => not_hex_out);
					count := 0;
					hex_ctrl <= "0010";
			end case;
			hex_out <= NOT not_hex_out;
		end if;
	end process;
end architecture;

architecture decimal of hex_display is
	procedure hex_map (
		variable input : in std_logic_vector(3 downto 0);
		signal output : out std_logic_vector(6 downto 0) ) is
	begin
		case input is
			when "0000" => output <= "0111111"; -- "0"     
			when "0001" => output <= "0000110"; -- "1" 
			when "0010" => output <= "1011011"; -- "2" 
			when "0011" => output <= "1001111"; -- "3" 
			when "0100" => output <= "1100110"; -- "4" 
			when "0101" => output <= "1101101"; -- "5" 
			when "0110" => output <= "1111101"; -- "6" 
			when "0111" => output <= "0000111"; -- "7" 
			when "1000" => output <= "1111111"; -- "8"     
			when "1001" => output <= "1101111"; -- "9" 
			when "1010" => output <= "1110111"; -- a
			when "1011" => output <= "1111100"; -- b
			when "1100" => output <= "0111001"; -- C
			when "1101" => output <= "1011110"; -- d
			when "1110" => output <= "1111001"; -- E
			when "1111" => output <= "1110001"; -- F
		end case;
	end procedure;
	signal not_hex_out : std_logic_vector(6 downto 0);
begin
	
	hex_pt <= '1';
	hex_dot <= '1';
	
	HEX_PROC : process(clk, a)
		variable count : integer range 0 to 3 := 0;
		variable a_int : integer range 0 to 9999;
		variable thou, hund, tens, ones : integer range 0 to 9;
		variable thou_vec, hund_vec, tens_vec, ones_vec : std_logic_vector(3 downto 0);
	begin
		if rising_edge(clk) then
			
			a_int := to_integer(unsigned(a));
			thou := ((a_int mod 10000) - (a_int mod 1000))/1000;
			hund := ((a_int mod 1000) - (a_int mod 100))/100;
			tens := ((a_int mod 100) - (a_int mod 10))/10;
			ones := ((a_int mod 10) - (a_int mod 1))/1;
			
			thou_vec := std_logic_vector(to_unsigned(thou, 4));
			hund_vec := std_logic_vector(to_unsigned(hund, 4));
			tens_vec := std_logic_vector(to_unsigned(tens, 4));
			ones_vec := std_logic_vector(to_unsigned(ones, 4));
			
			hex_out <= (others => '0');
			case count is
				when 0 =>
					hex_map (input => ones_vec, output => not_hex_out);
					count := count + 1;
					hex_ctrl <= "0001";
				when 1 =>
					hex_map (input => tens_vec, output => not_hex_out);
					count := count + 1;
					hex_ctrl <= "1000";
				when 2 =>
					hex_map (input => hund_vec, output => not_hex_out);
					count := count + 1;
					hex_ctrl <= "0100";
				when 3 =>
					hex_map (input => thou_vec, output => not_hex_out);
					count := 0;
					hex_ctrl <= "0010";
			end case;
			hex_out <= NOT not_hex_out;
		end if;
	end process;
end architecture;