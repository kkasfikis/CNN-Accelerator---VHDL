library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use STD.textio.all;
use ieee.std_logic_textio.all;
USE ieee.numeric_std.ALL;

entity Pool_RAM_IC is
port(
	clk : in std_logic;
	rst : in std_logic;
	init_file : in std_logic;
	dataSize : in std_logic_vector(31 downto 0);
	activation_request : in std_logic;
	activation_acknowledge : out std_logic;
	pool_address : in std_logic_vector(31 downto 0);
	pool_data : in std_logic_vector(31 downto 0)
);
end Pool_RAM_IC;

architecture Behavioral of Pool_RAM_IC is

	-----------SIGNAL DECLARATION-------------
	type WRITE_STATES is (IDLE,WRITE_RESULT_0,WRITE_RESULT_1,WRITE_RESULT_2);
	signal writeState : WRITE_STATES;
	signal init_line : std_logic_vector(63 downto 0);
	signal dataSize_int : integer;
	signal pool_address_int : integer;
	file pool_file : text;
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
	variable P_line : line;
	variable myArray : value_array;
	variable sum : std_logic_vector(15 downto 0);
	begin
		if(rising_edge(clk)) then
			if(rst = '1') then
				activation_acknowledge <= '0';
				writeState <= IDLE;
				sum := "0000000000000000";
				init_line <= "0000000000000000000000000000000000000000000000000000000000000000";
			else
				if(init_file = '1') then
					file_open(pool_file, "pool_file.txt",  write_mode);
					if(dataSize(1 downto 0) = "00") then
						for i in 0 to dataSize_int-1 loop
							write(P_line,init_line);
							writeLine(pool_file,P_line);
						end loop;
					else
						for i in 0 to dataSize_int loop
							write(P_line,init_line);
							writeLine(pool_file,P_line);
						end loop;
					end if;
					file_close(pool_file);
				else
					case writeState is
						when IDLE =>
							if(activation_request = '1') then
								read_from_file("pool_file.txt",myArray);
								writeState<= WRITE_RESULT_0;
								activation_acknowledge <= '0';
							end if;
						when WRITE_RESULT_0 =>
							sum(7 downto 0) := pool_data(7 downto 0);
							sum(15 downto 8) := (others => pool_data(31));
							writeState <= WRITE_RESULT_1;
						when WRITE_RESULT_1 =>
							if(pool_address(1 downto 0) = "00") then
								myArray(pool_address_int) := myArray(pool_address_int)(63 downto 16) & sum;
							elsif (pool_address(1 downto 0) = "01") then
								myArray(pool_address_int) := myArray(pool_address_int)(63 downto 32) & sum & myArray(pool_address_int)(15 downto 0);
							elsif (pool_address(1 downto 0) = "10") then
								myArray(pool_address_int) := myArray(pool_address_int)(63 downto 48) & sum & myArray(pool_address_int)(31 downto 0);
							else
								myArray(pool_address_int) := sum & myArray(pool_address_int)(47 downto 0);
							end if;
							writeState <= WRITE_RESULT_2;
						when WRITE_RESULT_2 =>
							write_to_file("pool_file.txt",myArray);
							writeState <= IDLE;
							activation_acknowledge <= '1';
					end case;
				end if;
				
			end if;
		end if;
	end process;

	pool_address_int <= to_integer(unsigned(pool_address(31 downto 2)));
	dataSize_int <= to_integer(unsigned(dataSize(31 downto 2)));


end Behavioral;

