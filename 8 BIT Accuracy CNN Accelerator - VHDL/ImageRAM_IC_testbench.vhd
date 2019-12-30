LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ImageRAM_IC_testbench IS
END ImageRAM_IC_testbench;
 
ARCHITECTURE behavior OF ImageRAM_IC_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Image_RAM_IC
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         burst_request : IN  std_logic;
         burst_acknowledge : OUT  std_logic;
         burst_size : IN  std_logic_vector(31 downto 0);
         finished : IN  std_logic;
         read_image : IN  std_logic;
         image_addr : IN  std_logic_vector(31 downto 0);
         image_data_valid : OUT  std_logic;
         image_data_out : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal burst_request : std_logic := '0';
   signal burst_size : std_logic_vector(31 downto 0) := (others => '0');
   signal finished : std_logic := '0';
   signal read_image : std_logic := '0';
   signal image_addr : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal burst_acknowledge : std_logic;
   signal image_data_valid : std_logic;
   signal image_data_out : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Image_RAM_IC PORT MAP (
          clk => clk,
          rst => rst,
          burst_request => burst_request,
          burst_acknowledge => burst_acknowledge,
          burst_size => burst_size,
          finished => finished,
          read_image => read_image,
          image_addr => image_addr,
          image_data_valid => image_data_valid,
          image_data_out => image_data_out
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
		wait for clk_period;
		burst_size <= "00000000000000000000000000001000";
		image_addr <= "00000000000000000000000000000110";
		read_image <= '1';
		burst_request <= '1';
		wait for clk_period;
		read_image <= '0';
		burst_request <= '0';
      -- insert stimulus here 

      wait;
   end process;

END;
