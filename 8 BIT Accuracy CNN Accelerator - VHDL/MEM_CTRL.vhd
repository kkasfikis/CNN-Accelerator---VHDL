library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity MEM_CTRL is
port(
	---------------INPUTS--------------
	clk: in std_logic;
	rst: in std_logic;
	mode : in std_logic_vector(1 downto 0); 
	stride_data : in integer; -- stride * values per column
	numOfData : in integer;
	data1 : in std_logic_vector(31 downto 0);
	data1_valid : in std_logic;
	data2 : in std_logic_vector(31 downto 0);
	data2_valid : in std_logic;
	CCU_buffer_full : in std_logic;
	-------------OUTPUTS---------------
	CCU_rst : out std_logic;
	value1 : out std_logic_vector(31 downto 0);
	value2 : out std_logic_vector(31 downto 0);
	value_valid : out std_logic
);
end MEM_CTRL;

architecture Behavioral of MEM_CTRL is

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
	
	----------SIGNAL DECLARATION---------------
	signal read1_addr_sig : std_logic_vector(7 downto 0);
	signal read2_addr_sig : std_logic_vector(7 downto 0);
	signal read1_addr_int : integer range 0 to 255;
	signal read2_addr_int : integer range 0 to 255;
	signal write1_addr_sig : std_logic_vector(7 downto 0);
	signal write1_addr_int : integer range 0 to 255;
	signal write2_addr_sig : std_logic_vector(7 downto 0);
	signal write2_addr_int : integer range 0 to 255;
	signal valid_write_data1_sig : std_logic_vector(0 downto 0);
	signal valid_write_data2_sig : std_logic_vector(0 downto 0);
	signal value1_sig : std_logic_vector(31 downto 0);
	signal value2_sig : std_logic_vector(31 downto 0);
	signal buffer1_counter : integer;
	signal buffer2_counter : integer;
	signal CCU_buffer_full_sig : std_logic;
	signal valid_read : std_logic;
	signal data_counter :integer;
	type FSM_STATES is (idle,read_data);
	signal myState : FSM_STATES;
	----------END OF SIGNAL DECLARATION--------
	
begin
	
	--------IMAGE LOCAL BUFFER-----------------
	LB1 : RAM_256x32 
	port map(
		ADDRA =>read1_addr_sig,
		DINA => "00000000000000000000000000000000",
		WEA => "0",
		RSTA =>rst,
		CLKA =>clk,
		DOUTA =>value1_sig,
		ADDRB =>write1_addr_sig,
		DINB =>data1,
		WEB =>valid_write_data1_sig,
		RSTB =>rst,
		CLKB =>clk,
		DOUTB => open
	);
	-------------------------------------------
	
	---------FILTER LOCAL BUFFER---------------
	LB2 : RAM_256x32 
	port map(
		ADDRA =>read2_addr_sig,
		DINA => "00000000000000000000000000000000",
		WEA => "0",
		RSTA =>rst,
		CLKA =>clk,
		DOUTA =>value2_sig,
		ADDRB =>write2_addr_sig,
		DINB =>data2,
		WEB =>valid_write_data2_sig,
		RSTB =>rst,
		CLKB =>clk,
		DOUTB => open
	);
	--------------------------------------------

	-----------BUFFER1/2 COUNTER PROCESS-------------
	process(clk) is
	begin 
		if (rising_edge(clk)) then
			if (rst='1') then
				buffer1_counter <= 0;
				buffer2_counter <= 0;
			else
				if(mode = "11" or mode = "01") then
					buffer1_counter <= 0;
					if(mode = "11")then
						buffer2_counter <= 0;
					else
						buffer2_counter <= numOfData;
					end if;
				elsif(mode="10") then
					buffer1_counter <= numOfData - stride_data;
					buffer2_counter <= numOfData;
				else
					if(buffer1_counter>0 and buffer2_counter>0 and valid_read='1' and data1_valid='0') then
						buffer1_counter <= buffer1_counter - 1;
					elsif (valid_read='0' and data1_valid='1') then
						buffer1_counter <= buffer1_counter + 1;
					end if;
					if(buffer1_counter>0 and buffer2_counter>0 and valid_read ='1' and data2_valid='0') then
						buffer2_counter <= buffer2_counter - 1;
					elsif (valid_read='0' and data2_valid='1') then
						buffer2_counter <= buffer2_counter + 1;
					end if;
				end if;
			end if;
		end if;
	end process;
	----------END OF BUFFER1/2 COUNTER PROCESS--------
	
	------------------READ PROCESS--------------------
	process(clk) is
	begin
		if(rising_edge(clk))then
			if(rst='1')then
				value1 <= "00000000000000000000000000000000";
				value2 <= "00000000000000000000000000000000";
				value_valid <= '0';
				read1_addr_int <= 0;
				read2_addr_int <= 0;
				valid_read <= '0';
				myState <= idle;
				CCU_rst <= '0';
			else
				if(mode = "11") then
					myState<= idle;
					read1_addr_int <= 0;
					read2_addr_int <= 0;
					CCU_rst <= '1';
				elsif(mode = "01") then
					myState<= idle;
					read1_addr_int <= 0;
					read2_addr_int <= 0;
					CCU_rst <= '1';
				elsif(mode = "10") then
					myState<= idle;
					read1_addr_int <= read1_addr_int - numOfData + stride_data;
					read2_addr_int <= 0;
					CCU_rst <= '1';
				else
					CCU_rst <= '0';
					case myState is
						when idle =>
							value1 <= "00000000000000000000000000000000";
							value2 <= "00000000000000000000000000000000";
							value_valid <= '0';
							if(buffer1_counter>0 and buffer2_counter>0 and CCU_buffer_full = '0') then
								myState <= read_data;								
								valid_read <= '1';
							end if;
						when read_data=>
							valid_read<='0';
							if(CCU_buffer_full ='0') then
								read1_addr_int <= read1_addr_int + 1;
								read2_addr_int <= read2_addr_int + 1;
								value1 <= value1_sig;
								value2 <= value2_sig;
								value_valid <= '1';
								myState<= idle;
							end if;
					end case;
				end if;
			end if;
		end if;
	end process;
	--------------------------------------------
	
	-------------WRITE PROCESS----------------------
	process(clk) is
	begin
		if (rising_edge(clk)) then
			if(rst='1')then
				write1_addr_int <= 0;
				write2_addr_int <= 0;
			else
				if(mode = "11" ) then
					write1_addr_int <= 0;
					write2_addr_int <= 0;
				elsif(mode = "01") then
					write1_addr_int <= 0;
				elsif(mode = "00") then
					if(data1_valid='1') then
						write1_addr_int <= write1_addr_int + 1;
					end if;
					if(data2_valid='1') then
						write2_addr_int <= write2_addr_int + 1;
					end if;
				end if;
			end if;
		end if;
	end process;
	-------------------------------------------------
	
	read1_addr_sig <= conv_std_logic_vector(read1_addr_int,8);
	read2_addr_sig <= conv_std_logic_vector(read2_addr_int,8);
	write1_addr_sig <= conv_std_logic_vector(write1_addr_int,8);
	write2_addr_sig <= conv_std_logic_vector(write2_addr_int,8);
	valid_write_data1_sig <= "1" when data1_valid='1' else "0";
	valid_write_data2_sig <= "1" when data2_valid='1' else "0";
end Behavioral;

