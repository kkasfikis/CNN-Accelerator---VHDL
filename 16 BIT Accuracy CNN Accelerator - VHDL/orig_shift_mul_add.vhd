library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use ieee.std_logic_unsigned.all;

entity orig_shift_mul_add is
port(
	--inputs
	clk : in std_logic;
	rst : in std_logic;
	result_fromIndex : in integer;
	result_toIndex : in integer;
	value1 : in std_logic_vector(31 downto 0);
	value2 : in std_logic_vector(31 downto 0);
	activation_request : in std_logic;
	result_acknowledge : in std_logic;
	--outputs
	overflow : out std_logic;
	underanked : out std_logic;
	result : out std_logic_vector(31 downto 0);
	activation_acknowledge : out std_logic;
	result_request : out std_logic
);
end orig_shift_mul_add;

architecture Behavioral of orig_shift_mul_add is
	-----------------------SIGNAL DECLARATION-------------------------------
	type FSM_STATES is (idle_state,working_state,final_state);
	signal myState : FSM_STATES;
	type value_array is array(31 downto 0) of std_logic_vector(63 downto 0);
	signal value1_array :value_array;
	signal value2_array :value_array;
	signal value1_finished : std_logic;
	signal value2_finished : std_logic;
	signal result1_sig : std_logic_vector(63 downto 0);
	signal result2_sig : std_logic_vector(63 downto 0);
	-------------------END OF SIGNAL DECLARATION----------------------------
