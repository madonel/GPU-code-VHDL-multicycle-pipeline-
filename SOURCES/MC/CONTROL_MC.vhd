----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:13:03 05/08/2022 
-- Design Name: 
-- Module Name:    CONTROL_MC - Behavioral 
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

entity CONTROL_MC is
    Port ( clk : in STD_LOGIC;
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
end CONTROL_MC;

architecture Behavioral of CONTROL_MC is

--what we need is states

--STATES
--s0 INSTRUCTION FETCH
--s1 decode 
--s2 R TYPE
--s3 R TYPE final state
--s4 ORi TYPE
--s5 ORi TYPE final state
--s6 Load word/byte execute
--s7 Load word/byte read mem
--s8 Load word/byte final state of write back
--s9 Store word/byte execute
--s10 Store word/byte final state of write back
--s11 BEQ

type STATE_TYPE is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11);
signal current_state, next_state : STATE_TYPE ;

begin

control_process : process (opcode, current_state)

begin 
--------FIRST OF DETERMINE THE STATES
	case current_state is 

		when s0 => next_state <= s1 ;--pas decode 

		when s1 =>
			case opcode is 
				when "100000" => next_state <= s1;  --r type
				when "111000" => next_state <= s4;  --i type  li comand 
				when "111001" => next_state <= s4;  --lui command
				when "110000" => next_state <= s4;  --addi command
				when "110010" => next_state <= s4;  --nandi command
				when "110011" => next_state <= s4;  --ori command
				when "111111" => next_state <= s11; --branch commands
				when "000000" => next_state <= s11; --branch commands
				when "000001" => next_state <= s11; --branch commands
				when "000011" => next_state <= s6;  --load byte
				when "000111" => next_state <= s9;  --store byte
				when "001111" => next_state <= s6;  --load word
				when "011111" => next_state <= s9;  --store word
				when others   => next_state <= s0;
        end case;

        when s2 => next_state <= s3;

        when s3 => next_state <= s0;

        when s4 => next_state <= s5;

        when s5 => next_state <= s0;

        when s6 => next_state <= s7;

        when s7 => next_state <= s8;

        when s8 => next_state <= s0;

        when s9 => next_state <= s10;

        when s10 => next_state <= s0;

        when s11 => next_state <= s0;

        when others => next_state <= s0; 
end case;
end process control_process;          --asychrono


control_with_clock: process(clk)
begin 
----------IT IS A MULTICYCLE PROCESSOR with each cycle of a clock comes a new state
	if (rising_edge(clk)) then
		if (rst = '1') then
			current_state <= s0;
		else 
			current_state <= next_state;
	    end if;
	end if;
    
end process control_with_clock;


