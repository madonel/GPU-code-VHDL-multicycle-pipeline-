----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:15:48 04/05/2022 
-- Design Name: 
-- Module Name:    MEMSTAGE - Behavioral 
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
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MEMSTAGE is 
    Port ( ByteOp : in  STD_LOGIC;  --shma elegxou gia epilogh lw/sw(0) OR lb/sb(1)  
           Mem_WrEn : in  STD_LOGIC;  --flag energopoihshs eggrafhs sth mnhmh
           ALU_MEM_Addr : in  STD_LOGIC_VECTOR (31 downto 0) := (others => '0'); --apotelesma ALU
           MEM_DataIn : in  STD_LOGIC_VECTOR (31 downto 0) := (others => '0');  --apotelesma RF[rd] gia apofhkeush sth mnhmh gia entoles swap sb, sw
           MEM_DataOut : out  STD_LOGIC_VECTOR (31 downto 0) ;  --dedomena gia fortwsh apo mnhmh pros register lb lw(pros RF)
           MM_WrEn : out  STD_LOGIC :='0' ;
           MM_Addr : out  STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
           MM_WrData : out  STD_LOGIC_VECTOR (31 downto 0) := (others => '0') ;
           MM_RdData : in  STD_LOGIC_VECTOR (31 downto 0));
end MEMSTAGE;

architecture Behavioral of MEMSTAGE is

signal mem_write_enable : STD_LOGIC  := '0';
signal increase_addr : STD_LOGIC_VECTOR (31 downto 0); 

begin

mem_write_enable <= Mem_WrEn;
MM_WrEn  <= mem_write_enable;

--increase_addr <= ALU_MEM_Addr + x"400";
MM_Addr <= ALU_MEM_Addr + x"00000400";

	memstage_pro : process (ByteOp, Mem_WrEn, MM_RdData,ALU_MEM_Addr, MEM_DataIn ) --ALU_MEM_Addr
begin

if (ByteOp = '0') then
	if (Mem_WrEn = '1' ) then   --sw
		MM_WrData <= MEM_DataIn;
	end if;
	MEM_DataOut <= MM_RdData;     --lw	
else
	if (Mem_WrEn = '1' ) then   --sb
		MM_WrData <=   "000000000000000000000000" &  MEM_DataIn(7 downto 0);        --std_logic_vector(resize(unsigned(MEM_DataIn(7 downto 0)), 32));
	end if;
		MEM_DataOut <= "000000000000000000000000" & MM_RdData(7 downto 0); --std_logic_vector(resize(unsigned(MM_RdData(7 downto 0)), 32));
end if;

end process;
end Behavioral;

