----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

----------------------------------------------------------------------------------

entity SEG is
Port (

		-- Buttons --
		BUTTON: in STD_LOGIC_VECTOR(7 downto 0);
		
		-- 8Seg --
		LEDOut:		 out STD_LOGIC_VECTOR(7 DOWNTO 0);
		DigitSelect: out STD_LOGIC_VECTOR(3 DOWNTO 0)
		
	);
end SEG;

architecture Behavioral of SEG is
	signal LED:	STD_LOGIC_VECTOR(3 downto 0);	-- To encode 8 seg
	signal Count: integer := 0;					-- For password
	constant D1: STD_LOGIC_VECTOR(3 downto 0) := "0001";				-- For DigitSelect
	constant D2: STD_LOGIC_VECTOR(3 downto 0) := "0010";				-- For DigitSelect
	constant D3: STD_LOGIC_VECTOR(3 downto 0) := "0100";				-- For DigitSelect
	constant D4: STD_LOGIC_VECTOR(3 downto 0) := "1000";				-- For DigitSelect
begin

	process(LED)   
	begin
		case LED is
			when "0000"=>LEDOut	<= "11000000";    --'0'		
			when "0001"=>LEDOut	<= "11111001";    --'1'		
			when "0010"=>LEDOut	<= "10100100";    --'2'		
			when "0011"=>LEDOut	<= "10110000";    --'3'		
			when "0100"=>LEDOut	<= "10011001";    --'4'			Encoder 
			when "0101"=>LEDOut	<= "10010010";    --'5'		
			when "0110"=>LEDOut	<= "10000010";    --'6'			  --- 
			when "0111"=>LEDOut	<= "11111000";    --'7'		  5 |   | 1		
			when "1000"=>LEDOut	<= "10000000";    --'8'		     --- <------6
			when "1001"=>LEDOut	<= "10010000";    --'9'		  4 |   | 2
			when "1010"=>LEDOut	<= "10001000";    --'A'		     --- 
			when "1011"=>LEDOut	<= "10000011";    --'b'		      3
			when "1100"=>LEDOut	<= "11000110";    --'C'
			when "1101"=>LEDOut	<= "10100001";    --'d'
			when "1110"=>LEDOut	<= "10000110";    --'E'
			when "1111"=>LEDOut	<= "10001110";    --'F'
			when others=>LEDOut	<= "XXXXXXXX";    --' '
		end case;	
	end process;
	
	process(BUTTON, Count)
	begin
						-- Password --
			if (BUTTON = "11111110") then			-- First number
				if (Count = 0) then
					Count <= 1;
				end if;
			
			elsif (BUTTON = "11111101") then		-- Second number
				if (Count = 1) then
					Count <= 2;
				end if;

			elsif (BUTTON = "11111011") then		-- Third number
				if (Count = 2) then
					Count <= 3;
				end if;

			elsif (BUTTON = "11110111") then		-- Last number
				if (Count = 3) then
					Count <= 4;
				end if;
				
			elsif (BUTTON = "11101111") or (BUTTON = "11011111") or (BUTTON = "10111111") or (BUTTON = "01111111") then
				if (Count > 0) then
					Count <= 0;
				end if;
			
			end if;
			
	end process;
		
	process(Count)
	begin
				-- Display If Good Number --
		case Count is
			when 0 => 
				DigitSelect <= "1111";
				LED <= "0000";
			when 1 => 
				DigitSelect <= D4;
				LED <= "0001";
			when 2 =>
				DigitSelect <= D3;
				LED <= "0010";
			when 3 =>
				DigitSelect <= D2;
				LED <= "0011";	
			when 4 =>
				DigitSelect <= D1;
				LED <= "0100";
			when others =>
				DigitSelect <= "1111";
				LED <= "0000";
			end case;
	end process;
end Behavioral;