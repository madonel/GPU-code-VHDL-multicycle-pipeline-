----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:11:25 03/27/2022 
-- Design Name: 
-- Module Name:    MUX2x1 - Behavioral 
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
use ieee.std_logic_unsigned.all;
use  ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MUX2x1 is
    Port (  mux_in_zero : in  STD_LOGIC_VECTOR(31 downto 0);
    	      mux_in_one : in  STD_LOGIC_VECTOR(31 downto 0);
            sel : in  STD_LOGIC;
            mux_out : out  STD_LOGIC_VECTOR(31 downto 0));
end MUX2x1;

architecture Behavioral of MUX2x1 is
begin
  --TO BALA TWRA     KAI ETSI DOULEUEI TO RF_A = 1 KAI RF_B = 1
--mux: process (sel, mux_in_zero, mux_in_one)

--begin
mux_out <= mux_in_one when sel = '1' else 
           mux_in_zero when sel = '0';
	
--end process;

end Behavioral;

