----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:57:05 05/22/2022 
-- Design Name: 
-- Module Name:    CONTROL_PIPELINE - Behavioral 
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

entity CONTROL_PIPELINE is
    Port ( clk : in  STD_LOGIC;
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
    	   Memory_read : out STD_LOGIC
    	   );
end CONTROL_PIPELINE;

architecture Behavioral of CONTROL_PIPELINE is

component Register_4bit
	port(  CLK : in  STD_LOGIC;
           Reset : in  STD_LOGIC :='0';
           Datain : in  STD_LOGIC_VECTOR(3 downto 0) :=(others=>'0');
           WE : in  STD_LOGIC ;
           Dataout : out  STD_LOGIC_VECTOR(3 downto 0) :=(others=>'0'));
end component;

component Register_1bit
	port(  CLK : in  STD_LOGIC;
           Reset : in  STD_LOGIC :='0';
           Datain : in  STD_LOGIC :='0';
           WE : in  STD_LOGIC ;
           Dataout : out STD_LOGIC :='0') ;
end component;

signal func_in_reg_ID_EX : STD_LOGIC_VECTOR(3 downto 0);
signal ALU_BIN_SEL_in_reg_ID_EX : STD_LOGIC;
signal ByteOp_in_reg_ID_EX : STD_LOGIC;
signal WrData_sel_in_reg_ID_EX : STD_LOGIC;
signal Rf_WrEn_in_reg_ID_EX : STD_LOGIC;
signal MEM_WrEn_in_reg_ID_EX : STD_LOGIC;

signal ByteOp_out_reg : STD_LOGIC;
signal WrData_sel_out_reg : STD_LOGIC;
signal Rf_WrEn_out_reg : STD_LOGIC;
signal MEM_WrEn_out_reg : STD_LOGIC;
signal rf_wren_out_ex_mem : STD_LOGIC;
signal WrData_sel_out_reg_ex_mem : STD_LOGIC;
signal rst :  STD_LOGIC := '0';

begin

-------------------------	ID/EX NECESSARY REGS-------------------------------
ID_EX_AluFunc_Reg : Register_4bit port map(CLK => clk,
                                           Reset => rst, 
                                           Datain => func_in_reg_ID_EX,
                                           WE => WrEn,
                                           Dataout => ALU_func);

ID_EX_ByteOp_Reg : Register_1bit port map( CLK => clk,
                                           Reset => rst, 
                                           Datain => ByteOp_in_reg_ID_EX,
                                           WE => WrEn,
                                           Dataout => ByteOp_out_reg);

ID_EX_alu_bin_sel_Reg : Register_1bit port map(CLK => clk,
                                           Reset => rst, 
                                           Datain => ALU_BIN_SEL_in_reg_ID_EX,
                                           WE => WrEn,
                                           Dataout => alu_bin_sel);

ID_EX_WrData_sel_reg : Register_1bit port map(CLK => clk,
                                           Reset => rst, 
                                           Datain => WrData_sel_in_reg_ID_EX,
                                           WE => WrEn,
                                           Dataout => WrData_sel_out_reg);

ID_EX_Rf_WrEn_Reg : Register_1bit port map(CLK => clk,
                                           Reset => rst, 
                                           Datain => Rf_WrEn_in_reg_ID_EX,
                                           WE => WrEn,
                                           Dataout => Rf_WrEn_out_reg);

ID_EX_MEM_WrEn_Reg : Register_1bit port map(CLK => clk,
                                           Reset => rst, 
                                           Datain => MEM_WrEn_in_reg_ID_EX,
                                           WE => WrEn,
                                           Dataout => MEM_WrEn_out_reg);

------------------------ EX/MEM NECESSARY REGS ------------------------------
EX_MEM_MEM_WrEn_Reg : Register_1bit port map(CLK => clk,
                                           Reset => '0', 
                                           Datain => MEM_WrEn_out_reg,
                                           WE => WrEn,
                                           Dataout => mem_wren);

