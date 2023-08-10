----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:33:14 05/15/2022 
-- Design Name: 
-- Module Name:    PROCESSOR_MULTICYCLE - Behavioral 
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

entity PROCESSOR_MULTICYCLE is
    Port ( clk : in STD_LOGIC;
    	   rst : in STD_LOGIC;
    	   instr : in  STD_LOGIC_VECTOR(31 downto 0);
    	   MM_RdData : in  STD_LOGIC_VECTOR(31 downto 0);
    	   pc : out STD_LOGIC_VECTOR(31 downto 0);
           MM_Addr : out  STD_LOGIC_VECTOR(31 downto 0);
           MM_WrData : out  STD_LOGIC_VECTOR(31 downto 0);
           MM_WrEn : out  STD_LOGIC);
end PROCESSOR_MULTICYCLE;

architecture Behavioral of PROCESSOR_MULTICYCLE is

component DATAPATH_MC 
	port ( clk : in  STD_LOGIC;
    	   PC_sel : in STD_LOGIC;
    	   PC_LdEn : in STD_LOGIC;
           rst : in  STD_LOGIC;
           RF_B_sel : in  STD_LOGIC;
           RF_WrData_sel : in  STD_LOGIC;
           ALU_func : in  STD_LOGIC_VECTOR(3 downto 0);
           ALU_Bin_sel : in STD_LOGIC;
           ALU_zero : out  STD_LOGIC;
           ByteOp : in  STD_LOGIC;
           Mem_WrEn : in  STD_LOGIC;
           MM_RdData : in  STD_LOGIC_VECTOR(31 downto 0);
           ImmExt : in  STD_LOGIC_VECTOR(1 downto 0);
           PC : out STD_LOGIC_VECTOR(31 downto 0);
           Instr : in  STD_LOGIC_VECTOR(31 downto 0);
           MM_Addr : out  STD_LOGIC_VECTOR(31 downto 0);
           MM_WrData : out  STD_LOGIC_VECTOR(31 downto 0);
           MM_WrEn : out  STD_LOGIC;
           write_enable : in  STD_LOGIC;
           reg_decex_wren : in  STD_LOGIC;
           reg_alumem_wren : in  STD_LOGIC;
           reg_instr_wren : in  STD_LOGIC;
           reg_mem_wren: in  STD_LOGIC;
           Inst_out_reg : out STD_LOGIC_VECTOR);
end component;

component CONTROL_MC 
	port(  clk : in STD_LOGIC;
    	   rst : in STD_LOGIC;
    	   opcode: in STD_LOGIC_VECTOR (5 downto 0);
           func : in STD_LOGIC_VECTOR(5 downto 0);
           PC_Sel : out STD_LOGIC;
           RF_B_Sel : out STD_LOGIC;
           mem_wren : out STD_LOGIC;   --tou mem stage (AN DEN PAIRNAEI APO TO KATW PATH TOTE mem_wren = 0)
           rf_wren : out STD_LOGIC;    --eimai to write_enable tou DATAPATH_MC
           ALU_func : out STD_LOGIC_VECTOR(3 downto 0);
           RF_WrData_sel : out STD_LOGIC;
           alu_bin_sel : out STD_LOGIC;
           alu_zero : in STD_LOGIC;
           PC_LdEn : out STD_LOGIC;
           immext_out : out STD_LOGIC_VECTOR(1 downto 0);
           byteop : out STD_LOGIC;
           reg_decex_wren : out  STD_LOGIC;
           reg_alumem_wren : out  STD_LOGIC;
           reg_instr_wren : out  STD_LOGIC;
           reg_mem_wren: out  STD_LOGIC);
end component;

signal pc_sel_sig : STD_LOGIC;
signal PC_LdEn : STD_LOGIC;
signal RF_B_sel : STD_LOGIC;
signal RF_WrData_sel : STD_LOGIC;
signal ALU_func : STD_LOGIC_VECTOR(3 downto 0);
signal ALU_Bin_sel : STD_LOGIC;
signal ALU_zero : STD_LOGIC;
signal ByteOp : STD_LOGIC;
signal Mem_WrEn : STD_LOGIC;
signal ImmExt : STD_LOGIC_VECTOR(1 downto 0);
signal write_enable : STD_LOGIC;
signal reg_decex_wren : STD_LOGIC;
signal reg_alumem_wren : STD_LOGIC;
signal reg_instr_wren : STD_LOGIC;
signal reg_mem_wren : STD_LOGIC;
signal instr_control_sig : STD_LOGIC_VECTOR(31 downto 0);

begin



datapath_port_mc : DATAPATH_MC port map (clk => clk ,
    	                                 PC_sel => pc_sel_sig,
    	                                 PC_LdEn => PC_LdEn,
                                         rst => rst,
                                         RF_B_sel => RF_B_sel,
                                         RF_WrData_sel => RF_WrData_sel,
                                         ALU_func => ALU_func,
                                         ALU_Bin_sel => ALU_Bin_sel,
                                         ALU_zero => ALU_zero,
                                         ByteOp => ByteOp,
                                         Mem_WrEn => Mem_WrEn,
                                         MM_RdData => MM_RdData,
                                         ImmExt => ImmExt,
                                         PC => pc,
                                         Instr => instr,
                                         MM_Addr => MM_Addr,
                                         MM_WrData => MM_WrData,
                                         MM_WrEn => MM_WrEn,
                                         write_enable => write_enable,
                                         reg_decex_wren => reg_decex_wren,
                                         reg_alumem_wren => reg_alumem_wren,
                                         reg_instr_wren => reg_instr_wren,
                                         reg_mem_wren => reg_mem_wren,
                                         Inst_out_reg => instr_control_sig);

control_port_mc : CONTROL_MC port map(	clk => clk,
    	                                rst => rst,
    	                                opcode => instr_control_sig(31 downto 26),
                                        func => instr_control_sig(5 downto 0),
                                        PC_Sel => pc_sel_sig,
                                        RF_B_Sel => RF_B_Sel,
                                        mem_wren => Mem_WrEn,  --tou mem stage (AN DEN PAIRNAEI APO TO KATW PATH TOTE mem_wren = 0)
                                        rf_wren => write_enable,   --eimai to write_enable tou DATAPATH_MC
                                        ALU_func => ALU_func,
                                        RF_WrData_sel => RF_WrData_sel,
                                        alu_bin_sel => ALU_Bin_sel,
                                        alu_zero => ALU_zero,
                                        PC_LdEn => PC_LdEn,
                                        immext_out => ImmExt,
                                        byteop => ByteOp,
                                        reg_decex_wren => reg_decex_wren,
                                        reg_alumem_wren => reg_alumem_wren,
                                        reg_instr_wren => reg_instr_wren,
                                        reg_mem_wren => reg_mem_wren);



end Behavioral;

