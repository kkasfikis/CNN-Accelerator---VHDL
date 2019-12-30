library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use work.HelperProcedures.All;
USE ieee.numeric_std.ALL;

entity Pooling is
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
end Pooling;

architecture Behavioral of Pooling is
	
	component RAM_4096x32 is
	port(
		--PORT A
		ADDRA : in std_logic_vector(11 downto 0);
		DINA : in std_logic_vector(31 downto 0);
		WEA : in std_logic_vector(0 downto 0);
		RSTA : in std_logic;
		CLKA : in std_logic;
		DOUTA : out std_logic_vector(31 downto 0);
		--PORT B
		ADDRB : in std_logic_vector(11 downto 0);
		DINB : in std_logic_vector(31 downto 0);
		WEB : in std_logic_vector(0 downto 0);
		RSTB : in std_logic;
		CLKB : in std_logic;
		DOUTB : out std_logic_vector(31 downto 0)
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
	
	-----------SIGNAL DECLARATION-------------------
	signal read_addr_sig : std_logic_vector(11 downto 0);
	signal read_addr_int : integer range 0 to 4095;
	signal write_addr_sig : std_logic_vector(11 downto 0);
	signal write_addr_int : integer range 0 to 4095;
	signal valid_write_data_sig : std_logic_vector(0 downto 0);
	signal valid_write : std_logic;
	signal current_pool_x : integer;
	signal current_pool_y : integer;
	signal current_pool_y_sig : std_logic_vector(31 downto 0);
	signal column_count : integer range 0 to 63;
	signal row_count : integer range 0 to 63;
	signal pool_write_data : std_logic_vector(31 downto 0);
	signal pool_read_data : std_logic_vector(31 downto 0);
	signal result_data_sig : std_logic_vector(31 downto 0);
	signal p_line_addr,p_pos_addr : std_logic_vector(31 downto 0);
	type CALC_STATES is (calculateAddr_1,calculateAddr_2,calculateAddr_3);
	signal calcState : CALC_STATES;
	type FSM_STATES is (idle,readData_0,readData,readData_1,writeData,getMemAddr);
	signal myState : FSM_STATES;
	signal p_sm0_value1_sig,p_sm0_value2_sig,p_sm0_result_sig,p_sm1_value1_sig,p_sm1_value2_sig,p_sm1_result_sig,p_sm2_value1_sig,p_sm2_value2_sig,p_sm2_result_sig  : std_logic_vector(31 downto 0);
	signal p_sm0_request_sig,p_sm0_ack_sig,p_sm1_request_sig,p_sm1_ack_sig,p_sm2_request_sig,p_sm2_ack_sig: std_logic;
	signal mul_rst : std_logic;
	signal pHeight_sig : std_logic_vector(31 downto 0);
	signal startCalc,finishedCalc : std_logic;
	signal firstFilter : std_logic;
	signal offset_sig : std_logic_vector(31 downto 0);
	signal buffer_rst : std_logic;
	signal buf_rst : std_logic;
	
	signal div_value1 : std_logic_vector(31 downto 0);
	signal div_value2 : std_logic_vector(31 downto 0);
	signal div_request : std_logic;
	signal div_acknowledge : std_logic;
	signal div_result : std_logic_vector(31 downto 0);
	signal div_rst : std_logic;
	------------------------------------------------
	
begin

	p_sm0 : orig_shift_mul_add
	port map(
		clk => clk,
		rst => mul_rst,
		result_fromIndex => 31,
		result_toIndex  => 0,
		value1 => p_sm0_value1_sig,
		value2 => p_sm0_value2_sig,
		activation_request => p_sm0_request_sig,
		result_acknowledge => '0',
		overflow => open,
		underanked => open,
		result => p_sm0_result_sig,
		activation_acknowledge => open,
		result_request => p_sm0_ack_sig
	);
	
	p_sm1 : orig_shift_mul_add
	port map(
		clk => clk,
		rst => mul_rst,
		result_fromIndex => 31,
		result_toIndex  => 0,
		value1 => p_sm1_value1_sig,
		value2 => p_sm1_value2_sig,
		activation_request => p_sm1_request_sig,
		result_acknowledge => '0',
		overflow => open,
		underanked => open,
		result => p_sm1_result_sig,
		activation_acknowledge => open,
		result_request => p_sm1_ack_sig
	);
	
	p_sm2 : orig_shift_mul_add
	port map(
		clk => clk,
		rst => mul_rst,
		result_fromIndex => 31,
		result_toIndex  => 0,
		value1 => p_sm2_value1_sig,
		value2 => p_sm2_value2_sig,
		activation_request => p_sm2_request_sig,
		result_acknowledge => '0',
		overflow => open,
		underanked => open,
		result => p_sm2_result_sig,
		activation_acknowledge => open,
		result_request => p_sm2_ack_sig
	);
	
	div : Divider
	port map (
		clk => clk,
		rst => div_rst,
		activation_request => div_request, 
		divident => div_value1,
		divider => div_value2,
		quotient => div_result,
		remainder => open, 
		activation_acknowledge => div_acknowledge
	); 

	POOL_BUFFER : RAM_4096x32 
	port map(
		ADDRA =>read_addr_sig,
		DINA => "00000000000000000000000000000000",
		WEA => "0",
		RSTA =>buffer_rst,
		CLKA =>clk,
		DOUTA =>pool_read_data,
		ADDRB =>write_addr_sig,
		DINB =>pool_write_data,
		WEB =>valid_write_data_sig,
		RSTB =>buffer_rst,
		CLKB =>clk,
		DOUTB => open
	);
	
	
	process(clk) is	
	begin
		if(rising_edge(clk)) then
			if(rst = '1') then
				mul_rst <= '1';
				calcState <= calculateAddr_1;
				finishedCalc <= '0';
				firstFilter <= '0';
				offset_sig <= "00000000000000000000000000000000";
			elsif(activation_request= '1' and framer_mode = "11") then
				mul_rst <= '1';
				calcState <= calculateAddr_1;
				finishedCalc <= '0';
				if(firstFilter = '1') then
					--offset_sig <= std_logic_vector(unsigned(offset_sig) + to_unsigned(poolOffset,32));
				else
					offset_sig <= "00000000000000000000000000000000";
					firstFilter <= '1';
				end if;
			else
				case calcState is
					when calculateAddr_1 =>
						mul_rst <= '0';
						if( startCalc = '1' ) then
							finishedCalc <= '0';
							
							p_sm0_value1_sig <= "00" & pHeight_sig(31 downto 2);
							p_sm0_value2_sig <= std_logic_vector(to_unsigned(current_pool_x,32));
							
							p_sm1_value1_sig <= "000000000000000000000000000000" & pHeight_sig(1 downto 0);
							p_sm1_value2_sig <= std_logic_vector(to_unsigned(current_pool_x,32));
							
							p_sm2_value1_sig <= pHeight_sig;
							p_sm2_value2_sig <= std_logic_vector(to_unsigned(current_pool_x,32));
							
							p_sm0_request_sig <= '1';
							p_sm1_request_sig <= '1';
							p_sm2_request_sig <= '1';
							
							
							calcState <= calculateAddr_2;
						end if;
					when calculateAddr_2 =>
						mul_rst <= '0';
						
						p_sm0_request_sig <= '0';
						p_sm1_request_sig <= '0';
						p_sm2_request_sig <= '0';
						
						if(p_sm0_ack_sig = '1' and p_sm1_ack_sig = '1' and p_sm2_ack_sig = '1') then
							
							p_line_addr <= std_logic_vector(unsigned(p_sm0_result_sig) + unsigned("00" & p_sm1_result_sig(31 downto 2)) + unsigned("00" & current_pool_y_sig(31 downto 2)));   
							p_pos_addr <= std_logic_vector(unsigned("000000000000000000000000000000" & p_sm2_result_sig(1 downto 0)) + unsigned("000000000000000000000000000000" & current_pool_y_sig(1 downto 0)));
							
							calcState <= calculateAddr_3;
						end if;
					when calculateAddr_3 =>
						pool_address <= std_logic_vector(unsigned(offset_sig) + unsigned(p_line_addr(29 downto 0) & "00") + unsigned(p_pos_addr));
						calcState <= calculateAddr_1;
						finishedCalc <= '1';							
						mul_rst <= '1';
				end case;
			end if;
		end if;
	end process;
	
	-----------------------------------------------
	process(clk) is 
	variable pool_write_data_sig : std_logic_vector(31 downto 0);
	begin
		if(rising_edge(clk)) then
			if(rst = '1') then
				buf_rst <= '0';
				column_count <= 0;
				row_count <= 0;
				read_addr_int <= 0;
				write_addr_int <= 0;
				current_pool_x <= 0;
				current_pool_y <= 0;
				startCalc <= '0';
				myState<= idle;
				valid_write <= '0';
				pool_data_valid <= '0';
				buf_rst <= '0';
				activation_acknowledge <= '0';
				pool_write_data <= "00000000000000000000000000000000";
				pool_data <= "00000000000000000000000000000000"; 
				pool_write_data_sig := "00000000000000000000000000000000";
				div_rst <= '1';
			else
				div_rst <= '0';
				case myState is
					when idle =>
						valid_write <= '0';
						if(activation_request = '1') then
							pool_data_valid<= '0';
							if(framer_mode = "11") then
								column_count <= 1;
								row_count <= 1;
								read_addr_int <= 0;
								write_addr_int <= 0;
								current_pool_x <= 0;
								current_pool_y <= 0;
							elsif(framer_mode = "10") then
								if(column_count < pool_size) then
									column_count <= column_count + 1;
								else
									current_pool_x <= current_pool_x + 1;
									column_count <= 1;
									read_addr_int <= read_addr_int + 1;
									write_addr_int <= write_addr_int + 1;
								end if;
							elsif(framer_mode = "01") then
								read_addr_int <= 0;
								write_addr_int <= 0;
								current_pool_x <= 0;
								column_count <= 1;
								if(row_count < pool_size) then
									row_count <= row_count + 1;
								else
									current_pool_y <= current_pool_y +1;
									row_count <= 1;
								end if;
							end if;
							activation_acknowledge <= '0';
							myState <= readData_0;
							result_data_sig <= result_value;
						end if;
					when readData_0 =>
						myState<= readData;
					when readData=>
						if(pooling_mode ='0')then --AVG
							if(row_count =1 and column_count = 1) then
								pool_write_data <= result_data_sig;
								myState <= writeData;
							else
								signed_addition_32with32bit(pool_read_data,result_data_sig,pool_write_data_sig);
								myState <= readData_1;
							end if;
						else							  --MAX
							if(row_count =1 and column_count = 1) then
								pool_write_data <= result_data_sig;
							else
								if(pool_read_data(31) = result_data_sig(31)) then
									if(to_integer(unsigned(pool_read_data(30 downto 0))) < to_integer(unsigned(result_data_sig(30 downto 0)))) then
										pool_write_data <= result_data_sig;
									else
										pool_write_data <= pool_read_data;
									end if;
								else
									if(pool_read_data(31) = '1') then
										pool_write_data <= result_data_sig;
									else
										pool_write_data <= pool_read_data;
									end if;
								end if;
							end if;
							myState <= writeData;
						end if;
					when readData_1 =>
						pool_write_data <= pool_write_data_sig;
						myState <= writeData;
					when writeData=>
						valid_write <= '1';
						if(row_count = pool_size and column_count = pool_size) then
							startCalc <= '1';
							if(pooling_mode = '0') then
								div_value1 <= pool_write_data;
								div_value2 <= std_logic_vector(to_unsigned(sq_pool_size,32));
								div_request <= '1';
								div_rst <= '0';
							end if;
							myState <= getMemAddr;
						else
							activation_acknowledge <= '1';
							myState <= idle;
						end if;
						pool_data <= pool_write_data;
					when getMemAddr=>
						startCalc <= '0';
						valid_write <= '0';
						if(finishedCalc = '1' and startCalc = '0') then
							if(pooling_mode = '0') then
								div_request <= '0';
								if(div_acknowledge = '1') then
									myState <= idle;
									activation_acknowledge <= '1';
									pool_data_valid <= '1';
									pool_data <= div_result;
									div_rst <= '1';
								end if;
							else
								myState <= idle;
								activation_acknowledge <= '1';
								pool_data_valid <= '1';
							end if;
						end if;
				end case;
			end if;
		end if;
	end process;	
	----------------------------------------------
	buffer_rst <= rst or buf_rst;
	read_addr_sig <= std_logic_vector(to_unsigned(read_addr_int,12));
	write_addr_sig <= std_logic_vector(to_unsigned(write_addr_int,12));
	valid_write_data_sig <= "1" when valid_write='1' else "0";
	current_pool_y_sig <= std_logic_vector(to_unsigned(current_pool_y,32));
	pHeight_sig <= std_logic_vector(to_unsigned(pHeight,32));
	
end Behavioral;

