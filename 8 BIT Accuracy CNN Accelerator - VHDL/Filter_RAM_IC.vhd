library ieee;
use ieee.std_logic_1164.all;
use STD.textio.all;
use ieee.std_logic_textio.all;
USE ieee.numeric_std.ALL;

entity Filter_RAM_IC is
	port(
	-----COMMON-------
	clk : in std_logic;
	rst : in std_logic;
	burst_request : in std_logic;
	burst_acknowledge : out std_logic;
	burst_size : in std_logic_vector(31 downto 0);
	------------------
	------IMAGE-------
	read_filter : in std_logic;
	filter_addr : in std_logic_vector(31 downto 0);
	filter_data_valid: out std_logic;
	filter_data_out : out std_logic_vector(31 downto 0)
	------------------
	);
end Filter_RAM_IC;

architecture Behavioral of Filter_RAM_IC is

	-------------SIGNAL DECRALATION----------------------------
	---------IMAGE---------------
	constant f_Width : natural :=64;
	file filter_file : text;
	signal F_line_addr : integer range 0 to 3;
	signal F_start_data : integer range 0 to 3;
	signal F_counter : integer range 0 to 63;
	
	-----------------------------
	--------COMMON---------------
	type READ_STATES is (IDLE,BURST);
	signal readState : READ_STATES;
	signal bSize : integer range 0 to 63;
	signal bitCounter : integer range 0 to 1;
	-----------------------------
	-------------END OF SIGNAL DECRALATION----------------------

begin
	
	process(clk)	
	------IMAGE VARS--------
	variable F_Line : line;
	variable F_line_counter : integer;
	variable F_read_data : std_logic_vector(f_Width-1 downto 0);
	------------------------
	begin
		if(rising_edge(clk))then
			if(rst='1') then
				readState <= IDLE;
				F_counter<=0;
				bSize <= 0;
				F_line_counter:=0;
				F_counter <= 0;
				F_start_data <= 0; -- to remove;
				filter_data_valid <= '0';
				burst_acknowledge <= '0';
				filter_data_out <= "00000000000000000000000000000000";
				bitCounter <= 0;
			else
				case readState is
					when IDLE=>
						filter_data_valid <= '0';
						burst_acknowledge <= '0';
						if (burst_request ='1' and read_filter = '1') then
							file_open(filter_file, "filter_file.txt",  read_mode);
							while (F_line_counter < to_integer(unsigned(filter_addr(31 downto 2))) + 1) loop
								if(not endfile(filter_file)) then
									readline(filter_file,F_Line);
									if (F_line_counter = to_integer(unsigned(filter_addr(31 downto 2)))) then
										read(F_Line,F_read_data);
									end if;
								end if;
								F_line_counter := F_line_counter + 1;
							end loop;
							bSize <= to_integer(unsigned(burst_size));
							readState<=BURST;
							F_counter<=0;
							F_line_addr <= to_integer(unsigned(filter_addr(1 downto 0)));						
						end if;
					when BURST=>
						if(F_line_addr = 0) then
--							if(bitCounter = 0) then
--								filter_data_out <= "000000000000000000000000" & F_read_data(7 downto 0);
--								bitCounter <= bitCounter+1;
--								filter_data_valid <= '0';
--							else
								filter_data_out <= F_read_data(8) & "00000000000000000000000" & F_read_data(7 downto 0);
								--filter_data_out(31) <= F_read_data(8);
								F_line_addr <= F_line_addr +1;
								bitCounter <= 0;
								filter_data_valid <= '1';
--							end if;
						elsif(F_line_addr = 1) then
--							if(bitCounter = 0) then
--								filter_data_out <= "000000000000000000000000" & F_read_data(23 downto 16);
--								bitCounter <= bitCounter + 1;
--								filter_data_valid <= '0';
--							else
								filter_data_out <=  F_read_data(24) & "00000000000000000000000" & F_read_data(23 downto 16);
								--filter_data_out(31) <= F_read_data(24);
								F_line_addr <= F_line_addr +1;
								bitCounter <= 0;
								filter_data_valid <='1';
--							end if;
						elsif(F_line_addr = 2) then
--							if(bitCounter = 0) then
--								filter_data_out <= "000000000000000000000000" & F_read_data(39 downto 32);
--								bitCounter <= bitCounter + 1;
--								filter_data_valid <= '0';
--							else
								filter_data_out <= F_read_data(40) & "00000000000000000000000" & F_read_data(39 downto 32);
								--filter_data_out(31) <= F_read_data(40);
								F_line_addr <= F_line_addr +1;
								bitCounter <= 0;
								filter_data_valid <='1';
--							end if;
						elsif(F_line_addr = 3) then
--							if(bitCounter = 0) then
--								filter_data_out <= "000000000000000000000000" & F_read_data(55 downto 48);
--								bitCounter <= bitCounter + 1;
--								filter_data_valid <= '0';
--							else
								filter_data_out <= F_read_data(56) & "00000000000000000000000" & F_read_data(55 downto 48);
								--filter_data_out(31) <= F_read_data(56);
								F_line_addr <= 0;
								bitCounter <= 0;
								filter_data_valid <='1';
								if(F_counter < bSize) then
									if(not endfile(filter_file)) then
										readline(filter_file,F_Line);
										read(F_Line,F_read_data);
									end if;
								end if;
--							end if;
						end if;
						if(F_counter = bSize - 1) then
							F_counter <= 0;
							burst_acknowledge <= '1';
							readState <= IDLE;
							file_close(filter_file);
							F_line_counter := 0;
						elsif(F_counter < bSize - 1) then
							F_counter <= F_counter + 1;
						end if;
						
				end case;
			end if;
		end if;
	end process;
	
end Behavioral;

