
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Layer_testbench IS
END Layer_testbench;
 
ARCHITECTURE behavior OF Layer_testbench IS 

    COMPONENT Conv_ReLU_Pooling
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         ReLU_enabled : IN  std_logic;
         Pooling_enabled : IN  std_logic;
         pooling_mode : IN  std_logic;
         poolDim : IN  integer;
         image_width : IN  integer;
         image_height : IN  integer;
         stride : IN  integer;
         filterDim : IN  integer;
         numOfChannels : IN  integer;
         numOfFilters : IN  integer;
         image_burst_request : OUT  std_logic;
         image_burst_acknowledge : IN  std_logic;
         read_image : OUT  std_logic;
         image_addr : OUT  std_logic_vector(31 downto 0);
         image_data_valid : IN  std_logic;
         image_data_out : IN  std_logic_vector(31 downto 0);
         filter_burst_request : OUT  std_logic;
         filter_burst_acknowledge : IN  std_logic;
         read_filter : OUT  std_logic;
         filter_addr : OUT  std_logic_vector(31 downto 0);
         filter_data_valid : IN  std_logic;
         filter_data_out : IN  std_logic_vector(31 downto 0);
         pool_activation_request : OUT  std_logic;
         pool_activation_acknowledge : IN  std_logic;
         pool_address : OUT  std_logic_vector(31 downto 0);
         pool_data : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal ReLU_enabled : std_logic := '0';
   signal Pooling_enabled : std_logic := '0';
   signal pooling_mode : std_logic := '0';
   signal poolDim : integer := 0;
   signal image_width : integer := 0;
   signal image_height : integer := 0;
   signal stride : integer := 0;
   signal filterDim : integer := 0;
   signal numOfChannels : integer := 0;
   signal numOfFilters : integer := 0;
   signal image_burst_acknowledge : std_logic := '0';
   signal image_data_valid : std_logic := '0';
   signal image_data_out : std_logic_vector(31 downto 0) := (others => '0');
   signal filter_burst_acknowledge : std_logic := '0';
   signal filter_data_valid : std_logic := '0';
   signal filter_data_out : std_logic_vector(31 downto 0) := (others => '0');
   signal pool_activation_acknowledge : std_logic := '0';

 	--Outputs
   signal image_burst_request : std_logic;
   signal read_image : std_logic;
   signal image_addr : std_logic_vector(31 downto 0);
   signal filter_burst_request : std_logic;
   signal read_filter : std_logic;
   signal filter_addr : std_logic_vector(31 downto 0);
   signal pool_activation_request : std_logic;
   signal pool_address : std_logic_vector(31 downto 0);
   signal pool_data : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Conv_ReLU_Pooling PORT MAP (
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
          image_burst_request => image_burst_request,
          image_burst_acknowledge => image_burst_acknowledge,
          read_image => read_image,
          image_addr => image_addr,
          image_data_valid => image_data_valid,
          image_data_out => image_data_out,
          filter_burst_request => filter_burst_request,
          filter_burst_acknowledge => filter_burst_acknowledge,
          read_filter => read_filter,
          filter_addr => filter_addr,
          filter_data_valid => filter_data_valid,
          filter_data_out => filter_data_out,
          pool_activation_request => pool_activation_request,
          pool_activation_acknowledge => pool_activation_acknowledge,
          pool_address => pool_address,
          pool_data => pool_data
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      rst <= '1';
      wait for 100 ns;	
		rst <= '0';
		poolDim <= 2;
		image_width <= 134;
		image_height <= 132;
		stride <= 2;
		filterDim <= 3;
		numOfChannels <= 3;
		numOfFilters <= 3;
		
      --wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
