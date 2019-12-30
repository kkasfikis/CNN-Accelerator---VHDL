--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:00:17 07/28/2019
-- Design Name:   
-- Module Name:   C:/CCUacc/SingleFilterCalculator_testbench.vhd
-- Project Name:  CCUacc
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: Single_Filter_Calculator
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
 
ENTITY SingleFilterCalculator_testbench IS
END SingleFilterCalculator_testbench;
 
ARCHITECTURE behavior OF SingleFilterCalculator_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Single_Filter_Calculator
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         stride : IN  std_logic;
         filterDim : IN  std_logic;
         iHeight : IN  std_logic;
         rHeight : IN  std_logic;
         max_x : IN  std_logic;
         max_y : IN  std_logic;
         image_offset : IN  std_logic;
         filter_offset : IN  std_logic;
         filter_column_offset : IN  std_logic;
         image_column_offset : IN  std_logic;
         numOfChannels : IN  std_logic;
         stride_data : IN  std_logic;
         numOfData : IN  std_logic;
         result_baseAddress : IN  std_logic;
         image_burst_request : OUT  std_logic;
         image_burst_acknowledge : IN  std_logic;
         read_image : OUT  std_logic;
         image_addr : OUT  std_logic_vector(31 downto 0);
         image_data_valid : IN  std_logic;
         image_data_out : IN  std_logic_vector(31 downto 0);
         filter_burst_request : OUT  std_logic;
         filter_burst_acknowledge : IN  std_logic;
         read_filter : OUT  std_logic;
         filter_addr : OUT  std_logic_vector(31 downto 0);
         filter_data_valid : IN  std_logic;
         filter_data_out : IN  std_logic_vector(31 downto 0);
         result_activation_request : OUT  std_logic;
         result_activation_acknowledge : IN  std_logic;
         addToExisting : OUT  std_logic;
         result_address : OUT  std_logic_vector(31 downto 0);
         result_data : OUT  std_logic_vector(31 downto 0);
         activation_request : IN  std_logic;
         activation_acknowledge : OUT  std_logic;
         filter_address : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal stride : std_logic := '0';
   signal filterDim : std_logic := '0';
   signal iHeight : std_logic := '0';
   signal rHeight : std_logic := '0';
   signal max_x : std_logic := '0';
   signal max_y : std_logic := '0';
   signal image_offset : std_logic := '0';
   signal filter_offset : std_logic := '0';
   signal filter_column_offset : std_logic := '0';
   signal image_column_offset : std_logic := '0';
   signal numOfChannels : std_logic := '0';
   signal stride_data : std_logic := '0';
   signal numOfData : std_logic := '0';
   signal result_baseAddress : std_logic := '0';
   signal image_burst_acknowledge : std_logic := '0';
   signal image_data_valid : std_logic := '0';
   signal image_data_out : std_logic_vector(31 downto 0) := (others => '0');
   signal filter_burst_acknowledge : std_logic := '0';
   signal filter_data_valid : std_logic := '0';
   signal filter_data_out : std_logic_vector(31 downto 0) := (others => '0');
   signal result_activation_acknowledge : std_logic := '0';
   signal activation_request : std_logic := '0';
   signal filter_address : std_logic := '0';

 	--Outputs
   signal image_burst_request : std_logic;
   signal read_image : std_logic;
   signal image_addr : std_logic_vector(31 downto 0);
   signal filter_burst_request : std_logic;
   signal read_filter : std_logic;
   signal filter_addr : std_logic_vector(31 downto 0);
   signal result_activation_request : std_logic;
   signal addToExisting : std_logic;
   signal result_address : std_logic_vector(31 downto 0);
   signal result_data : std_logic_vector(31 downto 0);
   signal activation_acknowledge : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Single_Filter_Calculator PORT MAP (
          clk => clk,
          rst => rst,
          stride => stride,
          filterDim => filterDim,
          iHeight => iHeight,
          rHeight => rHeight,
          max_x => max_x,
          max_y => max_y,
          image_offset => image_offset,
          filter_offset => filter_offset,
          filter_column_offset => filter_column_offset,
          image_column_offset => image_column_offset,
          numOfChannels => numOfChannels,
          stride_data => stride_data,
          numOfData => numOfData,
          result_baseAddress => result_baseAddress,
          image_burst_request => image_burst_request,
          image_burst_acknowledge => image_burst_acknowledge,
          read_image => read_image,
          image_addr => image_addr,
          image_data_valid => image_data_valid,
          image_data_out => image_data_out,
          filter_burst_request => filter_burst_request,
          filter_burst_acknowledge => filter_burst_acknowledge,
          read_filter => read_filter,
          filter_addr => filter_addr,
          filter_data_valid => filter_data_valid,
          filter_data_out => filter_data_out,
          result_activation_request => result_activation_request,
          result_activation_acknowledge => result_activation_acknowledge,
          addToExisting => addToExisting,
          result_address => result_address,
          result_data => result_data,
          activation_request => activation_request,
          activation_acknowledge => activation_acknowledge,
          filter_address => filter_address
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
		stride<= 3;
		filterDim <= 4;
		iHeight <= 8;
		max_x <= 5;
		max_y <= 5;
		image_offset <= 64;
		filter_offset <= 16;
      image_column_offset <= 8;
		filter_column_offset <= 4;
		numOfChannels <= 3;
		stride_data <= 12;
		numOfData <= 16;
		filter_address <= 0;
		activation_request <= '1';
		wait for clk_period;
		activation_request <= '0';
      wait;
   end process;

END;
