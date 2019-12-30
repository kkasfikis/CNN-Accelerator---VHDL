LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY CCU_testbench IS
END CCU_testbench;
 
ARCHITECTURE behavior OF CCU_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Convolution_Calc_Unit
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         data1 : IN  std_logic_vector(32 downto 0);
         data2 : IN  std_logic_vector(31 downto 0);
         valid_write : IN  std_logic_vector(0 downto 0);
			numOfData : IN integer range 0 to 4096;
			mode : in std_logic_vector(1 downto 0);
         buffer_full : OUT  std_logic;
         buffer_full_1 : OUT  std_logic;
         sum : OUT  std_logic_vector(31 downto 0);
         final_sum : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal data1 : std_logic_vector(32 downto 0) := (others => '0');
   signal data2 : std_logic_vector(31 downto 0) := (others => '0');
   signal valid_write : std_logic_vector(0 downto 0) := (others => '0');
	signal numOfData : integer range 0 to 4096;
	signal mode : std_logic_vector(1 downto 0);
 	--Outputs
   signal buffer_full : std_logic;
   signal buffer_full_1 : std_logic;
   signal sum : std_logic_vector(31 downto 0);
   signal final_sum : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Convolution_Calc_Unit PORT MAP (
          clk => clk,
          rst => rst,
          data1 => data1,
          data2 => data2,
          valid_write => valid_write,
			 numOfData => numOfData,
			 mode => mode,
          buffer_full => buffer_full,
          buffer_full_1 => buffer_full_1,
          sum => sum,
          final_sum => final_sum
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
		mode <= "00";
		valid_write <= "0";
		numOfData <= 4;
		wait for clk_period;
		valid_write <= "1";
		data1 <= "000000001000000000000000000000000"; -- +2
		data2 <= "00000010000000000000000000000000";
		wait for clk_period;
		valid_write <= "1";
		data1 <= "100000001000000000000000000000000";-- -1
		data2 <= "00000001000000000000000000000000";
		wait for clk_period;
		valid_write <= "1";
		data1 <= "000000101000000000000000000000000";-- +30
		data2 <= "00000110000000000000000000000000";
		wait for clk_period;
		valid_write <= "1";
		data1 <= "100000011000000000000000000000000";-- -9
		data2 <= "00000011000000000000000000000000";
		wait for clk_period;
		valid_write <= "0";
		wait for clk_period*30;
		mode <= "10";
		numOfData <= 4;
		wait for clk_period;
		mode <= "00";
		wait for clk_period;
		valid_write <= "1";
		data1 <= "000000001000000000000000000000000"; -- +2
		data2 <= "00000010000000000000000000000000";
		wait for clk_period;
		valid_write <= "1";
		data1 <= "100000001000000000000000000000000";-- -1
		data2 <= "00000001000000000000000000000000";
		wait for clk_period;
		valid_write <= "1";
		data1 <= "000000101000000000000000000000000";-- +30
		data2 <= "00000110000000000000000000000000";
		wait for clk_period;
		valid_write <= "1";
		data1 <= "100000011000000000000000000000000";-- -9
		data2 <= "00000011000000000000000000000000";
		wait for clk_period;
		valid_write <= "0";
      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
