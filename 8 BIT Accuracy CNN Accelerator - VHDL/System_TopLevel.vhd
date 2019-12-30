library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;

entity System_TopLevel is
port(
	clk : in std_logic;
	rst : in std_logic;
	ReLU_enabled : in std_logic;
	Pooling_enabled : in std_logic;
	pooling_mode : in std_logic;
	poolDim : in integer range 0 to 16;
	image_width : in integer range 0 to 4096;
	image_height : in integer range 0 to 2048;
	stride : in integer range 0 to 15;
	filterDim : in integer range 0 to 16;
	numOfChannels : in integer range 0 to 120;
	numOfFilters : in integer range 0 to 240
);
end System_TopLevel;

architecture Behavioral of System_TopLevel is

	component RAM_InterConnects is
	port(
		clk : in std_logic;
		rst : in std_logic;
		-------FILTER_RAM_IC---------
		filter_burst_request : in std_logic;
		filter_burst_acknowledge : out std_logic;
		filter_burst_size : in std_logic_vector(31 downto 0);
		read_filter : in std_logic;
		filter_addr : in std_logic_vector(31 downto 0);
		filter_data_valid: out std_logic;
		filter_data_out : out std_logic_vector(31 downto 0);
		-----------------------------
		------IMAGE_RAM_IC-----------
		image_burst_request : in std_logic;
		image_burst_acknowledge : out std_logic;
		image_burst_size : in std_logic_vector(31 downto 0);
		read_image : in std_logic;
		image_addr : in std_logic_vector(31 downto 0);
		image_data_valid: out std_logic;
		image_data_out : out std_logic_vector(31 downto 0);
		-----------------------------
		------RESULT_RAM_IC----------
		result_init_file : in std_logic;
		result_dataSize : in std_logic_vector(31 downto 0);
		result_read_write : in std_logic; --
		result_activation_request : in std_logic;
		result_activation_acknowledge : out std_logic;
		result_address : in std_logic_vector(31 downto 0);
		result_data : in std_logic_vector(31 downto 0);
		result_read_data : out std_logic_vector(31 downto 0); --
		result_read_data_valid : out std_logic;
		-----------------------------
		------POOL_RAM_IC------------
		pool_init_file : in std_logic;
		pool_dataSize : in std_logic_vector(31 downto 0);
		pool_activation_request : in std_logic;
		pool_activation_acknowledge : out std_logic;
		pool_address : in std_logic_vector(31 downto 0);
		pool_data : in std_logic_vector(31 downto 0)
		-----------------------------
	);
	end component;
	
	component Conv_ReLU_Pooling is
	port(
		clk : in std_logic;
		rst : in std_logic;
		ReLU_enabled : in std_logic;
		Pooling_enabled : in std_logic;
		pooling_mode : in std_logic;
		poolDim : in integer;
		image_width : in integer;
		image_height : in integer;
		stride : in integer;
		filterDim : in integer;
		numOfChannels : in integer;
		numOfFilters : in integer;
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
		------RESULT_RAM_IC----------
		result_init_file : out std_logic;
		result_dataSize : out std_logic_vector(31 downto 0);
		result_read_write : out std_logic; --
		result_activation_request : out std_logic;
		result_activation_acknowledge : in std_logic;
		result_address : out std_logic_vector(31 downto 0);
		result_data : out std_logic_vector(31 downto 0);
		result_read_data : in std_logic_vector(31 downto 0); --
		result_read_data_valid : out std_logic;
		-----------------------------
		------POOL_RAM_IC------------
		pool_init_file : out std_logic;
		pool_dataSize : out std_logic_vector(31 downto 0);
		pool_activation_request : out std_logic;
		pool_activation_acknowledge : in std_logic;
		pool_address : out std_logic_vector(31 downto 0);
		pool_data : out std_logic_vector(31 downto 0)
		-----------------------------
	);
	end component;
	
	
	signal filter_burst_request_sig : std_logic;
	signal filter_burst_acknowledge_sig : std_logic;
	signal read_filter_sig : std_logic;
	signal filter_addr_sig : std_logic_vector(31 downto 0);
	signal filter_data_valid_sig : std_logic;
	signal filter_data_out_sig : std_logic_vector(31 downto 0);
	
	signal image_burst_request_sig : std_logic;
	signal image_burst_acknowledge_sig : std_logic;
	signal read_image_sig : std_logic;
	signal image_addr : std_logic_vector(31 downto 0);
	signal image_data_valid : std_logic;
	signal image_data_out : std_logic_vector(31 downto 0);
	
	signal result_init_sig : std_logic;
	signal result_dataSize_sig : std_logic_vector(31 downto 0);
	signal result_read_write_sig : std_logic;
	signal result_activation_request_sig : std_logic;
	signal result_activation_acknowledge_sig : std_logic;
	signal result_address_sig : std_logic_vector(31 downto 0);
	signal result_data_sig : std_logic_vector(31 downto 0);
	signal result_read_data_sig : std_logic_vector(31 downto 0);
	signal result_read_data_valid_sig : std_logic;
	
	signal pool_init_file_sig : std_logic;
	signal pool_dataSize_sig : std_logic_vector(31 downto 0);
	signal pool_activation_request_sig : std_logic;
	signal pool_activation_acknowledge_sig : std_logic;
	signal pool_address_sig : std_logic_vector(31 downto 0);
	signal pool_data_sig : std_logic_vector(31 downto 0);
	
	signal filter_dim_sig : std_logic_vector(31 downto 0);

