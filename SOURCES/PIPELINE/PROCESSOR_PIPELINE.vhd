----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:25:49 05/22/2022 
-- Design Name: 
-- Module Name:    PROCESSOR_PIPELINE - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity PROCESSOR_PIPELINE is
    Port (  clk : in  STD_LOGIC;
    	    rst : in STD_LOGIC;
    	    Instr : in STD_LOGIC_VECTOR(31 downto 0);
    	    WrEn : in STD_LOGIC;
    	    PC : out STD_LOGIC_VECTOR(31 downto 0);
    	    MM_RdData : in STD_LOGIC_VECTOR(31 downto 0);
    	    MM_WrData : out STD_LOGIC_VECTOR(31 downto 0);
    	    MM_WrEn : out STD_LOGIC;
    	    MM_Addr : out STD_LOGIC_VECTOR(31 downto 0));
end PROCESSOR_PIPELINE;

architecture Behavioral of PROCESSOR_PIPELINE is

component CONTROL_PIPELINE 
	port(  clk : in  STD_LOGIC;
    	   ALU_func : out STD_LOGIC_VECTOR(3 downto 0);
    	   ALU_zero : out STD_LOGIC;
    	   WrEn : in STD_LOGIC;
    	   alu_bin_sel: out STD_LOGIC;
    	   rf_b_sel : out STD_LOGIC;
    	   rf_WrData_sel : out STD_LOGIC;
    	   mem_wren : out STD_LOGIC;
    	   byteop : out STD_LOGIC;
    	   instr : in STD_LOGIC_VECTOR(31 downto 0);
    	   PC_sel : out STD_LOGIC;
    	   PC_LdEn : out STD_LOGIC;
    	   RF_WrEn_WB : out STD_LOGIC;
    	   Stalling : in STD_LOGIC;
    	   ImmExt : out STD_LOGIC_VECTOR(1 downto 0);
    	   RF_WrEn_EX_MEM : out STD_LOGIC;
    	   ID_EX_WrEn : out STD_LOGIC;
    	   EX_MEM_WrEn : out STD_LOGIC;
    	   reg_instr_wren : out  STD_LOGIC;
    	   mem_wb_WrEn : out STD_LOGIC;
    	   Memory_read : out STD_LOGIC);
end component;

component DATAPATH_PIPELINE
	port(  clk : in  STD_LOGIC;
    	   rst : in  STD_LOGIC;
    	   PC_LdEn : in STD_LOGIC;
    	   Instr : in STD_LOGIC_VECTOR(31 downto 0);
    	   IF_ID_wren : in STD_LOGIC;
    	   ID_EX_wren : in STD_LOGIC;
           PC : out  STD_LOGIC_VECTOR(31 downto 0);
           RF_WrData_sel : in STD_LOGIC;
           RF_B_sel : in STD_LOGIC ;
           ImmExt : in STD_LOGIC_VECTOR(1 downto 0);
           PC_sel : in STD_LOGIC;
           ex_mem_wren : in STD_LOGIC;	
           mem_wb_wren : in STD_LOGIC;
           Memory_read : in STD_LOGIC;
           RF_WrEn_EX_MEM : in std_logic;
           RF_WrEn_WB : in std_logic;
           Stalling : out std_logic;
           MM_WrEn : out std_logic;
           MM_Addr : out std_logic_vector(31 downto 0);
           MM_WrData : out std_logic_vector(31 downto 0);
           ByteOp : in std_logic;
           Mem_WrEn : in std_logic;
           MM_RdData : in  STD_LOGIC_VECTOR(31 downto 0);
           ALU_Bin_sel : in std_logic;
           ALU_func : in std_logic_vector(3 downto 0);
           ALU_zero : out  STD_LOGIC;
           RegInstr_out : out std_logic_vector(31 downto 0)
       );
end component;

signal PC_sel : std_logic;
signal PC_LdEn : STD_LOGIC;
signal Mem_WrEn : std_logic;
signal RF_WrEn : STD_LOGIC;
signal RF_WrData_sel : STD_LOGIC;
signal RF_B_sel : STD_LOGIC;
signal ImmExt_b : std_logic_vector(1 downto 0);
signal ALU_Bin_sel : std_logic;
signal ALU_func : std_logic_vector(3 downto 0);
signal ALU_zero : std_logic;
signal ByteOp : std_logic;
signal ID_EX_wren : std_logic;
signal Stalling : std_logic;
signal EX_MEM_WrEn : std_logic;
signal reg_instr_wren : std_logic;
signal Memory_read : std_logic;
signal RF_WrEn_WB : std_logic;
signal RF_WrEn_EX_MEM : std_logic;
signal mem_wb_wren : std_logic;
signal ConInstr : std_logic_vector(31 downto 0);

begin

datapath : DATAPATH_PIPELINE port map(clk => clk,
    	   rst => rst,
    	   PC_LdEn => PC_LdEn,
    	   Instr => Instr,
    	   IF_ID_wren => reg_instr_wren,
    	   ID_EX_wren => ID_EX_wren,
           PC => PC,
           RF_WrData_sel => RF_WrData_sel,
           RF_B_sel => RF_B_sel,
           ImmExt => ImmExt_b,
           PC_sel => PC_sel,
           ex_mem_wren => EX_MEM_WrEn,	
           mem_wb_wren => mem_wb_wren,
           Memory_read => Memory_read,
           RF_WrEn_EX_MEM => RF_WrEn_EX_MEM,
           RF_WrEn_WB => RF_WrEn_WB,
           Stalling => Stalling,
           MM_WrEn => MM_WrEn,
           MM_Addr => MM_Addr,
           MM_WrData => MM_WrData,
           ByteOp => ByteOp,
           Mem_WrEn => Mem_WrEn,
           MM_RdData => MM_RdData,
           ALU_Bin_sel => ALU_Bin_sel,
           ALU_func => ALU_func,
           ALU_zero => ALU_zero,
           RegInstr_out => ConInstr );


control : CONTROL_PIPELINE port map(clk => clk,
    	   ALU_func => ALU_func,
    	   ALU_zero => ALU_zero,
    	   WrEn => WrEn,
    	   alu_bin_sel => ALU_Bin_sel,
    	   rf_b_sel => RF_B_sel,
    	   rf_WrData_sel => RF_WrData_sel,
    	   mem_wren => Mem_WrEn,
    	   byteop => ByteOp,
    	   instr => ConInstr,
    	   PC_sel => PC_sel,
    	   PC_LdEn => PC_LdEn,
    	   RF_WrEn_WB => RF_WrEn_WB,
    	   Stalling => Stalling,
    	   ImmExt => ImmExt_b,
    	   RF_WrEn_EX_MEM => RF_WrEn_EX_MEM,
    	   ID_EX_WrEn => ID_EX_WrEn,
    	   EX_MEM_WrEn => EX_MEM_WrEn,
    	   reg_instr_wren => reg_instr_wren,
    	   mem_wb_WrEn => mem_wb_wren,
    	   Memory_read => Memory_read);

end Behavioral;

