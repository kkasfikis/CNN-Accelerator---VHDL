library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.HelperProcedures.ALL;

entity Conv_ReLU_Pooling is
port(
	clk : in std_logic;
	rst : in std_logic;
	ReLU_enabled : in std_logic;
	Pooling_enabled : in std_logic;
	pooling_mode : in std_logic;
	poolDim : in integer range 0 to 16;
	image_width : in integer range 0 to 4096;
	image_height : in integer range 0 to 2048;
	stride : in integer range 0 to 15;
	filterDim : in integer range 0 to 16;
	numOfChannels : in integer range 0 to 120;
	numOfFilters : in integer range 0 to 240;
	-------IMAGE IC-------------------
	image_burst_request : out std_logic;
	image_burst_acknowledge : in std_logic;
	read_image : out std_logic;
	image_addr : out std_logic_vector(31 downto 0);
	image_data_valid : in std_logic;
	image_data_out : in std_logic_vector(31 downto 0);
	----------------------------------
	-------FILTER IC------------------
	filter_burst_request : out std_logic;
	filter_burst_acknowledge : in std_logic;
	read_filter : out std_logic;
	filter_addr : out std_logic_vector(31 downto 0);
	filter_data_valid : in std_logic;
	filter_data_out : in std_logic_vector(31 downto 0);
	----------------------------------
	------RESULT_RAM_IC----------
	result_init_file : out std_logic;
	result_dataSize : out std_logic_vector(31 downto 0);
	result_read_write : out std_logic; --
	result_activation_request : out std_logic;
	result_activation_acknowledge : in std_logic;
	result_address : out std_logic_vector(31 downto 0);
	result_data : out std_logic_vector(31 downto 0);
	result_read_data : in std_logic_vector(31 downto 0); --
	result_read_data_valid : out std_logic;
	-----------------------------
	------POOL_RAM_IC------------
	pool_init_file : out std_logic;
	pool_dataSize : out std_logic_vector(31 downto 0);
	pool_activation_request : out std_logic;
	pool_activation_acknowledge : in std_logic;
	pool_address : out std_logic_vector(31 downto 0);
	pool_data : out std_logic_vector(31 downto 0)
	-----------------------------
);
end Conv_ReLU_Pooling;

