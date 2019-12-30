library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.HelperProcedures.ALL;
entity full_adder_ctrl is
port(
	--inputs
	clk : in std_logic;
	rst : in std_logic;
	result0 : in std_logic_vector(31 downto 0);
	result1 : in std_logic_vector(31 downto 0);
	result2 : in std_logic_vector(31 downto 0);
	result3 : in std_logic_vector(31 downto 0);
	result4 : in std_logic_vector(31 downto 0);
	result5 : in std_logic_vector(31 downto 0);
	result6 : in std_logic_vector(31 downto 0);
	result7 : in std_logic_vector(31 downto 0);
	result8 : in std_logic_vector(31 downto 0);
	result9 : in std_logic_vector(31 downto 0);
	result10 : in std_logic_vector(31 downto 0);
	result11 : in std_logic_vector(31 downto 0);
	result12 : in std_logic_vector(31 downto 0);
	result13 : in std_logic_vector(31 downto 0);
	result14 : in std_logic_vector(31 downto 0);
	result_request : in std_logic_vector(14 downto 0);
	numOfData : in integer;
	--outputs
	buffer_full : out std_logic;
	sum : out std_logic_vector(31 downto 0);
	final_sum : out std_logic;
	result_acknowledge : out std_logic_vector(14 downto 0)
);
end full_adder_ctrl;

architecture Behavioral of full_adder_ctrl is

	component RAM_256x32 is
	port(
		--PORT A
		ADDRA : in std_logic_vector(7 downto 0);
		DINA : in std_logic_vector(31 downto 0);
		WEA : in std_logic_vector(0 downto 0);
		RSTA : in std_logic;
		CLKA : in std_logic;
		DOUTA : out std_logic_vector(31 downto 0);
		--PORT B
		ADDRB : in std_logic_vector(7 downto 0);
		DINB : in std_logic_vector(31 downto 0);
		WEB : in std_logic_vector(0 downto 0);
		RSTB : in std_logic;
		CLKB : in std_logic;
		DOUTB : out std_logic_vector(31 downto 0)
	);
	end component;

	------------------SIGNAL DECLARATION--------------------------
	signal read_addr_int : integer range 0 to 255;
	signal write_addr_int : integer range 0 to 255;
	signal read_addr_sig : std_logic_vector(7 downto 0);
	signal read_data_sig : std_logic_vector(31 downto 0);
	signal write_addr_sig : std_logic_vector(7 downto 0);
	signal write_data_sig : std_logic_vector(31 downto 0);
	signal valid_write_sig : std_logic;
	signal valid_write : std_logic_vector(0 downto 0);
	signal sum_sig : std_logic_vector(63 downto 0);
	signal valid_read : std_logic;
	signal buffer_counter :integer range 0 to 255;
	signal buffer_empty : std_logic;
	signal numData : integer;
	type FSM_STATES is (idle,workaround);
	signal myState_read : FSM_STATES;
	signal myState_write : FSM_STATES;
	--------------END OF SIGNAL DECLARATION-----------------------
