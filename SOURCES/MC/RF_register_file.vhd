----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:30:53 03/14/2022 
-- Design Name: 
-- Module Name:    RF_register_file - Behavioral 
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
---------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use work.my_matrix.all;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity RF_register_file is
    Port ( Ard1 : in STD_LOGIC_VECTOR(4 downto 0);
    	   Ard2 : in STD_LOGIC_VECTOR(4 downto 0);
           Awr : in  STD_LOGIC_VECTOR(4 downto 0);
           Dout1 : out  STD_LOGIC_VECTOR(31 downto 0);
           Dout2 : out  STD_LOGIC_VECTOR(31 downto 0);
           Din : in  STD_LOGIC_VECTOR(31 downto 0);
           WrEn : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           reset : in STD_LOGIC := '0' );
end RF_register_file;

architecture Behavioral of RF_register_file is

component Register_ex
	port (	CLK, WE , reset: in STD_LOGIC;
		  	Datain         : in STD_LOGIC_VECTOR(31 downto 0);
		  	Dataout        : out STD_LOGIC_VECTOR(31 downto 0) := (others => '0'));
end component;

component Decoder
	port (        	Awr : in STD_LOGIC_VECTOR(4 downto 0);
	      	decoder_out : out STD_LOGIC_VECTOR(31 downto 0));
end component;

component MUX 
	port (	input_mux  :  in MATRIX := (others=> (others=>'0'));
          	sel        :  in STD_LOGIC_VECTOR (4 downto 0);
          	output_mux : out STD_LOGIC_VECTOR (31 downto 0));
end component;

signal decoder_sig : std_logic_vector (31 downto 0) := (others => '0'); 
signal reg_output : MATRIX  := (others=> (others=>'0'));
signal we_sig : std_logic_vector(31 downto 0) := (others=>'0');

begin
	--Register_File: process (Clk)    --pote fes process?   
--begin
decoder_port: Decoder port map (Awr => Awr, decoder_out => decoder_sig);

reg_zero : Register_ex port map (reset => reset,
	                             Datain => Din, 
							     CLK => Clk, 
								 WE => '0', 
								 Dataout => reg_output(0));

Gen_register: for i in 1 to 31 generate 
    we_sig(i) <= decoder_sig(i) AND WrEn after 2 ns;           --ftiaxneis apo prin 
	regx : Register_ex port map
		(   reset => reset,
			Datain => Din, 
			CLK => Clk, 
			WE => we_sig(i), 
			Dataout => reg_output(i));
end generate Gen_register;

--anti gia for generate kane aplo port map gia kafe periptwsh
mux_one: MUX port map (input_mux => reg_output, sel => Ard1, output_mux => Dout1);
mux_two: MUX port map (input_mux => reg_output, sel => Ard2, output_mux => Dout2);

end Behavioral;

