library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity input_ctrl is
port(
	--inputs
	clk : in std_logic;
	rst : in std_logic;
	data1 : in std_logic_vector(31 downto 0);
	data2 : in std_logic_vector(31 downto 0);
	valid_write : in std_logic_vector(0 downto 0);
	activation_acknowledge : in std_logic_vector(7 downto 0);
	--outputs
	buffer_full : out std_logic;
	value1 : out std_logic_vector(31 downto 0);
	value2 : out std_logic_vector(31 downto 0);
	activation_request : out std_logic_vector(7 downto 0)
);
end input_ctrl;

architecture Behavioral of input_ctrl is

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
	
	------------------------SIGNAL DECLARATION----------------------
	signal read_addr_int : integer range 0 to 255;
	signal write_addr_int : integer range 0 to 255;
	signal read_addr_sig : std_logic_vector(7 downto 0);
	signal write_addr_sig : std_logic_vector(7 downto 0);
	signal shift_mul_flags : std_logic_vector(7 downto 0);
	signal buffer_counter : integer range 0 to 255;
	signal buffer_empty : std_logic;
	signal activation_request_sig : std_logic_vector(7 downto 0);
	type FSM_STATES is (idle,assign_task,workaround);
	signal myState : FSM_STATES;
	signal valid_read : std_logic;
	signal valid_write_sig : std_logic;
	--------------------END OF SIGNAL DECLARATION-------------------
	
begin

	CB1 : RAM_256x32 
	port map(
		ADDRA =>read_addr_sig,
		DINA => "00000000000000000000000000000000",
		WEA => "0",
		RSTA =>rst,
		CLKA =>clk,
		DOUTA =>value1,
		ADDRB =>write_addr_sig,
		DINB =>data1,
		WEB =>valid_write,
		RSTB =>rst,
		CLKB =>clk,
		DOUTB => open
	);
	
	CB2 : RAM_256x32 
	port map(
		ADDRA =>read_addr_sig,
		DINA => "00000000000000000000000000000000",
		WEA => "0",
		RSTA =>rst,
		CLKA =>clk,
		DOUTA =>value2,
		ADDRB =>write_addr_sig,
		DINB =>data2,
		WEB =>valid_write,
		RSTB =>rst,
		CLKB =>clk,
		DOUTB => open
	);
	
	---------ASSIGN / READ/WRITE POINTERS PROCESS------------------------
	process(clk) is
	begin 
		if (rising_edge(clk)) then
			if (rst='1') then
				write_addr_int <= 0;
				read_addr_int <= 0;
				valid_read <= '0';
				myState <= idle;
				activation_request_sig <= "00000000";
				shift_mul_flags <= "00000000";
			else
				---------WRITE CHECK----------------
				if(valid_write_sig = '1') then
					write_addr_int <= write_addr_int + 1;
				end if;
				------------------------------------
				--------ZERO SHIFT MUL FLAGS -------
				for i in 0 to 7 loop 
					if(activation_acknowledge(i) = '1') then
						shift_mul_flags(i) <= '0';
					end if;
				end loop;
				------------------------------------
				--------READ/ASSIGN FSM-----------
				case myState is 
					when idle =>
						activation_request_sig <= "00000000";
						valid_read <='0';
						if(buffer_counter > 0 and buffer_counter < 254) then
							myState <= assign_task;
						end if;
					when assign_task =>
						if(shift_mul_flags = "11111111") then
							valid_read <='0';
						else
							if(buffer_counter >0) then
								myState <= workaround;
								valid_read <='1';
								if(shift_mul_flags(0) ='0') then
									shift_mul_flags(0) <= '1';
									activation_request_sig <= "00000001";
								elsif (shift_mul_flags(1) ='0') then
									shift_mul_flags(1) <= '1';
									activation_request_sig <= "00000010";
								elsif (shift_mul_flags(2) ='0') then
									shift_mul_flags(2) <= '1';
									activation_request_sig <= "00000100";
								elsif (shift_mul_flags(3) ='0') then
									shift_mul_flags(3) <= '1';
									activation_request_sig <= "00001000";
								elsif (shift_mul_flags(4) ='0') then
									shift_mul_flags(4) <= '1';
									activation_request_sig <= "00010000";
								elsif (shift_mul_flags(5) ='0') then
									shift_mul_flags(5) <= '1';
									activation_request_sig <= "00100000";
								elsif (shift_mul_flags(6) ='0') then
									shift_mul_flags(6) <= '1';
									activation_request_sig <= "01000000";
								elsif (shift_mul_flags(7) ='0') then
									shift_mul_flags(7) <= '1';
									activation_request_sig <= "10000000";
								else
									activation_request_sig <= "00000000";
								end if;
							else
								myState <= idle;
							end if;
						end if;
					when workaround =>
						valid_read <='0';
						activation_request_sig <= "00000000";
						read_addr_int <= read_addr_int + 1;
						if(buffer_counter > 0 and buffer_counter < 254) then
							myState <= assign_task;
						else
							myState <= idle;
						end if;
				end case;
			end if;
		end if;
	end process;
	---------END OF ASSIGN / READ/WRITE POINTERS PROCESS------------------
	
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
	
	valid_write_sig <= '1' when valid_write="1" else '0';
	buffer_full <= '1' when buffer_counter>=254 else '0';
	buffer_empty <= '1' when buffer_counter=0 else '0';
	read_addr_sig <= conv_std_logic_vector(read_addr_int,8);
	write_addr_sig <= conv_std_logic_vector(write_addr_int,8);
	activation_request <= activation_request_sig;

end Behavioral;

