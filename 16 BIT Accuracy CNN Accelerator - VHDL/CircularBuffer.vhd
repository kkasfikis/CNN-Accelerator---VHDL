library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity CircularBuffer is
port(
	clk : in std_logic;
	rst : in std_logic;
	read_address : in std_logic_vector(7 downto 0);
	write_address : in std_logic_vector(7 downto 0);
	write_data : in std_logic_vector(31 downto 0);
	valid_write : in std_logic;
	read_data : out std_logic_vector(31 downto 0)
);
end CircularBuffer;

architecture Behavioral of CircularBuffer is

end Behavioral;

