LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ChannelCalculator_testbench IS
END ChannelCalculator_testbench;
 
ARCHITECTURE behavior OF ChannelCalculator_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Channel_Calculator
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         activation_request : IN  std_logic;
         activation_acknowledge : OUT  std_logic;
         mode : IN  std_logic_vector(1 downto 0);
         stride_data : IN  integer;
         numOfData : IN  integer;
         data1 : IN  std_logic_vector(31 downto 0);
         data1_valid : IN  std_logic;
         data2 : IN  std_logic_vector(31 downto 0);
         data2_valid : IN  std_logic;
         sum : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal activation_request : std_logic := '0';
   signal mode : std_logic_vector(1 downto 0) := (others => '0');
   signal stride_data : integer := 0;
   signal numOfData : integer := 0;
   signal data1 : std_logic_vector(31 downto 0) := (others => '0');
   signal data1_valid : std_logic := '0';
   signal data2 : std_logic_vector(31 downto 0) := (others => '0');
   signal data2_valid : std_logic := '0';

 	--Outputs
   signal activation_acknowledge : std_logic;
   signal sum : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Channel_Calculator PORT MAP (
          clk => clk,
          rst => rst,
          activation_request => activation_request,
          activation_acknowledge => activation_acknowledge,
          mode => mode,
          stride_data => stride_data,
          numOfData => numOfData,
          data1 => data1,
          data1_valid => data1_valid,
          data2 => data2,
          data2_valid => data2_valid,
          sum => sum
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
		activation_request <= '1';
		mode <= "11";
		stride_data <= 2;
		numOfData <= 4;
		wait for clk_period;
		activation_request <= '0';
		data1 <= "00000001000000000000000000000000";
		data1_valid <= '1';
		data2 <= "00000000000000000000000000000000";
		data2_valid <= '0';
		wait for clk_period;	
		data1 <= "00000010000000000000000000000000";
		data1_valid <= '1';
		data2 <= "00000001000000000000000000000000";
		data2_valid <= '1';
		wait for clk_period;	
		data1 <= "00000100000000000000000000000000";
		data1_valid <= '1';
		data2 <= "00000000000000000000000000000000";
		data2_valid <= '0';
		wait for clk_period;	
		data1 <= "00001000000000000000000000000000";
		data1_valid <= '1';
		data2 <= "00000010000000000000000000000000";
		data2_valid <= '1';
		wait for clk_period;		
		data1 <= "00000000000000000000000000000000";
		data1_valid <= '0';
		data2 <= "00000000000000000000000000000000";
		data2_valid <= '0';
		wait for clk_period;	
		data1 <= "00000000000000000000000000000000";
		data1_valid <= '0';
		data2 <= "00000100000000000000000000000000";
		data2_valid <= '1';
		wait for clk_period;	
		data1 <= "00000000000000000000000000000000";
		data1_valid <= '0';
		data2 <= "00000000000000000000000000000000";
		data2_valid <= '0';
		wait for clk_period;	
		data1 <= "00000000000000000000000000000000";
		data1_valid <= '0';
		data2 <= "00001000000000000000000000000000";
		data2_valid <= '1';
		wait for clk_period;	
		data1_valid <= '0';
		data2_valid <= '0';
      wait for clk_period*30;
		mode <= "10";
		activation_request <='1';
		wait for clk_period;
		activation_request <='0';
		data1 <= "00000010000000000000000000000000";
		data1_valid <= '1';
		wait for clk_period;
		data1 <= "00000100000000000000000000000000";
		data1_valid <= '1';
		wait for clk_period;
		data1_valid <= '0';
		wait for clk_period*30;
		activation_request <= '1';
		mode <= "01";
		wait for clk_period;
		activation_request <='0';
		data1 <= "00000010000000000000000000000000";
		data1_valid <= '1';
		wait for clk_period;
		data1 <= "00000100000000000000000000000000";
		data1_valid <= '1';
		wait for clk_period;
		data1 <= "00001000000000000000000000000000";
		data1_valid <= '1';
		wait for clk_period;
		data1 <= "00010000000000000000000000000000";
		data1_valid <= '1';
		wait for clk_period;
		data1_valid <= '0';

      -- insert stimulus here 

      wait;
   end process;

END;
