LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY ResultRAM_IC_testbench IS
END ResultRAM_IC_testbench;
 
ARCHITECTURE behavior OF ResultRAM_IC_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Result_RAM_IC
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         init_file : IN  std_logic;
         dataSize : IN  std_logic_vector(31 downto 0);
         activation_request : IN  std_logic;
         activation_acknowledge : OUT  std_logic;
			addToExisting : in std_logic;
         result_address : IN  std_logic_vector(31 downto 0);
         result_data : IN  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal init_file : std_logic := '0';
   signal dataSize : std_logic_vector(31 downto 0) := (others => '0');
   signal activation_request : std_logic := '0';
	signal addToExisting : std_logic := '0';
   signal result_address : std_logic_vector(31 downto 0) := (others => '0');
   signal result_data : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal activation_acknowledge : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Result_RAM_IC PORT MAP (
          clk => clk,
          rst => rst,
          init_file => init_file,
          dataSize => dataSize,
          activation_request => activation_request,
          activation_acknowledge => activation_acknowledge,
			 addToExisting => addToExisting,
          result_address => result_address,
          result_data => result_data
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
      wait for 100 ns;	
		rst <= '1';
      wait for clk_period*10;
		rst <= '0';
		addToExisting <= '0';
		init_file <= '1';
		dataSize <= "00000000000000000000000001111001";
		wait for clk_period;
		init_file <= '0';
		wait for clk_period*5;
		result_address <= "00000000000000000000000000000001";
		result_data <= "00000001000000000000000000000000";
		activation_request <= '1';
		wait for clk_period;
		activation_request <= '0';
		wait for clk_period*5;
		result_address <= "00000000000000000000000000100000";
		result_data <= "00000011000000000000000000000000";
		activation_request <= '1';
		wait for clk_period;
		activation_request <= '0';
		wait for clk_period*5;
		result_address <= "00000000000000000000000001100011";
		result_data <= "00000111000000000000000000000000";
		activation_request <= '1';
		wait for clk_period;
		activation_request <= '0';
		wait for clk_period*5;
		addToExisting <= '1';
		result_address <= "00000000000000000000000001100011";
		result_data <= "00000111000000000000000000000000";
		activation_request <= '1';
		wait for clk_period;
		activation_request <= '0';
      -- insert stimulus here 

      wait;
   end process;

END;
