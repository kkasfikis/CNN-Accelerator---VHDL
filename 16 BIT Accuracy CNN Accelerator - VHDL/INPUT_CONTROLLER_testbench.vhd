LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY INPUT_CONTROLLER_testbench IS
END INPUT_CONTROLLER_testbench;
 
ARCHITECTURE behavior OF INPUT_CONTROLLER_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT input_ctrl
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         data1 : IN  std_logic_vector(31 downto 0);
         data2 : IN  std_logic_vector(31 downto 0);
         valid_write : IN  std_logic_vector(0 downto 0);
         activation_acknowledge : IN  std_logic_vector(31 downto 0);
         buffer_full : OUT  std_logic;
         value1 : OUT  std_logic_vector(31 downto 0);
         value2 : OUT  std_logic_vector(31 downto 0);
         activation_request : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal data1 : std_logic_vector(31 downto 0) := (others => '0');
   signal data2 : std_logic_vector(31 downto 0) := (others => '0');
   signal valid_write : std_logic_vector(0 downto 0) := (others => '0');
   signal activation_acknowledge : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal buffer_full : std_logic;
   signal value1 : std_logic_vector(31 downto 0);
   signal value2 : std_logic_vector(31 downto 0);
   signal activation_request : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: input_ctrl PORT MAP (
          clk => clk,
          rst => rst,
          data1 => data1,
          data2 => data2,
          valid_write => valid_write,
          activation_acknowledge => activation_acknowledge,
          buffer_full => buffer_full,
          value1 => value1,
          value2 => value2,
          activation_request => activation_request
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
		activation_acknowledge <= "00000000000000000000000000000000";
		wait for clk_period;
		data1 <= "00000000000000000000000000000001";
		data2 <= "00000000000000000000000000000010";
		valid_write <= "1";
		wait for clk_period;
		data1 <= "00000000000000000000000000000011";
		data2 <= "00000000000000000000000000000100";
		valid_write <= "1";
		wait for clk_period;
		
		data1 <= "00000000000000000000000000000101";
		data2 <= "00000000000000000000000000000110";
		valid_write <= "1";
      wait for clk_period;
		activation_acknowledge <= "00000000000000000000000000000001";
		data1 <= "00000000000000000000000000000111";
		data2 <= "00000000000000000000000000001000";
		valid_write <= "1";	
		wait for clk_period;
		activation_acknowledge <= "00000000000000000000000000000000";
		data1 <= "00000000000000000000000000000000";
		data2 <= "00000000000000000000000000000000";
		valid_write <= "0";
      -- insert stimulus here 
		wait for clk_period * 10;
		activation_acknowledge <= "00000000000000000000000000000001";
		wait for clk_period;
		activation_acknowledge <= "00000000000000000000000000000010";
		wait for clk_period;
		activation_acknowledge <= "00000000000000000000000000000100";
      wait;
   end process;

END;