architecture Behavioral of Conv_ReLU_Pooling is
	
	--Convolution
	component Multiple_Filter_Calculator is
	port(
		clk : in std_logic;
		rst : in std_logic;
		activation_request : in std_logic;
		activation_acknowledge : out std_logic;
		-------SYSTEM CONSTANTS-----------
		stride : in integer;
		filterDim : in integer;
		iHeight : in integer;
		rHeight : in integer;
		max_x : in integer;
		max_y : in integer;
		image_offset : in integer;
		result_offset : in integer;
		filter_offset : in integer;
		wholeFilter_offset : in integer;
		filter_column_offset : in integer;
		image_column_offset : in integer;
		numOfChannels : in integer;
		numOfFilters : in integer;
		stride_data : in integer;
		numOfData : in integer;
		----------------------------------
		-------IMAGE IC-------------------
		image_burst_request : out std_logic;
		image_burst_acknowledge : in std_logic;
		read_image : out std_logic;
		image_addr : out std_logic_vector(31 downto 0);
		image_data_valid : in std_logic;
		image_data_out : in std_logic_vector(31 downto 0);
		----------------------------------
		-------FILTER IC------------------
		filter_burst_request : out std_logic;
		filter_burst_acknowledge : in std_logic;
		read_filter : out std_logic;
		filter_addr : out std_logic_vector(31 downto 0);
		filter_data_valid : in std_logic;
		filter_data_out : in std_logic_vector(31 downto 0);
		----------------------------------
		result_out : out std_logic_vector(31 downto 0);
		result_out_valid : out std_logic;
		result_address_out : out std_logic_vector(31 downto 0);
		previous_result_saved : in std_logic;
		----------------------------------
		addToExisting : out std_logic;
		lastChannels : out std_logic;
		framerMode : out std_logic_vector(1 downto 0)
	);
	end component;
	
	--ReLU 
	component ReLU is
	port(
		clk : in std_logic;
		rst : in std_logic;
		ReLU_enabled : in std_logic;
		result_value : in std_logic_vector(31 downto 0);
		activation_request: in std_logic;
		result_value_out : out std_logic_vector(31 downto 0);
		activation_acknowledge : out std_logic
	);
	end component;
	
	--Pooling
	component Pooling is
	port(
		clk: in std_logic;
		rst: in std_logic;
		pool_size : in integer;
		sq_pool_size : in integer;
		pHeight : in integer;
		poolOffset : in integer;
		pooling_enabled : in std_logic;
		pooling_mode : in std_logic;
		framer_mode : in std_logic_vector(1 downto 0);
		framer_lastChannels : in std_logic;
		result_value : in std_logic_vector(31 downto 0);
		activation_request : in std_logic;
		pool_address : out std_logic_vector(31 downto 0);
		pool_data : out std_logic_vector(31 downto 0);
		pool_data_valid : out std_logic;
		activation_acknowledge : out std_logic
	);
	end component;
	
	
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
	
	component Divider is
	port (
		clk : in STD_LOGIC;
		rst : in std_logic;
		activation_request : in STD_LOGIC;
		divident : in  STD_LOGIC_VECTOR (31 downto 0); 
		divider: in  STD_LOGIC_VECTOR (31 downto 0);  
		quotient : out  STD_LOGIC_VECTOR (31 downto 0);  
		remainder : out  STD_LOGIC_VECTOR (31 downto 0);  
		activation_acknowledge : out STD_LOGIC
	); 
	end component;
	
	----------SIGNAL DECLARATION---------
	--CONV
	signal resultHeight : integer;
	signal resultWidth : integer;
	signal max_x : integer;
	signal max_y : integer;
	signal imageOffset : integer;
	signal resultOffset : integer;
	signal filterOffset : integer;
	signal wholeFilterOffset : integer;
	signal stride_data : integer;
	signal numOfData : integer;
	signal frameResult : std_logic_vector(31 downto 0);
	signal result_address_sig : std_logic_vector(31 downto 0);
	signal result_addr : std_logic_vector(31 downto 0);
	signal frameResult_valid : std_logic;
	signal previousResult_saved : std_logic;
	signal conv_ActivationRequest : std_logic;
	signal conv_ActivationAcknowledge : std_logic;
	signal frame_addToExisting : std_logic;
	signal frame_addToExisting_sig : std_logic;
	signal frame_lastChannels : std_logic;
	signal framerMode : std_logic_vector(1 downto 0);
	--ReLU
	signal ReLU_ActivationRequest: std_logic;
	signal ReLU_dataIn : std_logic_vector(31 downto 0);
	signal ReLU_dataOut : std_logic_vector(31 downto 0);
	signal ReLU_activationAcknowledge : std_logic;
	--Pooling
	signal pool_resultHeight : integer;
	signal pool_resultWidth : integer;
	signal sq_pool_size : integer;
	signal poolOffset : integer;
	signal pool_ActivationRequest : std_logic;
	signal pool_dataIn : std_logic_vector(31 downto 0);
	signal pool_dataOut : std_logic_vector(31 downto 0);
	signal pool_data_valid : std_logic;
	signal pool_ActivationAcknowledge : std_logic;
	---------
	type FSM_STATES is (init,activate_conv,working,finished);
	signal myState : FSM_STATES;
	
	type INIT_FSM is (init,init_1,init_2,init_3,init_4,finished);
	signal initialization : INIT_FSM;
	
	type WORKING_FSM is (idle,requestRead,waitRead,enableReLU,waitReLU,enablePooling,waitPooling,requestPoolMem,waitPoolMem,requestWrite,waitWrite);
	signal workingFSM : WORKING_FSM;
	
	--MUL/DIV signals
	signal sData_value1 : std_logic_vector(31 downto 0);
	signal sData_value2 : std_logic_vector(31 downto 0);
	signal sData_request : std_logic;
	signal sData_result : std_logic_vector(31 downto 0);
	signal sData_acknowledge : std_logic;
	
	signal nData_value1 : std_logic_vector(31 downto 0);
	signal nData_value2 : std_logic_vector(31 downto 0);
	signal nData_request : std_logic;
	signal nData_result : std_logic_vector(31 downto 0);
	signal nData_acknowledge : std_logic;
	
	signal imOffset_value1 : std_logic_vector(31 downto 0);
	signal imOffset_value2 : std_logic_vector(31 downto 0);
	signal imOffset_request : std_logic;
	signal imOffset_result : std_logic_vector(31 downto 0);
	signal imOffset_acknowledge : std_logic;
	
	signal resWidth_value1 : std_logic_vector(31 downto 0);
	signal resWidth_value2 : std_logic_vector(31 downto 0);
	signal resWidth_request : std_logic;
	signal resWidth_result : std_logic_vector(31 downto 0);
	signal resWidth_acknowledge : std_logic;
	
	signal resHeight_value1 : std_logic_vector(31 downto 0);
	signal resHeight_value2 : std_logic_vector(31 downto 0);
	signal resHeight_request : std_logic;
	signal resHeight_result : std_logic_vector(31 downto 0);
	signal resHeight_acknowledge : std_logic;
	
	signal start : std_logic;
	signal mul_div_rst : std_logic;
	signal mode_sig : std_logic_vector(1 downto 0);
	signal mode_sig_1 : std_logic_vector(1 downto 0);
	signal frame_lastChannels_sig : std_logic;
	
	
	signal init_finished : std_logic;
	signal result_activation_request_sig : std_logic;
	signal pool_activation_request_sig : std_logic;
	-------------------------------------
	
	
	

