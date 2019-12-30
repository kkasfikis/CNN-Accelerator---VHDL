
library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;
--use ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
USE work.HelperProcedures.ALL;


entity FrameCalculator is
port(
	clk : in std_logic;
	rst : in std_logic;
	----------SYSTEM CONSTANTS------------
	stride : in integer;
	filterDim : in integer;
	image_offset : in integer;
	filter_offset : in integer;
	filter_column_offset : in integer;
	image_column_offset : in integer;
	numOfChannels : in integer;
	stride_data :in integer;
	numOfData : in integer;
	--------------------------------------
	-------FRAMER DATA--------------
	baseAddress_image : in integer;
	baseAddress_filter : in integer;
	baseAddress_result : in integer;
	--------------------------------
	activation_request : in std_logic;
	activation_acknowledge : out std_logic;
	mode : in std_logic_vector(1 downto 0);
	------IMAGE RAM IC--------------
	address_image : out integer;
	burstRequest_image : out std_logic;
	read_image : out std_logic;
	burstAcknowledge_image : in std_logic;
	data1_in : in std_logic_vector(31 downto 0);
	data1_valid_in : in std_logic;
	--------------------------------
	------FILTER RAM IC-------------
	address_filter : out integer;
	burstRequest_filter : out std_logic;
	read_filter : out std_logic;
	burstAcknowledge_filter : in std_logic;
	data2_in : in std_logic_vector(31 downto 0);
	data2_valid_in : in std_logic;
	---------------------------------
	result_out : out std_logic_vector(31 downto 0);
	result_out_valid : out std_logic;
	result_address_out : out std_logic_vector(31 downto 0);
	previous_result_saved : in std_logic
);
end FrameCalculator;

architecture Behavioral of FrameCalculator is

	component ChannelSelector is
	port(
		rst : in std_logic;
		clk : in std_logic;
		------SYSTEM CONSTANTS----------
		stride : in integer;
		filterDim : in integer;
		image_offset : in integer;
		filter_offset : in integer;
		filter_column_offset :in integer;
		image_column_offset : in integer;
		numOfChannels : in integer;
		--------------------------------
		-------FRAMER DATA--------------
		baseAddress_image : in integer;
		baseAddress_filter : in integer;
		--------------------------------
		activation_request : in std_logic;
		activation_acknowledge : out std_logic;
		mode : in std_logic_vector(1 downto 0);
		------IMAGE RAM IC--------------
		address_image : out integer;
		burstRequest_image : out std_logic;
		read_image : out std_logic;
		burstAcknowledge_image : in std_logic;
		data1_in : in std_logic_vector(31 downto 0);
		data1_valid_in : in std_logic;
		--------------------------------
		------FILTER RAM IC-------------
		address_filter : out integer;
		burstRequest_filter : out std_logic;
		read_filter : out std_logic;
		burstAcknowledge_filter : in std_logic;
		data2_in : in std_logic_vector(31 downto 0);
		data2_valid_in : in std_logic;
		---------------------------------
		acknowledge_channel : in std_logic_vector(3 downto 0);
		request_channel : out std_logic_vector(3 downto 0);
		data1_out : out std_logic_vector(31 downto 0);
		data2_out : out std_logic_vector(31 downto 0);
		data1_valid_out : out std_logic_vector(31 downto 0);
		data2_valid_out : out std_logic_vector(31 downto 0);
		mode_out : out std_logic_vector(1 downto 0)
	);
	end component;


	component Channel_Calculator is
	port(
		clk : in std_logic;
		rst : in std_logic;
		activation_request :in std_logic;
		activation_acknowledge : out std_logic;
		summed : in std_logic;
		mode : in std_logic_vector(1 downto 0);
		stride_data : in integer;
		numOfData : in integer;
		data1 : in std_logic_vector(31 downto 0);
		data1_valid : in std_logic;
		data2 : in std_logic_vector(31 downto 0);
		data2_valid : in std_logic;
		sum : out std_logic_vector(31 downto 0)
	);	
	end component;

	----------------SIGNAL DECLARATION------------------
	signal channel_request_sig : std_logic_vector(3 downto 0);
	signal channel_acknowledge_sig : std_logic_vector(3 downto 0);
	signal process_channel_acknowledge_sig : std_logic_vector(3 downto 0);
	signal data1_sig : std_logic_vector(31 downto 0);
	signal data2_sig : std_logic_vector(31 downto 0);
	signal data1_valid_sig : std_logic_vector(31 downto 0);
	signal data2_valid_sig : std_logic_vector(31 downto 0);
	signal activation_acknowledge_sig : std_logic;
	signal mode_out_sig : std_logic_vector(1 downto 0);
	signal result0,result1,result2,result3 : std_logic_vector(31 downto 0);
	signal nChannels : integer;
	signal baseAddress_result_int : std_logic_vector(31 downto 0);
	signal test : std_logic_vector(31 downto 0);
	----------------------------------------------------

