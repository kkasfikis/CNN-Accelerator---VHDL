library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
--use IEEE.STD_LOGIC_ARITH.ALL;

entity FRAMER is
port(
	clk : in std_logic;
	rst : in std_logic;
	-------SYSTEM CONSTANTS-----------
	max_x : in integer;
	max_y : in integer;
	numOfChannels : in integer;
	iHeight: in integer;
	rHeight: in integer;
	image_offset : in integer;
	filter_offset : in integer;
	stride : in integer;
	filterDim : in integer;
	----------------------------------
	result_baseAddress : in integer;
	filter_address : in integer;
	activation_request : in std_logic;
	activation_acknowledge : out std_logic;
	frameCalc_request : out std_logic;
	collector_acknowledge: in std_logic;
	mode : out std_logic_vector(1 downto 0);
	baseAddress_image : out integer;
	baseAddress_filter : out integer;
	frameCalc_numOfChannels: out integer;
	frameCalc_rst : out std_logic;
	result_address : out integer;
	addToExisting : out std_logic;
	lastChannels : out std_logic
);
end FRAMER;

architecture Behavioral of FRAMER is
	
	component orig_shift_mul_add
	port(
		clk : in std_logic;
		rst : in std_logic;
		result_fromIndex : in integer;
		result_toIndex : in integer;
		value1 : in std_logic_vector(31 downto 0);
		value2 : in std_logic_vector(31 downto 0);
		activation_request : in std_logic;
		result_acknowledge : in std_logic;
		overflow : out std_logic;
		underanked : out std_logic;
		result : out std_logic_vector(31 downto 0);
		activation_acknowledge : out std_logic;
		result_request : out std_logic
	);
	end component;
	
	---------SIGNAL DECLARATION-----------
	signal current_x : integer;
	signal current_y : integer;
	signal r_current_x :integer;
	signal r_current_y : integer;
	signal previous_x : integer;
	signal previous_y : integer;
	signal nChannels : integer;
	signal nChannels_sig : std_logic_vector(31 downto 0);
	signal numOfChannels_sig : std_logic_vector(31 downto 0);
	signal mode_sig : std_logic_vector(1 downto 0);
	signal calc_y : integer;
	signal next_iAddr : integer;
	signal next_rAddr : integer;
	signal i_line_addr_0 : std_logic_vector(31 downto 0);
	signal i_line_addr_1 : std_logic_vector(31 downto 0);
	signal r_line_addr_0 : std_logic_vector(31 downto 0);
	signal r_line_addr_1 : std_logic_vector(31 downto 0);
	type CALC_STATES is (calculateAddr_0,calculateAddr_1,calculateAddr_2,calculateAddr_3);
	signal calcState : CALC_STATES;
	type FSM_STATES is (idle,move,activateFrame,waitFrameResults);
	signal myState : FSM_STATES;
	signal start_calc : std_logic;
	signal finished_calc : std_logic;
	signal frameCalc_request_sig : std_logic;
	signal dProc_calc : std_logic;
	signal frameCalc_image_startAddr_sig : integer;
	signal frameCalc_filter_startAddr_sig : integer;
	signal frameCalc_numOfChannels_sig : integer;
	signal mul_rst : std_logic;
	signal i_sm0_value1_sig,i_sm0_value2_sig,i_sm0_result_sig,i_sm1_value1_sig,i_sm1_value2_sig,i_sm1_result_sig,i_sm2_value1_sig,i_sm2_value2_sig,i_sm2_result_sig  : std_logic_vector(31 downto 0);
	signal r_sm0_value1_sig,r_sm0_value2_sig,r_sm0_result_sig,r_sm1_value1_sig,r_sm1_value2_sig,r_sm1_result_sig,r_sm2_value1_sig,r_sm2_value2_sig,r_sm2_result_sig  : std_logic_vector(31 downto 0);
	signal i_sm0_request_sig,i_sm0_ack_sig,i_sm1_request_sig,i_sm1_ack_sig,i_sm2_request_sig,i_sm2_ack_sig: std_logic;
	signal r_sm0_request_sig,r_sm0_ack_sig,r_sm1_request_sig,r_sm1_ack_sig,r_sm2_request_sig,r_sm2_ack_sig: std_logic;
	--------------------------------------