begin
	
	ConvolutionUnit : Multiple_Filter_Calculator
	port map(
		clk => clk,
		rst => rst,
		activation_request => conv_ActivationRequest,
		activation_acknowledge => conv_ActivationAcknowledge,
		-------SYSTEM CONSTANTS-----------
		stride => stride,
		filterDim => filterDim,
		iHeight => image_height,
		rHeight => resultHeight,
		max_x => max_x,
		max_y => max_y,
		image_offset => imageOffset,
		result_offset => resultOffset,
		filter_offset => filterOffset,
		wholeFilter_offset => wholeFilterOffset,
		filter_column_offset => filterDim,
		image_column_offset => image_height,
		numOfChannels => numOfChannels,
		numOfFilters => numOfFilters,
		stride_data => stride_data,
		numOfData => numOfData,
		----------------------------------
		-------IMAGE IC-------------------
		image_burst_request => image_burst_request,
		image_burst_acknowledge => image_burst_acknowledge,
		read_image => read_image,
		image_addr => image_addr,
		image_data_valid => image_data_valid,
		image_data_out => image_data_out,
		----------------------------------
		-------FILTER IC------------------
		filter_burst_request => filter_burst_request,
		filter_burst_acknowledge => filter_burst_acknowledge,
		read_filter => read_filter,
		filter_addr => filter_addr,
		filter_data_valid => filter_data_valid,
		filter_data_out => filter_data_out,
		----------------------------------
		result_out => frameResult,
		result_out_valid => frameResult_valid,
		result_address_out => result_address_sig,
		previous_result_saved => previousResult_saved,
		----------------------------------
		addToExisting => frame_addToExisting,
		lastChannels => frame_lastChannels,
		framerMode => framerMode
	);

	ReLUu : ReLU 
	port map(
		clk => clk,
		rst => rst,
		ReLU_enabled => ReLU_enabled,
		result_value => ReLU_dataIn,
		activation_request => ReLU_ActivationRequest,
		result_value_out => ReLU_dataOut,
		activation_acknowledge  => ReLU_ActivationAcknowledge
	);
	
	PoolingUnit : Pooling
	port map(
		clk => clk,
		rst => rst,
		pool_size => poolDim,
		sq_pool_size => sq_pool_size,
		pHeight => pool_resultHeight,
		poolOffset => poolOffset,
		pooling_enabled => Pooling_enabled,
		pooling_mode => pooling_mode,
		framer_mode => mode_sig,
		framer_lastChannels => frame_lastChannels_sig,
		result_value => pool_dataIn,
		activation_request => pool_ActivationRequest,
		pool_address => pool_address,
		pool_data => pool_data,
		pool_data_valid => pool_data_valid,
		activation_acknowledge => pool_ActivationAcknowledge
	);
	
	sData_sm : orig_shift_mul_add
	port map(
		clk => clk,
		rst => mul_div_rst,
		result_fromIndex => 31,
		result_toIndex  => 0,
		value1 => sData_value1,
		value2 => sData_value2,
		activation_request => sData_request,
		result_acknowledge => '0',
		overflow => open,
		underanked => open,
		result => sData_result,
		activation_acknowledge => open,
		result_request => sData_acknowledge
	);
	
	nData_sm : orig_shift_mul_add
	port map(
		clk => clk,
		rst => mul_div_rst,
		result_fromIndex => 31,
		result_toIndex  => 0,
		value1 => nData_value1,
		value2 => nData_value2,
		activation_request => nData_request,
		result_acknowledge => '0',
		overflow => open,
		underanked => open,
		result => nData_result,
		activation_acknowledge => open,
		result_request => nData_acknowledge
	);
	
	imOffset_sm : orig_shift_mul_add
	port map(
		clk => clk,
		rst => mul_div_rst,
		result_fromIndex => 31,
		result_toIndex  => 0,
		value1 => imOffset_value1,
		value2 => imOffset_value2,
		activation_request => imOffset_request,
		result_acknowledge => '0',
		overflow => open,
		underanked => open,
		result => imOffset_result,
		activation_acknowledge => open,
		result_request => imOffset_acknowledge
	);
	
	resWidth_div : Divider
	port map (
		clk => clk,
		rst => mul_div_rst,
		activation_request => resWidth_request, 
		divident => resWidth_value1,
		divider => resWidth_value2,
		quotient => resWidth_result,
		remainder => open, 
		activation_acknowledge => resWidth_acknowledge
	); 
	
	resHeight_div : Divider
	port map (
		clk => clk,
		rst => mul_div_rst,
		activation_request => resHeight_request, 
		divident  => resHeight_value1,
		divider => resHeight_value2,
		quotient => resHeight_result,
		remainder => open, 
		activation_acknowledge => resHeight_acknowledge
	); 
	
	process(clk) is
	begin
		if(rising_edge(clk)) then
			if(rst = '1') then
				init_finished <= '0';
				initialization <= init;
				mul_div_rst <= '1';
				start <= '0';
			else 
				case initialization is
					when init =>
						mul_div_rst <= '0';
						max_x <= image_width - filterDim + 1;
						max_y <= image_height - filterDim + 1;
						--stride data
						sData_value1 <= std_logic_vector(to_unsigned(stride,32));
						sData_value2 <= std_logic_vector(to_unsigned(filterDim,32));
						-------------
						--numOfData/filterOffset
						nData_value1 <= std_logic_vector(to_unsigned(filterDim,32));
						nData_value2 <= std_logic_vector(to_unsigned(filterDim,32));
						-------------
						--imageOffset
						imOffset_value1 <= std_logic_vector(to_unsigned(image_width,32));
						imOffset_value2 <= std_logic_vector(to_unsigned(image_height,32));
						-------------
						if(start = '0') then
							sData_request <= '1';
							nData_request <= '1';
							imOffset_request <= '1';
							start<= '1';
						else
							sData_request <= '0';
							nData_request <= '0';
							imOffset_request <= '0';
							if(nData_acknowledge = '1' and sData_acknowledge = '1' and imOffset_acknowledge = '1') then
								filterOffset <= to_integer(unsigned(nData_result));
								numOfData <= to_integer(unsigned(nData_result));
								imageOffset <= to_integer(unsigned(imOffset_result));
								stride_data <= to_integer(unsigned(sData_result));
								start <= '0';
								initialization <= init_1;
								mul_div_rst <= '1';
							end if;
						end if;
					when init_1 =>
						mul_div_rst <= '0';
						--resWidth / resHeight
						if(stride=1) then
							resultWidth <= max_x;
							resultHeight <= max_y;
						else
							resWidth_value1 <= std_logic_vector(to_unsigned(image_width - filterDim,32));
							resWidth_value2 <= std_logic_vector(to_unsigned(stride,32));
							resHeight_value1 <= std_logic_vector(to_unsigned(image_height - filterDim,32));
							resHeight_value2 <= std_logic_vector(to_unsigned(stride,32));
						end if;
						--wholeFilterOffset
						nData_value1 <= std_logic_vector(to_unsigned(numOfChannels,32));
						nData_value2 <= std_logic_vector(to_unsigned(filterOffset,32));
						-------------------
						if(start = '0') then
							start <= '1';
							nData_request <= '1';
							if(stride>1) then
								resHeight_request <= '1';
								resWidth_request <= '1';
							end if;
						else
							nData_request <= '0';
							resHeight_request <= '0';
							resWidth_request <= '0';
							if(stride = 1) then
								if(nData_acknowledge = '1') then
									wholeFilterOffset <= to_integer(unsigned(nData_result));
									initialization <= init_2;
									mul_div_rst <= '1';
									start <= '0';
								end if;
							else
								if(resWidth_acknowledge ='1' and resHeight_acknowledge = '1' and nData_acknowledge = '1') then
									wholeFilterOffset <= to_integer(unsigned(nData_result));
									resultHeight <= to_integer(unsigned(resHeight_result)) + 1;
									resultWidth <= to_integer(unsigned(resWidth_result)) + 1;
									start<= '0';
									initialization <= init_2;
									mul_div_rst <= '1';
								end if;
							end if;
						end if;
					when init_2 =>
						mul_div_rst <= '0';
						--resultOffset 
						nData_value1 <= std_logic_vector(to_unsigned(resultWidth,32));
						nData_value2 <= std_logic_vector(to_unsigned(resultHeight,32));
						--poolHeight
						resHeight_value1 <= std_logic_vector(to_unsigned(resultHeight - poolDim,32));
						resHeight_value2 <= std_logic_vector(to_unsigned(poolDim,32)); 
						--poolWidth
						resWidth_value1 <= std_logic_vector(to_unsigned(resultWidth - poolDim,32));
						resWidth_value2 <= std_logic_vector(to_unsigned(poolDim,32)); 
						if(start = '0') then
							start<= '1';
							nData_request <= '1';
							resWidth_request <= '1';
							resHeight_request <= '1';
						else
							nData_request <= '0';
							resWidth_request <= '0';
							resHeight_request <= '0';
							if(nData_acknowledge = '1' and resHeight_acknowledge = '1' and resWidth_acknowledge = '1') then
								resultOffset <= to_integer(unsigned(nData_result));
								pool_resultWidth <= to_integer(unsigned(resWidth_result)) + 1;
								pool_resultHeight <= to_integer(unsigned(resHeight_result)) + 1;
								initialization <= init_3;
								start<= '0';
								mul_div_rst <= '1';
							end if;
						end if;
					when init_3 =>
						mul_div_rst <= '0';
						--poolOffset 
						nData_value1 <= std_logic_vector(to_unsigned(pool_resultWidth,32));
						nData_value2 <= std_logic_vector(to_unsigned(pool_resultHeight,32));
						--sq_pool_size 
						sData_value1 <= std_logic_vector(to_unsigned(poolDim,32));
						sData_value2 <= std_logic_vector(to_unsigned(poolDim,32));
						if(start = '0') then
							start<= '1';
							nData_request <= '1';
							sData_request <= '1';
						else
							nData_request <= '0';
							sData_request <= '0';
							if(nData_acknowledge = '1' and sData_acknowledge = '1') then
								initialization <= init_4;
								poolOffset <= to_integer(unsigned(nData_result));
								sq_pool_size <= to_integer(unsigned(sData_result));
								mul_div_rst <= '1';
								start <= '0';
							end if;
						end if;
					when init_4 => 
						mul_div_rst <= '0';
						--result_DataSize
						nData_value1 <= std_logic_vector(to_unsigned(resultOffset,32));
						nData_value2 <= std_logic_vector(to_unsigned(numOfFilters,32));
						--pool_DataSize 
						sData_value1 <= std_logic_vector(to_unsigned(poolOffset,32));
						sData_value2 <= std_logic_vector(to_unsigned(numOfFilters,32));
						if(start = '0') then
							start <= '1';
							sData_request <= '1';
							nData_request <= '1';
						else
							sData_request <= '0';
							nData_request <= '0';
							if(nData_acknowledge = '1' and sData_acknowledge = '1') then
								start <= '0';
								result_dataSize <= nData_result;
								pool_dataSize <= sData_result;
								initialization <= finished;
								init_finished <= '1';
							end if;
						end if;
						
					when finished =>
						--nop
				end case;
			end if;
		end if;
	end process;
	
	process(clk) is
	variable processData : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";
	begin
		if(rising_edge(clk)) then
			if(rst = '1') then
				conv_ActivationRequest <= '0';
				ReLU_ActivationRequest <= '0';
				pool_ActivationRequest <= '0';
				result_activation_request_sig <= '0';
				pool_activation_request_sig <= '0';
				pool_dataIn <= "00000000000000000000000000000000";
				myState <= init;
				workingFSM <= idle;
				previousResult_saved <= '0';
			else
				case myState is 
					when init=>
						if(init_finished = '1') then
							myState <= activate_conv;
							result_init_file <= '1';
							pool_init_file <= '1';
						end if;
					when activate_conv =>
						result_init_file <= '0';
						pool_init_file <= '0';
						conv_ActivationRequest <= '1';
						myState <= working;
					when working =>
						conv_ActivationRequest <= '0';					
						case workingFSM is
							when idle =>
								if(frameResult_valid = '1') then
									previousResult_saved <= '0';
									processData := frameResult;
									if(frame_AddToExisting = '1') then
										workingFSM <= requestRead;
									else 
										workingFSM <= enableReLU;
									end if;
									mode_sig <= mode_sig_1;
									result_addr <= result_address_sig;
									frame_lastChannels_sig <= frame_lastChannels;
								end if;
							when requestRead =>
								if(result_activation_request_sig = '0') then
									result_read_write <= '0'; 
									result_activation_request_sig <= '1';
									result_address <= result_addr;
								else
									result_activation_request_sig <= '0';
									workingFSM <= waitRead;
								end if;
							when waitRead =>
								if(result_activation_acknowledge = '1') then
									signed_addition_32with32bit(result_read_data,processData,processData);
									workingFSM <= enableReLU;
								end if;
							when enableReLU =>
								if(frame_lastChannels_sig = '1') then
									if(ReLU_enabled = '1') then
										if(ReLU_ActivationRequest = '0') then
											ReLU_ActivationRequest <= '1';
											ReLU_dataIn <= processData;
										else
											ReLU_ActivationRequest <= '0';
											workingFSM <= waitReLU;
										end if;
									elsif(Pooling_enabled = '1') then
										workingFSM <= enablePooling;
									else
										workingFSM <= requestWrite;
									end if;
								else
									workingFSM <= requestWrite;
								end if;
							when waitReLU =>
								if(ReLU_ActivationAcknowledge = '1') then
									processData := ReLU_dataOut;
									if(pooling_enabled = '1') then
										workingFSM <= enablePooling;
									else
										workingFSM <= requestWrite;
									end if;
								end if;
							when enablePooling =>
								if(pool_ActivationRequest = '0') then
									pool_ActivationRequest <= '1';
									if(processData(30 downto 8) /= "00000000000000000000000") then
										pool_dataIn <= processData(31) & "0000000000000000000000011111111";
									else
										pool_dataIn <= processData;
									end if;
								else 
									workingFSM <= waitPooling;
									pool_ActivationRequest <= '0';
								end if;
							when waitPooling =>
								if(pool_ActivationAcknowledge = '1') then
									if(pool_data_valid = '1') then
										workingFSM <= requestPoolMem;
									else
										workingFSM <= requestWrite;
									end if;
								end if;
							when requestPoolMem =>
								if(pool_activation_request_sig = '0') then
									pool_activation_request_sig <= '1';
								else 
									pool_activation_request_sig <= '0';
									workingFSM <= waitPoolMem;
								end if;
							when waitPoolMem =>
								if(pool_activation_acknowledge = '1') then
									workingFSM <= requestWrite;
								end if;
							when requestWrite =>
								if(result_activation_request_sig = '0') then
									result_read_write <= '1';
									result_activation_request_sig <= '1';
									result_address <= result_addr;
									if(processData(30 downto 8) /= "00000000000000000000000") then
										result_data <= processData(31) & "1111111111111111111111111111111";
									else
										result_data <= processData;
									end if;
								else
									result_activation_request_sig <= '0';
									workingFSM <= waitWrite;
								end if;
							when waitWrite =>
								if(result_activation_acknowledge = '1') then
									if(conv_ActivationAcknowledge = '1') then
										myState <= finished;
									end if; 
									workingFSM <= idle;
									previousResult_saved <= '1';
								end if;
						end case;
					when finished =>
						
				end case;
			end if;
		end if;
	end process;
	
	pool_activation_request <= pool_activation_request_sig;
	result_activation_request <= result_activation_request_sig;
	mode_sig_1 <= framerMode when framerMode/="00" else mode_sig_1;
end Behavioral;

