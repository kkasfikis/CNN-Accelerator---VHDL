library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Convolution_Calc_Unit is
port(
	--inputs
	clk : in std_logic;
	rst : in std_logic;
	data1 : in std_logic_vector(31 downto 0);
	data2 : in std_logic_vector(31 downto 0);
	valid_write : in std_logic_vector(0 downto 0);
	numOfData : in integer;
	summed : in std_logic;
	--outputs
	buffer_full : out std_logic;
	buffer_full_1 : out std_logic;
	sum : out std_logic_vector(31 downto 0);
	final_sum : out std_logic
);
end Convolution_Calc_Unit;

architecture Behavioral of Convolution_Calc_Unit is

	--------------------------------------SIGNAL SECTION-------------------------------------------
	signal result0,result1,result2,result3,result4,result5,result6,result7,result8,result9,result10,result11,result12,result13,result14: std_logic_vector(31 downto 0);
	signal value1_sig : std_logic_vector(31 downto 0);
	signal value2_sig : std_logic_vector(31 downto 0);
	signal activation_acknowledge_sig : std_logic_vector(14 downto 0);
	signal activation_request_sig : std_logic_vector(14 downto 0);
	signal result_acknowledge_sig : std_logic_vector(14 downto 0);
	signal result_request_sig : std_logic_vector(14 downto 0);
	signal fa_rst : std_logic;
--------------------------------END OF SIGNAL SECTION -----------------------------------------

	component input_ctrl
	port(
		clk : in std_logic;
		rst : in std_logic;
		data1 : in std_logic_vector(31 downto 0);
		data2 : in std_logic_vector(31 downto 0);
		valid_write : in std_logic_vector(0 downto 0);
		activation_acknowledge : in std_logic_vector(14 downto 0);
		buffer_full : out std_logic;
		value1 : out std_logic_vector(31 downto 0);
		value2 : out std_logic_vector(31 downto 0);
		activation_request : out std_logic_vector(14 downto 0)
	);
	end component;

	component shift_mul_add
	port(
		clk : in std_logic;
		rst : in std_logic;
		value1 : in std_logic_vector(31 downto 0);
		value2 : in std_logic_vector(31 downto 0);
		activation_request : in std_logic;
		result_acknowledge : in std_logic;
		result : out std_logic_vector(31 downto 0);
		activation_acknowledge : out std_logic;
		result_request : out std_logic
	);
	end component;

	component full_adder_ctrl
	port(
		clk : in std_logic;
		rst : in std_logic;
		result0 : in std_logic_vector(31 downto 0);
		result1 : in std_logic_vector(31 downto 0);
		result2 : in std_logic_vector(31 downto 0);
		result3 : in std_logic_vector(31 downto 0);
		result4 : in std_logic_vector(31 downto 0);
		result5 : in std_logic_vector(31 downto 0);
		result6 : in std_logic_vector(31 downto 0);
		result7 : in std_logic_vector(31 downto 0);
		result8 : in std_logic_vector(31 downto 0);
		result9 : in std_logic_vector(31 downto 0);
		result10 : in std_logic_vector(31 downto 0);
		result11 : in std_logic_vector(31 downto 0);
		result12 : in std_logic_vector(31 downto 0);
		result13 : in std_logic_vector(31 downto 0);
		result14 : in std_logic_vector(31 downto 0);
		numOfData : in integer;
		result_request : in std_logic_vector(14 downto 0);
		buffer_full : out std_logic;
		sum : out std_logic_vector(31 downto 0);
		final_sum : out std_logic;
		result_acknowledge : out std_logic_vector(14 downto 0)
	);
	end component;
	
begin

	INPUT_CONTROLLER : input_ctrl
	port map(
		clk => clk,
		rst => rst,
		data1 => data1,
		data2 => data2,
		valid_write => valid_write,
		activation_acknowledge => activation_acknowledge_sig,
		buffer_full => buffer_full,
		value1 => value1_sig,
		value2 => value2_sig,
		activation_request => activation_request_sig
	);

