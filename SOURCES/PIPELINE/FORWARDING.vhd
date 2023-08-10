----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:04:31 05/20/2022 
-- Design Name: 
-- Module Name:    FORWARDING - Behavioral 
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

entity FORWARDING is
    Port ( ID_EX_RegisterRS : in  STD_LOGIC_VECTOR(4 downto 0);
    	   ID_EX_RegisterRT : in  STD_LOGIC_VECTOR(4 downto 0);
    	   EX_MEM_RegisterRD : in STD_LOGIC_VECTOR (4 downto 0);
    	   EX_MEM_RegWrite : in std_logic;
    	   MEM_WB_RegisterRD : in STD_LOGIC_VECTOR(4 downto 0);
    	   MEM_WB_RegWrite : in std_logic;
    	   ForwardA : out STD_LOGIC_VECTOR(1 downto 0);
    	   ForwardB : out STD_LOGIC_VECTOR(1 downto 0));
end FORWARDING;

architecture Behavioral of FORWARDING is

begin

forwarding : process(ID_EX_RegisterRS, ID_EX_RegisterRT, EX_MEM_RegisterRD, EX_MEM_RegWrite, MEM_WB_RegisterRD, MEM_WB_RegWrite )

begin

--forward A for RS
--forward B for RT/RD
--forward(for either a or b ) == 00 no forward
--forward == 01 from ex/mem
--forward == 10 from mem/wb

--DO NOT FORWARD WHEN
--DESTINATION REGISTER IS ZERO OR REGWRITE IS NOT ASSERTED

if(EX_MEM_RegisterRD = "00000")then
--an ola 0 no forward
	if(MEM_WB_RegisterRD = "00000")then
		ForwardA <= "00";
		ForwardB <= "00";
	else 

		if (MEM_WB_RegisterRD = ID_EX_RegisterRS and MEM_WB_RegWrite= '1') then
			ForwardA <= "10";--take from mem_out
		else 
			ForwardA <= "00";
		end if;

		if (MEM_WB_RegisterRD = ID_EX_RegisterRT and MEM_WB_RegWrite= '1') then
			ForwardB <= "10";--take from mem_out
		else 
			ForwardB <= "00";
		end if;

	end if;
else 

	if(MEM_WB_RegisterRD = "00000") then

		if(EX_MEM_RegisterRD = "00000")then
			ForwardA <= "00";
			ForwardB <= "00";
        else
		 if (EX_MEM_RegisterRD = ID_EX_RegisterRS and EX_MEM_RegWrite= '1') then
			ForwardA <= "01";--take from mem_out
		 else 
			ForwardA <= "00";
		 end if;

		 if (EX_MEM_RegisterRD = ID_EX_RegisterRT and EX_MEM_RegWrite= '1') then
			ForwardB <= "01";--take from mem_out
		 else 
			ForwardB <= "00";
		 end if;
		end if;
	else

		if (MEM_WB_RegisterRD = EX_MEM_RegisterRD) then 

			if (EX_MEM_RegisterRD = ID_EX_RegisterRS and EX_MEM_RegWrite= '1' and MEM_WB_RegWrite= '1') then 
				ForwardA <= "01";
			elsif(EX_MEM_RegisterRD = ID_EX_RegisterRS and EX_MEM_RegWrite= '1' and MEM_WB_RegWrite= '0') then
				ForwardA <= "01";
			elsif(EX_MEM_RegisterRD = ID_EX_RegisterRS and EX_MEM_RegWrite= '0' and MEM_WB_RegWrite= '1') then
				ForwardA <= "10";
			else
				ForwardA <= "00";
			end if;

			if (EX_MEM_RegisterRD = ID_EX_RegisterRT and EX_MEM_RegWrite= '1' and MEM_WB_RegWrite= '1') then 
				ForwardB <= "01";
			elsif(EX_MEM_RegisterRD = ID_EX_RegisterRT and EX_MEM_RegWrite= '1' and MEM_WB_RegWrite= '0') then
				ForwardB <= "01";
			elsif(EX_MEM_RegisterRD = ID_EX_RegisterRT and EX_MEM_RegWrite= '0' and MEM_WB_RegWrite= '1') then
				ForwardB <= "10";
			else
				ForwardB <= "00";
			end if;
		else
			
			if (EX_MEM_RegisterRD = ID_EX_RegisterRS and EX_MEM_RegWrite = '1') then
				ForwardA <= "01"; 
			elsif (MEM_WB_RegisterRD = ID_EX_RegisterRS and MEM_WB_RegWrite = '1' ) then
				ForwardA <= "10";
			else 
				ForwardA <= "00";
			end if;

			if (EX_MEM_RegisterRD = ID_EX_RegisterRT and EX_MEM_RegWrite = '1') then
				ForwardB <= "01"; 
			elsif (MEM_WB_RegisterRD = ID_EX_RegisterRT and MEM_WB_RegWrite = '1' ) then
				ForwardB <= "10";
			else 
				ForwardB <= "00";
			end if;

		end if;

	end if;



end if;





end process;

end Behavioral;

