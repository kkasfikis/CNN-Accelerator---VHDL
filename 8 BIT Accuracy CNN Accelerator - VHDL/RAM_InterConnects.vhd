library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity RAM_InterConnects is
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
end RAM_InterConnects;

architecture Behavioral of RAM_InterConnects is

	component Filter_RAM_IC is
	port(
		clk : in std_logic;
		rst : in std_logic;
		burst_request : in std_logic;
		burst_acknowledge : out std_logic;
		burst_size : in std_logic_vector(31 downto 0);
		read_filter : in std_logic;
		filter_addr : in std_logic_vector(31 downto 0);
		filter_data_valid: out std_logic;
		filter_data_out : out std_logic_vector(31 downto 0)
	);
	end component;
	
	component Image_RAM_IC is
	port(
		clk : in std_logic;
		rst : in std_logic;
		burst_request : in std_logic;
		burst_acknowledge : out std_logic;
		burst_size : in std_logic_vector(31 downto 0);
		read_image : in std_logic;
		image_addr : in std_logic_vector(31 downto 0);
		image_data_valid: out std_logic;
		image_data_out : out std_logic_vector(31 downto 0)
	);
	end component;
	
	component Result_RAM_IC is
	port(
		clk : in std_logic;
		rst : in std_logic;
		init_file : in std_logic;
		dataSize : in std_logic_vector(31 downto 0);
		read_write : in std_logic;
		activation_request : in std_logic;
		activation_acknowledge : out std_logic;
		result_address : in std_logic_vector(31 downto 0);
		result_data : in std_logic_vector(31 downto 0);
		result_read_data : out std_logic_vector(31 downto 0);
		result_read_data_valid : out std_logic
	);
	end component;

	component Pool_RAM_IC is
	port(
		clk : in std_logic;
		rst : in std_logic;
		init_file : in std_logic;
		dataSize : in std_logic_vector(31 downto 0);
		activation_request : in std_logic;
		activation_acknowledge : out std_logic;
		pool_address : in std_logic_vector(31 downto 0);
		pool_data : in std_logic_vector(31 downto 0)
	);
	end component;
	
	
begin

	Image_IC : Image_RAM_IC
	port map(
		clk => clk,
		rst => rst,
		burst_request => image_burst_request,
		burst_acknowledge => image_burst_acknowledge,
		burst_size => image_burst_size,
		read_image => read_image,
		image_addr => image_addr,
		image_data_valid => image_data_valid,
		image_data_out => image_data_out
	);
	
	Filter_IC : Filter_RAM_IC
	port map(
		clk => clk,
		rst => rst,
		burst_request => filter_burst_request,
		burst_acknowledge => filter_burst_acknowledge,
		burst_size => filter_burst_size,
		read_filter => read_filter,
		filter_addr => filter_addr,
		filter_data_valid => filter_data_valid,
		filter_data_out => filter_data_out
	);

	Result_IC : Result_RAM_IC
	port map(
		clk => clk,
		rst => rst,
		init_file  => result_init_file,
		dataSize  => result_dataSize,
		read_write => result_read_write,
		activation_request  => result_activation_request,
		activation_acknowledge  => result_activation_acknowledge,
		result_address  => result_address,
		result_data  => result_data,
		result_read_data => result_read_data,
		result_read_data_valid => result_read_data_valid
	);
	
	Pool_IC : Pool_RAM_IC 
	port map(
		clk => clk,
		rst => rst,
		init_file => pool_init_file,
		dataSize => pool_dataSize,
		activation_request => pool_activation_request,
		activation_acknowledge => pool_activation_acknowledge,
		pool_address => pool_address,
		pool_data => pool_data
	);

end Behavioral;

