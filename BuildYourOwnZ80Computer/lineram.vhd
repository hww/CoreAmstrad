-- megafunction wizard: %RAM: 2-PORT%
-- GENERATION: STANDARD
-- VERSION: WM1.0
-- MODULE: altsyncram 

-- ============================================================
-- File Name: lineram.vhd
-- Megafunction Name(s):
-- 			altsyncram
-- ============================================================
-- ************************************************************
-- THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
--
-- 5.0 Build 148 04/26/2005 SJ Web Edition
-- ************************************************************


--Copyright (C) 1991-2005 Altera Corporation
--Your use of Altera Corporation's design tools, logic functions 
--and other software and tools, and its AMPP partner logic       
--functions, and any output files any of the foregoing           
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
USE altera_mf.altera_mf_components.all;

ENTITY lineram IS
	PORT
	(
		data		: IN STD_LOGIC_VECTOR (17 DOWNTO 0);
		wren		: IN STD_LOGIC  := '1';
		wraddress		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		rdaddress		: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
		wrclock		: IN STD_LOGIC ;
		rdclock		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (17 DOWNTO 0)
	);
END lineram;


ARCHITECTURE SYN OF lineram IS

	SIGNAL sub_wire0	: STD_LOGIC_VECTOR (17 DOWNTO 0);



	COMPONENT altsyncram
	GENERIC (
		intended_device_family		: STRING;
		operation_mode		: STRING;
		width_a		: NATURAL;
		widthad_a		: NATURAL;
		numwords_a		: NATURAL;
		width_b		: NATURAL;
		widthad_b		: NATURAL;
		numwords_b		: NATURAL;
		lpm_type		: STRING;
		width_byteena_a		: NATURAL;
		outdata_reg_b		: STRING;
		indata_aclr_a		: STRING;
		wrcontrol_aclr_a		: STRING;
		address_aclr_a		: STRING;
		address_reg_b		: STRING;
		address_aclr_b		: STRING;
		outdata_aclr_b		: STRING;
		power_up_uninitialized		: STRING
	);
	PORT (
			wren_a	: IN STD_LOGIC ;
			clock0	: IN STD_LOGIC ;
			clock1	: IN STD_LOGIC ;
			address_a	: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
			address_b	: IN STD_LOGIC_VECTOR (9 DOWNTO 0);
			q_b	: OUT STD_LOGIC_VECTOR (17 DOWNTO 0);
			data_a	: IN STD_LOGIC_VECTOR (17 DOWNTO 0)
	);
	END COMPONENT;

BEGIN
	q    <= sub_wire0(17 DOWNTO 0);

	altsyncram_component : altsyncram
	GENERIC MAP (
		intended_device_family => "Cyclone",
		operation_mode => "DUAL_PORT",
		width_a => 18,
		widthad_a => 10,
		numwords_a => 1024,
		width_b => 18,
		widthad_b => 10,
		numwords_b => 1024,
		lpm_type => "altsyncram",
		width_byteena_a => 1,
		outdata_reg_b => "UNREGISTERED",
		indata_aclr_a => "NONE",
		wrcontrol_aclr_a => "NONE",
		address_aclr_a => "NONE",
		address_reg_b => "CLOCK1",
		address_aclr_b => "NONE",
		outdata_aclr_b => "NONE",
		power_up_uninitialized => "FALSE"
	)
	PORT MAP (
		wren_a => wren,
		clock0 => wrclock,
		clock1 => rdclock,
		address_a => wraddress,
		address_b => rdaddress,
		data_a => data,
		q_b => sub_wire0
	);



END SYN;