begin
	
	i_sm0 : orig_shift_mul_add
	port map(
		clk => clk,
		rst => mul_rst,
		result_fromIndex => 31,
		result_toIndex  => 0,
		value1 => i_sm0_value1_sig,
		value2 => i_sm0_value2_sig,
		activation_request => i_sm0_request_sig,
		result_acknowledge => '0',
		overflow => open,
		underanked => open,
		result => i_sm0_result_sig,
		activation_acknowledge => open,
		result_request => i_sm0_ack_sig
	);
	
	i_sm1 : orig_shift_mul_add
	port map(
		clk => clk,
		rst => mul_rst,
		result_fromIndex => 31,
		result_toIndex  => 0,
		value1 => i_sm1_value1_sig,
		value2 => i_sm1_value2_sig,
		activation_request => i_sm1_request_sig,
		result_acknowledge => '0',
		overflow => open,
		underanked => open,
		result => i_sm1_result_sig,
		activation_acknowledge => open,
		result_request => i_sm1_ack_sig
	);
	
	i_sm2 : orig_shift_mul_add
	port map(
		clk => clk,
		rst => mul_rst,
		result_fromIndex => 31,
		result_toIndex  => 0,
		value1 => i_sm2_value1_sig,
		value2 => i_sm2_value2_sig,
		activation_request => i_sm2_request_sig,
		result_acknowledge => '0',
		overflow => open,
		underanked => open,
		result => i_sm2_result_sig,
		activation_acknowledge => open,
		result_request => i_sm2_ack_sig
	);
	
	r_sm0 : orig_shift_mul_add
	port map(
		clk => clk,
		rst => mul_rst,
		result_fromIndex => 31,
		result_toIndex  => 0,
		value1 => r_sm0_value1_sig,
		value2 => r_sm0_value2_sig,
		activation_request => r_sm0_request_sig,
		result_acknowledge => '0',
		overflow => open,
		underanked => open,
		result => r_sm0_result_sig,
		activation_acknowledge => open,
		result_request => r_sm0_ack_sig
	);
	
	r_sm1 : orig_shift_mul_add
	port map(
		clk => clk,
		rst => mul_rst,
		result_fromIndex => 31,
		result_toIndex  => 0,
		value1 => r_sm1_value1_sig,
		value2 => r_sm1_value2_sig,
		activation_request => r_sm1_request_sig,
		result_acknowledge => '0',
		overflow => open,
		underanked => open,
		result => r_sm1_result_sig,
		activation_acknowledge => open,
		result_request => r_sm1_ack_sig
	);
	
	r_sm2 : orig_shift_mul_add
	port map(
		clk => clk,
		rst => mul_rst,
		result_fromIndex => 31,
		result_toIndex  => 0,
		value1 => r_sm2_value1_sig,
		value2 => r_sm2_value2_sig,
		activation_request => r_sm2_request_sig,
		result_acknowledge => '0',
		overflow => open,
		underanked => open,
		result => r_sm2_result_sig,
		activation_acknowledge => open,
		result_request => r_sm2_ack_sig
	);
	
	process(clk) is
	begin
		if(rising_edge(clk)) then
			if(rst ='1') then
				mode_sig <= "11";
			else	
				if(activation_request = '1' or dProc_calc = '1') then
					current_x <= 0;
					current_y <= 0;
					previous_x <= 0;
					previous_y <= 0;
					r_current_x <= 0;
					r_current_y <= 0;
					finished_calc<='0';
					mode_sig <= "11";
					calcState <= calculateAddr_0;
					
					i_line_addr_0 <= (others => '0');
					i_line_addr_1 <= (others => '0');
					next_iAddr <= 0;
					
					r_line_addr_0 <= (others => '0');
					r_line_addr_1 <= (others => '0');
					next_rAddr <= 0;
				else
					case calcState is
						when calculateAddr_0 =>
							if(start_calc = '1') then
								mul_rst <= '1';
								finished_calc <= '0';
								previous_x <= current_x;
								previous_y <= current_y;
								if((current_x + stride) < max_x ) then
									current_x <= current_x + stride;
									r_current_x <= r_current_x + 1;
									calcState <= calculateAddr_1;
								else
									if((current_y + stride) < max_y) then
										current_y <= current_y + stride;
										r_current_y <= r_current_y + 1;
										current_x <= 0;
										r_current_x <= 0;
										calcState <= calculateAddr_1;
									else 
										current_y <= max_y +1;
										current_x <= max_x +1;
									end if;
								end if;
								
							end if;
							i_line_addr_0 <= std_logic_vector(to_unsigned(iHeight, 32));
							r_line_addr_0 <= std_logic_vector(to_unsigned(rHeight,32));
						when calculateAddr_1 =>
							mul_rst <= '0';
							i_line_addr_1 <= std_logic_vector(to_unsigned(current_y, 32));
							r_line_addr_1 <= std_logic_vector(to_unsigned(r_current_y,32));
							
							if(previous_y = current_y ) then
								mode_sig <= "10";
								i_sm0_value1_sig <= "00" & i_line_addr_0(31 downto 2);
								i_sm0_value2_sig <= std_logic_vector(to_unsigned(current_x + filterDim - stride,32));
								
								i_sm1_value1_sig <= "000000000000000000000000000000" & i_line_addr_0(1 downto 0);
								i_sm1_value2_sig <= std_logic_vector(to_unsigned(current_x + filterDim - stride,32));
								
								i_sm2_value1_sig <= i_line_addr_0;
								i_sm2_value2_sig <= std_logic_vector(to_unsigned(current_x + filterDim - stride,32));
							elsif(previous_y /= current_y) then
								mode_sig <= "01";
								i_sm0_value1_sig <= "00" & i_line_addr_0(31 downto 2);
								i_sm0_value2_sig <= std_logic_vector(to_unsigned(current_x,32));
								
								i_sm1_value1_sig <= "000000000000000000000000000000" & i_line_addr_0(1 downto 0);
								i_sm1_value2_sig <= std_logic_vector(to_unsigned(current_x,32));
								
								i_sm2_value1_sig <= i_line_addr_0;
								i_sm2_value2_sig <= std_logic_vector(to_unsigned(current_x,32));
							end if;
							
							i_sm0_request_sig <= '1';
							i_sm1_request_sig <= '1';
							i_sm2_request_sig <= '1';
							
							r_sm0_value1_sig <= "00" & r_line_addr_0(31 downto 2);
							r_sm0_value2_sig <= std_logic_vector(to_unsigned(r_current_x,32));
							r_sm0_request_sig <= '1';
							
							r_sm1_value1_sig <= "000000000000000000000000000000" & r_line_addr_0(1 downto 0);
							r_sm1_value2_sig <= std_logic_vector(to_unsigned(r_current_x,32));
							r_sm1_request_sig <= '1';
							
							r_sm2_value1_sig <= r_line_addr_0;
							r_sm2_value2_sig <= std_logic_vector(to_unsigned(r_current_x,32));
							r_sm2_request_sig <= '1';
							
							calcState <= calculateAddr_2;
						when calculateAddr_2 =>
							i_sm0_request_sig <= '0';
							i_sm1_request_sig <= '0';
							i_sm2_request_sig <= '0';
							r_sm0_request_sig <= '0';
							r_sm1_request_sig <= '0';
							r_sm2_request_sig <= '0';
							
							if(r_sm0_ack_sig = '1' and r_sm1_ack_sig = '1' and r_sm2_ack_sig = '1' and i_sm0_ack_sig = '1' and i_sm1_ack_sig = '1' and i_sm2_ack_sig = '1') then
