----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:31:43 03/22/2022 
-- Design Name: 
-- Module Name:    IFSTAGE - Behavioral 
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
--use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IFSTAGE is
    Port ( PC_Immed : in  STD_LOGIC_VECTOR (31 downto 0);
           PC_sel : in  STD_LOGIC;
           PC_LdEn : in  STD_LOGIC;
           Reset : in  STD_LOGIC := '0';
           Clk : in  STD_LOGIC;
           PC : out  STD_LOGIC_VECTOR (31 downto 0));
end IFSTAGE;

architecture Behavioral of IFSTAGE is

signal pc_plus4_signal : STD_LOGIC_VECTOR (31 downto 0);   --in between signal for PC(otherwise I get an error)
signal pc_plusEx_signal : STD_LOGIC_VECTOR (31 downto 0);
signal mux_output_signal : STD_LOGIC_VECTOR (31 downto 0) ;                --signal of mux2x1 output
signal current_PC : STD_LOGIC_VECTOR (31 downto 0) ;   --cause PC is out we are going to use a signal to represent it
signal sign_extend_signal : STD_LOGIC_VECTOR (31 downto 0);

component Register_ex 
	port(    CLK : in  STD_LOGIC;
           Reset : in  STD_LOGIC :='0';
           Datain : in  STD_LOGIC_VECTOR(31 downto 0);
           WE : in  STD_LOGIC ;
           Dataout : out  STD_LOGIC_VECTOR(31 downto 0) ) ;
end component;

component MUX2x1
	port(  mux_in_zero : in  STD_LOGIC_VECTOR(31 downto 0);
    	   mux_in_one : in  STD_LOGIC_VECTOR(31 downto 0);
         sel : in  STD_LOGIC;
         mux_out : out  STD_LOGIC_VECTOR(31 downto 0));
end component;

begin

   PC <= current_PC;
  
   pc_plus4_signal <= current_pc + 4;             -- PC+4
    
   --with PC_Immed(0) select 
   sign_extend_signal <=  PC_Immed(29 downto 0) & "00"; --when '0';--std_logic_vector(shift_left(signed(PC_Immed),2));
                          --PC_Immed(27 downto 0) & "1111" when '1',
                         --(others => 'X') when others;
		  
	pc_plusEx_signal <= pc_plus4_signal + sign_extend_signal;    -- (PC+4) + SignExt(Immed)*4

	MUX2x1_mux : MUX2x1 port map(     mux_in_zero => pc_plus4_signal,
									                  mux_in_one => pc_plusEx_signal,
									                  sel => PC_sel,
									                  mux_out => mux_output_signal);

  Register_ex_port : Register_ex port map(	    CLK => Clk,
					  								                    Reset => Reset,
					  								                    Datain => mux_output_signal,
					  							                      WE => PC_LdEn,
				  								                      Dataout => current_PC); 
   
end Behavioral;
 