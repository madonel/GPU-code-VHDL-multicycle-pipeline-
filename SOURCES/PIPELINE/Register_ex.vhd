----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:26:26 03/14/2022 
-- Design Name: 
-- Module Name:    Register_ex - Behavioral 
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Register_ex is
    Port ( CLK : in  STD_LOGIC;
           Reset : in  STD_LOGIC :='0';
           Datain : in  STD_LOGIC_VECTOR(31 downto 0) :=(others=>'0');
           WE : in  STD_LOGIC ;
           Dataout : out  STD_LOGIC_VECTOR(31 downto 0) :=(others=>'0'));
end Register_ex;

architecture Behavioral of Register_ex is

begin

regist_pro:process(CLK, Reset)

begin
 
if rising_edge(CLK) then

	if WE = '1' then
    	Dataout <= Datain after 10 ns;
    elsif Reset = '1' then
      Dataout<= x"00000000" ;
    end if;  	
end if;

end process;



end Behavioral;