--								i_line_addr_0 <= std_logic_vector(to_unsigned(to_integer(unsigned(i_sm0_result_sig)) + to_integer(unsigned(i_sm1_result_sig(31 downto 2))) + to_integer(unsigned(i_line_addr_1(31 downto 2))),30)) & "00";
--								i_line_addr_1 <= std_logic_vector(to_unsigned(to_integer(unsigned(i_sm2_result_sig(1 downto 0))) + to_integer(unsigned(i_line_addr_1(1 downto 0))),32));
--								r_line_addr_0 <= std_logic_vector(to_unsigned(to_integer(unsigned(r_sm0_result_sig)) + to_integer(unsigned(r_sm1_result_sig(31 downto 2))) + to_integer(unsigned(r_line_addr_1(31 downto 2))),30)) & "00";
--								r_line_addr_1 <= std_logic_vector(to_unsigned(to_integer(unsigned(r_sm2_result_sig(1 downto 0))) + to_integer(unsigned(r_line_addr_1(1 downto 0))),32));
								i_line_addr_0 <= std_logic_vector(unsigned(i_sm0_result_sig) + unsigned("00" & i_sm1_result_sig(31 downto 2)) + unsigned("00" & i_line_addr_1(31 downto 2)));
								i_line_addr_1 <= std_logic_vector(unsigned("000000000000000000000000000000" & i_sm2_result_sig(1 downto 0)) + unsigned("000000000000000000000000000000" & i_line_addr_1(1 downto 0)));
								r_line_addr_0 <= std_logic_vector(unsigned(r_sm0_result_sig) + unsigned("00" & r_sm1_result_sig(31 downto 2)) + unsigned("00" & r_line_addr_1(31 downto 2)));
								r_line_addr_1 <= std_logic_vector(unsigned("000000000000000000000000000000" & r_sm2_result_sig(1 downto 0)) + unsigned("000000000000000000000000000000" & r_line_addr_1(1 downto 0)));
							
								calcState <= calculateAddr_3;
							end if;
						when calculateAddr_3 =>