EX_MEM_ByteOp_Reg : Register_1bit port map(CLK => clk,
                                           Reset => '0', 
                                           Datain => ByteOp_out_reg,
                                           WE => WrEn,
                                           Dataout => byteop);

EX_MEM_Rf_WrEn_Reg : Register_1bit port map(CLK => clk,
                                           Reset => '0', 
                                           Datain => Rf_WrEn_out_reg,
                                           WE => WrEn,
                                           Dataout => rf_wren_out_ex_mem);

--FOR FORWARDING ----

RF_WrEn_EX_MEM <= rf_wren_out_ex_mem;

EX_MEM_RF_WrData_sel_Reg : Register_1bit port map(CLK => clk,
                                                  Reset => '0', 
                                                  Datain => WrData_sel_out_reg,
                                                  WE => WrEn,
                                                  Dataout => WrData_sel_out_reg_ex_mem);

---------------------------MEM/WB NECESSARY REGS-----------------------------------------
MEM_WB_Rf_WrEn_Reg : Register_1bit port map(CLK => clk,
                                           Reset => '0', 
                                           Datain => rf_wren_out_ex_mem,
                                           WE => WrEn,
                                           Dataout => RF_WrEn_WB);

MEM_WB_RF_WrData_sel_Reg : Register_1bit port map(CLK => clk,
                                                  Reset => '0', 
                                                  Datain => WrData_sel_out_reg_ex_mem,
                                                  WE => WrEn,
                                                  Dataout => rf_WrData_sel);

