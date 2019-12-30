LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 

ENTITY FrameCalculator_testbench IS
END FrameCalculator_testbench;
 
ARCHITECTURE behavior OF FrameCalculator_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FrameCalculator
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         stride : IN  integer;
         filterDim : IN  integer;
         image_offset : IN  integer;
         filter_offset : IN  integer;
         filter_column_offset : IN  integer;
         image_column_offset : IN  integer;
         numOfChannels : IN  integer;
         stride_data : IN  integer;
         numOfData : IN  integer;
         baseAddress_image : IN  integer;
         baseAddress_filter : IN  integer;
         activation_request : IN  std_logic;
         activation_acknowledge : OUT  std_logic;
         mode : IN  std_logic_vector(1 downto 0);
         address_image : OUT  integer;
         burstRequest_image : OUT  std_logic;
         read_image : OUT  std_logic;
         burstAcknowledge_image : IN  std_logic;
         data1_in : IN  std_logic_vector(31 downto 0);
         data1_valid_in : IN  std_logic;
         address_filter : OUT  integer;
         burstRequest_filter : OUT  std_logic;
         read_filter : OUT  std_logic;
         burstAcknowledge_filter : IN  std_logic;
         data2_in : IN  std_logic_vector(31 downto 0);
         data2_valid_in : IN  std_logic;
         totalFrameSum : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal stride : integer := 0;
   signal filterDim : integer := 0;
   signal image_offset : integer := 0;
   signal filter_offset : integer := 0;
   signal filter_column_offset : integer := 0;
   signal image_column_offset : integer := 0;
   signal numOfChannels : integer := 0;
   signal stride_data : integer := 0;
   signal numOfData : integer := 0;
   signal baseAddress_image : integer := 0;
   signal baseAddress_filter : integer := 0;
   signal activation_request : std_logic := '0';
   signal mode : std_logic_vector(1 downto 0) := (others => '0');
   signal burstAcknowledge_image : std_logic := '0';
   signal data1_in : std_logic_vector(31 downto 0) := (others => '0');
   signal data1_valid_in : std_logic := '0';
   signal burstAcknowledge_filter : std_logic := '0';
   signal data2_in : std_logic_vector(31 downto 0) := (others => '0');
   signal data2_valid_in : std_logic := '0';

 	--Outputs
   signal activation_acknowledge : std_logic;
   signal address_image : integer;
   signal burstRequest_image : std_logic;
   signal read_image : std_logic;
   signal address_filter : integer;
   signal burstRequest_filter : std_logic;
   signal read_filter : std_logic;
   signal totalFrameSum : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FrameCalculator PORT MAP (
          clk => clk,
          rst => rst,
          stride => stride,
          filterDim => filterDim,
          image_offset => image_offset,
          filter_offset => filter_offset,
          filter_column_offset => filter_column_offset,
          image_column_offset => image_column_offset,
          numOfChannels => numOfChannels,
          stride_data => stride_data,
          numOfData => numOfData,
          baseAddress_image => baseAddress_image,
          baseAddress_filter => baseAddress_filter,
          activation_request => activation_request,
          activation_acknowledge => activation_acknowledge,
          mode => mode,
          address_image => address_image,
          burstRequest_image => burstRequest_image,
          read_image => read_image,
          burstAcknowledge_image => burstAcknowledge_image,
          data1_in => data1_in,
          data1_valid_in => data1_valid_in,
          address_filter => address_filter,
          burstRequest_filter => burstRequest_filter,
          read_filter => read_filter,
          burstAcknowledge_filter => burstAcknowledge_filter,
          data2_in => data2_in,
          data2_valid_in => data2_valid_in,
          totalFrameSum => totalFrameSum
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period;
		activation_request <= '0';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      rst <= '1';
      wait for 100 ns;	
		rst <= '0';
		stride <= 1;
		filterDim <= 2;
		image_offset <= 16;
		filter_offset <= 8;
		filter_column_offset <= 4;
		image_column_offset <= 4;
		numOfChannels <=1
		stride_data <=2;
		numOfData <= 4;
		activation_request <= '1';
		mode <= "11";
		wait for clk_period;
		activation_request <= '0';
		
      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