begin

	process(clk) is
	begin
		if rising_edge(clk) then
			if (rst ='1') then
				for i in 0 to 31 loop
					value1_array(i) <= "0000000000000000000000000000000000000000000000000000000000000000";
					value2_array(i) <= "0000000000000000000000000000000000000000000000000000000000000000";
				end loop;
				overflow <= '0';
				underanked <= '0';
				result_request <= '0';
				activation_acknowledge <= '0';
				result1_sig <= "0000000000000000000000000000000000000000000000000000000000000000";
				result2_sig <= "0000000000000000000000000000000000000000000000000000000000000000";
				result <= "00000000000000000000000000000000";
				myState <= idle_state;
				value1_finished <='0';
				value2_finished <='0';
			else
				case myState is
					when idle_state => 
						activation_acknowledge <= '0';
						result <= "00000000000000000000000000000000";
						overflow <= '0';
						underanked <= '0';
						if(activation_request ='1') then
							for i in 0 to 31 loop
								if(value1(i)='1') then
									value1_array(i)(31+i downto i) <= value2; 
									value1_array(i)(63 downto 32+i) <= (others => '0');
									value1_array(i)(i-1 downto 0) <= (others => '0');
								else
									value1_array(i) <= "0000000000000000000000000000000000000000000000000000000000000000";
								end if;
								if(value2(i)='1') then
									value2_array(i)(31+i downto i) <= value1(31 downto 0);
									value2_array(i)(63 downto 32+i) <= (others => '0');
									value2_array(i)(i-1 downto 0) <= (others => '0');
								else
									value2_array(i) <= "0000000000000000000000000000000000000000000000000000000000000000";
								end if;
							end loop;
							myState <= working_state;
						end if;
					when working_state =>
						if(value1_finished='0' and value2_finished='0') then
							result <= "00000000000000000000000000000000";
							if(value1_array(0) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value1_array(0) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result1_sig <= std_logic_vector(unsigned(result1_sig)) + std_logic_vector(unsigned(value1_array(0)));
							elsif (value1_array(1) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value1_array(1) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result1_sig <= std_logic_vector(unsigned(result1_sig)) + std_logic_vector(unsigned(value1_array(1)));
							elsif (value1_array(2) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value1_array(2) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result1_sig <= std_logic_vector(unsigned(result1_sig)) + std_logic_vector(unsigned(value1_array(2)));
							elsif (value1_array(3) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value1_array(3) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result1_sig <= std_logic_vector(unsigned(result1_sig)) + std_logic_vector(unsigned(value1_array(3)));
							elsif (value1_array(4) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value1_array(4) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result1_sig <= std_logic_vector(unsigned(result1_sig)) + std_logic_vector(unsigned(value1_array(4)));
							elsif (value1_array(5) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value1_array(5) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result1_sig <= std_logic_vector(unsigned(result1_sig)) + std_logic_vector(unsigned(value1_array(5)));
							elsif (value1_array(6) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value1_array(6) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result1_sig <= std_logic_vector(unsigned(result1_sig)) + std_logic_vector(unsigned(value1_array(6)));
							elsif (value1_array(7) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value1_array(7) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result1_sig <= std_logic_vector(unsigned(result1_sig)) + std_logic_vector(unsigned(value1_array(7)));
							elsif (value1_array(8) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value1_array(8) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result1_sig <= std_logic_vector(unsigned(result1_sig)) + std_logic_vector(unsigned(value1_array(8)));
							elsif (value1_array(9) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value1_array(9) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result1_sig <= std_logic_vector(unsigned(result1_sig)) + std_logic_vector(unsigned(value1_array(9)));
							elsif (value1_array(10) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value1_array(10) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result1_sig <= std_logic_vector(unsigned(result1_sig)) + std_logic_vector(unsigned(value1_array(10)));
							elsif (value1_array(11) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value1_array(11) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result1_sig <= std_logic_vector(unsigned(result1_sig)) + std_logic_vector(unsigned(value1_array(11)));
							elsif (value1_array(12) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value1_array(12) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result1_sig <= std_logic_vector(unsigned(result1_sig)) + std_logic_vector(unsigned(value1_array(12)));
							elsif (value1_array(13) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value1_array(13) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result1_sig <= std_logic_vector(unsigned(result1_sig)) + std_logic_vector(unsigned(value1_array(13)));
							elsif (value1_array(14) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value1_array(14) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result1_sig <= std_logic_vector(unsigned(result1_sig)) + std_logic_vector(unsigned(value1_array(14)));
							elsif (value1_array(15) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value1_array(15) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result1_sig <= std_logic_vector(unsigned(result1_sig)) + std_logic_vector(unsigned(value1_array(15)));
							elsif (value1_array(16) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value1_array(16) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result1_sig <= std_logic_vector(unsigned(result1_sig)) + std_logic_vector(unsigned(value1_array(16)));
							elsif (value1_array(17) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value1_array(17) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result1_sig <= std_logic_vector(unsigned(result1_sig)) + std_logic_vector(unsigned(value1_array(17)));
							elsif (value1_array(18) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value1_array(18) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result1_sig <= std_logic_vector(unsigned(result1_sig)) + std_logic_vector(unsigned(value1_array(18)));
							elsif (value1_array(19) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value1_array(19) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result1_sig <= std_logic_vector(unsigned(result1_sig)) + std_logic_vector(unsigned(value1_array(19)));
							elsif (value1_array(20) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value1_array(20) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result1_sig <= std_logic_vector(unsigned(result1_sig)) + std_logic_vector(unsigned(value1_array(20)));
							elsif (value1_array(21) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value1_array(21) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result1_sig <= std_logic_vector(unsigned(result1_sig)) + std_logic_vector(unsigned(value1_array(21)));
							elsif (value1_array(22) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value1_array(22) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result1_sig <= std_logic_vector(unsigned(result1_sig)) + std_logic_vector(unsigned(value1_array(22)));
							elsif (value1_array(23) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value1_array(23) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result1_sig <= std_logic_vector(unsigned(result1_sig)) + std_logic_vector(unsigned(value1_array(23)));
							elsif (value1_array(24) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value1_array(24) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result1_sig <= std_logic_vector(unsigned(result1_sig)) + std_logic_vector(unsigned(value1_array(24)));
							elsif (value1_array(25) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value1_array(25) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result1_sig <= std_logic_vector(unsigned(result1_sig)) + std_logic_vector(unsigned(value1_array(25)));
							elsif (value1_array(26) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value1_array(26) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result1_sig <= std_logic_vector(unsigned(result1_sig)) + std_logic_vector(unsigned(value1_array(26)));
							elsif (value1_array(27) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value1_array(27) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result1_sig <= std_logic_vector(unsigned(result1_sig)) + std_logic_vector(unsigned(value1_array(27)));
							elsif (value1_array(28) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value1_array(28) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result1_sig <= std_logic_vector(unsigned(result1_sig)) + std_logic_vector(unsigned(value1_array(28)));
							elsif (value1_array(29) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value1_array(29) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result1_sig <= std_logic_vector(unsigned(result1_sig)) + std_logic_vector(unsigned(value1_array(29)));
							elsif (value1_array(30) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value1_array(30) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result1_sig <= std_logic_vector(unsigned(result1_sig)) + std_logic_vector(unsigned(value1_array(30)));
							elsif (value1_array(31) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value1_array(31) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result1_sig <= std_logic_vector(unsigned(result1_sig)) + std_logic_vector(unsigned(value1_array(31)));
							else
								value1_finished <= '1';
								result(31 downto 0) <= result1_sig(result_fromIndex downto result_toIndex);
								myState <= final_state;
								result_request <='1';
								if(result1_sig(63 downto 56) /= "0000000000000000") then
									overflow <= '1';
								end if;
								if(result1_sig(23 downto 0) /= "0000000000000000") then
									underanked <= '1';
								end if;
							end if;
							
							if(value2_array(0) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value2_array(0) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result2_sig <= std_logic_vector(unsigned(result2_sig)) + std_logic_vector(unsigned(value2_array(0)));
							elsif (value2_array(1) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value2_array(1) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result2_sig <= std_logic_vector(unsigned(result2_sig)) + std_logic_vector(unsigned(value2_array(1)));
							elsif (value2_array(2) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value2_array(2) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result2_sig <= std_logic_vector(unsigned(result2_sig)) + std_logic_vector(unsigned(value2_array(2)));
							elsif (value2_array(3) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value2_array(3) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result2_sig <= std_logic_vector(unsigned(result2_sig)) + std_logic_vector(unsigned(value2_array(3)));
							elsif (value2_array(4) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value2_array(4) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result2_sig <= std_logic_vector(unsigned(result2_sig)) + std_logic_vector(unsigned(value2_array(4)));
							elsif (value2_array(5) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value2_array(5) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result2_sig <= std_logic_vector(unsigned(result2_sig)) + std_logic_vector(unsigned(value2_array(5)));
							elsif (value2_array(6) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value2_array(6) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result2_sig <= std_logic_vector(unsigned(result2_sig)) + std_logic_vector(unsigned(value2_array(6)));
							elsif (value2_array(7) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value2_array(7) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result2_sig <= std_logic_vector(unsigned(result2_sig)) + std_logic_vector(unsigned(value2_array(7)));
							elsif (value2_array(8) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value2_array(8) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result2_sig <= std_logic_vector(unsigned(result2_sig)) + std_logic_vector(unsigned(value2_array(8)));
							elsif (value2_array(9) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value2_array(9) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result2_sig <= std_logic_vector(unsigned(result2_sig)) + std_logic_vector(unsigned(value2_array(9)));
							elsif (value2_array(10) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value2_array(10) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result2_sig <= std_logic_vector(unsigned(result2_sig)) + std_logic_vector(unsigned(value2_array(10)));
							elsif (value2_array(11) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value2_array(11) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result2_sig <= std_logic_vector(unsigned(result2_sig)) + std_logic_vector(unsigned(value2_array(11)));
							elsif (value2_array(12) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value2_array(12) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result2_sig <= std_logic_vector(unsigned(result2_sig)) + std_logic_vector(unsigned(value2_array(12)));
							elsif (value2_array(13) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value2_array(13) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result2_sig <= std_logic_vector(unsigned(result2_sig)) + std_logic_vector(unsigned(value2_array(13)));
							elsif (value2_array(14) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value2_array(14) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result2_sig <= std_logic_vector(unsigned(result2_sig)) + std_logic_vector(unsigned(value2_array(14)));
							elsif (value2_array(15) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value2_array(15) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result2_sig <= std_logic_vector(unsigned(result2_sig)) + std_logic_vector(unsigned(value2_array(15)));
							elsif (value2_array(16) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value2_array(16) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result2_sig <= std_logic_vector(unsigned(result2_sig)) + std_logic_vector(unsigned(value2_array(16)));
							elsif (value2_array(17) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value2_array(17) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result2_sig <= std_logic_vector(unsigned(result2_sig)) + std_logic_vector(unsigned(value2_array(17)));
							elsif (value2_array(18) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value2_array(18) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result2_sig <= std_logic_vector(unsigned(result2_sig)) + std_logic_vector(unsigned(value2_array(18)));
							elsif (value2_array(19) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value2_array(19) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result2_sig <= std_logic_vector(unsigned(result2_sig)) + std_logic_vector(unsigned(value2_array(19)));
							elsif (value2_array(20) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value2_array(20) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result2_sig <= std_logic_vector(unsigned(result2_sig)) + std_logic_vector(unsigned(value2_array(20)));
							elsif (value2_array(21) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value2_array(21) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result2_sig <= std_logic_vector(unsigned(result2_sig)) + std_logic_vector(unsigned(value2_array(21)));
							elsif (value2_array(22) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value2_array(22) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result2_sig <= std_logic_vector(unsigned(result2_sig)) + std_logic_vector(unsigned(value2_array(22)));
							elsif (value2_array(23) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value2_array(23) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result2_sig <= std_logic_vector(unsigned(result2_sig)) + std_logic_vector(unsigned(value2_array(23)));
							elsif (value2_array(24) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value2_array(24) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result2_sig <= std_logic_vector(unsigned(result2_sig)) + std_logic_vector(unsigned(value2_array(24)));
							elsif (value2_array(25) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value2_array(25) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result2_sig <= std_logic_vector(unsigned(result2_sig)) + std_logic_vector(unsigned(value2_array(25)));
							elsif (value2_array(26) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value2_array(26) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result2_sig <= std_logic_vector(unsigned(result2_sig)) + std_logic_vector(unsigned(value2_array(26)));
							elsif (value2_array(27) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value2_array(27) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result2_sig <= std_logic_vector(unsigned(result2_sig)) + std_logic_vector(unsigned(value2_array(27)));
							elsif (value2_array(28) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value2_array(28) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result2_sig <= std_logic_vector(unsigned(result2_sig)) + std_logic_vector(unsigned(value2_array(28)));
							elsif (value2_array(29) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value2_array(29) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result2_sig <= std_logic_vector(unsigned(result2_sig)) + std_logic_vector(unsigned(value2_array(29)));
							elsif (value2_array(30) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value2_array(30) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result2_sig <= std_logic_vector(unsigned(result2_sig)) + std_logic_vector(unsigned(value2_array(30)));
							elsif (value2_array(31) /= "0000000000000000000000000000000000000000000000000000000000000000") then
								value2_array(31) <= "0000000000000000000000000000000000000000000000000000000000000000";
								result2_sig <= std_logic_vector(unsigned(result2_sig)) + std_logic_vector(unsigned(value2_array(31)));
							else
								value2_finished <= '1';
								result <= result2_sig(result_fromIndex downto result_toIndex);
								myState <= final_state;
								result_request <='1';
								if(result2_sig(63 downto 56) /= "0000000000000000") then
									overflow <= '1';
								end if;
								if(result2_sig(23 downto 0) /= "0000000000000000") then
									underanked <= '1';
								end if;
							end if;
						else
							myState <= final_state;
						end if;
					when final_state =>	
						if (result_acknowledge ='1') then
							result1_sig <= "0000000000000000000000000000000000000000000000000000000000000000";
							result2_sig <= "0000000000000000000000000000000000000000000000000000000000000000";
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

