library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FilterSelector is
port(
	clk : in std_logic;
	rst : in std_logic;
	numOfFilters : in integer;
	filterOffset : in integer;
	resultOffset : in integer;
	activation_request : in std_logic;
	activation_acknowledge : out std_logic;
	rst_filter_calc : out std_logic;
	request_filter_calc : out std_logic;
	acknowledge_filter_calc : in std_logic;
	filter_address : out integer;
	rOffset : out integer
);
end FilterSelector;

architecture Behavioral of FilterSelector is

	-----SIGNAL DECLARATION--------
	signal fCounter : integer;
	signal fAddress : integer;
	type FSM_STATES is (idle,nextFilter,activateFilterCalc,waitFilterCalc);
	signal myState : FSM_STATES;
	signal r_offset : integer;
	-------------------------------
	
begin

	process(clk) is
	begin
		if(rising_edge(clk)) then
			if(rst = '1') then
				fCounter <= 0;
				fAddress <= 0;
				activation_acknowledge <= '0';
				rst_filter_calc <= '0';
				request_filter_calc <= '0';
				r_Offset <= 0;
				myState <= IDLE;
			else 
				case myState is 
					when idle =>
						if(activation_request = '1') then
							fCounter <= 0;
							fAddress <= 0;
							activation_acknowledge <= '0';
							rst_filter_calc <= '0';
							request_filter_calc <= '0';
							myState <= nextFilter;
						end if;
					when nextFilter =>
						if(fCounter < numOfFilters) then
							myState<= activateFilterCalc;
							rst_filter_calc <= '1';
						else
							activation_acknowledge <= '1';
						end if;
					when activateFilterCalc=>
						rst_filter_calc <= '0';
						request_filter_calc <= '1';
						myState<=waitFilterCalc;
					when waitFilterCalc=>
						request_filter_calc <= '0';
						if(acknowledge_filter_calc = '1') then
							myState <= nextFilter;
							fCounter <= fCounter + 1;
							fAddress <= fAddress + filterOffset;
							r_Offset <= resultOffset + r_Offset;
						end if;
				end case;
			end if;
		end if;
	end process;
	
	rOffset <= r_offset;
	filter_address <= fAddress;
	
end Behavioral;

