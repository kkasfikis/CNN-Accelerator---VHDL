LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY TopLevel_testbench IS
END TopLevel_testbench;
 
ARCHITECTURE behavior OF TopLevel_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT System_TopLevel
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
         numOfFilters : IN  integer
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

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: System_TopLevel PORT MAP (
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
          numOfFilters => numOfFilters
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
		ReLU_enabled <= '1';
		Pooling_enabled <= '1';
		pooling_mode <= '0';
		poolDim <= 2;
		image_width <= 64;
		image_height <= 64;
		stride <= 1;
		filterDim <= 3;
		numOfChannels <= 3;
		numOfFilters <= 1;
      wait for clk_period;

      -- insert stimulus here 

      wait;
   end process;

END;