begin
	ICs : RAM_InterConnects
	port map(
		clk => clk, 
		rst => rst,
		-------FILTER_RAM_IC---------
		filter_burst_request => filter_burst_request_sig,
		filter_burst_acknowledge => filter_burst_acknowledge_sig,
		filter_burst_size => filter_dim_sig,
		read_filter => read_filter_sig,
		filter_addr => filter_addr_sig,
		filter_data_valid => filter_data_valid_sig,
		filter_data_out => filter_data_out_sig,
		-----------------------------
		------IMAGE_RAM_IC-----------
		image_burst_request => image_burst_request_sig,
		image_burst_acknowledge => image_burst_acknowledge_sig,
		image_burst_size => filter_dim_sig,
		read_image => read_image_sig,
		image_addr => image_addr,
		image_data_valid => image_data_valid,
		image_data_out => image_data_out,
		-----------------------------
		------RESULT_RAM_IC----------
		result_init_file => result_init_sig,
		result_dataSize => result_dataSize_sig,
		result_read_write => result_read_write_sig,
		result_activation_request => result_activation_request_sig,
		result_activation_acknowledge => result_activation_acknowledge_sig,
		result_address => result_address_sig,
		result_data => result_data_sig,
		result_read_data  => result_read_data_sig,
		result_read_data_valid  => result_read_data_valid_sig,
		-----------------------------
		------POOL_RAM_IC------------
		pool_init_file  => pool_init_file_sig,
		pool_dataSize  => pool_dataSize_sig,
		pool_activation_request  => pool_activation_request_sig,
		pool_activation_acknowledge => pool_activation_acknowledge_sig,
		pool_address => pool_address_sig,
		pool_data => pool_data_sig
		-----------------------------
	);
	

	Layer : Conv_ReLU_Pooling 
	port map(
		clk => clk,
		rst => rst,
		ReLU_enabled => ReLU_enabled,
		Pooling_enabled => Pooling_enabled,
		pooling_mode => pooling_mode,
		poolDim => poolDim,
		image_width => image_width,
		image_height => image_height,
		stride => stride,
		filterDim => filterDim,
		numOfChannels => numOfChannels,
		numOfFilters => numOfFilters,
		-------IMAGE IC-------------------
		image_burst_request => image_burst_request_sig,
		image_burst_acknowledge => image_burst_acknowledge_sig,
		read_image => read_image_sig,
		image_addr => image_addr,
		image_data_valid => image_data_valid,
		image_data_out => image_data_out,
		----------------------------------
		-------FILTER IC------------------
		filter_burst_request => filter_burst_request_sig,
		filter_burst_acknowledge => filter_burst_acknowledge_sig,
		read_filter => read_filter_sig,
		filter_addr => filter_addr_sig,
		filter_data_valid => filter_data_valid_sig,
		filter_data_out => filter_data_out_sig,
		----------------------------------
		------RESULT_RAM_IC----------
		result_init_file => result_init_sig,
		result_dataSize => result_dataSize_sig,
		result_read_write => result_read_write_sig,
		result_activation_request => result_activation_request_sig,
		result_activation_acknowledge => result_activation_acknowledge_sig,
		result_address => result_address_sig,
		result_data => result_data_sig,
		result_read_data => result_read_data_sig,
		result_read_data_valid => result_read_data_valid_sig,
		-----------------------------
		------POOL_RAM_IC------------
		pool_init_file => pool_init_file_sig,
		pool_dataSize => pool_dataSize_sig,
		pool_activation_request => pool_activation_request_sig,
		pool_activation_acknowledge => pool_activation_acknowledge_sig,
		pool_address => pool_address_sig,
		pool_data => pool_data_sig
		-----------------------------
	);
	
	filter_dim_sig <= std_logic_vector(to_unsigned(filterDim,32));

end Behavioral;

