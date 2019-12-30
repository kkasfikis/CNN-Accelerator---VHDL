library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ReLU is
port(
	clk : in std_logic;
	rst : in std_logic;
	ReLU_enabled : in std_logic;
	result_value : in std_logic_vector(31 downto 0);
	activation_request: in std_logic;
	result_value_out : out std_logic_vector(31 downto 0);
	activation_acknowledge : out std_logic
);
end ReLU;

architecture Behavioral of ReLU is

	type FSM_STATES is (idle,rectify);
	signal myState : FSM_STATES;

begin

	process(clk) is
	begin
		if(rising_edge(clk)) then
			if(rst = '1') then
				activation_acknowledge <= '0';
				result_value_out <= "00000000000000000000000000000000";
				myState <= idle;
			else
				case myState is
					when idle =>
						if(activation_request = '1' and ReLU_enabled= '1') then
							myState <= rectify;
							activation_acknowledge <= '0';
						end if;
					when rectify =>
						if(result_value(31) = '1') then
							result_value_out <= "00000000000000000000000000000000";
						else
							result_value_out <= result_value;
						end if;
						activation_acknowledge <= '1';
				end case;
				
			end if;
		end if;
	end process;

end Behavioral;

