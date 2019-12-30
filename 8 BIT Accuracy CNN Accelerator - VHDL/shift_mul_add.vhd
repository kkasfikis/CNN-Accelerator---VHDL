library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;  
--use IEEE.STD_LOGIC_ARITH.ALL;
--use ieee.std_logic_unsigned.all;

entity shift_mul_add is
port(
	--inputs
	clk : in std_logic;
	rst : in std_logic;
	value1 : in std_logic_vector(31 downto 0);
	value2 : in std_logic_vector(31 downto 0);
	activation_request : in std_logic;
	result_acknowledge : in std_logic;
	--outputs
	result : out std_logic_vector(31 downto 0);
	activation_acknowledge : out std_logic;
	result_request : out std_logic
);
end shift_mul_add;

architecture Behavioral of shift_mul_add is
	-----------------------SIGNAL DECLARATION-------------------------------
	type FSM_STATES is (idle_state,working_state,final_state);
	signal myState : FSM_STATES;
	type value_array is array(7 downto 0) of unsigned(15 downto 0);
	signal value1_array :value_array;
	signal value2_array :value_array;
	signal value1_finished : std_logic;
	signal value2_finished : std_logic;
	signal result1_sig : unsigned(31 downto 0);
	signal result2_sig : unsigned(31 downto 0);
	signal sign : std_logic;
	-------------------END OF SIGNAL DECLARATION----------------------------
begin

	process(clk) is
	begin
		if rising_edge(clk) then
			if (rst ='1') then
				for i in 0 to 7 loop
					value1_array(i) <= "0000000000000000";
					value2_array(i) <= "0000000000000000";
				end loop;
				result_request <= '0';
				activation_acknowledge <= '0';
				result1_sig <= "00000000000000000000000000000000";
				result2_sig <= "00000000000000000000000000000000";
				result <= "00000000000000000000000000000000";
				myState <= idle_state;
				value1_finished <='0';
				value2_finished <='0';
			else
				case myState is
					when idle_state => 
						activation_acknowledge <= '0';
						result <= "00000000000000000000000000000000";
						if(activation_request ='1') then
							if(value1(31) = '1' and value2(31)='1') then
								sign <= '0';
							elsif(value1(31)= '0' and value2(31) = '0') then
								sign <= '0';
							else
								sign <= '1';
							end if;
							
							for i in 0 to 7 loop
								if(value1(i)='1') then
									value1_array(i)(7+i downto i) <= unsigned(value2(7 downto 0)); 
									value1_array(i)(15 downto 8+i) <= (others => '0');
									value1_array(i)(i-1 downto 0) <= (others => '0');
								else
									value1_array(i) <= "0000000000000000";
								end if;
								if(value2(i)='1') then
									value2_array(i)(7+i downto i) <= unsigned(value1(7 downto 0));
									value2_array(i)(15 downto 8+i) <= (others => '0');
									value2_array(i)(i-1 downto 0) <= (others => '0');
								else
									value2_array(i) <= "0000000000000000";
								end if;
							end loop;
							myState <= working_state;
						end if;
					when working_state =>
						if(value1_finished='0' and value2_finished='0') then
							result <= "00000000000000000000000000000000";
							if(value1_array(0) /= "0000000000000000") then
								value1_array(0) <= "0000000000000000";
								result1_sig <= result1_sig + resize(value1_array(0),32);
							elsif (value1_array(1) /= "0000000000000000") then
								value1_array(1) <= "0000000000000000";
								result1_sig <= result1_sig + resize(value1_array(1),32);
							elsif (value1_array(2) /= "0000000000000000") then
								value1_array(2) <= "0000000000000000";
								result1_sig <= result1_sig + resize(value1_array(2),32);
							elsif (value1_array(3) /= "0000000000000000") then
								value1_array(3) <= "0000000000000000";
								result1_sig <= result1_sig + resize(value1_array(3),32);
							elsif (value1_array(4) /= "0000000000000000") then
								value1_array(4) <= "0000000000000000";
								result1_sig <= result1_sig + resize(value1_array(4),32);
							elsif (value1_array(5) /= "0000000000000000") then
								value1_array(5) <= "0000000000000000";
								result1_sig <= result1_sig + resize(value1_array(5),32);
							elsif (value1_array(6) /= "0000000000000000") then
								value1_array(6) <= "0000000000000000";
								result1_sig <= result1_sig + resize(value1_array(6),32);
							elsif (value1_array(7) /= "0000000000000000") then
								value1_array(7) <= "0000000000000000";
								result1_sig <= result1_sig + resize(value1_array(7),32);
							else
								value1_finished <= '1';
								result <= sign & std_logic_vector(result1_sig(30 downto 0));
								myState <= final_state;
								result_request <='1';
							end if;
							
							if(value2_array(0) /= "0000000000000000") then
								value2_array(0) <= "0000000000000000";
								result2_sig <= result2_sig + resize(value2_array(0),32);
							elsif (value2_array(1) /= "0000000000000000") then
								value2_array(1) <= "0000000000000000";
								result2_sig <= result2_sig + resize(value2_array(1),32);
							elsif (value2_array(2) /= "0000000000000000") then
								value2_array(2) <= "0000000000000000";
								result2_sig <= result2_sig + resize(value2_array(2),32);
							elsif (value2_array(3) /= "0000000000000000") then
								value2_array(3) <= "0000000000000000";
								result2_sig <= result2_sig + resize(value2_array(3),32);
							elsif (value2_array(4) /= "0000000000000000") then
								value2_array(4) <= "0000000000000000";
								result2_sig <= result2_sig + resize(value2_array(4),32);
							elsif (value2_array(5) /= "0000000000000000") then
								value2_array(5) <= "0000000000000000";
								result2_sig <= result2_sig + resize(value2_array(5),32);
							elsif (value2_array(6) /= "0000000000000000") then
								value2_array(6) <= "0000000000000000";
								result2_sig <= result2_sig + resize(value2_array(6),32);
							elsif (value2_array(7) /= "0000000000000000") then
								value2_array(7) <= "0000000000000000";
								result2_sig <= result2_sig + resize(value2_array(7),32);
							else
								value2_finished <= '1';
								result <= sign & std_logic_vector(result2_sig(30 downto 0));
								myState <= final_state;
								result_request <='1';
							end if;
						else
							myState <= final_state;
						end if;
					when final_state =>	
						if (result_acknowledge ='1') then
							result1_sig <= "00000000000000000000000000000000";
							result2_sig <= "00000000000000000000000000000000";
							activation_acknowledge <= '1';
							result_request <= '0';
							myState <= idle_state;
							value1_finished <='0';
							value2_finished <='0';
						end if;
				end case;
			end if;
		end if;
	end process;
end Behavioral;

