library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library XilinxCoreLib;

entity DPRAM_256x32 is
port (
	addra: IN std_logic_VECTOR(7 downto 0);
	addrb: IN std_logic_VECTOR(7 downto 0);
	clka: IN std_logic;
	clkb: IN std_logic;
	dina: IN std_logic_VECTOR(31 downto 0);
	dinb: IN std_logic_VECTOR(31 downto 0);
	douta: OUT std_logic_VECTOR(31 downto 0);
	doutb: OUT std_logic_VECTOR(31 downto 0);
	ena: IN std_logic;
	enb: IN std_logic;
	sinita: IN std_logic;
	sinitb: IN std_logic;
	wea: IN std_logic;
	web: IN std_logic
);
end DPRAM_256x32;

architecture Behavioral of DPRAM_256x32 is
	component wrapped_dpbram256x32
		port (
		addra: IN std_logic_VECTOR(7 downto 0);
		addrb: IN std_logic_VECTOR(7 downto 0);
		clka: IN std_logic;
		clkb: IN std_logic;
		dina: IN std_logic_VECTOR(31 downto 0);
		dinb: IN std_logic_VECTOR(31 downto 0);
		douta: OUT std_logic_VECTOR(31 downto 0);
		doutb: OUT std_logic_VECTOR(31 downto 0);
		ena: IN std_logic;
		enb: IN std_logic;
		sinita: IN std_logic;
		sinitb: IN std_logic;
		wea: IN std_logic;
		web: IN std_logic);
	end component;

	-- Configuration specification 
	for all : wrapped_dpbram256x32 use entity XilinxCoreLib.blkmemdp_v4_0(behavioral)
	generic map(
		c_ysinitb_is_high => 1,
		c_yweb_is_high => 1,
		c_has_enb => 1,
		c_has_ena => 1,
		c_write_modeb => 0,
		c_pipe_stages_b => 0,
		c_write_modea => 0,
		c_pipe_stages_a => 0,
		c_yenb_is_high => 1,
		c_addrb_width => 8,
		c_has_dinb => 1,
		c_has_dina => 1,
		c_has_doutb => 1,
		c_has_douta => 1,
		c_ymake_bmm => 0,
		c_ysinita_is_high => 1,
		c_reg_inputsb => 0,
		c_has_rfdb => 0,
		c_reg_inputsa => 0,
		c_has_rfda => 0,
		c_yprimitive_type => "512x36",
		c_yhierarchy => "hierarchy1",
		c_mem_init_file => "mif_file_16_1",
		c_yclka_is_rising => 1,
		c_sinita_value => "0",
		c_has_sinitb => 1,
		c_has_sinita => 1,
		c_depth_b => 256,
		c_depth_a => 256,
		c_has_ndb => 0,
		c_has_nda => 0,
		c_has_web => 1,
		c_sinitb_value => "0",
		c_yuse_single_primitive => 1,
		c_has_wea => 1,
		c_default_data => "0",
		c_has_default_data => 1,
		c_ywea_is_high => 1,
		c_yclkb_is_rising => 1,
		c_width_b => 32,
		c_width_a => 32,
		c_ytop_addr => "1024",
		c_yena_is_high => 1,
		c_limit_data_pitch => 18,
		c_ybottom_addr => "0",
		c_has_rdyb => 0,
		c_has_rdya => 0,
		c_has_limit_data_pitch => 0,
		c_enable_rlocs => 0,
		c_addra_width => 8
	);
	
begin

	U0 : wrapped_dpbram256x32
	port map (
		addra => addra,
		addrb => addrb,
		clka => clka,
		clkb => clkb,
		dina => dina,
		dinb => dinb,
		douta => douta,
		doutb => doutb,
		ena => ena,
		enb => enb,
		sinita => sinita,
		sinitb => sinitb,
		wea => wea,
		web => web
	);
end Behavioral;

