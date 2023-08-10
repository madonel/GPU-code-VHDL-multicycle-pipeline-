----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:24:22 05/19/2022 
-- Design Name: 
-- Module Name:    MUX_3_x_1 - Behavioral 
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

entity MUX_3_x_1 is
    Port (    mux_in_zero : in  STD_LOGIC_VECTOR(31 downto 0);
    	      mux_in_one : in  STD_LOGIC_VECTOR(31 downto 0);
    	      mux_in_two : in  STD_LOGIC_VECTOR(31 downto 0);
              sel : in  STD_LOGIC_VECTOR(1 downto 0);
              mux_out : out  STD_LOGIC_VECTOR(31 downto 0));
end MUX_3_x_1;

architecture Behavioral of MUX_3_x_1 is

begin
mux_out <= mux_in_one when sel = "01" else 
           mux_in_zero when sel = "00" else
           mux_in_two when sel = "10";


end Behavioral;

