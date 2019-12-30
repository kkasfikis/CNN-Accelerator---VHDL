
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY Pooling_testbench IS
END Pooling_testbench;
 
ARCHITECTURE behavior OF Pooling_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Pooling
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         pool_size : IN  integer;
         pHeight : IN  integer;
         poolOffset : IN  integer;
         pooling_enabled : IN  std_logic;
         pooling_mode : IN  std_logic;
         framer_mode : IN  std_logic_vector(1 downto 0);
         framer_lastChannels : IN  std_logic;
         result_value : IN  std_logic_vector(31 downto 0);
         activation_request : IN  std_logic;
         pool_address : OUT  std_logic_vector(31 downto 0);
         pool_data : OUT  std_logic_vector(31 downto 0);
         pool_data_valid : OUT  std_logic;
         activation_acknowledge : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal pool_size : integer := 0;
   signal pHeight : integer := 0;
   signal poolOffset : integer := 0;
   signal pooling_enabled : std_logic := '0';
   signal pooling_mode : std_logic := '0';
   signal framer_mode : std_logic_vector(1 downto 0) := (others => '0');
   signal framer_lastChannels : std_logic := '0';
   signal result_value : std_logic_vector(31 downto 0) := (others => '0');
   signal activation_request : std_logic := '0';

 	--Outputs
   signal pool_address : std_logic_vector(31 downto 0);
   signal pool_data : std_logic_vector(31 downto 0);
   signal pool_data_valid : std_logic;
   signal activation_acknowledge : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Pooling PORT MAP (
          clk => clk,
          rst => rst,
          pool_size => pool_size,
          pHeight => pHeight,
          poolOffset => poolOffset,
          pooling_enabled => pooling_enabled,
          pooling_mode => pooling_mode,
          framer_mode => framer_mode,
          framer_lastChannels => framer_lastChannels,
          result_value => result_value,
          activation_request => activation_request,
          pool_address => pool_address,
          pool_data => pool_data,
          pool_data_valid => pool_data_valid,
          activation_acknowledge => activation_acknowledge
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
		pool_size <= 2;
		pHeight <= 2;
		poolOffset <= 0;
		pooling_enabled <= '1';
		pooling_mode <= '1';
      wait for 100 ns;	
		rst <= '0';
		activation_request <= '1';
		framer_mode <= "11";
		result_value <= "00000000000000000000000000010000";
		wait for clk_period;
		activation_request <= '0';
		wait for clk_period * 10;
		
		activation_request <= '1';
		framer_mode <= "10";
		result_value <= "00000000000000000000000000001001";
		wait for clk_period;
		activation_request <= '0';
		wait for clk_period * 10;
		
		activation_request <= '1';
		framer_mode <= "10";
		result_value <= "10000000000000000000000000100000";
		wait for clk_period;
		activation_request <= '0';
		wait for clk_period * 10;
		
		activation_request <= '1';
		framer_mode <= "10";
		result_value <= "00000000000000000000000001001000";
		wait for clk_period;
		activation_request <= '0';
		wait for clk_period * 10;
		
		activation_request <= '1';
		framer_mode <= "10";
		result_value <= "00000000000000000000111100000000";
		wait for clk_period;
		activation_request <= '0';
		wait for clk_period * 10;
		
		
		
		
		activation_request <= '1';
		framer_mode <= "01";
		result_value <= "00000000000000000000000000000010";
		wait for clk_period;
		activation_request <= '0';
		wait for clk_period * 10;
		
		activation_request <= '1';
		framer_mode <= "10";
		result_value <= "00000000000000000000000000000101";
		wait for clk_period;
		activation_request <= '0';
		wait for clk_period * 10;
		
		activation_request <= '1';
		framer_mode <= "10";
		result_value <= "00000000000000000000000001000001";
		wait for clk_period;
		activation_request <= '0';
		wait for clk_period * 10;
		
		activation_request <= '1';
		framer_mode <= "10";
		result_value <= "10000000000000000000000000001011";
		wait for clk_period;
		activation_request <= '0';
		wait for clk_period * 10;
		
		activation_request <= '1';
		framer_mode <= "10";
		result_value <= "00000000000000000000111100000000";
		wait for clk_period;
		activation_request <= '0';
		wait for clk_period * 10;
		
		
		
		
				
		activation_request <= '1';
		framer_mode <= "01";
		result_value <= "00000000000000000000000000001010";
		wait for clk_period;
		activation_request <= '0';
		wait for clk_period * 10;
		
		activation_request <= '1';
		framer_mode <= "10";
		result_value <= "10000000000000000000000000000100";
		wait for clk_period;
		activation_request <= '0';
		wait for clk_period * 10;
		
		activation_request <= '1';
		framer_mode <= "10";
		result_value <= "00000000000000000000000000010011";
		wait for clk_period;
		activation_request <= '0';
		wait for clk_period * 10;
		
		activation_request <= '1';
		framer_mode <= "10";
		result_value <= "10000000000000000000000000010111";
		wait for clk_period;
		activation_request <= '0';
		wait for clk_period * 10;
		
		activation_request <= '1';
		framer_mode <= "10";
		result_value <= "00000000000000000000111100000000";
		wait for clk_period;
		activation_request <= '0';
		wait for clk_period * 10;
		
		
		
				
		activation_request <= '1';
		framer_mode <= "01";
		result_value <= "10000000000000000000000000011000";
		wait for clk_period;
		activation_request <= '0';
		wait for clk_period * 10;
		
		activation_request <= '1';
		framer_mode <= "10";
		result_value <= "00000000000000000000000000010010";
		wait for clk_period;
		activation_request <= '0';
		wait for clk_period * 10;
		
		activation_request <= '1';
		framer_mode <= "10";
		result_value <= "00000000000000000000000000000101";
		wait for clk_period;
		activation_request <= '0';
		wait for clk_period * 10;
		
		activation_request <= '1';
		framer_mode <= "10";
		result_value <= "00000000000000000000000000000100";
		wait for clk_period;
		activation_request <= '0';
		wait for clk_period * 10;
		
		activation_request <= '1';
		framer_mode <= "10";
		result_value <= "00000000000000000000111100000000";
		wait for clk_period;
		activation_request <= '0';
		wait for clk_period * 10;
		
      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