begin

	SelectChannel : ChannelSelector
	port map(
		rst => rst,
		clk => clk,
		------SYSTEM CONSTANTS----------
		stride =>stride,
		filterDim =>filterDim,
		image_offset =>image_offset,
		filter_offset =>filter_offset,
		filter_column_offset =>filter_column_offset,
		image_column_offset =>image_column_offset,
		numOfChannels => numOfChannels,
		--------------------------------
		-------FRAMER DATA--------------
		baseAddress_image => baseAddress_image,
		baseAddress_filter =>baseAddress_filter,
		--------------------------------
		activation_request => activation_request,
		activation_acknowledge => activation_acknowledge_sig,
		mode => mode,
		------IMAGE RAM IC--------------
		address_image => address_image,
		burstRequest_image => burstRequest_image,
		read_image => read_image,
		burstAcknowledge_image => burstAcknowledge_image,
		data1_in => data1_in,
		data1_valid_in => data1_valid_in,
		--------------------------------
		------FILTER RAM IC-------------
		address_filter =>address_filter,
		burstRequest_filter =>burstRequest_filter,
		read_filter =>read_filter,
		burstAcknowledge_filter =>burstAcknowledge_filter,
		data2_in =>data2_in,
		data2_valid_in =>data2_valid_in,
		---------------------------------
		acknowledge_channel =>process_channel_acknowledge_sig,
		request_channel =>channel_request_sig,
		data1_out => data1_sig,
		data2_out => data2_sig,
		data1_valid_out => data1_valid_sig,
		data2_valid_out => data2_valid_sig,
		mode_out => mode_out_sig
	);

	
	ChannelCalc_0 : Channel_Calculator
	port map(
		clk => clk,
		rst => rst,
		activation_request => channel_request_sig(0),
		activation_acknowledge => channel_acknowledge_sig(0),
		mode => mode_out_sig,
		summed => process_channel_acknowledge_sig(0),
		stride_data => stride_data,
		numOfData => numOfData,
		data1 => data1_sig,
		data1_valid => data1_valid_sig(0),
		data2 => data2_sig,
		data2_valid => data2_valid_sig(0),
		sum => result0
	);
	
	ChannelCalc_1 : Channel_Calculator
	port map(
		clk => clk,
		rst => rst,
		activation_request => channel_request_sig(1),
		activation_acknowledge => channel_acknowledge_sig(1),
		mode => mode_out_sig,
		summed => process_channel_acknowledge_sig(1),
		stride_data => stride_data,
		numOfData => numOfData,
		data1 => data1_sig,
		data1_valid => data1_valid_sig(1),
		data2 => data2_sig,
		data2_valid => data2_valid_sig(1),
		sum => result1
	);
	
	ChannelCalc_2 : Channel_Calculator
	port map(
		clk => clk,
		rst => rst,
		activation_request => channel_request_sig(2),
		activation_acknowledge => channel_acknowledge_sig(2),
		mode => mode_out_sig,
		summed => process_channel_acknowledge_sig(2),
		stride_data => stride_data,
		numOfData => numOfData,
		data1 => data1_sig,
		data1_valid => data1_valid_sig(2),
		data2 => data2_sig,
		data2_valid => data2_valid_sig(2),
		sum => result2
	);
	
	ChannelCalc_3 : Channel_Calculator
	port map(
		clk => clk,
		rst => rst,
		activation_request => channel_request_sig(3),
		activation_acknowledge => channel_acknowledge_sig(3),
		mode => mode_out_sig,
		summed => process_channel_acknowledge_sig(3),
		stride_data => stride_data,
		numOfData => numOfData,
		data1 => data1_sig,
		data1_valid => data1_valid_sig(3),
		data2 => data2_sig,
		data2_valid => data2_valid_sig(3),
		sum => result3
	);
	
	process(clk) is
	variable frameSum : std_logic_vector(31 downto 0);
	variable firstFrame : std_logic;
	variable check : std_logic := '0';
	begin
		if(rising_edge(clk)) then
			if(rst='1') then
				firstFrame := '0';
				frameSum := "00000000000000000000000000000000";
				result_out <= "00000000000000000000000000000000";
				nChannels <= 0;
				activation_acknowledge <= '0';
				result_out_valid <= '0';
				check :='0';
			else
				test <= frameSum;
				if(activation_request = '1') then
					frameSum := "00000000000000000000000000000000";
					nChannels <= 0;
					activation_acknowledge <= '0';
					result_out_valid <= '0';
					check := '0';
				else
					if(nChannels < numOfChannels) then
						if(channel_acknowledge_sig(0)='1') then
							process_channel_acknowledge_sig <= "0001";
							signed_addition_32with32bit(result0,frameSum,frameSum);
							nChannels <= nChannels + 1;
						elsif(channel_acknowledge_sig(1)='1') then
							process_channel_acknowledge_sig <= "0010";
							signed_addition_32with32bit(result1,frameSum,frameSum);
							nChannels <= nChannels + 1;
						elsif(channel_acknowledge_sig(2)='1') then
							process_channel_acknowledge_sig <= "0100";
							signed_addition_32with32bit(result2,frameSum,frameSum);
							nChannels <= nChannels + 1;
						elsif(channel_acknowledge_sig(3)='1') then
							process_channel_acknowledge_sig <= "1000";
							signed_addition_32with32bit(result3,frameSum,frameSum);
							nChannels <= nChannels + 1;
						else
							process_channel_acknowledge_sig <= "0000";
						end if;
					elsif(nChannels = numOfChannels and numOfChannels /= 0) then
						if(check = '0') then
							if(firstFrame = '0' or previous_result_saved = '1') then
								result_out <= frameSum;
								result_out_valid <= '1';
								firstFrame := '1';
								activation_acknowledge <= '1';
								result_address_out <= baseAddress_result_int;
								check := '1';
							end if;
						else 
							result_out_valid <= '0';
						end if;
					end if;
				end if;
			end if;
		end if;
	end process;
	
	baseAddress_result_int <= std_logic_vector(to_unsigned(baseAddress_result,32));
end Behavioral;

