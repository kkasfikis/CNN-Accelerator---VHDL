
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.STD_LOGIC_ARITH.ALL;

entity ChannelSelector is
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
end ChannelSelector;

architecture Behavioral of ChannelSelector is
	------------SIGNAL DECLARATION------------
	signal working_channels : std_logic_vector(3 downto 0);
	signal mode_sig : std_logic_vector(1 downto 0);
	signal baseAddr_image : integer;
	signal address_image_sig: integer;
	signal baseAddr_filter : integer;
	signal address_filter_sig : integer;
	signal channelsAssigned : integer;
	signal currentChannel : integer;
	signal columnNumber : integer;
	type FSM_STATES is (idle,request,burst);
	signal myState : FSM_STATES;
	signal ackImage : std_logic;
	signal ackFilter : std_logic;
	signal image_offset_sig : integer;
	signal filter_offset_sig : integer;
	signal image_column_addr : integer;
	signal filter_column_addr : integer;
	signal curColumn : integer;
	signal working : std_logic;
	------------------------------------------
begin
	
	process(clk) is
	begin
		if(rising_edge(clk))then
			if(rst='1') then
				data1_out <= "00000000000000000000000000000000";
				data2_out <= "00000000000000000000000000000000";
				data1_valid_out <= "00000000000000000000000000000000";
				data2_valid_out <= "00000000000000000000000000000000";
				request_channel <= "0000";
				working_channels <= "0000"; 
				mode_out <= "00";
				baseAddr_image <= 0;
				baseAddr_filter <= 0;
				mode_sig <= "00";
				read_image <= '0';
				read_filter <= '0';
				channelsAssigned <= 0;
				activation_acknowledge <= '0';
				burstRequest_image <= '0';
				burstRequest_filter <= '0';
				ackImage <='0';
				ackFilter <='0';
				address_filter_sig <= 0;
				address_image_sig <= 0;
				columnNumber <= 0;
				image_column_addr <= 0;
				filter_column_addr <= 0;
				working <= '0';
			else
				------------Zero channelCalcs that no longer work-----------
				for i in 0 to 3 loop 
					if(acknowledge_channel(i) = '1') then
						working_channels(i) <= '0';
					end if;
				end loop;
				------------------------------------------------------------
				if(activation_request = '1') then
					activation_acknowledge <= '0';
					mode_sig<= mode;
					baseAddr_image <= baseAddress_image;
					baseAddr_filter <= baseAddress_filter;
					channelsAssigned <= 0;
					ackImage <= '0';
					ackFilter <= '0';
					if(mode = "11") then
						read_image <= '1';
						read_filter <='1';
					else
						read_image <= '1';
						read_filter <='0';
					end if;
					myState <= idle;
					working <= '1';
					columnNumber <= 0;
					request_channel <="0000";
				else
					case myState is 
						when idle =>
							data1_valid_out <= "00000000000000000000000000000000";
							data2_valid_out <= "00000000000000000000000000000000";
							-------Work till all channels calculated-------------
							if(working = '1') then
								if (channelsAssigned < numOfChannels) then
									if(working_channels(channelsAssigned)='0') then
										channelsAssigned <= channelsAssigned +1;
										currentChannel <= channelsAssigned;
										myState<= request;
										working_channels(channelsAssigned) <= '1';
										if(channelsAssigned = 0) then
											address_filter_sig <= baseAddr_filter;
											address_image_sig <= baseAddr_image;
											image_column_addr <=  baseAddr_image;--address_image_sig;
											filter_column_addr <= baseAddr_filter;--address_filter_sig;
										else 
											address_filter_sig <= address_filter_sig + filter_offset;
											address_image_sig <= address_image_sig + image_offset;
											image_column_addr <= address_image_sig + image_offset;
											filter_column_addr <= address_filter_sig + filter_offset;
										end if;
										if(mode_sig /= "10") then
											columnNumber <= filterDim;
										else
											columnNumber <= stride;
										end if;
										curColumn <= 0;
										mode_out <= mode_sig;
										request_channel(channelsAssigned) <= '1';
									end if;
								else
									activation_acknowledge <= '1';
									working <= '0';
								end if;
							end if;
							------------------------------------------------------
						when request => 
							mode_out <= "00";
							ackImage <= '0';
							ackFilter <= '0';
							request_channel <= "0000";
							data1_valid_out <= "00000000000000000000000000000000";
							data2_valid_out <= "00000000000000000000000000000000";
							------While statement true loop between calculate and burst-----------
							if(curColumn < columnNumber) then
								myState <= burst;
								image_column_addr <= image_column_addr + image_column_offset;
								address_image <= image_column_addr;
								filter_column_addr <= filter_column_addr + filter_column_offset;
								address_filter <= filter_column_addr;
								burstRequest_image <= '1';
								burstRequest_filter <= '1';	
								curColumn <= curColumn + 1;
							else 
								myState <= idle;
							end if;
							-----------------------------------------------------------------------
						when burst =>
							burstRequest_image <= '0';
							burstRequest_filter <= '0';
							
							if(curColumn = columnNumber and ackImage = '1' and ackFilter ='1') then
								myState <= idle;
								data2_valid_out <= "00000000000000000000000000000000";
								data1_valid_out <= "00000000000000000000000000000000";
							elsif (curColumn /= columnNumber and ackImage = '1' and ackFilter ='1') then
								myState <= request;
								data2_valid_out <= "00000000000000000000000000000000";
								data1_valid_out <= "00000000000000000000000000000000";
							else
								if(mode_sig /= "11" or burstAcknowledge_filter ='1') then
									ackFilter<='1';
								end if;
								if(burstAcknowledge_image ='1') then
									ackImage <= '1';
								end if;
								
								if(data2_valid_in = '1') then
									data2_valid_out(currentChannel) <= '1';
									data2_out <= data2_in ;
								else
									data2_valid_out <= "00000000000000000000000000000000";
									data2_out <= "00000000000000000000000000000000";
								end if;
								
								if(data1_valid_in = '1') then
									data1_valid_out(currentChannel) <= '1';
									data1_out <= data1_in;
								else 
									data1_valid_out <= "00000000000000000000000000000000";
									data1_out <= "00000000000000000000000000000000";
								end if;
							end if;
					end case;
				end if;
			end if;
		end if;
	end process;
	
end Behavioral;

