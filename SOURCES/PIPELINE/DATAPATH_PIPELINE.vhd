----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:34:21 05/17/2022 
-- Design Name: 
-- Module Name:    DATAPATH_PIPELINE - Behavioral 
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

entity DATAPATH_PIPELINE is
    Port ( clk : in  STD_LOGIC; --
    	   rst : in  STD_LOGIC;--
    	   PC_LdEn : in STD_LOGIC;--
    	   Instr : in STD_LOGIC_VECTOR(31 downto 0);--
    	   IF_ID_wren : in STD_LOGIC;--
    	   ID_EX_wren : in STD_LOGIC;--
           PC : out  STD_LOGIC_VECTOR(31 downto 0);--
           RF_WrData_sel : in STD_LOGIC;--
           RF_B_sel : in STD_LOGIC ;--
           ImmExt : in STD_LOGIC_VECTOR(1 downto 0);--
           PC_sel : in STD_LOGIC;--
           ex_mem_wren : in STD_LOGIC;--	
           mem_wb_wren : in STD_LOGIC;--
           Memory_read : in STD_LOGIC;--
           RF_WrEn_EX_MEM : in std_logic;--
           RF_WrEn_WB : in std_logic;--
           Stalling : out std_logic;--
           MM_WrEn : out std_logic;--
           MM_Addr : out std_logic_vector(31 downto 0);--
           MM_WrData : out std_logic_vector(31 downto 0);--
           ByteOp : in std_logic;--
           Mem_WrEn : in std_logic;--
           MM_RdData : in  STD_LOGIC_VECTOR(31 downto 0);--
           ALU_Bin_sel : in std_logic;--
           ALU_func : in std_logic_vector(3 downto 0);--
           ALU_zero : out  STD_LOGIC;--
           RegInstr_out : out std_logic_vector(31 downto 0)--
           );
end DATAPATH_PIPELINE;

architecture Behavioral of DATAPATH_PIPELINE is

component Register_ex
	port ( CLK : in  STD_LOGIC;
           Reset : in  STD_LOGIC :='0';
           Datain : in  STD_LOGIC_VECTOR(31 downto 0) :=(others=>'0');
           WE : in  STD_LOGIC ;
           Dataout : out  STD_LOGIC_VECTOR(31 downto 0) :=(others=>'0'));
end component;

component Register_5
	port ( CLK : in  STD_LOGIC;
           Reset : in  STD_LOGIC :='0';
           Datain : in  STD_LOGIC_VECTOR(4 downto 0) := (others=>'0');
           WE : in  STD_LOGIC ;
           Dataout : out  STD_LOGIC_VECTOR(4 downto 0) :=(others=>'0'));
end component;


--one mux after ID/EX register 
--and another one after mem/wb register
component MUX2x1
	port(   mux_in_zero : in  STD_LOGIC_VECTOR(31 downto 0);
    	    mux_in_one : in  STD_LOGIC_VECTOR(31 downto 0);
            sel : in  STD_LOGIC;
            mux_out : out  STD_LOGIC_VECTOR(31 downto 0));
end component;

component MUX_3_x_1   ---this mux is necessary for forwardig where we are gonna need 2 of them
	port(     mux_in_zero : in  STD_LOGIC_VECTOR(31 downto 0);
    	      mux_in_one : in  STD_LOGIC_VECTOR(31 downto 0);
    	      mux_in_two : in  STD_LOGIC_VECTOR(31 downto 0);
              sel : in  STD_LOGIC_VECTOR(1 downto 0);
              mux_out : out  STD_LOGIC_VECTOR(31 downto 0));
end component;

component MUX2x1_5bit 
    Port (  mux_in_zero : in  STD_LOGIC_VECTOR(4 downto 0);
    	    mux_in_one : in  STD_LOGIC_VECTOR(4 downto 0);
            sel : in  STD_LOGIC;
            mux_out : out  STD_LOGIC_VECTOR(4 downto 0));
end component;