begin
	
	CB : RAM_256x32 
	port map(
		ADDRA =>read_addr_sig,
		DINA => "00000000000000000000000000000000",
		WEA => "0",
		RSTA =>rst,
		CLKA =>clk,
		DOUTA =>read_data_sig,
		ADDRB =>write_addr_sig,
		DINB =>write_data_sig,
		WEB =>valid_write,
		RSTB =>rst,
		CLKB =>clk,
		DOUTB => open
	);

	--------------PROCESS WRITE-----------------------------
	process(clk) is
	begin
		if(rising_edge(clk))then
			if(rst='1')then
				write_addr_int <= 0;
				result_acknowledge <= "000000000000000";
				write_data_sig <= "00000000000000000000000000000000";
				myState_write <= idle;
			else
				case myState_write is 
					when idle =>
						if(buffer_counter>=254 or result_request= "000000000000000") then
							valid_write <="0";
							result_acknowledge <= "000000000000000";
							write_data_sig <= "00000000000000000000000000000000";
						else
							myState_write <= workaround;
							valid_write <= "1";
							if(result_request(0)='1') then
								result_acknowledge <= "000000000000001";
								write_data_sig <= result0;
							elsif (result_request(1)='1') then
								result_acknowledge <= "000000000000010";
								write_data_sig <= result1;
							elsif (result_request(2)='1') then
								result_acknowledge <= "000000000000100";
								write_data_sig <= result2;
							elsif (result_request(3)='1') then
								result_acknowledge <= "000000000001000";
								write_data_sig <= result3;
							elsif (result_request(4)='1') then
								result_acknowledge <= "000000000010000";
								write_data_sig <= result4;
							elsif (result_request(5)='1') then
								result_acknowledge <= "000000000100000";
								write_data_sig <= result5;
							elsif (result_request(6)='1') then
								result_acknowledge <= "000000001000000";
								write_data_sig <= result6;
							elsif (result_request(7)='1') then
								result_acknowledge <= "000000010000000";
								write_data_sig <= result7;
							elsif (result_request(8)='1') then
								result_acknowledge <= "000000100000000";
								write_data_sig <= result8;
							elsif (result_request(9)='1') then
								result_acknowledge <= "000001000000000";
								write_data_sig <= result9;
							elsif (result_request(10)='1') then
								result_acknowledge <= "000010000000000";
								write_data_sig <= result10;
							elsif (result_request(11)='1') then
								result_acknowledge <= "000100000000000";
								write_data_sig <= result11;
							elsif (result_request(12)='1') then
								result_acknowledge <= "001000000000000";
								write_data_sig <= result12;
							elsif (result_request(13)='1') then
								result_acknowledge <= "010000000000000";
								write_data_sig <= result13;
							elsif (result_request(14)='1') then
								result_acknowledge <= "100000000000000";
								write_data_sig <= result14;
							end if;
						end if;
					when workaround =>
						valid_write <= "0";
						write_addr_int <= write_addr_int + 1;
						myState_write <= idle;
				end case;
			end if;
		end if;
	end process;
	--------------END OF PROCESS WRITE--------------------------------------
	
	--------------PROCESS READ/ ADDER----------------------------------------------
	process(clk) is
	variable mySum : std_logic_vector(63 downto 0);
	begin
		if(rising_edge(clk))then
			if(rst = '1') then
				numData <= 0;
				sum_sig <= "0000000000000000000000000000000000000000000000000000000000000000";
				mySum := "0000000000000000000000000000000000000000000000000000000000000000";
				read_addr_int <= 0;
				valid_read <= '0';
				myState_read <= idle;
			else
				case myState_read is 
					when idle =>
						if(buffer_counter > 0) then
							valid_read<='1';
							myState_read <= workaround;
						else
							valid_read <='0';
						end if;
					when workaround =>
						
						signed_addition_64with32bit(read_data_sig,mySum,mySum);
						sum_sig <= mySum;
						read_addr_int <= read_addr_int + 1;
						myState_read <= idle;
						numData <= numData + 1;
						valid_read <= '0';
				end case;
			end if;
		end if;
	end process;
	--------------END OF PROCESS READ/ ADDER---------------------------------------
	
	-----------BUFFER COUNTER PROCESS-------------
	process(clk) is
	begin 
		if (rising_edge(clk)) then
			if (rst='1') then
				buffer_counter <= 0;
			else
				if(buffer_counter>0 and valid_read ='1' and valid_write_sig='0') then
					buffer_counter <= buffer_counter - 1;
				elsif (valid_read ='0' and valid_write_sig='1') then
					buffer_counter <= buffer_counter + 1;
				end if;
			end if;
		end if;
	end process;
	----------END OF BUFFER COUNTER PROCESS--------
	final_sum <= '1' when (numData=numOfData and rst='0' and numOfData/=0) else '0';
	buffer_full <= '1' when buffer_counter>=254 else '0';
	buffer_empty <= '1' when buffer_counter=0 else '0';
	read_addr_sig <= std_logic_vector(to_unsigned(read_addr_int,8));
	write_addr_sig <= std_logic_vector(to_unsigned(write_addr_int,8));
	sum <= sum_sig(63) & sum_sig(30 downto 0) when sum_sig(62 downto 31)= "00000000000000000000000000000000" else  sum_sig(63) & "1111111111111111111111111111111";
	valid_write_sig <= '1' when valid_write="1" else '0';
	
end Behavioral;