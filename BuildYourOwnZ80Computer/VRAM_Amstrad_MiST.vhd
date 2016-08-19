--    {@{@{@{@{@{@
--  {@{@{@{@{@{@{@{@  This code is covered by CoreAmstrad synthesis r004
--  {@    {@{@    {@  A core of Amstrad CPC 6128 running on MiST-board platform
--  {@{@{@{@{@{@{@{@
--  {@  {@{@{@{@  {@  CoreAmstrad is implementation of FPGAmstrad on MiST-board
--  {@{@        {@{@   Contact : renaudhelias@gmail.com
--  {@{@{@{@{@{@{@{@   @see http://code.google.com/p/mist-board/
--    {@{@{@{@{@{@     @see FPGAmstrad at CPCWiki
--
--
--------------------------------------------------------------------------------
-- Wizard generated file... really ? no ;)
-- see mem_altera_gen.vhd
--------------------------------------------------------------------------------
-- megafunction wizard: %RAM: 2-PORT%
-- GENERATION: STANDARD
-- VERSION: WM1.0
-- MODULE: altsyncram 

-- ============================================================
-- File Name: VRAM_Amstrad_MiST.vhd
-- Megafunction Name(s):
-- 			altsyncram
--
-- Simulation Library Files(s):
-- 			altera_mf
-- ============================================================
-- ************************************************************
-- THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
--
-- 13.0.1 Build 232 06/12/2013 SP 1 SJ Web Edition
-- ************************************************************


--Copyright (C) 1991-2013 Altera Corporation
--Your use of Altera Corporation's design tools, logic functions 
--and other software and tools, and its AMPP partner logic 
--functions, and any output files from any of the foregoing 
--(including device programming or simulation files), and any 
--associated documentation or information are expressly subject 
--to the terms and conditions of the Altera Program License 
--Subscription Agreement, Altera MegaCore Function License 
--Agreement, or other applicable license agreement, including, 
--without limitation, that your use is for the sole purpose of 
--programming logic devices manufactured by Altera and sold by 
--Altera or its authorized distributors.  Please refer to the 
--applicable agreement for further details.


LIBRARY ieee;
USE ieee.std_logic_1164.all;

LIBRARY altera_mf;
USE altera_mf.all;

ENTITY VRAM_Amstrad_MiST IS
--	PORT
--	(
--		data		: IN STD_LOGIC_VECTOR (0 DOWNTO 0);
--		rdaddress		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
--		rdclock		: IN STD_LOGIC ;
--		wraddress		: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
--		wrclock		: IN STD_LOGIC  := '1';
--		wren		: IN STD_LOGIC  := '0';
--		q		: OUT STD_LOGIC_VECTOR (0 DOWNTO 0)
--	);
	 port ( vga_A    : in    std_logic_vector (13 downto 0); 
			  vga_CLK  : in    std_logic; 
			  vram_A   : in    std_logic_vector (13 downto 0); 
			  vram_CLK : in    std_logic; 
			  vram_D   : in    std_logic; 
			  vram_W   : in    std_logic; 
			  vga_D    : out   std_logic);
END VRAM_Amstrad_MiST;


ARCHITECTURE SYN OF vram_amstrad_mist IS

--	SIGNAL sub_wire0	: STD_LOGIC_VECTOR (0 DOWNTO 0);
--	SIGNAL sub_wire1	: STD_LOGIC_VECTOR (0 DOWNTO 0);

component altera_syncram_dp
  generic ( 
    abits : integer := 4; dbits : integer := 32
  );
  port (
    clk1     : in std_ulogic;
    address1 : in std_logic_vector((abits -1) downto 0);
    datain1  : in std_logic_vector((dbits -1) downto 0);
    dataout1 : out std_logic_vector((dbits -1) downto 0);
    enable1  : in std_ulogic;
    write1   : in std_ulogic;
    clk2     : in std_ulogic;
    address2 : in std_logic_vector((abits -1) downto 0);
    datain2  : in std_logic_vector((dbits -1) downto 0);
    dataout2 : out std_logic_vector((dbits -1) downto 0);
    enable2  : in std_ulogic;
    write2   : in std_ulogic);
end component;

--	COMPONENT altsyncram
--	GENERIC (
--		address_aclr_b		: STRING;
--		address_reg_b		: STRING;
--		clock_enable_input_a		: STRING;
--		clock_enable_input_b		: STRING;
--		clock_enable_output_b		: STRING;
--		intended_device_family		: STRING;
--		lpm_type		: STRING;
--		numwords_a		: NATURAL;
--		numwords_b		: NATURAL;
--		operation_mode		: STRING;
--		outdata_aclr_b		: STRING;
--		outdata_reg_b		: STRING;
--		power_up_uninitialized		: STRING;
--		widthad_a		: NATURAL;
--		widthad_b		: NATURAL;
--		width_a		: NATURAL;
--		width_b		: NATURAL;
--		width_byteena_a		: NATURAL
--	);
--	PORT (
--			address_a	: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
--			clock0	: IN STD_LOGIC ;
--			data_a	: IN STD_LOGIC_VECTOR (0 DOWNTO 0);
--			q_b	: OUT STD_LOGIC_VECTOR (0 DOWNTO 0);
--			wren_a	: IN STD_LOGIC ;
--			address_b	: IN STD_LOGIC_VECTOR (13 DOWNTO 0);
--			clock1	: IN STD_LOGIC 
--	);
--	END COMPONENT;
signal dIn : std_logic_vector(0 downto 0):=(others=>'0');
signal dOut : std_logic_vector(0 downto 0):=(others=>'0');
BEGIN

dIn(0)<=vram_D;
vga_D<=dOut(0);

 u0: altera_syncram_dp
  generic map (abits=>14, dbits=>1)
  port map (
    clk1 => vram_CLK,
	 address1 => vram_A,
	 datain1 => dIn,
    dataout1 => open,
	 enable1 => '1',
	 write1 => vram_W,
    clk2 => vga_CLK,
	 address2 => vga_A,
	 datain2 => "0",
    dataout2 => dOut,
	 enable2 => '1',
	 write2 => '0');


--	--q    <= sub_wire0(0 DOWNTO 0);
--	vga_D <= sub_wire0(0);
--	sub_wire1(0)<=vram_D;
--
--	altsyncram_component : altsyncram
--	GENERIC MAP (
--		address_aclr_b => "NONE",
--		address_reg_b => "CLOCK1",
--		clock_enable_input_a => "BYPASS",
--		clock_enable_input_b => "BYPASS",
--		clock_enable_output_b => "BYPASS",
--		intended_device_family => "Cyclone III",
--		lpm_type => "altsyncram",
--		numwords_a => 16384,
--		numwords_b => 16384,
--		operation_mode => "DUAL_PORT",
--		outdata_aclr_b => "NONE",
--		outdata_reg_b => "CLOCK1",
--		power_up_uninitialized => "FALSE",
--		widthad_a => 14,
--		widthad_b => 14,
--		width_a => 1,
--		width_b => 1,
--		width_byteena_a => 1
--	)
--	PORT MAP (
--		address_a => vram_A, --wraddress,
--		clock0 => vram_CLK, --wrclock,
--		data_a => sub_wire1, --data,
--		wren_a => vram_W, --wren,
--		address_b => vga_A, --rdaddress,
--		clock1 => vga_CLK, --rdclock,
--		q_b => sub_wire0
--	);



END SYN;

-- ============================================================
-- CNX file retrieval info
-- ============================================================
-- Retrieval info: PRIVATE: ADDRESSSTALL_A NUMERIC "0"
-- Retrieval info: PRIVATE: ADDRESSSTALL_B NUMERIC "0"
-- Retrieval info: PRIVATE: BYTEENA_ACLR_A NUMERIC "0"
-- Retrieval info: PRIVATE: BYTEENA_ACLR_B NUMERIC "0"
-- Retrieval info: PRIVATE: BYTE_ENABLE_A NUMERIC "0"
-- Retrieval info: PRIVATE: BYTE_ENABLE_B NUMERIC "0"
-- Retrieval info: PRIVATE: BYTE_SIZE NUMERIC "8"
-- Retrieval info: PRIVATE: BlankMemory NUMERIC "1"
-- Retrieval info: PRIVATE: CLOCK_ENABLE_INPUT_A NUMERIC "0"
-- Retrieval info: PRIVATE: CLOCK_ENABLE_INPUT_B NUMERIC "0"
-- Retrieval info: PRIVATE: CLOCK_ENABLE_OUTPUT_A NUMERIC "0"
-- Retrieval info: PRIVATE: CLOCK_ENABLE_OUTPUT_B NUMERIC "0"
-- Retrieval info: PRIVATE: CLRdata NUMERIC "0"
-- Retrieval info: PRIVATE: CLRq NUMERIC "0"
-- Retrieval info: PRIVATE: CLRrdaddress NUMERIC "0"
-- Retrieval info: PRIVATE: CLRrren NUMERIC "0"
-- Retrieval info: PRIVATE: CLRwraddress NUMERIC "0"
-- Retrieval info: PRIVATE: CLRwren NUMERIC "0"
-- Retrieval info: PRIVATE: Clock NUMERIC "1"
-- Retrieval info: PRIVATE: Clock_A NUMERIC "0"
-- Retrieval info: PRIVATE: Clock_B NUMERIC "0"
-- Retrieval info: PRIVATE: IMPLEMENT_IN_LES NUMERIC "0"
-- Retrieval info: PRIVATE: INDATA_ACLR_B NUMERIC "0"
-- Retrieval info: PRIVATE: INDATA_REG_B NUMERIC "0"
-- Retrieval info: PRIVATE: INIT_FILE_LAYOUT STRING "PORT_B"
-- Retrieval info: PRIVATE: INIT_TO_SIM_X NUMERIC "0"
-- Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone III"
-- Retrieval info: PRIVATE: JTAG_ENABLED NUMERIC "0"
-- Retrieval info: PRIVATE: JTAG_ID STRING "NONE"
-- Retrieval info: PRIVATE: MAXIMUM_DEPTH NUMERIC "0"
-- Retrieval info: PRIVATE: MEMSIZE NUMERIC "16384"
-- Retrieval info: PRIVATE: MEM_IN_BITS NUMERIC "0"
-- Retrieval info: PRIVATE: MIFfilename STRING ""
-- Retrieval info: PRIVATE: OPERATION_MODE NUMERIC "2"
-- Retrieval info: PRIVATE: OUTDATA_ACLR_B NUMERIC "0"
-- Retrieval info: PRIVATE: OUTDATA_REG_B NUMERIC "1"
-- Retrieval info: PRIVATE: RAM_BLOCK_TYPE NUMERIC "0"
-- Retrieval info: PRIVATE: READ_DURING_WRITE_MODE_MIXED_PORTS NUMERIC "2"
-- Retrieval info: PRIVATE: READ_DURING_WRITE_MODE_PORT_A NUMERIC "3"
-- Retrieval info: PRIVATE: READ_DURING_WRITE_MODE_PORT_B NUMERIC "3"
-- Retrieval info: PRIVATE: REGdata NUMERIC "1"
-- Retrieval info: PRIVATE: REGq NUMERIC "0"
-- Retrieval info: PRIVATE: REGrdaddress NUMERIC "1"
-- Retrieval info: PRIVATE: REGrren NUMERIC "1"
-- Retrieval info: PRIVATE: REGwraddress NUMERIC "1"
-- Retrieval info: PRIVATE: REGwren NUMERIC "1"
-- Retrieval info: PRIVATE: SYNTH_WRAPPER_GEN_POSTFIX STRING "0"
-- Retrieval info: PRIVATE: USE_DIFF_CLKEN NUMERIC "0"
-- Retrieval info: PRIVATE: UseDPRAM NUMERIC "1"
-- Retrieval info: PRIVATE: VarWidth NUMERIC "0"
-- Retrieval info: PRIVATE: WIDTH_READ_A NUMERIC "1"
-- Retrieval info: PRIVATE: WIDTH_READ_B NUMERIC "1"
-- Retrieval info: PRIVATE: WIDTH_WRITE_A NUMERIC "1"
-- Retrieval info: PRIVATE: WIDTH_WRITE_B NUMERIC "1"
-- Retrieval info: PRIVATE: WRADDR_ACLR_B NUMERIC "0"
-- Retrieval info: PRIVATE: WRADDR_REG_B NUMERIC "0"
-- Retrieval info: PRIVATE: WRCTRL_ACLR_B NUMERIC "0"
-- Retrieval info: PRIVATE: enable NUMERIC "0"
-- Retrieval info: PRIVATE: rden NUMERIC "0"
-- Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
-- Retrieval info: CONSTANT: ADDRESS_ACLR_B STRING "NONE"
-- Retrieval info: CONSTANT: ADDRESS_REG_B STRING "CLOCK1"
-- Retrieval info: CONSTANT: CLOCK_ENABLE_INPUT_A STRING "BYPASS"
-- Retrieval info: CONSTANT: CLOCK_ENABLE_INPUT_B STRING "BYPASS"
-- Retrieval info: CONSTANT: CLOCK_ENABLE_OUTPUT_B STRING "BYPASS"
-- Retrieval info: CONSTANT: INTENDED_DEVICE_FAMILY STRING "Cyclone III"
-- Retrieval info: CONSTANT: LPM_TYPE STRING "altsyncram"
-- Retrieval info: CONSTANT: NUMWORDS_A NUMERIC "16384"
-- Retrieval info: CONSTANT: NUMWORDS_B NUMERIC "16384"
-- Retrieval info: CONSTANT: OPERATION_MODE STRING "DUAL_PORT"
-- Retrieval info: CONSTANT: OUTDATA_ACLR_B STRING "NONE"
-- Retrieval info: CONSTANT: OUTDATA_REG_B STRING "CLOCK1"
-- Retrieval info: CONSTANT: POWER_UP_UNINITIALIZED STRING "FALSE"
-- Retrieval info: CONSTANT: WIDTHAD_A NUMERIC "14"
-- Retrieval info: CONSTANT: WIDTHAD_B NUMERIC "14"
-- Retrieval info: CONSTANT: WIDTH_A NUMERIC "1"
-- Retrieval info: CONSTANT: WIDTH_B NUMERIC "1"
-- Retrieval info: CONSTANT: WIDTH_BYTEENA_A NUMERIC "1"
-- Retrieval info: USED_PORT: data 0 0 1 0 INPUT NODEFVAL "data[0..0]"
-- Retrieval info: USED_PORT: q 0 0 1 0 OUTPUT NODEFVAL "q[0..0]"
-- Retrieval info: USED_PORT: rdaddress 0 0 14 0 INPUT NODEFVAL "rdaddress[13..0]"
-- Retrieval info: USED_PORT: rdclock 0 0 0 0 INPUT NODEFVAL "rdclock"
-- Retrieval info: USED_PORT: wraddress 0 0 14 0 INPUT NODEFVAL "wraddress[13..0]"
-- Retrieval info: USED_PORT: wrclock 0 0 0 0 INPUT VCC "wrclock"
-- Retrieval info: USED_PORT: wren 0 0 0 0 INPUT GND "wren"
-- Retrieval info: CONNECT: @address_a 0 0 14 0 wraddress 0 0 14 0
-- Retrieval info: CONNECT: @address_b 0 0 14 0 rdaddress 0 0 14 0
-- Retrieval info: CONNECT: @clock0 0 0 0 0 wrclock 0 0 0 0
-- Retrieval info: CONNECT: @clock1 0 0 0 0 rdclock 0 0 0 0
-- Retrieval info: CONNECT: @data_a 0 0 1 0 data 0 0 1 0
-- Retrieval info: CONNECT: @wren_a 0 0 0 0 wren 0 0 0 0
-- Retrieval info: CONNECT: q 0 0 1 0 @q_b 0 0 1 0
-- Retrieval info: GEN_FILE: TYPE_NORMAL VRAM_Amstrad_MiST.vhd TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL VRAM_Amstrad_MiST.inc TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL VRAM_Amstrad_MiST.cmp TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL VRAM_Amstrad_MiST.bsf TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL VRAM_Amstrad_MiST_inst.vhd TRUE
-- Retrieval info: LIB_FILE: altera_mf
