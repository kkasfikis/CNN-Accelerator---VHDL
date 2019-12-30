library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Multiple_Filter_Calculator is
port(
	clk : in std_logic;
	rst : in std_logic;
	activation_request : in std_logic;
	activation_acknowledge : out std_logic;
	-------SYSTEM CONSTANTS-----------
	stride : in integer;
	filterDim : in integer;
	iHeight : in integer;
	rHeight : in integer;
	max_x : in integer;
	max_y : in integer;
	image_offset : in integer;
	result_offset : in integer;
	filter_offset : in integer;
	wholeFilter_offset : in integer;
	filter_column_offset : in integer;
	image_column_offset : in integer;
	numOfChannels : in integer;
	numOfFilters : in integer;
	stride_data : in integer;
	numOfData : in integer;
	----------------------------------
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
	result_out : out std_logic_vector(31 downto 0);
	result_out_valid : out std_logic;
	result_address_out : out std_logic_vector(31 downto 0);
	previous_result_saved : in std_logic;
	----------------------------------
	addToExisting : out std_logic;
	lastChannels : out std_logic;
	framerMode : out std_logic_vector(1 downto 0)
);
end Multiple_Filter_Calculator;

architecture Behavioral of Multiple_Filter_Calculator is
	
	component FilterSelector is
	port(
		clk : in std_logic;
		rst : in std_logic;
		numOfFilters : in integer;
		filterOffset : in integer;
		resultOffset : in integer;
		activation_request : in std_logic;
		activation_acknowledge : out std_logic;
		rst_filter_calc : out std_logic;
		request_filter_calc : out std_logic;
		acknowledge_filter_calc : in std_logic;
		filter_address : out integer;
		rOffset :out integer
	);
	end component;
	
	component Single_Filter_Calculator is
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
	end component;

	--------------SIGNAL DECLARATION----------------------
	signal request_filter_calc_sig : std_logic;
	signal acknowledge_filter_calc_sig : std_logic;
	signal filter_address_sig : integer;
	signal rst_filterCalc : std_logic;
	signal SingleFilterCalc_rst : std_logic;
	signal rOffset : integer;
	------------------------------------------------------

begin
	
	SelectFilter : FilterSelector
	port map(
		clk => clk,
		rst => rst,
		numOfFilters => numOfFilters,
		filterOffset => wholeFilter_offset,
		resultOffset => result_offset,
		activation_request => activation_request,
		activation_acknowledge => activation_acknowledge,
		rst_filter_calc => rst_filterCalc,
		request_filter_calc => request_filter_calc_sig,
		acknowledge_filter_calc => acknowledge_filter_calc_sig,
		filter_address => filter_address_sig,
		rOffset => rOffset
	);
	
	FilterCalc : Single_Filter_Calculator
	port map(
		clk => clk,
		rst => SingleFilterCalc_rst,
		-------SYSTEM CONSTANTS-----------
		stride => stride,
		filterDim => filterDim,
		iHeight => iHeight,
		rHeight => rHeight,
		max_x => max_x,
		max_y => max_y,
		image_offset => image_offset,
		filter_offset => filter_offset,
		filter_column_offset => filter_column_offset,
		image_column_offset => image_column_offset,
		numOfChannels => numOfChannels,
		stride_data => stride_data,
		numOfData => numOfData,
		----------------------------------
		result_baseAddress => rOffset,
		-------IMAGE IC-------------------
		image_burst_request => image_burst_request,
		image_burst_acknowledge => image_burst_acknowledge,
		read_image => read_image,
		image_addr => image_addr,
		image_data_valid => image_data_valid,
		image_data_out => image_data_out,
		----------------------------------
		-------FILTER IC------------------
		filter_burst_request => filter_burst_request,
		filter_burst_acknowledge => filter_burst_acknowledge,
		read_filter => read_filter,
		filter_addr => filter_addr,
		filter_data_valid => filter_data_valid,
		filter_data_out => filter_data_out,
		----------------------------------
		result_out => result_out,
		result_out_valid => result_out_valid,
		result_address_out => result_address_out,
		previous_result_saved => previous_result_saved,
		addToExisting => addToExisting,
		lastChannels => lastChannels,
		activation_request => request_filter_calc_sig,
		activation_acknowledge => acknowledge_filter_calc_sig,
		filter_address => filter_address_sig,
		framerMode => framerMode
	);
	
	SingleFilterCalc_rst <= rst_filterCalc or rst;
end Behavioral;

