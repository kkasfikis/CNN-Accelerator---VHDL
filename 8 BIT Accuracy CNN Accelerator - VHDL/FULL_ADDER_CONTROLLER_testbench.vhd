LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
ENTITY FULL_ADDER_CONTROLLER_testbench IS
END FULL_ADDER_CONTROLLER_testbench;
 
ARCHITECTURE behavior OF FULL_ADDER_CONTROLLER_testbench IS 
 
    COMPONENT full_adder_ctrl
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         result0 : IN  std_logic_vector(31 downto 0);
         result1 : IN  std_logic_vector(31 downto 0);
         result2 : IN  std_logic_vector(31 downto 0);
         result3 : IN  std_logic_vector(31 downto 0);
         result4 : IN  std_logic_vector(31 downto 0);
         result5 : IN  std_logic_vector(31 downto 0);
         result6 : IN  std_logic_vector(31 downto 0);
         result7 : IN  std_logic_vector(31 downto 0);
         result8 : IN  std_logic_vector(31 downto 0);
         result9 : IN  std_logic_vector(31 downto 0);
         result10 : IN  std_logic_vector(31 downto 0);
         result11 : IN  std_logic_vector(31 downto 0);
         result12 : IN  std_logic_vector(31 downto 0);
         result13 : IN  std_logic_vector(31 downto 0);
         result14 : IN  std_logic_vector(31 downto 0);
         result15 : IN  std_logic_vector(31 downto 0);
         result16 : IN  std_logic_vector(31 downto 0);
         result17 : IN  std_logic_vector(31 downto 0);
         result18 : IN  std_logic_vector(31 downto 0);
         result19 : IN  std_logic_vector(31 downto 0);
         result20 : IN  std_logic_vector(31 downto 0);
         result21 : IN  std_logic_vector(31 downto 0);
         result22 : IN  std_logic_vector(31 downto 0);
         result23 : IN  std_logic_vector(31 downto 0);
         result24 : IN  std_logic_vector(31 downto 0);
         result25 : IN  std_logic_vector(31 downto 0);
         result26 : IN  std_logic_vector(31 downto 0);
         result27 : IN  std_logic_vector(31 downto 0);
         result28 : IN  std_logic_vector(31 downto 0);
         result29 : IN  std_logic_vector(31 downto 0);
         result30 : IN  std_logic_vector(31 downto 0);
         result31 : IN  std_logic_vector(31 downto 0);
         result_request : IN  std_logic_vector(31 downto 0);
			numOfData : in integer range 0 to 4096;
         buffer_full : OUT  std_logic;
         sum : OUT  std_logic_vector(31 downto 0);
         final_sum : OUT  std_logic;
         result_acknowledge : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal result0 : std_logic_vector(31 downto 0) := (others => '0');
   signal result1 : std_logic_vector(31 downto 0) := (others => '0');
   signal result2 : std_logic_vector(31 downto 0) := (others => '0');
   signal result3 : std_logic_vector(31 downto 0) := (others => '0');
   signal result4 : std_logic_vector(31 downto 0) := (others => '0');
   signal result5 : std_logic_vector(31 downto 0) := (others => '0');
   signal result6 : std_logic_vector(31 downto 0) := (others => '0');
   signal result7 : std_logic_vector(31 downto 0) := (others => '0');
   signal result8 : std_logic_vector(31 downto 0) := (others => '0');
   signal result9 : std_logic_vector(31 downto 0) := (others => '0');
   signal result10 : std_logic_vector(31 downto 0) := (others => '0');
   signal result11 : std_logic_vector(31 downto 0) := (others => '0');
   signal result12 : std_logic_vector(31 downto 0) := (others => '0');
   signal result13 : std_logic_vector(31 downto 0) := (others => '0');
   signal result14 : std_logic_vector(31 downto 0) := (others => '0');
   signal result15 : std_logic_vector(31 downto 0) := (others => '0');
   signal result16 : std_logic_vector(31 downto 0) := (others => '0');
   signal result17 : std_logic_vector(31 downto 0) := (others => '0');
   signal result18 : std_logic_vector(31 downto 0) := (others => '0');
   signal result19 : std_logic_vector(31 downto 0) := (others => '0');
   signal result20 : std_logic_vector(31 downto 0) := (others => '0');
   signal result21 : std_logic_vector(31 downto 0) := (others => '0');
   signal result22 : std_logic_vector(31 downto 0) := (others => '0');
   signal result23 : std_logic_vector(31 downto 0) := (others => '0');
   signal result24 : std_logic_vector(31 downto 0) := (others => '0');
   signal result25 : std_logic_vector(31 downto 0) := (others => '0');
   signal result26 : std_logic_vector(31 downto 0) := (others => '0');
   signal result27 : std_logic_vector(31 downto 0) := (others => '0');
   signal result28 : std_logic_vector(31 downto 0) := (others => '0');
   signal result29 : std_logic_vector(31 downto 0) := (others => '0');
   signal result30 : std_logic_vector(31 downto 0) := (others => '0');
   signal result31 : std_logic_vector(31 downto 0) := (others => '0');
   signal result_request : std_logic_vector(31 downto 0) := (others => '0');
	signal numOfData : integer range 0 to 4096;
 	--Outputs
   signal buffer_full : std_logic;
   signal sum : std_logic_vector(31 downto 0);
   signal final_sum : std_logic;
   signal result_acknowledge : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: full_adder_ctrl PORT MAP (
          clk => clk,
          rst => rst,
          result0 => result0,
          result1 => result1,
          result2 => result2,
          result3 => result3,
          result4 => result4,
          result5 => result5,
          result6 => result6,
          result7 => result7,
          result8 => result8,
          result9 => result9,
          result10 => result10,
          result11 => result11,
          result12 => result12,
          result13 => result13,
          result14 => result14,
          result15 => result15,
          result16 => result16,
          result17 => result17,
          result18 => result18,
          result19 => result19,
          result20 => result20,
          result21 => result21,
          result22 => result22,
          result23 => result23,
          result24 => result24,
          result25 => result25,
          result26 => result26,
          result27 => result27,
          result28 => result28,
          result29 => result29,
          result30 => result30,
          result31 => result31,
          result_request => result_request,
			 numOfData => numOfData,
          buffer_full => buffer_full,
          sum => sum,
          final_sum => final_sum,
          result_acknowledge => result_acknowledge
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '1';
		wait for clk_period/2;
		clk <= '0';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      rst<='1';
      wait for 100 ns;	
		rst<='0';
		numOfData <= 2;
		wait for clk_period*20;
		result0<= "00000000000000000000000000000001";
		result1<= "00000000000000000000000000000010";
		result_request <= "00000000000000000000000000000011";
		wait for clk_period * 2;
		result_request <= "00000000000000000000000000000010";
		wait for clk_period * 2;
		result_request <= "00000000000000000000000000000000";
      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
