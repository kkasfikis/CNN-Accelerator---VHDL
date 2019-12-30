library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Channel_Calculator is
port(
	clk : in std_logic;
	rst : in std_logic;
	
	activation_request :in std_logic;
	activation_acknowledge : out std_logic;
	summed : in std_logic;
	mode : in std_logic_vector(1 downto 0);
	stride_data : in integer;
	numOfData : in integer;
	data1 : in std_logic_vector(31 downto 0);
	data1_valid : in std_logic;
	data2 : in std_logic_vector(31 downto 0);
	data2_valid : in std_logic;
	sum : out std_logic_vector(31 downto 0)
);	
end Channel_Calculator;

architecture Behavioral of Channel_Calculator is
	
	component MEM_CTRL is
	port(
		---------------INPUTS--------------
		clk: in std_logic;
		rst: in std_logic;
		mode : in std_logic_vector(1 downto 0);
		stride_data : in integer; -- stride * values per column
		numOfData : in integer;
		data1 : in std_logic_vector(31 downto 0);
		data1_valid : in std_logic;
		data2 : in std_logic_vector(31 downto 0);
		data2_valid : in std_logic;
		CCU_buffer_full : in std_logic;
		-------------OUTPUTS---------------
		CCU_rst : out std_logic;
		value1 : out std_logic_vector(31 downto 0);
		value2 : out std_logic_vector(31 downto 0);
		value_valid : out std_logic
	);
	end component;
	
	component Convolution_Calc_Unit is
	port(
		clk : in std_logic;
		rst : in std_logic;
		data1 : in std_logic_vector(31 downto 0);
		data2 : in std_logic_vector(31 downto 0);
		valid_write : in std_logic_vector(0 downto 0);
		numOfData : in integer;
		summed : in std_logic;
		buffer_full : out std_logic;
		buffer_full_1 : out std_logic;
		sum : out std_logic_vector(31 downto 0);
		final_sum : out std_logic
	);
	end component;
	
	----------SIGNAL DECLARATION-----------------
	signal value1_sig : std_logic_vector(31 downto 0);
	signal value2_sig : std_logic_vector(31 downto 0);
	signal values_valid_sig : std_logic;
	signal values_valid_sig_array : std_logic_vector(0 downto 0);
	signal CCU_rst_sig : std_logic;
	signal CCU_full : std_logic;
	signal CCU_bf_1 : std_logic;
	signal CCU_bf_2 : std_logic;
	signal mode_sig : std_logic_vector(1 downto 0);
	signal ccu_rst : std_logic;
	---------------------------------------------
	
begin

	LOCAL_BUFFERS : MEM_CTRL
	port map(
		clk => clk,
		rst => rst,
		mode => mode_sig,
		stride_data  => stride_data,
		numOfData  => numOfData,
		data1  => data1,
		data1_valid  => data1_valid,
		data2  => data2,
		data2_valid  => data2_valid,
		CCU_buffer_full  => CCU_full,
		CCU_rst => CCU_rst_sig,
		value1  => value1_sig,
		value2  => value2_sig,
		value_valid  => values_valid_sig
	);
	
	CCU : Convolution_Calc_Unit
	port map(
		clk  => clk,
		rst  => ccu_rst,
		data1  => value1_sig,
		data2  => value2_sig,
		valid_write  => values_valid_sig_array,
		summed => summed,
		numOfData  => numOfData,
		buffer_full  => CCU_bf_1,
		buffer_full_1  => CCU_bf_2,
		sum  => sum,
		final_sum  => activation_acknowledge 
	);
	
	ccu_rst <=rst or CCU_rst_sig;
	CCU_full <= CCU_bf_1 or CCU_bf_2;
	mode_sig <= mode when activation_request = '1' else "00";
	values_valid_sig_array <= "1" when values_valid_sig = '1' else "0";
end Behavioral;

