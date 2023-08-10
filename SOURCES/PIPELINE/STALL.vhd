----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:49:26 05/21/2022 
-- Design Name: 
-- Module Name:    STALLING - Behavioral 
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

entity STALL is
    Port ( Memory_read_out : in  STD_LOGIC;
    	   RegRT_ID_EX : in std_logic_vector(4 downto 0);
    	   RegRT_IF_ID : in std_logic_vector(4 downto 0);
    	   RegRS_IF_ID : in std_logic_vector(4 downto 0);
    	   Stalling : out std_logic := '0');
end STALL;

architecture Behavioral of STALL is

begin
stalling_pro : process(Memory_read_out, RegRT_ID_EX, RegRT_IF_ID, RegRS_IF_ID )
begin 

if (Memory_read_out = '1') then
	if(RegRS_IF_ID = RegRT_ID_EX or RegRT_ID_EX = RegRT_IF_ID) then
		Stalling <= '1';
    else 
    	Stalling <= '0';
    end if;
else
	Stalling <= '0';

end if;

end process;


end Behavioral;

