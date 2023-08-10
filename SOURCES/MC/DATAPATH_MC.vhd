----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:18:24 04/24/2022 
-- Design Name: 
-- Module Name:    DATAPATH_MC - Behavioral 
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

entity DATAPATH_MC is
    Port ( clk : in  STD_LOGIC;
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
           Inst_out_reg : out STD_LOGIC_VECTOR(31 downto 0));
end DATAPATH_MC;

architecture Behavioral of DATAPATH_MC is


signal instr_out: std_logic_vector(31 downto 0);
signal rf_a_in : std_logic_vector(31 downto 0);
signal rf_b_in : std_logic_vector(31 downto 0);
signal rf_a_out : std_logic_vector(31 downto 0);
signal rf_b_out : std_logic_vector(31 downto 0);
signal alu_in_reg_S: std_logic_vector(31 downto 0);
signal alu_out_reg_S: std_logic_vector(31 downto 0);
signal mem_M_out : std_logic_vector(31 downto 0);
signal immed_in_reg : std_logic_vector(31 downto 0);
signal immed_out_reg : std_logic_vector(31 downto 0);
signal mem_out : std_logic_vector(31 downto 0);

component IFSTAGE 
	port ( PC_Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           PC_sel : in  STD_LOGIC;
           PC_LdEn : in  STD_LOGIC;
           Reset : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           PC : out  STD_LOGIC_VECTOR (31 downto 0));
end component;

component Register_ex
	port(  CLK : in  STD_LOGIC;
           Reset : in  STD_LOGIC :='0';
           Datain : in  STD_LOGIC_VECTOR(31 downto 0) :=(others=>'0');
           WE : in  STD_LOGIC ;
           Dataout : out  STD_LOGIC_VECTOR(31 downto 0) :=(others=>'0'));
end component;

component DECSTAGE 
	port(  Instr : in  STD_LOGIC_VECTOR (31 downto 0);
           WrEn : in  STD_LOGIC;
           ALU_out : in  STD_LOGIC_VECTOR (31 downto 0) ;
           MEM_out : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrData_sel : in  STD_LOGIC;
           RF_B_sel : in  STD_LOGIC;
           ImmExt : in  STD_LOGIC_VECTOR (1 downto 0);
           Clk : in  STD_LOGIC;
           Immed : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_A : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : out  STD_LOGIC_VECTOR (31 downto 0);
           Rst : in STD_LOGIC :='0');
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


begin
--TO IR  sumfwna me tis diafaneies tis fewrias
instruction_register: Register_ex port map(CLK => clk,
										   Reset => rst,
          								   Datain => Instr,
           								   WE => reg_instr_wren,
                                           Dataout => instr_out);
--register 
register_decImmed_ex : Register_ex port map(CLK => clk,
										   Reset => rst,
          								   Datain => immed_in_reg,
           								   WE => reg_decex_wren,
                                           Dataout => immed_out_reg);
--TO A
registerA_dec_ex : Register_ex port map   (CLK => clk,
										   Reset => rst,
          								   Datain => rf_a_in,
           								   WE => reg_decex_wren,
                                           Dataout => rf_a_out);
--TO B
registerB_dec_ex : Register_ex port map   (CLK => clk,
										   Reset => rst,
          								   Datain => rf_b_in,
           								   WE => reg_decex_wren,
                                           Dataout => rf_b_out);
--TO S
registerS_ex : Register_ex port map       (CLK => clk,
										   Reset => rst,
          								   Datain => alu_in_reg_S,
           								   WE => reg_alumem_wren,
                                           Dataout => alu_out_reg_S);

register_mem_M : Register_ex port map     (CLK => clk,
										   Reset => rst,
          								   Datain => mem_out,
           								   WE => reg_mem_wren,
                                           Dataout => mem_M_out);

decstage_port : DECSTAGE port map    ( Instr => instr_out,
                                       WrEn => write_enable,
                                       ALU_out => alu_out_reg_S,
                                       MEM_out => mem_M_out,
                                       RF_WrData_sel => RF_WrData_sel,
                                       RF_B_sel => RF_B_sel,
                                       ImmExt => ImmExt,
                                       Clk => clk , 
                                       Immed => immed_in_reg,
                                       RF_A => rf_a_in,
                                       RF_B => rf_b_in,
                                       Rst => rst);

ifstage_port : IFSTAGE port map (PC_Immed => immed_in_reg,
          				         PC_sel => PC_sel,
           				         PC_LdEn => PC_LdEn,
                                 Reset => rst,
                                 Clk => clk,
                                 PC => PC);

exstage_port : EXSTAGE port map (	RF_A => rf_a_out,
									RF_B => rf_b_out,
                                    Immed => immed_out_reg,
                                    ALU_Bin_sel => ALU_Bin_sel,
                                    ALU_func => ALU_func,
                                    ALU_out => alu_in_reg_S,   
                                    ALU_zero => ALU_zero);

memstage_port : MEMSTAGE port map ( ByteOp => ByteOp,
                                    Mem_WrEn => Mem_WrEn,
                                    ALU_MEM_Addr => alu_out_reg_S,
                                    MEM_DataIn => rf_b_out,
                                    MEM_DataOut => mem_out,
                                    MM_Addr => MM_Addr,
                                    MM_WrData => MM_WrData,
                                    MM_RdData => MM_RdData,
                                    MM_WrEn => MM_WrEn);
Inst_out_reg <= instr_out;
end Behavioral;