-------ACTUAL OUTPUTS OF THE CONTROL unit
control_outputs: process(current_state, func, alu_zero, opcode)
begin
--those who have func do not have a branch command
    case current_state is
    --INSTRUCTION FETCH
    	when s0 => 
    		PC_LdEn <= '0';        --PCSource
    		reg_instr_wren <= '1'; --IRWrite apla grafeis to instruction sto instruction fetch
    		reg_decex_wren <= '0'; --ALUSrcA ALUSrcB  to xa 0
     		reg_alumem_wren <= '0';   --ola ta alla mhden
    		PC_sel <= '0';
    		mem_wren <= '0';
    		rf_wren <= '0';   --maybe to xa 0
     		reg_mem_wren <= '0';

    	when s1 =>
    		--DECODE
    		PC_LdEn <= '0';
    		reg_instr_wren <= '0'; --IRWrite apla grafeis to instruction sto instruction fetch
    		reg_decex_wren <= '1'; --ALUSrcA ALUSrcB
    		reg_alumem_wren <= '0';   --ola ta alla mhden
    		mem_wren <= '0';
    		rf_wren <= '0';--to xa 0
    		reg_mem_wren <= '0';

    		--need to set immext_out value also
    		if opcode = "100000" then 
    			RF_B_Sel <= '0';  --r type
    		else 
    			RF_B_Sel <= '1';  --i type
    		end if;


    		case opcode is
				when "111000" => immext_out <= "01";  --sign extend wi type  li comand 
				when "111001" => immext_out <= "00";  --zero fill  --lui command
				when "110000" => immext_out <= "01";  --zero fill  --addi command
				when "110010" => immext_out <= "00";  --zero fill  --nandi command
				when "110011" => immext_out <= "00";  --zero fill  --ori command
				when "111111" => immext_out <= "01";  --sign extend--branch commands
				when "000000" => immext_out <= "01";  --sign extend --branch commands
				when "000001" => immext_out <= "01";  --sign ext --branch commands
				when "000011" => immext_out <= "01";  --sign extend   --load byte
				when "000111" => immext_out <= "01";  --sign extend   --store byte
				when "001111" => immext_out <= "01";  --sign extend  --load word
				when "011111" => immext_out <= "01";  --sign extend  --store word
				when others   => 

				end case;

		when s2 =>
		--R TYPE
    		reg_instr_wren <= '0'; --IRWrite apla grafeis to instruction sto instruction fetch
    		reg_decex_wren <= '0'; --ALUSrcA ALUSrcB
    		reg_alumem_wren <= '1';   --ola ta alla mhden   opws fainetai kai apo tis diafaneies ths fewria anafetw ston s timh s<=a+b ara s register
    		reg_mem_wren <= '0';
    		alu_bin_sel <= '0';  --to fes 0 logw rf_b
    		ALU_func <= func(3 downto 0);

    	when s3 =>
    	--s3 R TYPE final state
    		PC_LdEn <= '1';          --PCSource h PC entolh fa erfei ena kuklo meta ara fes na ginei otan apo s3 pas ston s0 ara edw o PC_LdEn ginetai 1
    		reg_instr_wren <= '0';   --IRWrite apla grafeis to instruction sto instruction fetch
    		reg_decex_wren <= '0';   --ALUSrcA ALUSrcB
    		reg_alumem_wren <= '0';  --ola ta alla mhden   opws fainetai kai apo tis diafaneies ths fewria anafetw ston s timh s<=a+b ara s register
    		PC_sel <= '0';           --den exeis immediate ara 0
    		mem_wren <= '0';         -- gi auto de 3erw 
    		RF_WrData_sel <= '0';    -- na to gra4w ston register R[rd] <= S felw to ALU_OUT
    		rf_wren <= '1';
    		reg_mem_wren <= '0';     --o M register einai apo to katw monopati pou den pairnaei ara 0
    		
    	when s4 =>
    	--ORi TYPE
    		reg_instr_wren <= '0'; --IRWrite apla grafeis to instruction sto instruction fetch
    		reg_decex_wren <= '0'; --ALUSrcA ALUSrcB
    		reg_alumem_wren <= '1';   --ola ta alla mhden   opws fainetai kai apo tis diafaneies ths fewria anafetw ston s timh s<=a+b ara s register
    		reg_mem_wren <= '0';
    		alu_bin_sel <= '1';   --fes immed gia auto 1

    		if opcode = "111000" then
				ALU_func <= "0000";
			elsif opcode = "111001" then
				ALU_func <= "0000";
			elsif opcode = "110000" then
				ALU_func <= "0000";
			elsif opcode = "110010" then
				ALU_func <= "0101";
			elsif opcode = "110011" then
				ALU_func <= "0011";
			end if;

		when s5 =>
    	--ORi TYPE execute final stage
    		PC_LdEn <= '1';        --PCSource  (kai na mh to balw its okay?) CHECK
    		reg_instr_wren <= '0'; --IRWrite apla grafeis to instruction sto instruction fetch
    		reg_decex_wren <= '0'; --ALUSrcA ALUSrcB
    		reg_alumem_wren <= '0';   --ola ta alla mhden   opws fainetai kai apo tis diafaneies ths fewria anafetw ston s timh s<=a+b ara s register
    		PC_sel <= '0';
    		mem_wren <= '0';
    		rf_wren <= '1';
    		reg_mem_wren <= '0';
    		RF_WrData_sel <= '0';    -- write in given register R[rd] <= S value comes from ALU_OUT

    	when s6 =>
    	--Load word/byte execute
    		reg_instr_wren <= '0';   --IRWrite apla grafeis to instruction sto instruction fetch
    		reg_decex_wren <= '0';   --ALUSrcA ALUSrcB
    		reg_alumem_wren <= '1';  --ola ta alla mhden   opws fainetai kai apo tis diafaneies ths fewria anafetw ston s timh s<=a+b ara s register
    		PC_LdEn <= '0';
    		mem_wren <= '0';         --den eina store entolh ara den bazoume 1
    		rf_wren <= '0';
    		reg_mem_wren <= '0';     
    		alu_bin_sel <= '1';      --we need the immediate value for the offset
    		ALU_func <= "0000";      --eite einai lword eite lbyte

    	when s7 =>
    	-- Load word/byte read mem
    		PC_LdEn <= '0';          
    		reg_instr_wren <= '0';   --IRWrite apla grafeis to instruction sto instruction fetch
    		reg_decex_wren <= '0';   --ALUSrcA ALUSrcB
    		reg_alumem_wren <= '0';  --ola ta alla mhden   opws fainetai kai apo tis diafaneies ths fewria anafetw ston s timh s<=a+b ara s register
    		PC_sel <= '0';
    		mem_wren <= '0';         --den eina store entolh ara den bazoume 1
    		rf_wren <= '0';
    		reg_mem_wren <= '1';  
    		
    		if(opcode = "000011") then byteop <= '1';
    		else byteop <= '0';
    		end if;

    	when s8 =>
    	-- Load word/byte final state of write back

    		PC_LdEn <= '1';          --PCSource (KANE TON ENABLE) pare thn epomenh entolh ena kuklo meta sthn katastash s0
    		reg_instr_wren <= '0';   --IRWrite apla grafeis to instruction sto instruction fetch
    		reg_decex_wren <= '0';   --ALUSrcA ALUSrcB
    		reg_alumem_wren <= '0';  --ola ta alla mhden   opws fainetai kai apo tis diafaneies ths fewria anafetw ston s timh s<=a+b ara s register
    		PC_sel <= '0';
    		mem_wren <= '0';         --den eina store entolh ara den bazoume 1
    		rf_wren <= '1';
    		reg_mem_wren <= '0';     
    		RF_WrData_sel <= '1';    -- -- to pairneis apo to mem_out 

    	when s9 =>
    	-- Store word/byte execute
    		reg_instr_wren <= '0';   --IRWrite apla grafeis to instruction sto instruction fetch
    		reg_decex_wren <= '1';   --ALUSrcA ALUSrcB
    		reg_alumem_wren <= '1';  --ola ta alla mhden   opws fainetai kai apo tis diafaneies ths fewria anafetw ston s timh s<=a+b ara s register
    		PC_sel <= '0';           --den einai branch entolh
    		mem_wren <= '0';         --den eina store entolh ara den bazoume 1 
    		rf_wren <= '0';
    		reg_mem_wren <= '0';     
    		alu_bin_sel <= '1';      --we need the immediate value for the offset
    		ALU_func <= "0000";      --eite einai sword eite sbyte

    	when s10 =>
    	--  Store word/byte final state of write back
    		PC_LdEn <= '1';        --PCSource  (kai na mh to balw its okay?) CHECK
    		reg_instr_wren <= '0';   --IRWrite apla grafeis to instruction sto instruction fetch
    		reg_decex_wren <= '0';   --ALUSrcA ALUSrcB
    		reg_alumem_wren <= '0';  --ola ta alla mhden   opws fainetai kai apo tis diafaneies ths fewria anafetw ston s timh s<=a+b ara s register
    		PC_sel <= '0';           --den einai branch entolh
    		mem_wren <= '1';         --den eina store entolh ara den bazoume 1
    		rf_wren <= '0';
    		reg_mem_wren <= '0';      --maybe 0 not sure

    		if(opcode = "000111") then byteop <= '1';
    		else byteop <= '0';
    		end if;

    	when s11 =>
    	--  BRANCH
    		reg_instr_wren <= '1';   --IRWrite apla grafeis to instruction sto instruction fetch
    		reg_decex_wren <= '0';   --ALUSrcA ALUSrcB
    		reg_alumem_wren <= '0';  --ola ta alla mhden   opws fainetai kai apo tis diafaneies ths fewria anafetw ston s timh s<=a+b ara s register
    		reg_mem_wren <= '0';       --maybe 0 not sure

    		if (opcode = "000000") then --beq
    			PC_Sel <= alu_zero;
    			ALU_func <= "0001";
    			alu_bin_sel <= '0'; --to xa 0
    			PC_LdEn <= '1';
    			RF_B_Sel <= '1';

    		elsif opcode = "000001" then  --bne
    			PC_Sel <= not(alu_zero);
    			ALU_func <= "0001";
    			alu_bin_sel <= '0'; --to xa 0
    			PC_LdEn <= '1';

    		elsif opcode = "111111" then  --b
    			 PC_Sel <= '1';
    			 PC_LdEn <= '1';   
    			 mem_wren <= '0';
    			 rf_wren <= '0';
    		end if;
        when others =>
        end case;

    --end case;

	end process control_outputs;


end Behavioral;

