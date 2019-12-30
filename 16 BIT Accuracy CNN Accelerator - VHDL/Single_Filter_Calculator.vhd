library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity Single_Filter_Calculator is
port(
	clk : in std_logic;
	rst : in std_logic;
	-------SYSTEM CONSTANTS-----------
	stride : in integer;
	filterDim : in integer;
	iHeight : in integer;
	rHeight : in integer;
	max_x : in integer;
	max_y : in integer;
	image_offset : in integer;
	filter_offset : in integer;
	filter_column_offset : in integer;
	image_column_offset : in integer;
	numOfChannels : in integer;
	stride_data : in integer;
	numOfData : in integer;
	----------------------------------
	result_baseAddress : in integer;
	-------IMAGE IC-------------------
	image_burst_request : out std_logic;
	image_burst_acknowledge : in std_logic;
	read_image : out std_logic;
	image_addr : out std_logic_vector(31 downto 0);
	image_data_valid : in std_logic;
	image_data_out : in std_logic_vector(31 downto 0);
	----------------------------------
	-------FILTER IC------------------
	filter_burst_request : out std_logic;
	filter_burst_acknowledge : in std_logic;
	read_filter : out std_logic;
	filter_addr : out std_logic_vector(31 downto 0);
	filter_data_valid : in std_logic;
	filter_data_out : in std_logic_vector(31 downto 0);
	----------------------------------
	-------FrameCalc------------------
	result_out : out std_logic_vector(31 downto 0);
	result_out_valid : out std_logic;
	result_address_out : out std_logic_vector(31 downto 0);
	previous_result_saved : in std_logic;
	----------------------------------
	activation_request : in std_logic;
	activation_acknowledge : out std_logic;
	filter_address : in integer;
	addToExisting : out std_logic;
	lastChannels : out std_logic;
	framerMode : out std_logic_vector(1 downto 0)
	----------------------------------
);
end Single_Filter_Calculator;

architecture Behavioral of Single_Filter_Calculator is

	component FRAMER is
	port(
		clk : in std_logic;
		rst : in std_logic;
		-------SYSTEM CONSTANTS-----------
		max_x : in integer;
		max_y : in integer;
		numOfChannels : in integer;
		iHeight: in integer;
		rHeight: in integer;
		image_offset : in integer;
		filter_offset : in integer;
		stride : in integer;
		filterDim : in integer;
		----------------------------------
		result_baseAddress : in integer;
		filter_address : in integer;
		activation_request : in std_logic;
		activation_acknowledge : out std_logic;
		frameCalc_request : out std_logic;
		collector_acknowledge: in std_logic;
		mode : out std_logic_vector(1 downto 0);
		baseAddress_image : out integer;
		baseAddress_filter : out integer;
		frameCalc_numOfChannels: out integer;
		frameCalc_rst : out std_logic;
		result_address : out integer;
		addToExisting : out std_logic;
		lastChannels : out std_logic
	);
	end component;



	component FrameCalculator is
	port(
		clk : in std_logic;
		rst : in std_logic;
		----------SYSTEM CONSTANTS------------
		stride : in integer;
		filterDim : in integer;
		image_offset : in integer;
		filter_offset : in integer;
		filter_column_offset : in integer;
		image_column_offset : in integer;
		numOfChannels : in integer;
		stride_data :in integer;
		numOfData : in integer;
		--------------------------------------
		-------FRAMER DATA--------------
		baseAddress_image : in integer;
		baseAddress_filter : in integer;
		baseAddress_result : in integer;
		--------------------------------
		activation_request : in std_logic;
		activation_acknowledge : out std_logic;
		mode : in std_logic_vector(1 downto 0);
		------IMAGE RAM IC--------------
		address_image : out integer;
		burstRequest_image : out std_logic;
		read_image : out std_logic;
		burstAcknowledge_image : in std_logic;
		data1_in : in std_logic_vector(31 downto 0);
		data1_valid_in : in std_logic;
		--------------------------------
		------FILTER RAM IC-------------
		address_filter : out integer;
		burstRequest_filter : out std_logic;
		read_filter : out std_logic;
		burstAcknowledge_filter : in std_logic;
		data2_in : in std_logic_vector(31 downto 0);
		data2_valid_in : in std_logic;
		---------------------------------
		result_out : out std_logic_vector(31 downto 0);
		result_out_valid : out std_logic;
		result_address_out : out std_logic_vector(31 downto 0);
		previous_result_saved : in std_logic
	);
	end component;
	
	-----------SIGNAL DECLARATION-------------
	signal baseAddress_image_sig : integer;
	signal baseAddress_filter_sig : integer;
	signal mode_sig : std_logic_vector(1 downto 0);

	signal address_image : integer;
	
	signal address_filter : integer;
	signal addToExisting_sig : std_logic;
	signal frameCalc_request_sig : std_logic;
	signal collector_acknowledge_sig : std_logic;
	signal result_address_sig : integer;
	signal totalFrameSum_sig : std_logic_vector(31 downto 0);
	signal frameCalc_numOfChannels : integer;
	signal frameCalc_rst_sig : std_logic;
	signal frameCalc_rst : std_logic;
	------------------------------------------

