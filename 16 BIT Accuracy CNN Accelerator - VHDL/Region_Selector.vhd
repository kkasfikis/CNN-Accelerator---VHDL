library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Region_Selector is
port(
	-------INPUTS-----------
	clk : in std_logic;
	rst : in std_logic;
	mode : in std_logic_vector(1 downto 0);
	R_CCU_Full : in std_logic;
	G_CCU_Full : in std_logic;
	B_CCU_Full : in std_logic;
	numOfData : in integer;
	stride_data : in integer;
	
	R_offset : in integer;
	G_offset : in integer;
	B_offset : in integer;
	burst_address : in std_logic_vector(31 downto 0);
	burst_size : in integer;
	finished : in std_logic;
	
	activation_request : in std_logic;
	------------------------
	-------OUTPUTS----------
	R_value1 : out std_logic_vector(32 downto 0);
	R_value2 : out std_logic_vector(31 downto 0);
	R_valid : out std_logic;
	G_value1 : out std_logic_vector(32 downto 0);
	G_value2 : out std_logic_vector(31 downto 0);
	G_valid : out std_logic;
	B_value1 : out std_logic_vector(32 downto 0);
	B_value2 : out std_logic_vector(31 downto 0);
	B_valid : out std_logic;
	activation_acknowledge : out std_logic
	------------------------
);
end Region_Selector;

architecture Behavioral of Region_Selector is

	component MEM_CTRL is
	port(
		clk: in std_logic;
		rst: in std_logic;
		mode : in std_logic_vector(1 downto 0); 
		stride_data : in integer;
		numOfData : in integer;
		data1 : in std_logic_vector(31 downto 0);
		data1_valid : in std_logic;
		data2 : in std_logic_vector(31 downto 0);
		data2_valid : in std_logic;
		CCU_buffer_full : in std_logic;
		finish_acknowledge : out std_logic;
		value1 : out std_logic_vector(32 downto 0);
		value2 : out std_logic_vector(31 downto 0);
		value_valid : out std_logic
	);
	end component;
	
	component Filter_RAM_IC is
	port(
		clk : in std_logic;
		rst : in std_logic;
		burst_request : in std_logic;
		burst_acknowledge : out std_logic;
		burst_size : in std_logic_vector(31 downto 0);
		finished : in std_logic;
		read_filter : in std_logic;
		filter_addr : in std_logic_vector(31 downto 0);
		filter_data_valid: out std_logic;
		filter_data_out : out std_logic_vector(31 downto 0)
	);
	end component;
	
	component Image_RAM_IC is
	port(
		clk : in std_logic;
		rst : in std_logic;
		burst_request : in std_logic;
		burst_acknowledge : out std_logic;
		burst_size : in std_logic_vector(31 downto 0);
		finished : in std_logic;
		read_image : in std_logic;
		image_addr : in std_logic_vector(31 downto 0);
		image_data_valid: out std_logic;
		image_data_out : out std_logic_vector(31 downto 0)
	);
	end component;
	
	--------------SIGNAL DECLARATION---------------
	-----MemCtrl Signals---------------
	signal R_finished : std_logic;
	signal G_finished : std_logic;
	signal B_finished : std_logic;
	signal R_data1 : std_logic_vector(31 downto 0);
	signal R_data2 : std_logic_vector(31 downto 0);
	signal R_data1_valid : std_logic;
	signal R_data2_valid : std_logic;
	signal G_data1 : std_logic_vector(31 downto 0);
	signal G_data2 : std_logic_vector(31 downto 0);
	signal G_data1_valid : std_logic;
	signal G_data2_valid : std_logic;
	signal B_data1 : std_logic_vector(31 downto 0);
	signal B_data2 : std_logic_vector(31 downto 0);
	signal B_data1_valid : std_logic;
	signal B_data2_valid : std_logic;
	-----------------------------------
	-----Image IC Signals--------------
	signal image_burst_req : std_logic;
	signal image_burst_ack : std_logic;
	signal readImage : std_logic;
	signal image_address : std_logic_vector(31 downto 0);
	signal image_data_out : std_logic_vector(31 downto 0);
	signal image_data_valid : std_logic;
	-----------------------------------
	-----Filter IC Signals-------------
	signal filter_burst_req : std_logic;
	signal filter_burst_ack : std_logic;
	signal readFilter : std_logic;
	signal filter_address : std_logic_vector(31 downto 0);
	signal filter_data_out : std_logic_vector(31 downto 0);
	signal filter_data_valid : std_logic;
	-----------------------------------
	signal address_sig : std_logic_vector(31 downto 0);
	signal final_address_int : integer;
	signal final_address_sig : std_logic_vector(31 downto 0);
	-----------------------------------------------
	
begin
	
	ImageIC : Image_RAM_IC
	port map(
		clk => clk,
		rst  => rst,
		burst_request  => image_burst_req,
		burst_acknowledge  => image_burst_ack,
		burst_size  => burst_size,
		finished  => finished,
		read_image  => readImage,
		image_addr  => image_address,
		image_data_valid  => image_data_valid,
		image_data_out  => image_data_out
	);
	
	FilterIC : Filter_RAM_IC
	port map(
		clk  => clk,
		rst  => rst,
		burst_request  => filter_burst_req,
		burst_acknowledge  => filter_burst_ack,
		burst_size  => burst_size,
		finished  => finished,
		read_filter  => readFilter,
		filter_addr  => filter_address,
		filter_data_valid  => signal_data_valid,
		filter_data_out  => filter_data_out
	);
	
	R_MemCtrl : MEM_CTRL
	port map(
		clk => clk,
		rst => rst,
		mode => mode,
		stride_data => stride_data,
		numOfData => numOfData,
		data1 =>R_data1,
		data1_valid =>R_data1_valid,
		data2 =>R_data2,
		data2_valid =>R_data2_valid,
		CCU_buffer_full => R_CCU_Full,
		finish_acknowledge =>R_finished,
		value1 => R_value1,
		value2 => R_value2,
		value_valid => R_valid
	);
	
	G_MemCtrl : MEM_CTRL
	port map(
		clk => clk,
		rst => rst,
		mode => mode,
		stride_data => stride_data,
		numOfData => numOfData,
		data1 =>G_data1,
		data1_valid =>G_data1_valid,
		data2 =>G_data2,
		data2_valid =>G_data2_valid,
		CCU_buffer_full => G_CCU_Full,
		finish_acknowledge =>G_finished,
		value1 =>G_value1,
		value2 =>G_value2,
		value_valid =>G_valid
	);
	
	B_MemCtrl : MEM_CTRL
	port map(
		clk => clk,
		rst => rst,
		mode => mode,
		stride_data => stride_data,
		numOfData => numOfData,
		data1 =>B_data1,
		data1_valid =>B_data1_valid,
		data2 =>B_data2,
		data2_valid =>B_data2_valid,
		CCU_buffer_full => B_CCU_Full,
		finish_acknowledge =>B_finished,
		value1 =>B_value1,
		value2 =>B_value2,
		value_valid =>B_valid
	);
	
	process(clk) is
	begin
		if(rising_edge(clk))then
			if(rst = '1') then
			
			else 
				case myState is
					when idle =>
						if(activation_request = '1') then
							address_sig <= burst_address;
							myState <= extract_R;
							activation_acknowledge <= '0';
						end if;
					when extract_R =>
						
					when finish_R =>
						
					when extract_G =>
						
					when finish_G =>
						
					when extract_B =>
						
					when finish_B =>
						
				end case;
			end if;
		end if;
	end process;
	
end Behavioral;

