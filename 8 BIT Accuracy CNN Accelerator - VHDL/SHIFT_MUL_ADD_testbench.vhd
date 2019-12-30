--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   04:11:44 06/14/2019
-- Design Name:   
-- Module Name:   C:/diploma_project/SHIFT_MUL_ADD_testbench.vhd
-- Project Name:  diploma_project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: shift_mul_add
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY SHIFT_MUL_ADD_testbench IS
END SHIFT_MUL_ADD_testbench;
 
ARCHITECTURE behavior OF SHIFT_MUL_ADD_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
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

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
