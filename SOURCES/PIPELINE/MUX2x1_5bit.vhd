----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:03:40 05/19/2022 
-- Design Name: 
-- Module Name:    MUX2x1_5bit - Behavioral 
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

entity MUX2x1_5bit is
    Port (  mux_in_zero : in  STD_LOGIC_VECTOR(4 downto 0);
    	    mux_in_one : in  STD_LOGIC_VECTOR(4 downto 0);
            sel : in  STD_LOGIC;
            mux_out : out  STD_LOGIC_VECTOR(4 downto 0));
end MUX2x1_5bit;

architecture Behavioral of MUX2x1_5bit is

begin

mux_out <= mux_in_one when sel = '1' else 
           mux_in_zero when sel = '0';


end Behavioral;