-- ============================================================
-- CNX file retrieval info
-- ============================================================
-- Retrieval info: PRIVATE: MEM_IN_BITS NUMERIC "0"
-- Retrieval info: PRIVATE: OPERATION_MODE NUMERIC "2"
-- Retrieval info: PRIVATE: UseDPRAM NUMERIC "1"
-- Retrieval info: PRIVATE: VarWidth NUMERIC "0"
-- Retrieval info: PRIVATE: WIDTH_WRITE_A NUMERIC "18"
-- Retrieval info: PRIVATE: WIDTH_WRITE_B NUMERIC "18"
-- Retrieval info: PRIVATE: WIDTH_READ_A NUMERIC "18"
-- Retrieval info: PRIVATE: WIDTH_READ_B NUMERIC "18"
-- Retrieval info: PRIVATE: MEMSIZE NUMERIC "18432"
-- Retrieval info: PRIVATE: RAM_BLOCK_TYPE NUMERIC "0"
-- Retrieval info: PRIVATE: MAXIMUM_DEPTH NUMERIC "0"
-- Retrieval info: PRIVATE: IMPLEMENT_IN_LES NUMERIC "0"
-- Retrieval info: PRIVATE: Clock NUMERIC "1"
-- Retrieval info: PRIVATE: rden NUMERIC "0"
-- Retrieval info: PRIVATE: BYTE_ENABLE_A NUMERIC "0"
-- Retrieval info: PRIVATE: BYTE_ENABLE_B NUMERIC "0"
-- Retrieval info: PRIVATE: BYTE_SIZE NUMERIC "9"
-- Retrieval info: PRIVATE: Clock_A NUMERIC "0"
-- Retrieval info: PRIVATE: Clock_B NUMERIC "0"
-- Retrieval info: PRIVATE: REGdata NUMERIC "1"
-- Retrieval info: PRIVATE: REGwraddress NUMERIC "1"
-- Retrieval info: PRIVATE: REGwren NUMERIC "1"
-- Retrieval info: PRIVATE: REGrdaddress NUMERIC "1"
-- Retrieval info: PRIVATE: REGrren NUMERIC "1"
-- Retrieval info: PRIVATE: REGq NUMERIC "0"
-- Retrieval info: PRIVATE: INDATA_REG_B NUMERIC "0"
-- Retrieval info: PRIVATE: WRADDR_REG_B NUMERIC "0"
-- Retrieval info: PRIVATE: OUTDATA_REG_B NUMERIC "0"
-- Retrieval info: PRIVATE: CLRdata NUMERIC "0"
-- Retrieval info: PRIVATE: CLRwren NUMERIC "0"
-- Retrieval info: PRIVATE: CLRwraddress NUMERIC "0"
-- Retrieval info: PRIVATE: CLRrdaddress NUMERIC "0"
-- Retrieval info: PRIVATE: CLRrren NUMERIC "0"
-- Retrieval info: PRIVATE: CLRq NUMERIC "0"
-- Retrieval info: PRIVATE: BYTEENA_ACLR_A NUMERIC "0"
-- Retrieval info: PRIVATE: INDATA_ACLR_B NUMERIC "0"
-- Retrieval info: PRIVATE: WRCTRL_ACLR_B NUMERIC "0"
-- Retrieval info: PRIVATE: WRADDR_ACLR_B NUMERIC "0"
-- Retrieval info: PRIVATE: OUTDATA_ACLR_B NUMERIC "0"
-- Retrieval info: PRIVATE: BYTEENA_ACLR_B NUMERIC "0"
-- Retrieval info: PRIVATE: enable NUMERIC "0"
-- Retrieval info: PRIVATE: CLOCK_ENABLE_INPUT_A NUMERIC "0"
-- Retrieval info: PRIVATE: CLOCK_ENABLE_OUTPUT_A NUMERIC "0"
-- Retrieval info: PRIVATE: CLOCK_ENABLE_INPUT_B NUMERIC "0"
-- Retrieval info: PRIVATE: CLOCK_ENABLE_OUTPUT_B NUMERIC "0"
-- Retrieval info: PRIVATE: ADDRESSSTALL_A NUMERIC "0"
-- Retrieval info: PRIVATE: ADDRESSSTALL_B NUMERIC "0"
-- Retrieval info: PRIVATE: READ_DURING_WRITE_MODE_MIXED_PORTS NUMERIC "2"
-- Retrieval info: PRIVATE: INIT_TO_SIM_X NUMERIC "0"
-- Retrieval info: PRIVATE: BlankMemory NUMERIC "1"
-- Retrieval info: PRIVATE: MIFfilename STRING ""
-- Retrieval info: PRIVATE: INIT_FILE_LAYOUT STRING "PORT_B"
-- Retrieval info: PRIVATE: JTAG_ENABLED NUMERIC "0"
-- Retrieval info: PRIVATE: JTAG_ID STRING "NONE"
-- Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone"
-- Retrieval info: CONSTANT: INTENDED_DEVICE_FAMILY STRING "Cyclone"
-- Retrieval info: CONSTANT: OPERATION_MODE STRING "DUAL_PORT"
-- Retrieval info: CONSTANT: WIDTH_A NUMERIC "18"
-- Retrieval info: CONSTANT: WIDTHAD_A NUMERIC "10"
-- Retrieval info: CONSTANT: NUMWORDS_A NUMERIC "1024"
-- Retrieval info: CONSTANT: WIDTH_B NUMERIC "18"
-- Retrieval info: CONSTANT: WIDTHAD_B NUMERIC "10"
-- Retrieval info: CONSTANT: NUMWORDS_B NUMERIC "1024"
-- Retrieval info: CONSTANT: LPM_TYPE STRING "altsyncram"
-- Retrieval info: CONSTANT: WIDTH_BYTEENA_A NUMERIC "1"
-- Retrieval info: CONSTANT: OUTDATA_REG_B STRING "UNREGISTERED"
-- Retrieval info: CONSTANT: INDATA_ACLR_A STRING "NONE"
-- Retrieval info: CONSTANT: WRCONTROL_ACLR_A STRING "NONE"
-- Retrieval info: CONSTANT: ADDRESS_ACLR_A STRING "NONE"
-- Retrieval info: CONSTANT: ADDRESS_REG_B STRING "CLOCK1"
-- Retrieval info: CONSTANT: ADDRESS_ACLR_B STRING "NONE"
-- Retrieval info: CONSTANT: OUTDATA_ACLR_B STRING "NONE"
-- Retrieval info: CONSTANT: POWER_UP_UNINITIALIZED STRING "FALSE"
-- Retrieval info: USED_PORT: data 0 0 18 0 INPUT NODEFVAL data[17..0]
-- Retrieval info: USED_PORT: wren 0 0 0 0 INPUT VCC wren
-- Retrieval info: USED_PORT: q 0 0 18 0 OUTPUT NODEFVAL q[17..0]
-- Retrieval info: USED_PORT: wraddress 0 0 10 0 INPUT NODEFVAL wraddress[9..0]
-- Retrieval info: USED_PORT: rdaddress 0 0 10 0 INPUT NODEFVAL rdaddress[9..0]
-- Retrieval info: USED_PORT: wrclock 0 0 0 0 INPUT NODEFVAL wrclock
-- Retrieval info: USED_PORT: rdclock 0 0 0 0 INPUT NODEFVAL rdclock
-- Retrieval info: CONNECT: @data_a 0 0 18 0 data 0 0 18 0
-- Retrieval info: CONNECT: @wren_a 0 0 0 0 wren 0 0 0 0
-- Retrieval info: CONNECT: q 0 0 18 0 @q_b 0 0 18 0
-- Retrieval info: CONNECT: @address_a 0 0 10 0 wraddress 0 0 10 0
-- Retrieval info: CONNECT: @address_b 0 0 10 0 rdaddress 0 0 10 0
-- Retrieval info: CONNECT: @clock0 0 0 0 0 wrclock 0 0 0 0
-- Retrieval info: CONNECT: @clock1 0 0 0 0 rdclock 0 0 0 0
-- Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
-- Retrieval info: GEN_FILE: TYPE_NORMAL lineram.vhd TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL lineram.inc FALSE
-- Retrieval info: GEN_FILE: TYPE_NORMAL lineram.cmp TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL lineram.bsf FALSE
-- Retrieval info: GEN_FILE: TYPE_NORMAL lineram_inst.vhd FALSE
-- Retrieval info: GEN_FILE: TYPE_NORMAL lineram_waveforms.html TRUE
-- Retrieval info: GEN_FILE: TYPE_NORMAL lineram_wave*.jpg FALSE
