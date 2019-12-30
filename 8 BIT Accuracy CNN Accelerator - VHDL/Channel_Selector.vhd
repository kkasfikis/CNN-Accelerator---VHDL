library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Channel_Selector is
	clk : in std_logic;
	rst : in std_logic;
	mode : in std_logic_vector(1 downto 0);
	framer_address : in integer;
	
	
	
	numOfChannels : in integer;
	
	channel_calculator_activation_acknowledge : in std_logic_vector(63 downto 0);
	
	channel_calculator_activation_request : out std_logic_vector(63 downto 0);
end Channel_Selector;

architecture Behavioral of Channel_Selector is

begin



end Behavioral;

