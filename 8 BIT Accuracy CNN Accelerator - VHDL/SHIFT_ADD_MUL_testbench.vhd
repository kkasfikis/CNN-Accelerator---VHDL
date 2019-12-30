
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
 
ENTITY SHIFT_ADD_MUL_testbench IS
END SHIFT_ADD_MUL_testbench;
 
ARCHITECTURE behavior OF SHIFT_ADD_MUL_testbench IS 
 
    COMPONENT shift_mul_add
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         value1 : IN  std_logic_vector(31 downto 0);
         value2 : IN  std_logic_vector(31 downto 0);
         activation_request : IN  std_logic;
         result_acknowledge : IN  std_logic;
         overflow : OUT  std_logic;
         underanked : OUT  std_logic;
         result : OUT  std_logic_vector(31 downto 0);
         activation_acknowledge : OUT  std_logic;
         result_request : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal value1 : std_logic_vector(31 downto 0) := (others => '0');
   signal value2 : std_logic_vector(31 downto 0) := (others => '0');
   signal activation_request : std_logic := '0';
   signal result_acknowledge : std_logic := '0';

 	--Outputs
   signal overflow : std_logic;
   signal underanked : std_logic;
   signal result : std_logic_vector(31 downto 0);
   signal activation_acknowledge : std_logic;
   signal result_request : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: shift_mul_add PORT MAP (
          clk => clk,
          rst => rst,
          value1 => value1,
          value2 => value2,
          activation_request => activation_request,
          result_acknowledge => result_acknowledge,
          overflow => overflow,
          underanked => underanked,
          result => result,
          activation_acknowledge => activation_acknowledge,
          result_request => result_request
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
      -- hold reset state for 100 ns.
		rst <= '1';
      wait for 100 ns;	
		rst <='0';
		value1 <= "00000100000000000000000000000000";
		value2 <= "00000000100000000000000000000000";
		activation_request <='1';
		wait for clk_period;
		activation_request <='0';
      wait for clk_period*9;
		result_acknowledge <= '1';
		wait for clk_period;
		result_acknowledge <= '0';
		activation_request <='1';
		value1 <= "00000100000000000000000000000000";
		value2 <= "00000000010000000000000000000000";
		wait for clk_period;
		activation_request <='0';
		wait for clk_period*9;
		result_acknowledge <='1';
		wait for clk_period*2;
		result_acknowledge <='0';
      -- insert stimulus here 

      wait;
   end process;

END;
