library ieee;
use ieee.std_logic_1164.all;
use STD.textio.all;
use ieee.std_logic_textio.all;
USE ieee.numeric_std.ALL;

entity Image_RAM_IC is
	port(
	-----COMMON-------
	clk : in std_logic;
	rst : in std_logic;
	burst_request : in std_logic;
	burst_acknowledge : out std_logic;
	burst_size : in std_logic_vector(31 downto 0);
	------------------
	------IMAGE-------
	read_image : in std_logic;
	image_addr : in std_logic_vector(31 downto 0);
	image_data_valid: out std_logic;
	image_data_out : out std_logic_vector(31 downto 0)
	------------------
	);
end Image_RAM_IC;

architecture Behavioral of Image_RAM_IC is

	-------------SIGNAL DECRALATION----------------------------
	---------IMAGE---------------
	constant i_Width : natural :=64;
	file image_file : text;
	signal I_line_addr : integer range 0 to 3;
	signal I_start_data : integer range 0 to 3;
	signal I_counter : integer range 0 to 63;
	
	-----------------------------
	--------COMMON---------------
	type READ_STATES is (IDLE,BURST);
	signal readState : READ_STATES;
	signal bSize : integer range 0 to 63;
	-----------------------------
	signal bitCounter : integer range 0 to 1;
	-------------END OF SIGNAL DECRALATION----------------------

begin
	
	process(clk)	
	------IMAGE VARS--------
	variable I_Line : line;
	variable I_line_counter : integer;
	variable I_read_data : std_logic_vector(i_Width-1 downto 0);
	------------------------
	begin
		if(rising_edge(clk))then
			if(rst='1') then
				readState <= IDLE;
				I_counter<=0;
				bSize <= 0;
				I_line_counter:=0;
				I_counter <= 0;
				image_data_valid <= '0';
				I_start_data <= 0; -- to remove;
				burst_acknowledge <= '0';
				image_data_out <= "00000000000000000000000000000000";
				bitCounter <= 0;
			else
				case readState is
					when IDLE=>
						image_data_valid <= '0';
						burst_acknowledge <= '0';
						if (burst_request ='1' and read_image = '1') then
							file_open(image_file, "image_file.txt",  read_mode);
							while (I_line_counter < to_integer(unsigned(image_addr(31 downto 2))) + 1) loop
								if(not endfile(image_file)) then
									readline(image_file,I_Line);
									if (I_line_counter = to_integer(unsigned(image_addr(31 downto 2)))) then
										read(I_Line,I_read_data);
									end if;
								end if;
								I_line_counter := I_line_counter + 1;
							end loop;
							bSize <= to_integer(unsigned(burst_size));
							readState<=BURST;
							I_counter<=0;
							I_line_addr <= to_integer(unsigned(image_addr(1 downto 0)));
						end if;
					when BURST=>
						if(I_line_addr = 0) then
--							if(bitCounter = 0) then
--								image_data_out <= "00000000000000000" & I_read_data(14 downto 0);
--								bitCounter <= bitCounter+1;
--								image_data_valid <= '0';
--							else
								image_data_out <= I_read_data(15) & "0000000000000000" & I_read_data(14 downto 0);
								image_data_out(31) <= I_read_data(15);
								I_line_addr <= I_line_addr +1;
								bitCounter <= 0;
								image_data_valid <= '1';
--							end if;
						elsif(I_line_addr = 1) then
--							if(bitCounter = 0) then
--								image_data_out <= "00000000000000000" & I_read_data(30 downto 16);
--								bitCounter <= bitCounter+1;
--								image_data_valid <= '0';
--							else
								image_data_out <= I_read_data(31) & "0000000000000000" & I_read_data(30 downto 16);
								--image_data_out(31) <= I_read_data(31);
								I_line_addr <= I_line_addr +1;
								bitCounter <= 0;
								image_data_valid <= '1';
--							end if;
						elsif(I_line_addr = 2) then
--							if(bitCounter = 0) then
--								image_data_out <= "00000000000000000" & I_read_data(46 downto 32);
--								bitCounter <= bitCounter+1;
--								image_data_valid <= '0';
--							else
								image_data_out <= I_read_data(47) & "0000000000000000" & I_read_data(46 downto 32);
								--image_data_out(31) <= I_read_data(47);
								I_line_addr <= I_line_addr +1;
								bitCounter <= 0;
								image_data_valid <= '1';
--							end if;
						elsif(I_line_addr = 3) then
--							if(bitCounter = 0) then
--								image_data_out <= "00000000000000000" & I_read_data(62 downto 48);
--								bitCounter <= bitCounter+1;
--								image_data_valid <= '0';
--							else
								image_data_out <= I_read_data(63) & "0000000000000000" & I_read_data(62 downto 48);
								--image_data_out(31) <= I_read_data(63);
								I_line_addr <= 0;
								bitCounter <= 0;
								image_data_valid <= '1';
								if(I_counter < bSize) then
									if(not endfile(image_file)) then
										readline(image_file,I_Line);
										read(I_Line,I_read_data);
									end if;
								end if;
--							end if;
						end if;
						if(I_counter = bSize - 1) then
							I_counter <= 0;
							burst_acknowledge <= '1';
							readState <= IDLE;
							I_line_counter := 0;
							file_close(image_file);
						elsif(I_counter < bSize - 1) then
							I_counter <= I_counter+1;
						end if;
				end case;
			end if;
		end if;
	end process;
end Behavioral;

