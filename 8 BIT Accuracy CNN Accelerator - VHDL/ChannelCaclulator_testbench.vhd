--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   04:40:51 07/20/2019
-- Design Name:   
-- Module Name:   C:/CCUacc/ChannelCaclulator_testbench.vhd
-- Project Name:  CCUacc
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Channel_Calculator
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
 
ENTITY ChannelCaclulator_testbench IS
END ChannelCaclulator_testbench;
 
ARCHITECTURE behavior OF ChannelCaclulator_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Channel_Calculator
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         activation_request : IN  std_logic;
         activation_acknowledge : OUT  std_logic;
         mode : IN  std_logic_vector(1 downto 0);
         stride_data : IN  std_logic;
         numOfData : IN  std_logic;
         data1 : IN  std_logic_vector(31 downto 0);
         data1_valid : IN  std_logic;
         data2 : IN  std_logic_vector(31 downto 0);
         data2_valid : IN  std_logic;
         sum : IN  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal activation_request : std_logic := '0';
   signal mode : std_logic_vector(1 downto 0) := (others => '0');
   signal stride_data : std_logic := '0';
   signal numOfData : std_logic := '0';
   signal data1 : std_logic_vector(31 downto 0) := (others => '0');
   signal data1_valid : std_logic := '0';
   signal data2 : std_logic_vector(31 downto 0) := (others => '0');
   signal data2_valid : std_logic := '0';
   signal sum : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal activation_acknowledge : std_logic;

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
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
