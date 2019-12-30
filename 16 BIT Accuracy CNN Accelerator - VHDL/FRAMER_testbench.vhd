LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FRAMER_testbench IS
END FRAMER_testbench;
 
ARCHITECTURE behavior OF FRAMER_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FRAMER
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         max_x : IN  integer;
         max_y : IN  integer;
         iHeight : IN  integer;
         stride : IN  integer;
         filterDim : IN  integer;
         filter_address : IN  integer;
         activation_request : IN  std_logic;
         activation_acknowledge : OUT  std_logic;
         frameCalc_request : OUT  std_logic;
         collector_acknowledge : IN  std_logic;
         mode : OUT  std_logic_vector(1 downto 0);
         baseAddress_image : OUT  integer;
         baseAddress_filter : OUT  integer
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal max_x : integer := 0;
   signal max_y : integer := 0;
   signal iHeight : integer := 0;
   signal stride : integer := 0;
   signal filterDim : integer := 0;
   signal filter_address : integer := 0;
   signal activation_request : std_logic := '0';
   signal collector_acknowledge : std_logic := '0';

 	--Outputs
   signal activation_acknowledge : std_logic;
   signal frameCalc_request : std_logic;
   signal mode : std_logic_vector(1 downto 0);
   signal baseAddress_image : integer;
   signal baseAddress_filter : integer;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FRAMER PORT MAP (
          clk => clk,
          rst => rst,
          max_x => max_x,
          max_y => max_y,
          iHeight => iHeight,
          stride => stride,
          filterDim => filterDim,
          filter_address => filter_address,
          activation_request => activation_request,
          activation_acknowledge => activation_acknowledge,
          frameCalc_request => frameCalc_request,
          collector_acknowledge => collector_acknowledge,
          mode => mode,
          baseAddress_image => baseAddress_image,
          baseAddress_filter => baseAddress_filter
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
      -- hold reset state for 100 ns.
      rst <= '1';
		wait for 100 ns;	
		rst <= '0';
		max_x <= 5;
		max_y <= 5;
		iHeight <= 8;
		stride <= 3;
		filterDim <= 4;
		filter_address <= 0;
		activation_request <= '1';
		wait for clk_period;
		activation_request <= '0';
      wait for clk_period*5;
		collector_acknowledge <= '1';
		wait for clk_period;
		collector_acknowledge <= '0';
		wait for clk_period*5;
		collector_acknowledge <= '1';
		wait for clk_period;
		collector_acknowledge<= '0';
		wait for clk_period*5;
		collector_acknowledge<= '1';
		wait for clk_period;
		collector_acknowledge<= '0';
		wait for clk_period*5;
		collector_acknowledge<= '1';
		wait for clk_period;
		collector_acknowledge<= '0';
		wait for clk_period*5;
		collector_acknowledge<= '1';
		wait for clk_period;
		collector_acknowledge<= '0';
		wait for clk_period*5;
		collector_acknowledge<= '1';
		wait for clk_period;
		collector_acknowledge<= '0';
		wait for clk_period*5;
		collector_acknowledge<= '1';
		wait for clk_period;
		collector_acknowledge<= '0';
		wait for clk_period*5;
		collector_acknowledge<= '1';
		wait for clk_period;
		collector_acknowledge<= '0';
		wait for clk_period*5;
		collector_acknowledge<= '1';
		wait for clk_period;
		collector_acknowledge<= '0';
		wait for clk_period*5;
		collector_acknowledge<= '1';
		wait for clk_period;
		collector_acknowledge<= '0';
		wait for clk_period*5;
		collector_acknowledge<= '1';
		wait for clk_period;
		collector_acknowledge<= '0';
		wait for clk_period*5;
		collector_acknowledge<= '1';
		wait for clk_period;
		collector_acknowledge<= '0';
		wait for clk_period*5;
		collector_acknowledge<= '1';
		wait for clk_period;
		collector_acknowledge<= '0';
		wait for clk_period*5;
		collector_acknowledge<= '1';
		wait for clk_period;
		collector_acknowledge<= '0';
		wait for clk_period*5;
		collector_acknowledge<= '1';
		wait for clk_period;
		collector_acknowledge<= '0';
		wait for clk_period*5;
		collector_acknowledge<= '1';
		wait for clk_period;
		collector_acknowledge<= '0';
		wait for clk_period*5;
		collector_acknowledge<= '1';
		wait for clk_period;
		collector_acknowledge<= '0';
		wait for clk_period*5;
		collector_acknowledge<= '1';
		wait for clk_period;
		collector_acknowledge<= '0';
		wait for clk_period*5;
		collector_acknowledge<= '1';
		wait for clk_period;
		collector_acknowledge<= '0';
		wait for clk_period*5;
		collector_acknowledge<= '1';
		wait for clk_period;
		collector_acknowledge<= '0';
		wait for clk_period*5;
		collector_acknowledge<= '1';
		wait for clk_period;
		collector_acknowledge<= '0';
		wait for clk_period*5;
		collector_acknowledge<= '1';
		wait for clk_period;
		collector_acknowledge<= '0';
		wait for clk_period*5;
		collector_acknowledge<= '1';
		wait for clk_period;
		collector_acknowledge<= '0';
		wait for clk_period*5;
		collector_acknowledge<= '1';
		wait for clk_period;
		collector_acknowledge<= '0';
		wait for clk_period*5;
		collector_acknowledge<= '1';
		wait for clk_period;
		collector_acknowledge<= '0';

      -- insert stimulus here 

      wait;
   end process;

END;