component IFSTAGE 
	port ( PC_Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           PC_sel : in  STD_LOGIC;
           PC_LdEn : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           PC : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component DECSTAGE_P 
	port(  Instr : in  STD_LOGIC_VECTOR (31 downto 0);
           WriteReg : in STD_LOGIC_VECTOR(4 downto 0);
           WrEn : in  STD_LOGIC;
           ALU_out : in  STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
           MEM_out : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrData_sel : in  STD_LOGIC;
           RF_B_sel : in  STD_LOGIC;
           ImmExt : in  STD_LOGIC_VECTOR (1 downto 0);
           Clk : in  STD_LOGIC;
           Immed : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_A : out  STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
           RF_B : out  STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
           Rst : in  STD_LOGIC := '0');
end component;

component EXSTAGE 
	port(  RF_A : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : in  STD_LOGIC_VECTOR (31 downto 0);
           Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           ALU_Bin_sel : in  STD_LOGIC;
           ALU_func : in  STD_LOGIC_VECTOR (3 downto 0);
           ALU_out : out  STD_LOGIC_VECTOR (31 downto 0);
           ALU_zero : out  STD_LOGIC);
end component;

component MEMSTAGE 
	port(  ByteOp : in  STD_LOGIC;  --shma elegxou gia epilogh lw/sw(0) OR lb/sb(1)  
           Mem_WrEn : in  STD_LOGIC;  --flag energopoihshs eggrafhs sth mnhmh
           ALU_MEM_Addr : in  STD_LOGIC_VECTOR (31 downto 0) := (others => '0'); --apotelesma ALU
           MEM_DataIn : in  STD_LOGIC_VECTOR (31 downto 0) := (others => '0');  --apotelesma RF[rd] gia apofhkeush sth mnhmh gia entoles swap sb, sw
           MEM_DataOut : out  STD_LOGIC_VECTOR (31 downto 0) ;  --dedomena gia fortwsh apo mnhmh pros register lb lw(pros RF)
           MM_WrEn : out  STD_LOGIC :='0' ;
           MM_Addr : out  STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
           MM_WrData : out  STD_LOGIC_VECTOR (31 downto 0) := (others => '0') ;
           MM_RdData : in  STD_LOGIC_VECTOR (31 downto 0));
end component;

component PIPELINE_REGISTERS
	port(  clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           mem_wb_in : in STD_LOGIC_VECTOR(31 downto 0);
           mem_wb_out : out STD_LOGIC_VECTOR(31 downto 0);
           mem_wb_wren : in STD_LOGIC;
           ex_mem_wren : in STD_LOGIC;
           ex_mem_in : in STD_LOGIC_VECTOR(31 downto 0);
           ex_mem_out : out STD_LOGIC_VECTOR(31 downto 0);
           RegRD_id_ex_in : in STD_LOGIC_VECTOR(4 downto 0);
           ID_EX_wren : in STD_LOGIC;
           RegRD_ex_mem_output : out STD_LOGIC_VECTOR(4 downto 0);
           RegRD_mem_wb_out : out STD_LOGIC_VECTOR(4 downto 0);
           RegRS_id_ex_in : in STD_LOGIC_VECTOR(4 downto 0);
           RegRS_id_ex_out : out STD_LOGIC_VECTOR(4 downto 0);
           RegRT_id_ex_in : in STD_LOGIC_VECTOR(4 downto 0);
           RegRT_id_ex_out : out STD_LOGIC_VECTOR(4 downto 0);
           Memory_read : in STD_LOGIC;
           Memory_read_out : out STD_LOGIC);
end component;

component FORWARDING 
	port(  ID_EX_RegisterRS : in  STD_LOGIC_VECTOR(4 downto 0);
    	   ID_EX_RegisterRT : in  STD_LOGIC_VECTOR(4 downto 0);
    	   EX_MEM_RegisterRD : in STD_LOGIC_VECTOR (4 downto 0);
    	   EX_MEM_RegWrite : in std_logic;
    	   MEM_WB_RegisterRD : in STD_LOGIC_VECTOR(4 downto 0);
    	   MEM_WB_RegWrite : in std_logic;
    	   ForwardA : out STD_LOGIC_VECTOR(1 downto 0);
    	   ForwardB : out STD_LOGIC_VECTOR(1 downto 0));
end component;

component STALL 
	port(  Memory_read_out : in  STD_LOGIC;
    	   RegRT_ID_EX : in std_logic_vector(4 downto 0);
    	   RegRT_IF_ID : in std_logic_vector(4 downto 0);
    	   RegRS_IF_ID : in std_logic_vector(4 downto 0);
    	   Stalling : out std_logic := '0');
end component;

signal instr_out : STD_LOGIC_VECTOR(31 downto 0);
signal rf_a_in : std_logic_vector(31 downto 0);
signal rf_b_in : std_logic_vector(31 downto 0);
signal rf_a_out : std_logic_vector(31 downto 0);
signal rf_b_out : std_logic_vector(31 downto 0);
signal alu_out_mem_wb : std_logic_vector(31 downto 0);
signal immed_in_reg : std_logic_vector(31 downto 0);
signal immed_out_reg : std_logic_vector(31 downto 0);
signal ALU_output : std_logic_vector(31 downto 0);
signal alu_output_of_ex : std_logic_vector(31 downto 0);
signal memory_output : std_logic_vector(31 downto 0);
signal mem_out_reg_wb : std_logic_vector(31 downto 0);
signal ALU_input_A : std_logic_vector(31 downto 0);
signal ALU_input_B : std_logic_vector(31 downto 0);
signal RegRD_ex_mem_output: std_logic_vector(4 downto 0);
signal RegRD_mem_wb_out : std_logic_vector(4 downto 0);
signal RegRS_id_ex_out : std_logic_vector(4 downto 0);
signal RegRT_id_ex_out : std_logic_vector(4 downto 0);
signal Memory_read_out : std_logic; 
signal ex_mem_out : std_logic_vector(31 downto 0);
signal forward_mem_wb : std_logic_vector(31 downto 0);
signal rt_vs_rd_rslt : std_logic_vector(4 downto 0);
signal forwardA : std_logic_vector(1 downto 0);
signal forwardB : std_logic_vector(1 downto 0);

begin

InstructionFetch_port : IFSTAGE port map(PC_Immed => immed_in_reg,     --DONE
                                         PC_sel => PC_sel,
                                         PC_LdEn => PC_LdEn,
                                         Reset => rst,
                                         Clk => clk,
                                         PC => PC );
----------------------------------------------------------------------------------

instruction_register: Register_ex port map(CLK => clk,                  --DONE
										                       Reset => rst,
          								                 Datain => Instr,
           								                 WE => IF_ID_wren,
                                           Dataout => instr_out);

--krata rf_a
dec_ex_A_register : Register_ex port map( CLK => clk,
                                          Reset => rst,                 --DONE
                                          Datain => rf_a_in,
                                          WE => ID_EX_wren,
                                          Dataout => rf_a_out);
--krata rf_b
dec_ex_B_register : Register_ex port map( CLK => clk,
                                          Reset => rst,
                                          Datain => rf_b_in,            --DONE
                                          WE => ID_EX_wren,
                                          Dataout => rf_b_out);

register_decImmed_ex : Register_ex port map(  CLK => clk,                
										                          Reset => rst,
          								                    Datain => immed_in_reg,    --DONE
           								                    WE => ex_mem_wren,
                                              Dataout => immed_out_reg);

register_alu_mem : Register_ex port map( CLK => clk,
                                         Reset => rst,
                                         Datain => ALU_output,           --DONE
                                         WE => ex_mem_wren,
                                         Dataout => alu_output_of_ex  );

register_mem : Register_ex port map(    CLK => clk,
                                        Reset => rst,
                                        Datain => memory_output,
                                        WE => mem_wb_wren,                --DONE
                                        Dataout => mem_out_reg_wb );
-----------------------------------------------------------------------------------

decstage_port : DECSTAGE_P port map( Instr => instr_out,
                                   WriteReg => RegRD_mem_wb_out,
                                   WrEn => RF_WrEn_WB,
                                   ALU_out => alu_out_mem_wb,
                                   MEM_out => mem_out_reg_wb,            --DONE 
                                   RF_WrData_sel => RF_WrData_sel,
                                   RF_B_sel => RF_B_sel,
                                   ImmExt => ImmExt,
                                   Clk => clk,
                                   Immed => immed_in_reg,
                                   RF_A => rf_a_in,
                                   RF_B => rf_b_in,
                                   Rst => rst);

pipeline_registers_port : PIPELINE_REGISTERS port map(clk => clk,
           rst => rst,
           mem_wb_in => alu_output_of_ex,
           mem_wb_out =>  alu_out_mem_wb,        --DONE
           mem_wb_wren => mem_wb_wren,
           ex_mem_wren => ex_mem_wren,
           ex_mem_in => ALU_input_B,
           ex_mem_out => ex_mem_out,
           RegRD_id_ex_in => instr_out(20 downto 16),
           ID_EX_wren => ID_EX_wren,
           RegRD_ex_mem_output => RegRD_ex_mem_output,
           RegRD_mem_wb_out => RegRD_mem_wb_out,
           RegRS_id_ex_in => instr_out(25 downto 21),
           RegRS_id_ex_out => RegRS_id_ex_out,
           RegRT_id_ex_in => rt_vs_rd_rslt,
           RegRT_id_ex_out => RegRT_id_ex_out,
           Memory_read => Memory_read,
           Memory_read_out => Memory_read_out);


--------------------------------MUXES FOR FORWARDING--------------------------------------
MUX_WB_result : MUX2x1 port map (mux_in_zero => mem_out_reg_wb,   --DONE MUXES ALL
    	                           mux_in_one => alu_out_mem_wb,
                                 sel => RF_WrData_sel,
                                 mux_out => forward_mem_wb);

mux_rt_vs_rs : MUX2x1_5bit port map(  mux_in_zero => instr_out(15 downto 11),
    	                                mux_in_one => instr_out(20 downto 16),
                                      sel => RF_B_sel,
                                      mux_out => rt_vs_rd_rslt);

mux_for_register_A : MUX_3_x_1 port map( mux_in_zero => rf_a_out,
    	                                   mux_in_one => alu_output_of_ex,
    	                                   mux_in_two => forward_mem_wb,
                                         sel => forwardA,
                                         mux_out => ALU_input_A);

mux_for_register_B: MUX_3_x_1 port map(  mux_in_zero => rf_b_out,
    	                                   mux_in_one => alu_output_of_ex,
    	                                   mux_in_two => forward_mem_wb,
                                         sel => forwardB,
                                         mux_out => ALU_input_B);

-------------------------------------Forwarding Unit------------------------------------

forward_port : FORWARDING port map(ID_EX_RegisterRS => RegRS_id_ex_out,    --DONE
    	                           ID_EX_RegisterRT => RegRT_id_ex_out,
    	                           EX_MEM_RegisterRD => RegRD_ex_mem_output,
    	                           EX_MEM_RegWrite => RF_WrEn_EX_MEM,
    	                           MEM_WB_RegisterRD => RegRD_mem_wb_out,
    	                           MEM_WB_RegWrite => RF_WrEn_WB,
    	                           ForwardA => forwardA,
    	                           ForwardB => forwardB);

----------------------------------------STALLING-----------------------------------
stalling_port : STALL port map( Memory_read_out => Memory_read_out,
    	                          RegRT_ID_EX => RegRT_id_ex_out,              --DONE
    	                          RegRT_IF_ID => rt_vs_rd_rslt,
    	                          RegRS_IF_ID => instr_out(25 downto 21),
    	                          Stalling => Stalling);
-----------------------------------------------------------------------------------
exstage_port : EXSTAGE port map(RF_A => ALU_input_A,
                                RF_B => ALU_input_B,
                                Immed => immed_out_reg,
                                ALU_Bin_sel => ALU_Bin_sel,
                                ALU_func => ALU_func,
                                ALU_out => ALU_output,
                                ALU_zero => ALU_zero);

memstage_port : MEMSTAGE port map( ByteOp => ByteOp,  
                                   Mem_WrEn => Mem_WrEn,
                                   ALU_MEM_Addr => alu_output_of_ex,
                                   MEM_DataIn => ex_mem_out,
                                   MEM_DataOut => memory_output,
                                   MM_WrEn => MM_WrEn,
                                   MM_Addr => MM_Addr,
                                   MM_WrData => MM_WrData,
                                   MM_RdData => MM_RdData);
RegInstr_out <= instr_out;
end Behavioral;



