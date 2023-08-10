----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:54:54 04/04/2022 
-- Design Name: 
-- Module Name:    EXSTAGE - Behavioral 
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

entity EXSTAGE is
    Port ( RF_A : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_B : in  STD_LOGIC_VECTOR (31 downto 0);
           Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           ALU_Bin_sel : in  STD_LOGIC;
           ALU_func : in  STD_LOGIC_VECTOR (3 downto 0);
           ALU_out : out  STD_LOGIC_VECTOR (31 downto 0);
           ALU_zero : out  STD_LOGIC);
end EXSTAGE;

architecture Behavioral of EXSTAGE is

signal mux_output_sig : STD_LOGIC_VECTOR (31 downto 0);

component ALU
	port(    A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           Op : in  STD_LOGIC_VECTOR (3 downto 0);
           Outp : out  STD_LOGIC_VECTOR (31 downto 0);
           Zero : out  STD_LOGIC);
end component;

component MUX2x1
	port(     mux_in_zero : in  STD_LOGIC_VECTOR(31 downto 0);
    	      mux_in_one : in  STD_LOGIC_VECTOR(31 downto 0);
              sel : in  STD_LOGIC;
              mux_out : out  STD_LOGIC_VECTOR(31 downto 0));
end component;

begin

--Immed_32bits <= std_logic_vector(resize(unsigned(Immed), 32)); 

MUX_port : MUX2x1 port map( mux_in_zero => RF_B,
							mux_in_one  => Immed ,
							sel => ALU_Bin_sel,
							mux_out => mux_output_sig);


ALU_port : Alu port map( A => RF_A,
						 B => mux_output_sig,
						 Op => ALU_func,
						 Outp => ALU_out,  --upofetw oti den felw overflow kai cout
						 Zero => ALU_zero);


end Behavioral;