--							next_iAddr <= to_integer(unsigned(i_line_addr_0)) + to_integer(unsigned(i_line_addr_1));
--							next_rAddr <= to_integer(unsigned(r_line_addr_0)) + to_integer(unsigned(r_line_addr_1));

							next_iAddr <= to_integer(unsigned(i_line_addr_0(29 downto 0) & "00") + unsigned(i_line_addr_1));
							next_rAddr <= to_integer(unsigned(r_line_addr_0(29 downto 0) & "00") + unsigned(r_line_addr_1));
							finished_calc <= '1';
							calcState <= calculateAddr_0;
					end case;
				end if;
			end if;
		end if;
	end process;
	
	process(clk) is
	begin 
		if(rising_edge(clk)) then
			if(rst='1') then
				baseAddress_image <= 0;
				baseAddress_filter <= 0;
				frameCalc_image_startAddr_sig <= 0;
				frameCalc_filter_startAddr_sig <= 0;
				frameCalc_numOfChannels_sig <= 0;
				result_address <= 0;
				start_calc <= '0';
				dProc_calc <= '0';
				myState <= idle;
				mode <= "00";
				nChannels <= 0;
				activation_acknowledge <= '0';
				frameCalc_request_sig <= '0';
				frameCalc_rst <= '0';
				addToExisting <= '0';
				lastChannels <= '0';
			else
				if(nChannels + 4 >= numOfChannels and numOfChannels >0 ) then
					lastChannels <= '1';
				else 
					lastChannels <= '0';
				end if;
				case myState is
					when idle =>
						if(activation_request = '1') then
							addToExisting <= '0';
							lastChannels <= '0';
							baseAddress_image <= 0;
							baseAddress_filter <= filter_address;
							myState <= activateFrame;
							start_calc <= '1';
							if(nChannels + 4 <= numOfChannels) then
								nChannels <= 4;
								frameCalc_numOfChannels_sig <= 4;
							elsif(nChannels + 3 <= numOfChannels) then
								nChannels <= 3;
								frameCalc_numOfChannels_sig <= 3;
							elsif(nChannels + 2 <= numOfChannels) then
								nChannels <= 2;
								frameCalc_numOfChannels_sig <= 2;
							elsif(nChannels + 1 <= numOfChannels) then
								nChannels <= 1;
								frameCalc_numOfChannels_sig <= 1;
							end if;
						end if;
					when move =>
						
						if(current_x > max_x-1 and current_y > max_y-1)then
							dProc_calc <= '0';
							
							if(nChannels /= 0) then
								addToExisting <= '1';
							end if;
							
							frameCalc_rst <= '1';
							
							if(frameCalc_numOfChannels_sig = 1) then
								baseAddress_image <= frameCalc_image_startAddr_sig + image_offset;
								baseAddress_filter <= frameCalc_filter_startAddr_sig + filter_offset +filter_address;
								frameCalc_image_startAddr_sig <= frameCalc_image_startAddr_sig + image_offset;
								frameCalc_filter_startAddr_sig <= frameCalc_filter_startAddr_sig + filter_offset;
							elsif(frameCalc_numOfChannels_sig = 2) then
								baseAddress_image <= frameCalc_image_startAddr_sig + image_offset + image_offset;
								baseAddress_filter <= frameCalc_filter_startAddr_sig + filter_offset + filter_offset +filter_address;
								frameCalc_image_startAddr_sig <= frameCalc_image_startAddr_sig + image_offset + image_offset;
								frameCalc_filter_startAddr_sig <= frameCalc_filter_startAddr_sig + filter_offset + filter_offset;
							elsif(frameCalc_numOfChannels_sig = 3) then
								baseAddress_image <= frameCalc_image_startAddr_sig + image_offset + image_offset + image_offset;
								baseAddress_filter <= frameCalc_filter_startAddr_sig + filter_offset + filter_offset + filter_offset +filter_address;
								frameCalc_image_startAddr_sig <= frameCalc_image_startAddr_sig + image_offset + image_offset + image_offset;
								frameCalc_filter_startAddr_sig <= frameCalc_filter_startAddr_sig + filter_offset + filter_offset + filter_offset;
							elsif(frameCalc_numOfChannels_sig = 4) then
								baseAddress_image <= frameCalc_image_startAddr_sig + image_offset + image_offset + image_offset + image_offset;
								baseAddress_filter <= frameCalc_filter_startAddr_sig + filter_offset + filter_offset + filter_offset + filter_offset +filter_address;
								frameCalc_image_startAddr_sig <= frameCalc_image_startAddr_sig + image_offset + image_offset + image_offset + image_offset;
								frameCalc_filter_startAddr_sig <= frameCalc_filter_startAddr_sig + filter_offset + filter_offset + filter_offset + filter_offset;
							end if;
							
							if(nChannels + 4 <= numOfChannels) then
								nChannels <= nChannels+4;
								frameCalc_numOfChannels_sig <= 4;
								myState <= activateFrame;
								start_calc <= '1';
							elsif(nChannels + 3 <= numOfChannels) then
								nChannels <= nChannels+3;
								frameCalc_numOfChannels_sig <= 3;
								myState <= activateFrame;
								start_calc <= '1';
							elsif(nChannels + 2 <= numOfChannels) then
								nChannels <= nChannels+2;
								frameCalc_numOfChannels_sig <= 2;
								myState <= activateFrame;
								start_calc <= '1';
							elsif(nChannels + 1 <= numOfChannels) then
								nChannels <= nChannels+1;
								frameCalc_numOfChannels_sig <= 1;
								myState <= activateFrame;
								start_calc <= '1';
							else
								activation_acknowledge <= '1';
							end if;
						else
							if(finished_calc = '1') then
								start_calc <= '1';
								myState<= activateFrame;
								baseAddress_image <= frameCalc_image_startAddr_sig + next_iAddr;
								result_address <= next_rAddr;
							end if;
						end if;
					when activateFrame =>
						frameCalc_rst <= '0';
						dProc_calc <= '0';
						start_calc <= '0';
						mode<= mode_sig;
						frameCalc_request_sig <= '1';
						myState<=waitFrameResults;
					when waitFrameResults =>
						if(frameCalc_request_sig = '1') then
							frameCalc_request_sig <= '0';
						else
							mode<= "00";
							baseAddress_image <= 0;
							if (collector_acknowledge = '1') then
								myState <= move;
								if(current_x > max_x-1 and current_y > max_y-1) then
									dProc_calc <= '1';
								end if;
							end if;
						end if;
				end case;
				
			end if;
		end if;
	end process;

	frameCalc_numOfChannels <= frameCalc_numOfChannels_sig;
	frameCalc_request <= frameCalc_request_sig;
end Behavioral;

