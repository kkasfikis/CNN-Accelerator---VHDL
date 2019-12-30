--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   03:42:08 07/21/2019
-- Design Name:   
-- Module Name:   C:/CCUacc/ChannelSelector_testbench.vhd
-- Project Name:  CCUacc
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: ChannelSelector
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
 
ENTITY ChannelSelector_testbench IS
END ChannelSelector_testbench;
 
ARCHITECTURE behavior OF ChannelSelector_testbench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ChannelSelector
    PORT(
         rst : IN  std_logic;
         clk : IN  std_logic;
         stride : IN  integer;
         filterDim : IN  integer;
         image_offset : IN  integer;
         filter_offset : IN  integer;
         filter_column_offset : IN  integer;
         image_column_offset : IN  integer;
         numOfChannels : IN  integer;
         baseAddress_image : IN  integer;
         baseAddress_filter : IN  integer;
         activation_request : IN  std_logic;
         activation_acknowledge : OUT  std_logic;
         mode : IN  std_logic_vector(1 downto 0);
         address_image : OUT  integer;
         burstRequest_image : OUT  std_logic;
         read_image : OUT  std_logic;
         burstAcknowledge_image : IN  std_logic;
         data1_in : IN  std_logic_vector(31 downto 0);
         data1_valid_in : IN  std_logic;
         address_filter : OUT  integer;
         burstRequest_filter : OUT  std_logic;
         read_filter : OUT  std_logic;
         burstAcknowledge_filter : IN  std_logic;
         data2_in : IN  std_logic_vector(31 downto 0);
         data2_valid_in : IN  std_logic;
         acknowledge_channel : IN  std_logic_vector(31 downto 0);
         request_channel : OUT  std_logic_vector(31 downto 0);
         data1_out : OUT  std_logic_vector(31 downto 0);
         data2_out : OUT  std_logic_vector(31 downto 0);
         data1_valid_out : OUT  std_logic_vector(31 downto 0);
         data2_valid_out : OUT  std_logic_vector(31 downto 0);
         mode_out : OUT  std_logic_vector(1 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
   signal stride : integer := 0;
   signal filterDim : integer := 0;
   signal image_offset : integer := 0;
   signal filter_offset : integer := 0;
   signal filter_column_offset : integer := 0;
   signal image_column_offset : integer := 0;
   signal numOfChannels : integer := 0;
   signal baseAddress_image : integer := 0;
   signal baseAddress_filter : integer := 0;
   signal activation_request : std_logic := '0';
   signal mode : std_logic_vector(1 downto 0) := (others => '0');
   signal burstAcknowledge_image : std_logic := '0';
   signal data1_in : std_logic_vector(31 downto 0) := (others => '0');
   signal data1_valid_in : std_logic := '0';
   signal burstAcknowledge_filter : std_logic := '0';
   signal data2_in : std_logic_vector(31 downto 0) := (others => '0');
   signal data2_valid_in : std_logic := '0';
   signal acknowledge_channel : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal activation_acknowledge : std_logic;
   signal address_image : integer;
   signal burstRequest_image : std_logic;
   signal read_image : std_logic;
   signal address_filter : integer;
   signal burstRequest_filter : std_logic;
   signal read_filter : std_logic;
   signal request_channel : std_logic_vector(31 downto 0);
   signal data1_out : std_logic_vector(31 downto 0);
   signal data2_out : std_logic_vector(31 downto 0);
   signal data1_valid_out : std_logic_vector(31 downto 0);
   signal data2_valid_out : std_logic_vector(31 downto 0);
   signal mode_out : std_logic_vector(1 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ChannelSelector PORT MAP (
          rst => rst,
          clk => clk,
          stride => stride,
          filterDim => filterDim,
          image_offset => image_offset,
          filter_offset => filter_offset,
          filter_column_offset => filter_column_offset,
          image_column_offset => image_column_offset,
          numOfChannels => numOfChannels,
          baseAddress_image => baseAddress_image,
          baseAddress_filter => baseAddress_filter,
          activation_request => activation_request,
          activation_acknowledge => activation_acknowledge,
          mode => mode,
          address_image => address_image,
          burstRequest_image => burstRequest_image,
          read_image => read_image,
          burstAcknowledge_image => burstAcknowledge_image,
          data1_in => data1_in,
          data1_valid_in => data1_valid_in,
          address_filter => address_filter,
          burstRequest_filter => burstRequest_filter,
          read_filter => read_filter,
          burstAcknowledge_filter => burstAcknowledge_filter,
          data2_in => data2_in,
          data2_valid_in => data2_valid_in,
          acknowledge_channel => acknowledge_channel,
          request_channel => request_channel,
          data1_out => data1_out,
          data2_out => data2_out,
          data1_valid_out => data1_valid_out,
          data2_valid_out => data2_valid_out,
          mode_out => mode_out
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
		stride <= 1;
		filterDim <= 2;
		image_offset <= 2000;
		filter_offset <= 1000;
		filter_column_offset <= 100;
		image_column_offset <= 200;
		numOfChannels <= 4;
		baseAddress_image <= 0;
		baseAddress_filter <= 0;
		wait for clk_period;
		activation_request <= '1';
		mode <= "11";
		wait for clk_period;
		activation_request <= '0';
		wait for clk_period*2;
		data1_in <= "00000000000000000000000000000001";
		data1_valid_in <= '1';
		data2_in <= "00000000000000000000000000000001";
		data2_valid_in <= '0';
		burstAcknowledge_image <= '1';
		wait for clk_period;
		burstAcknowledge_image <= '0';
		data1_in <= "00000000000000000000000000000001";
		data1_valid_in <= '0';
		data2_in <= "00000000000000000000000000000001";
		data2_valid_in <= '1';
		burstAcknowledge_filter <= '1';
		wait for clk_period;
		burstAcknowledge_filter <= '0';
		data2_valid_in <= '0';
		
		wait for clk_period*2;
		data1_in <= "00000000000000000000000000000010";
		data1_valid_in <= '1';
		data2_in <= "00000000000000000000000000000010";
		data2_valid_in <= '0';
		burstAcknowledge_image <= '1';
		wait for clk_period;
		burstAcknowledge_image <= '0';
		data1_in <= "00000000000000000000000000000010";
		data1_valid_in <= '0';
		data2_in <= "00000000000000000000000000000010";
		data2_valid_in <= '1';
		burstAcknowledge_filter <= '1';
		wait for clk_period;
		burstAcknowledge_filter <= '0';
		data2_valid_in <= '0';
		
		wait for clk_period*4;
		data1_in <= "00000000000000000000000000000100";
		data1_valid_in <= '1';
		data2_in <= "00000000000000000000000000000100";
		data2_valid_in <= '0';
		burstAcknowledge_image <= '1';
		wait for clk_period;
		burstAcknowledge_image <= '0';
		data1_in <= "00000000000000000000000000000100";
		data1_valid_in <= '0';
		data2_in <= "00000000000000000000000000000100";
		data2_valid_in <= '1';
		burstAcknowledge_filter <= '1';
		wait for clk_period;
		burstAcknowledge_filter <= '0';
		data2_valid_in <= '0';
		
		wait for clk_period*2;
		data1_in <= "00000000000000000000000000001000";
		data1_valid_in <= '1';
		data2_in <= "00000000000000000000000000001000";
		data2_valid_in <= '0';
		burstAcknowledge_image <= '1';
		wait for clk_period;
		burstAcknowledge_image <= '0';
		data1_in <= "00000000000000000000000000001000";
		data1_valid_in <= '0';
		data2_in <= "00000000000000000000000000001000";
		data2_valid_in <= '1';
		burstAcknowledge_filter <= '1';
		wait for clk_period;
		burstAcknowledge_filter <= '0';
		data2_valid_in <= '0';
		
		wait for clk_period*4;
		data1_in <= "00000000000000000000000000010000";
		data1_valid_in <= '1';
		data2_in <= "00000000000000000000000000010000";
		data2_valid_in <= '0';
		burstAcknowledge_image <= '1';
		wait for clk_period;
		burstAcknowledge_image <= '0';
		data1_in <= "00000000000000000000000000010000";
		data1_valid_in <= '0';
		data2_in <= "00000000000000000000000000010000";
		data2_valid_in <= '1';
		burstAcknowledge_filter <= '1';
		wait for clk_period;
		burstAcknowledge_filter <= '0';
		data2_valid_in <= '0';
		
		wait for clk_period*2;
		data1_in <= "00000000000000000000000000100000";
		data1_valid_in <= '1';
		data2_in <= "00000000000000000000000000100000";
		data2_valid_in <= '0';
		burstAcknowledge_image <= '1';
		wait for clk_period;
		burstAcknowledge_image <= '0';
		data1_in <= "00000000000000000000000000100000";
		data1_valid_in <= '0';
		data2_in <= "00000000000000000000000000100000";
		data2_valid_in <= '1';
		burstAcknowledge_filter <= '1';
		wait for clk_period;
		burstAcknowledge_filter <= '0';
		data2_valid_in <= '0';
		
		wait for clk_period*4;
		data1_in <= "00000000000000000000000001000000";
		data1_valid_in <= '1';
		data2_in <= "00000000000000000000000001000000";
		data2_valid_in <= '0';
		burstAcknowledge_image <= '1';
		wait for clk_period;
		burstAcknowledge_image <= '0';
		data1_in <= "00000000000000000000000001000000";
		data1_valid_in <= '0';
		data2_in <= "00000000000000000000000001000000";
		data2_valid_in <= '1';
		burstAcknowledge_filter <= '1';
		wait for clk_period;
		burstAcknowledge_filter <= '0';
		data2_valid_in <= '0';
		
		wait for clk_period*2;
		data1_in <= "00000000000000000000000010000000";
		data1_valid_in <= '1';
		data2_in <= "00000000000000000000000010000000";
		data2_valid_in <= '0';
		burstAcknowledge_image <= '1';
		wait for clk_period;
		burstAcknowledge_image <= '0';
		data1_in <= "00000000000000000000000010000000";
		data1_valid_in <= '0';
		data2_in <= "00000000000000000000000010000000";
		data2_valid_in <= '1';
		burstAcknowledge_filter <= '1';
		wait for clk_period;
		burstAcknowledge_filter <= '0';
		data2_valid_in <= '0';
		
		
		-------------------------------------------
		wait for clk_period*5;
		acknowledge_channel <= "00000000000000000000000000001111";
		baseAddress_image <= 7000;
		baseAddress_filter <= 7000;
		activation_request <= '1';
		mode <= "10";
		wait for clk_period;
		acknowledge_channel <= "00000000000000000000000000000000";
		activation_request <= '0';
		wait for clk_period*2;
		data1_in <= "00000000000000000000000000000001";
		data1_valid_in <= '1';
		data2_in <= "00000000000000000000000000000001";
		data2_valid_in <= '0';
		burstAcknowledge_image <= '1';
		wait for clk_period;
		burstAcknowledge_image <= '0';
		data1_in <= "00000000000000000000000000000001";
		data1_valid_in <= '0';
		data2_in <= "00000000000000000000000000000001";
		data2_valid_in <= '1';
		burstAcknowledge_filter <= '1';
		wait for clk_period;
		burstAcknowledge_filter <= '0';
		data2_valid_in <= '0';
		
		wait for clk_period*2;
		data1_in <= "00000000000000000000000000000010";
		data1_valid_in <= '1';
		data2_in <= "00000000000000000000000000000010";
		data2_valid_in <= '0';
		burstAcknowledge_image <= '1';
		wait for clk_period;
		burstAcknowledge_image <= '0';
		data1_in <= "00000000000000000000000000000010";
		data1_valid_in <= '0';
		data2_in <= "00000000000000000000000000000010";
		data2_valid_in <= '1';
		burstAcknowledge_filter <= '1';
		wait for clk_period;
		burstAcknowledge_filter <= '0';
		data2_valid_in <= '0';
		
		wait for clk_period*4;
		data1_in <= "00000000000000000000000000000100";
		data1_valid_in <= '1';
		data2_in <= "00000000000000000000000000000100";
		data2_valid_in <= '0';
		burstAcknowledge_image <= '1';
		wait for clk_period;
		burstAcknowledge_image <= '0';
		data1_in <= "00000000000000000000000000000100";
		data1_valid_in <= '0';
		data2_in <= "00000000000000000000000000000100";
		data2_valid_in <= '1';
		burstAcknowledge_filter <= '1';
		wait for clk_period;
		burstAcknowledge_filter <= '0';
		data2_valid_in <= '0';
		
		wait for clk_period*2;
		data1_in <= "00000000000000000000000000001000";
		data1_valid_in <= '1';
		data2_in <= "00000000000000000000000000001000";
		data2_valid_in <= '0';
		burstAcknowledge_image <= '1';
		wait for clk_period;
		burstAcknowledge_image <= '0';
		data1_in <= "00000000000000000000000000001000";
		data1_valid_in <= '0';
		data2_in <= "00000000000000000000000000001000";
		data2_valid_in <= '1';
		burstAcknowledge_filter <= '1';
		wait for clk_period;
		burstAcknowledge_filter <= '0';
		data2_valid_in <= '0';
		
		wait for clk_period*4;
		data1_in <= "00000000000000000000000000010000";
		data1_valid_in <= '1';
		data2_in <= "00000000000000000000000000010000";
		data2_valid_in <= '0';
		burstAcknowledge_image <= '1';
		wait for clk_period;
		burstAcknowledge_image <= '0';
		data1_in <= "00000000000000000000000000010000";
		data1_valid_in <= '0';
		data2_in <= "00000000000000000000000000010000";
		data2_valid_in <= '1';
		burstAcknowledge_filter <= '1';
		wait for clk_period;
		burstAcknowledge_filter <= '0';
		data2_valid_in <= '0';
		
		wait for clk_period*2;
		data1_in <= "00000000000000000000000000100000";
		data1_valid_in <= '1';
		data2_in <= "00000000000000000000000000100000";
		data2_valid_in <= '0';
		burstAcknowledge_image <= '1';
		wait for clk_period;
		burstAcknowledge_image <= '0';
		data1_in <= "00000000000000000000000000100000";
		data1_valid_in <= '0';
		data2_in <= "00000000000000000000000000100000";
		data2_valid_in <= '1';
		burstAcknowledge_filter <= '1';
		wait for clk_period;
		burstAcknowledge_filter <= '0';
		data2_valid_in <= '0';
		
		wait for clk_period*4;
		data1_in <= "00000000000000000000000001000000";
		data1_valid_in <= '1';
		data2_in <= "00000000000000000000000001000000";
		data2_valid_in <= '0';
		burstAcknowledge_image <= '1';
		wait for clk_period;
		burstAcknowledge_image <= '0';
		data1_in <= "00000000000000000000000001000000";
		data1_valid_in <= '0';
		data2_in <= "00000000000000000000000001000000";
		data2_valid_in <= '1';
		burstAcknowledge_filter <= '1';
		wait for clk_period;
		burstAcknowledge_filter <= '0';
		data2_valid_in <= '0';
		
		wait for clk_period*2;
		data1_in <= "00000000000000000000000010000000";
		data1_valid_in <= '1';
		data2_in <= "00000000000000000000000010000000";
		data2_valid_in <= '0';
		burstAcknowledge_image <= '1';
		wait for clk_period;
		burstAcknowledge_image <= '0';
		data1_in <= "00000000000000000000000010000000";
		data1_valid_in <= '0';
		data2_in <= "00000000000000000000000010000000";
		data2_valid_in <= '1';
		burstAcknowledge_filter <= '1';
		wait for clk_period;
		burstAcknowledge_filter <= '0';
		data2_valid_in <= '0';
		
		
		
      wait for clk_period*10;
	  
      wait;
   end process;

END;
