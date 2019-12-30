library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use STD.textio.all;
use ieee.std_logic_textio.all;
USE ieee.numeric_std.ALL;
use work.HelperProcedures.All;

entity Result_RAM_IC is
port(
	clk : in std_logic;
	rst : in std_logic;
	init_file : in std_logic;
	dataSize : in std_logic_vector(31 downto 0);
	read_write : in std_logic;
	activation_request : in std_logic;
	activation_acknowledge : out std_logic;
	result_address : in std_logic_vector(31 downto 0);
	result_data : in std_logic_vector(31 downto 0);
	result_read_data : out std_logic_vector(31 downto 0);
	result_read_data_valid : out std_logic
);
end Result_RAM_IC;

architecture Behavioral of Result_RAM_IC is

	-----------SIGNAL DECLARATION-------------
	type WRITE_STATES is (IDLE,WRITE_RESULT_0,WRITE_RESULT_1,WRITE_RESULT_2);
	signal writeState : WRITE_STATES;
	type READ_STATES is (idle,readData);
	signal readState : READ_STATES;
	signal init_line : std_logic_vector(63 downto 0);
	signal dataSize_int : integer;
	signal result_address_int : integer;
	file result_file : text;
	type value_array is array(32767 downto 0) of std_logic_vector(63 downto 0);
	------------------------------------------

	procedure read_from_file(file_name : in string; dr : out value_array) is 
		file data_file : text open read_mode is file_name; 
		variable L:line; 
	begin 
		if(dataSize(1 downto 0) = "00") then
			for i in 0 to dataSize_int -1 loop 
				readline(data_file, L);
				read(L, dr(i)); 
			end loop; 
		else	
			for i in 0 to dataSize_int loop 
				readline(data_file, L);
				read(L, dr(i)); 
			end loop; 
		end if;
		file_close(data_file);
	end read_from_file;
 
	procedure write_to_file(file_name : in string; dw : in value_array) is 
		file data_file : text open write_mode is file_name; 
		variable L : line; 
	begin 
		if(dataSize(1 downto 0) = "00") then
			for i in 0 to dataSize_int -1 loop
				write(L,dw(i));
				writeLine(data_file,L);
			end loop;
		else
			for i in 0 to dataSize_int loop
				write(L,dw(i));
				writeLine(data_file,L);
			end loop;
		end if;
		file_close(data_file);
	end write_to_file; 

begin

	process(clk) is
	variable R_Line : line;
	variable myArray : value_array;
	variable R_line_counter : integer;
	variable sum : std_logic_vector(15 downto 0);
	variable R_read_data : std_logic_vector(63 downto 0);
	begin
		if(rising_edge(clk)) then
			if(rst = '1') then
				activation_acknowledge <= '0';
				writeState <= IDLE;
				sum := "0000000000000000";
				result_read_data <= "00000000000000000000000000000000";
				result_read_data_valid <= '0';
				R_line_counter := 0;
				R_read_data := "0000000000000000000000000000000000000000000000000000000000000000";
				init_line <= "0000000000000000000000000000000000000000000000000000000000000000";
			else
				if(init_file = '1') then
					file_open(result_file, "result_file.txt",  write_mode);
					if(dataSize(1 downto 0) = "00") then
						for i in 0 to dataSize_int-1 loop
							write(R_line,init_line);
							writeLine(result_file,R_line);
						end loop;
					else
						for i in 0 to dataSize_int loop
							write(R_line,init_line);
							writeLine(result_file,R_line);
						end loop;
					end if;
					file_close(result_file);
				else
					if(read_write = '1') then
						case writeState is
							when IDLE =>
								if(activation_request = '1') then
									read_from_file("result_file.txt",myArray);
									writeState<= WRITE_RESULT_0;
									activation_acknowledge <= '0';
								end if;
							when WRITE_RESULT_0 =>
								sum(14 downto 0) := result_data(14 downto 0);
								sum(15) := result_data(31);
								writeState <= WRITE_RESULT_1;
							when WRITE_RESULT_1 =>
								if(result_address(1 downto 0) = "00") then
									myArray(result_address_int) := myArray(result_address_int)(63 downto 16) & sum;
								elsif (result_address(1 downto 0) = "01") then
									myArray(result_address_int) := myArray(result_address_int)(63 downto 32) & sum & myArray(result_address_int)(15 downto 0);
								elsif (result_address(1 downto 0) = "10") then
									myArray(result_address_int) := myArray(result_address_int)(63 downto 48) & sum & myArray(result_address_int)(31 downto 0);
								else
									myArray(result_address_int) := sum & myArray(result_address_int)(47 downto 0);
								end if;
								writeState <= WRITE_RESULT_2;
							when WRITE_RESULT_2 =>
								write_to_file("result_file.txt",myArray);
								writeState <= IDLE;
								activation_acknowledge <= '1';
						end case;
					else
						case readState is
							when idle =>
								if(activation_request = '1') then
									activation_acknowledge <= '0';
									file_open(result_file, "result_file.txt",  read_mode);
									while (R_line_counter < to_integer(unsigned(result_address(31 downto 2))) + 1) loop
										if(not endfile(result_file)) then
											readline(result_file,R_Line);
											if (R_line_counter = to_integer(unsigned(result_address(31 downto 2)))) then
												read(R_Line,R_read_data);
											end if;
										end if;
										R_line_counter := R_line_counter + 1;
									end loop;
									readState <= readData;
									file_close(result_file);
								end if;
							when readData =>
								R_line_counter := 0;
								activation_acknowledge <= '1';
								if(result_address(1 downto 0) = "00") then
									result_read_data <= R_read_data(15) & "0000000000000000" & R_read_data(14 downto 0);
									result_read_data_valid <= '1';
								elsif (result_address(1 downto 0) = "01") then
									result_read_data <= R_read_data(31) & "0000000000000000" & R_read_data(30 downto 16);
									result_read_data_valid <= '1';
								elsif (result_address(1 downto 0) = "10") then
									result_read_data <= R_read_data(47) & "0000000000000000" & R_read_data(46 downto 32);
									result_read_data_valid <= '1';
								else
									result_read_data <= R_read_data(63) & "0000000000000000" & R_read_data(62 downto 48);
									result_read_data_valid <= '1';
								end if;
								readState <= idle;
						end case;
					end if;
				end if;
				
			end if;
		end if;
	end process;

	result_address_int <= to_integer(unsigned(result_address(31 downto 2)));
	dataSize_int <= to_integer(unsigned(dataSize(31 downto 2)));

end Behavioral;

