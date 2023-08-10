----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:02:15 03/16/2022 
-- Design Name: 
-- Module Name:    Decoder - Behavioral 
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

entity Decoder is
    Port ( Awr : in  STD_LOGIC_VECTOR(4 downto 0);
           decoder_out : out  STD_LOGIC_VECTOR(31 downto 0));
end Decoder;

architecture Behavioral of Decoder is

begin

	decoder_proc: process(Awr)

begin

if    (Awr = "00000") then --output 32bit input 5 bit 
	decoder_out  <= "00000000000000000000000000000001" after 10 ns;
elsif (Awr = "00001") then --output 32bit input 5 bit 
	decoder_out  <= "00000000000000000000000000000010" after 10 ns;
elsif (Awr = "00010") then
	decoder_out  <= "00000000000000000000000000000100" after 10 ns;
elsif (Awr = "00011") then
	decoder_out  <= "00000000000000000000000000001000" after 10 ns;
elsif (Awr = "00100") then
	decoder_out  <= "00000000000000000000000000010000" after 10 ns;
elsif (Awr = "00101") then
	decoder_out  <= "00000000000000000000000000100000" after 10 ns;
elsif (Awr = "00110") then
	decoder_out  <= "00000000000000000000000001000000" after 10 ns;
elsif (Awr = "00111") then
	decoder_out  <= "00000000000000000000000010000000" after 10 ns;
elsif (Awr = "01000") then
	decoder_out  <= "00000000000000000000000100000000" after 10 ns;
elsif (Awr = "01001") then
	decoder_out  <= "00000000000000000000001000000000" after 10 ns;
elsif (Awr = "01010") then
	decoder_out  <= "00000000000000000000010000000000" after 10 ns;
elsif (Awr = "01011") then
	decoder_out  <= "00000000000000000000100000000000" after 10 ns;
elsif (Awr = "01100") then
	decoder_out  <= "00000000000000000001000000000000" after 10 ns;
elsif (Awr = "01101") then
	decoder_out  <= "00000000000000000010000000000000" after 10 ns;
elsif (Awr = "01110") then
	decoder_out  <= "00000000000000000100000000000000" after 10 ns;
elsif (Awr = "01111") then
	decoder_out  <= "00000000000000001000000000000000" after 10 ns;
elsif (Awr = "10000") then
	decoder_out  <= "00000000000000010000000000000000" after 10 ns;
elsif (Awr = "10001") then
	decoder_out  <= "00000000000000100000000000000000" after 10 ns;
elsif (Awr = "10010") then
	decoder_out  <= "00000000000001000000000000000000" after 10 ns;
elsif (Awr = "10011") then
	decoder_out  <= "00000000000010000000000000000000" after 10 ns;
elsif (Awr = "10100") then
	decoder_out  <= "00000000000100000000000000000000" after 10 ns;
elsif (Awr = "10101") then
	decoder_out  <= "00000000001000000000000000000000" after 10 ns;
elsif (Awr = "10110") then
	decoder_out  <= "00000000010000000000000000000000" after 10 ns;
elsif (Awr = "10111") then
	decoder_out  <= "00000000100000000000000000000000" after 10 ns;
elsif (Awr = "11000") then
	decoder_out  <= "00000001000000000000000000000000" after 10 ns;
elsif (Awr = "11001") then
	decoder_out  <= "00000010000000000000000000000000" after 10 ns;
elsif (Awr = "11010") then
	decoder_out  <= "00000100000000000000000000000000" after 10 ns;
elsif (Awr = "11011") then
	decoder_out  <= "00001000000000000000000000000000" after 10 ns;
elsif (Awr = "11100") then
	decoder_out  <= "00010000000000000000000000000000" after 10 ns;
elsif (Awr = "11101") then
	decoder_out  <= "00100000000000000000000000000000" after 10 ns;
elsif (Awr = "11110") then
	decoder_out  <= "01000000000000000000000000000000" after 10 ns;
elsif (Awr = "11111") then
	decoder_out  <= "10000000000000000000000000000000" after 10 ns;
end if;

end process;

end Behavioral;