begin
	
	myFramer: FRAMER 
	port map(
		clk => clk,
		rst => rst,
		-------SYSTEM CONSTANTS-----------
		max_x => max_x,
		max_y => max_y,
		numOfChannels => numOfChannels,
		iHeight => iHeight,
		rHeight => rHeight,
		image_offset => image_offset,
		filter_offset => filter_offset,
		stride => stride,
		filterDim => filterDim,
		----------------------------------
		result_baseAddress => result_baseAddress,
		filter_address => filter_address,
		activation_request => activation_request,
		activation_acknowledge => activation_acknowledge,
		frameCalc_request => frameCalc_request_sig,
		collector_acknowledge => collector_acknowledge_sig, --TO CHANGE
		mode => mode_sig,
		baseAddress_image => baseAddress_image_sig,
		baseAddress_filter => baseAddress_filter_sig,
		frameCalc_numOfChannels => frameCalc_numOfChannels,
		frameCalc_rst => frameCalc_rst_sig,
		result_address => result_address_sig,
		addToExisting => addToExisting,
		lastChannels => lastChannels
	);

	calculateFrame : FrameCalculator
	port map(
		clk => clk,
		rst => rst,
		----------SYSTEM CONSTANTS------------
		stride => stride,
		filterDim => filterDim,
		image_offset => image_offset,
		filter_offset => filter_offset,
		filter_column_offset => filter_column_offset,
		image_column_offset => image_column_offset,
		numOfChannels => frameCalc_numOfChannels,
		stride_data => stride_data,
		numOfData => numOfData,
		--------------------------------------
		-------FRAMER DATA--------------
		baseAddress_image => baseAddress_image_sig,
		baseAddress_filter => baseAddress_filter_sig,
		baseAddress_result => result_address_sig,
		--------------------------------
		activation_request => frameCalc_request_sig,
		activation_acknowledge => collector_acknowledge_sig, -- TO CHANGE
		mode => mode_sig,
		------IMAGE RAM IC--------------
		address_image => address_image,
		burstRequest_image => image_burst_request,
		read_image => read_image,
		burstAcknowledge_image => image_burst_acknowledge,
		data1_in => image_data_out,
		data1_valid_in => image_data_valid,
		--------------------------------
		------FILTER RAM IC-------------
		address_filter => address_filter,
		burstRequest_filter => filter_burst_request,
		read_filter => read_filter,
		burstAcknowledge_filter => filter_burst_acknowledge,
		data2_in => filter_data_out,
		data2_valid_in => filter_data_valid,
		---------------------------------
		result_out => result_out,
		result_out_valid => result_out_valid,
		result_address_out => result_address_out, 
		previous_result_saved => previous_result_saved
	);
	
	
	image_addr <= conv_std_logic_vector(address_image, 32);
	filter_addr <=  conv_std_logic_vector(address_filter, 32);
	frameCalc_rst <= frameCalc_rst_sig or rst;
	framerMode <= mode_sig;
end Behavioral;

