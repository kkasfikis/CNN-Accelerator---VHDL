LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY MemCtrl_testbench IS
END MemCtrl_testbench;
 
ARCHITECTURE behavior OF MemCtrl_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT MEM_CTRL
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         mode : IN  std_logic_vector(1 downto 0);
         stride_data : IN  integer;
         numOfData : IN  integer;
         data1 : IN  std_logic_vector(31 downto 0);
         data1_valid : IN  std_logic;
         data2 : IN  std_logic_vector(31 downto 0);
         data2_valid : IN  std_logic;
         CCU_buffer_full : IN  std_logic;
         value1 : OUT  std_logic_vector(31 downto 0);
         value2 : OUT  std_logic_vector(31 downto 0);
         value_valid : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal mode : std_logic_vector(1 downto 0) := (others => '0');
   signal stride_data : integer := 0;
   signal numOfData : integer := 0;
   signal data1 : std_logic_vector(31 downto 0) := (others => '0');
   signal data1_valid : std_logic := '0';
   signal data2 : std_logic_vector(31 downto 0) := (others => '0');
   signal data2_valid : std_logic := '0';
   signal CCU_buffer_full : std_logic := '0';

 	--Outputs
   signal value1 : std_logic_vector(31 downto 0);
   signal value2 : std_logic_vector(31 downto 0);
   signal value_valid : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: MEM_CTRL PORT MAP (
          clk => clk,
          rst => rst,
          mode => mode,
          stride_data => stride_data,
          numOfData => numOfData,
          data1 => data1,
          data1_valid => data1_valid,
          data2 => data2,
          data2_valid => data2_valid,
          CCU_buffer_full => CCU_buffer_full,
          value1 => value1,
          value2 => value2,
          value_valid => value_valid
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
      wait for clk_period*10;	
		rst <= '0';
		numOfData <= 4;
		stride_data <= 2;
		mode <= "11";
		wait for clk_period;
		mode <= "00";
		CCU_buffer_full <= '0';
		data1 <= "00000000000000000000000000000001";
		data1_valid <= '1';
		data2 <= "00000000000000000000000000000000";
		data2_valid <= '0';
		wait for clk_period;	
		data1 <= "00000000000000000000000000000010";
		data1_valid <= '1';
		data2 <= "00000000000000000000000000000001";
		data2_valid <= '1';
		wait for clk_period;	
		data1 <= "00000000000000000000000000000100";
		data1_valid <= '1';
		data2 <= "00000000000000000000000000000000";
		data2_valid <= '0';
		wait for clk_period;	
		data1 <= "00000000000000000000000000001000";
		data1_valid <= '1';
		data2 <= "00000000000000000000000000000010";
		data2_valid <= '1';
		
		wait for clk_period;		
		data1 <= "00000000000000000000000000000000";
		data1_valid <= '0';
		data2 <= "00000000000000000000000000000000";
		data2_valid <= '0';
		wait for clk_period;	
		CCU_buffer_full <= '1';
		data1 <= "00000000000000000000000000000000";
		data1_valid <= '0';
		data2 <= "00000000000000000000000000000100";
		data2_valid <= '1';
		
		wait for clk_period;	
		
		data1 <= "00000000000000000000000000000000";
		data1_valid <= '0';
		data2 <= "00000000000000000000000000000000";
		data2_valid <= '0';
		wait for clk_period;		
		
		data1 <= "00000000000000000000000000000000";
		data1_valid <= '0';
		data2 <= "00000000000000000000000000001000";
		data2_valid <= '1';
		wait for clk_period;	
		CCU_buffer_full <= '0';
		data1_valid <= '0';
		data2_valid <= '0';
		wait for clk_period*20;
		mode <= "01";
		wait for clk_period;
		mode <= "00";
		data1 <= "00000000000000000000000000000011";
		data1_valid <= '1';
		wait for clk_period;
		data1 <= "00000000000000000000000000000110";
		data1_valid <= '1';
	   wait for clk_period;
		data1 <= "00000000000000000000000000001100";
		data1_valid <= '1';
		wait for clk_period;
		data1 <= "00000000000000000000000000011000";
		data1_valid <= '1';
		wait for clk_period;
		data1_valid <= '0';
		wait for clk_period*20;
		mode <= "10";
		wait for clk_period;
		mode <= "00";
		data1 <= "00000000000000000000000000011100";
		data1_valid <= '1';
		wait for clk_period;
		data1 <= "00000000000000000000000000111000";
		data1_valid <= '1';
		wait for clk_period;
		data1_valid <= '0';
		wait for clk_period*20;
		mode <= "10";
		wait for clk_period;
		mode <= "00";
		data1 <= "00000000000000000000000000111100";
		data1_valid <= '1';
		wait for clk_period;
		data1 <= "00000000000000000000000001111000";
		data1_valid <= '1';
		wait for clk_period;
		data1_valid <= '0';
	   wait;
   end process;

END;
