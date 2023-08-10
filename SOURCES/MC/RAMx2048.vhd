----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:28:51 03/22/2022 
-- Design Name: 
-- Module Name:    RAMx2048 - Behavioral 
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
use std.textio.all; 
use ieee.std_logic_textio.all;
use  ieee.numeric_std.all;



-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RAMx2048 is
    Port ( clk : in  STD_LOGIC;
           inst_addr : in  STD_LOGIC_VECTOR(10 downto 0);
           inst_dout : out  STD_LOGIC_VECTOR(31 downto 0);
           data_we : in  STD_LOGIC;                               --flag
           data_addr : in  STD_LOGIC_VECTOR(10 downto 0);
           data_din : in  STD_LOGIC_VECTOR(31 downto 0);
           data_dout : out  STD_LOGIC_VECTOR(31 downto 0));
end RAMx2048;

architecture syn of RAMx2048 is

	type ram_type is array (2047 downto 0) of std_logic_vector (31 downto 0);

    impure 
    function InitRamFromFile (RamFileName : in string ) return ram_type is 
	FILE ramfile : text is in RamFileName;
	variable RamFileLine : line;
	variable ram : ram_type;
	begin
		for i in 0 to 1023 loop 
			readline(ramfile, RamFileLine);
			read (RamFileLine, ram(i));
		end loop;

		for i in 1024 to 2047 loop
			ram(i) := x"00000000";
		end loop;
	return ram;
	end function;

	signal RAMx2048 : ram_type := InitRamFromFile("rom.data");

	begin
		process (clk, data_addr, data_din)
	    begin
			if clk'event and clk = '1' then 
				if data_we = '1' then
					RAMx2048(conv_integer(data_addr)) <= data_din;
				end if;
			end if;


        end process;

		data_dout <= RAMx2048(conv_integer(data_addr)) after 12ns ; 
		inst_dout <= RAMx2048(conv_integer(inst_addr)) after 12ns ;

end syn;