---------------------------------------SHIFT MUL PORT MAPS ------------------------------------------------

	SHIFT_MUL_ADD_0 : shift_mul_add
	port map(
		clk => clk,
		rst => rst,
		value1 => value1_sig,
		value2 => value2_sig,
		activation_request => activation_request_sig(0),
		result_acknowledge => result_acknowledge_sig(0),
		result => result0,
		activation_acknowledge => activation_acknowledge_sig(0),
		result_request => result_request_sig(0)
	);
	
	SHIFT_MUL_ADD_1 : shift_mul_add
	port map(
		clk => clk,
		rst => rst,
		value1 => value1_sig,
		value2 => value2_sig,
		activation_request => activation_request_sig(1),
		result_acknowledge => result_acknowledge_sig(1),
		result => result1,
		activation_acknowledge => activation_acknowledge_sig(1),
		result_request => result_request_sig(1)
	);
	
	SHIFT_MUL_ADD_2 : shift_mul_add
	port map(
		clk => clk,
		rst => rst,
		value1 => value1_sig,
		value2 => value2_sig,
		activation_request => activation_request_sig(2),
		result_acknowledge => result_acknowledge_sig(2),
		result => result2,
		activation_acknowledge => activation_acknowledge_sig(2),
		result_request => result_request_sig(2)
	);
	
	SHIFT_MUL_ADD_3 : shift_mul_add
	port map(
		clk => clk,
		rst => rst,
		value1 => value1_sig,
		value2 => value2_sig,
		activation_request => activation_request_sig(3),
		result_acknowledge => result_acknowledge_sig(3),
		result => result3,
		activation_acknowledge => activation_acknowledge_sig(3),
		result_request => result_request_sig(3)
	);
	
	SHIFT_MUL_ADD_4 : shift_mul_add
	port map(
		clk => clk,
		rst => rst,
		value1 => value1_sig,
		value2 => value2_sig,
		activation_request => activation_request_sig(4),
		result_acknowledge => result_acknowledge_sig(4),
		result => result4,
		activation_acknowledge => activation_acknowledge_sig(4),
		result_request => result_request_sig(4)
	);
	
	SHIFT_MUL_ADD_5 : shift_mul_add
	port map(
		clk => clk,
		rst => rst,
		value1 => value1_sig,
		value2 => value2_sig,
		activation_request => activation_request_sig(5),
		result_acknowledge => result_acknowledge_sig(5),
		result => result5,
		activation_acknowledge => activation_acknowledge_sig(5),
		result_request => result_request_sig(5)
	);
	
	SHIFT_MUL_ADD_6 : shift_mul_add
	port map(
		clk => clk,
		rst => rst,
		value1 => value1_sig,
		value2 => value2_sig,
		activation_request => activation_request_sig(6),
		result_acknowledge => result_acknowledge_sig(6),
		result => result6,
		activation_acknowledge => activation_acknowledge_sig(6),
		result_request => result_request_sig(6)
	);
	
	SHIFT_MUL_ADD_7 : shift_mul_add
	port map(
		clk => clk,
		rst => rst,
		value1 => value1_sig,
		value2 => value2_sig,
		activation_request => activation_request_sig(7),
		result_acknowledge => result_acknowledge_sig(7),
		result => result7,
		activation_acknowledge => activation_acknowledge_sig(7),
		result_request => result_request_sig(7)
	);
	
	SHIFT_MUL_ADD_8 : shift_mul_add
	port map(
		clk => clk,
		rst => rst,
		value1 => value1_sig,
		value2 => value2_sig,
		activation_request => activation_request_sig(8),
		result_acknowledge => result_acknowledge_sig(8),
		result => result8,
		activation_acknowledge => activation_acknowledge_sig(8),
		result_request => result_request_sig(8)
	);
	
	SHIFT_MUL_ADD_9 : shift_mul_add
	port map(
		clk => clk,
		rst => rst,
		value1 => value1_sig,
		value2 => value2_sig,
		activation_request => activation_request_sig(9),
		result_acknowledge => result_acknowledge_sig(9),
		result => result9,
		activation_acknowledge => activation_acknowledge_sig(9),
		result_request => result_request_sig(9)
	);
	
	SHIFT_MUL_ADD_10 : shift_mul_add
	port map(
		clk => clk,
		rst => rst,
		value1 => value1_sig,
		value2 => value2_sig,
		activation_request => activation_request_sig(10),
		result_acknowledge => result_acknowledge_sig(10),
		result => result10,
		activation_acknowledge => activation_acknowledge_sig(10),
		result_request => result_request_sig(10)
	);
	
	SHIFT_MUL_ADD_11 : shift_mul_add
	port map(
		clk => clk,
		rst => rst,
		value1 => value1_sig,
		value2 => value2_sig,
		activation_request => activation_request_sig(11),
		result_acknowledge => result_acknowledge_sig(11),
		result => result11,
		activation_acknowledge => activation_acknowledge_sig(11),
		result_request => result_request_sig(11)
	);
	
	SHIFT_MUL_ADD_12 : shift_mul_add
	port map(
		clk => clk,
		rst => rst,
		value1 => value1_sig,
		value2 => value2_sig,
		activation_request => activation_request_sig(12),
		result_acknowledge => result_acknowledge_sig(12),
		result => result12,
		activation_acknowledge => activation_acknowledge_sig(12),
		result_request => result_request_sig(12)
	);
	
	SHIFT_MUL_ADD_13 : shift_mul_add
	port map(
		clk => clk,
		rst => rst,
		value1 => value1_sig,
		value2 => value2_sig,
		activation_request => activation_request_sig(13),
		result_acknowledge => result_acknowledge_sig(13),
		result => result13,
		activation_acknowledge => activation_acknowledge_sig(13),
		result_request => result_request_sig(13)
	);
	
	SHIFT_MUL_ADD_14 : shift_mul_add
	port map(
		clk => clk,
		rst => rst,
		value1 => value1_sig,
		value2 => value2_sig,
		activation_request => activation_request_sig(14),
		result_acknowledge => result_acknowledge_sig(14),
		result => result14,
		activation_acknowledge => activation_acknowledge_sig(14),
		result_request => result_request_sig(14)
	);
--------------------------------------- END OF SHIFT MUL PORT MAPS ------------------------------------------------	
	
	FULL_ADDER_CONTROLLER : full_adder_ctrl
	port map(
		clk => clk,
		rst => fa_rst,
		result0 => result0,
		result1 => result1,
		result2 => result2,
		result3 => result3,
		result4 => result4,
		result5 => result5,
		result6 => result6,
		result7 => result7,
		result8 => result8,
		result9 => result9,
		result10 => result10,
		result11 => result11,
		result12 => result12,
		result13 => result13,
		result14 => result14,
		numOfData => numOfData,
		result_request => result_request_sig,
		buffer_full => buffer_full_1,
		sum => sum,
		final_sum => final_sum,
		result_acknowledge => result_acknowledge_sig
	);
	
	fa_rst <= rst or summed;
	
end Behavioral;