control_pipeline_process : process (instr, Stalling)
begin

	PC_LdEn <= '1' AND NOT(Stalling);
	PC_sel <= '0';


	ID_EX_WrEn <= '1';
	EX_MEM_WrEn <='1';
	reg_instr_wren <= '1'  AND NOT(Stalling);
	mem_wb_WrEn <= '1';
	Memory_read <= '0';

    rst <= '1';

    case instr(31 downto 26) is

    --  R TYPE COMMANDS 
    	when "100000" =>
    		func_in_reg_ID_EX <= instr(3 downto 0);
    		Rf_WrEn_in_reg_ID_EX <= '1';
    		WrData_sel_in_reg_ID_EX <= '0';
    		rf_b_sel <= '0';
    		ALU_BIN_SEL_in_reg_ID_EX <= '0';
    		MEM_WrEn_in_reg_ID_EX <= '0';

    	-- LI COMMAND 
        when "111000" =>
        	Rf_WrEn_in_reg_ID_EX <= '1';
        	MEM_WrEn_in_reg_ID_EX <= '0';
        	func_in_reg_ID_EX <= "0000";
        	ALU_BIN_SEL_in_reg_ID_EX <= '1';
        	ImmExt <= "01";
        	rf_b_sel <= '1';
        	Rf_WrEn_in_reg_ID_EX <= '1';

        -- LUI COMMAND 
        when "111001" =>
        	func_in_reg_ID_EX <= "0000";
        	Rf_WrEn_in_reg_ID_EX <= '1';
        	MEM_WrEn_in_reg_ID_EX <= '0';
        	ALU_BIN_SEL_in_reg_ID_EX <= '1';
        	ImmExt <= "00";
        	WrData_sel_in_reg_ID_EX <= '1';

        --ADDI
        when "110000" =>
        	func_in_reg_ID_EX <= "0000";
        	Rf_WrEn_in_reg_ID_EX <= '1';
        	MEM_WrEn_in_reg_ID_EX <= '0';
        	ALU_BIN_SEL_in_reg_ID_EX <= '1';
        	ImmExt <= "01";
        	WrData_sel_in_reg_ID_EX <= '0';
        	rf_b_sel <= '1';


        --NANDI
        when "110010" => 
        	func_in_reg_ID_EX <= "0101";
        	Rf_WrEn_in_reg_ID_EX <= '1';
        	MEM_WrEn_in_reg_ID_EX <= '0';
        	ALU_BIN_SEL_in_reg_ID_EX <= '1';
        	ImmExt <= "00";
        	rf_b_sel <= '1';
        	WrData_sel_in_reg_ID_EX <= '1';

        --ORI
        when "110011" =>
        	func_in_reg_ID_EX <= "0011";
        	Rf_WrEn_in_reg_ID_EX <= '1';
        	MEM_WrEn_in_reg_ID_EX <= '0';
        	ALU_BIN_SEL_in_reg_ID_EX <= '1';
        	ImmExt <= "00";
        	rf_b_sel <= '1';
        	WrData_sel_in_reg_ID_EX <= '0';

        --lb command 
        when "000011" =>
        	func_in_reg_ID_EX <= "0000";
        	Rf_WrEn_in_reg_ID_EX <= '1';
        	MEM_WrEn_in_reg_ID_EX <= '0';
        	ALU_BIN_SEL_in_reg_ID_EX <= '1';
        	ImmExt <= "01";
        	rf_b_sel <= '1';
        	WrData_sel_in_reg_ID_EX <= '1';
        	ByteOp_in_reg_ID_EX <= '1';
          Memory_read <= '1';

        --sb
        when "000111" =>
        	func_in_reg_ID_EX <= "0000";
        	Rf_WrEn_in_reg_ID_EX <= '0';
        	MEM_WrEn_in_reg_ID_EX <= '1';
        	ALU_BIN_SEL_in_reg_ID_EX <= '1';
        	ImmExt <= "01";
        	rf_b_sel <= '1';
        	WrData_sel_in_reg_ID_EX <= '0';
        	ByteOp_in_reg_ID_EX <= '1';

        --lw
        when "001111" =>
        	func_in_reg_ID_EX <= "0000";
        	Rf_WrEn_in_reg_ID_EX <= '1';
        	MEM_WrEn_in_reg_ID_EX <= '0';
        	ALU_BIN_SEL_in_reg_ID_EX <= '1';
        	ImmExt <= "01";
        	rf_b_sel <= '1';
        	WrData_sel_in_reg_ID_EX <= '1';
        	ByteOp_in_reg_ID_EX <= '0';
           Memory_read <= '1';

         --sw
        when "011111" =>
        	func_in_reg_ID_EX <= "0000";
        	Rf_WrEn_in_reg_ID_EX <= '0';
        	MEM_WrEn_in_reg_ID_EX <= '1';
        	ALU_BIN_SEL_in_reg_ID_EX <= '1';
        	ImmExt <= "01";
        	rf_b_sel <= '1';
        	WrData_sel_in_reg_ID_EX <= '1';
        	ByteOp_in_reg_ID_EX <= '0';

        --BRANCH
             when "111111" =>
              Rf_WrEn_in_reg_ID_EX <= '0';
              MEM_WrEn_in_reg_ID_EX <= '0';
              ImmExt <= "01";

        --BRANCH IF EQUAL
            when "000000" => 
              Rf_WrEn_in_reg_ID_EX <= '0';
              MEM_WrEn_in_reg_ID_EX <= '0';
              ImmExt <= "01";
              func_in_reg_ID_EX <= "0001";
              ALU_BIN_SEL_in_reg_ID_EX <= '0';
              rf_b_sel <= '1';

        --BRANCH IF NOT EQUAL
            when "000001" =>
              Rf_WrEn_in_reg_ID_EX <= '0';
              MEM_WrEn_in_reg_ID_EX <= '0';
              ImmExt <= "01";
              func_in_reg_ID_EX <= "0010";
              ALU_BIN_SEL_in_reg_ID_EX <= '0';
              rf_b_sel <= '1';


        when others => 
        	--Rf_WrEn_in_reg_ID_EX <= '0';
        	--MEM_WrEn_in_reg_ID_EX <= '0';
          PC_LdEn <= '0';
        end case;

end process;
end Behavioral;

