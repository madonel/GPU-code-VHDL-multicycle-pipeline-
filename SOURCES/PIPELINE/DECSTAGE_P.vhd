----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:03:07 05/23/2022 
-- Design Name: 
-- Module Name:    DECSTAGE_P - Behavioral 
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

entity DECSTAGE_P is
    Port (  WriteReg : in STD_LOGIC_VECTOR(4 downto 0);
    	    Instr : in  STD_LOGIC_VECTOR (31 downto 0);
            WrEn : in  STD_LOGIC;
           ALU_out : in  STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
           MEM_out : in  STD_LOGIC_VECTOR (31 downto 0);
           RF_WrData_sel : in  STD_LOGIC;
           RF_B_sel : in  STD_LOGIC;
           ImmExt : in  STD_LOGIC_VECTOR (1 downto 0);
           Clk : in  STD_LOGIC;
           Immed : out  STD_LOGIC_VECTOR (31 downto 0);
           RF_A : out  STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
           RF_B : out  STD_LOGIC_VECTOR (31 downto 0) := (others => '0');
           Rst : in  STD_LOGIC := '0');
end DECSTAGE_P;

architecture Behavioral of DECSTAGE_P is

signal mux_out_first_32_bit : STD_LOGIC_VECTOR(31 downto 0);
signal mux_out_second : STD_LOGIC_VECTOR(31 downto 0);
signal instr_two : STD_LOGIC_VECTOR(31 downto 0);
signal instr_three : STD_LOGIC_VECTOR(31 downto 0);
signal sign_sig : STD_LOGIC_VECTOR(15 downto 0);

component MUX2x1
  port(     mux_in_zero : in  STD_LOGIC_VECTOR(31 downto 0);
            mux_in_one : in  STD_LOGIC_VECTOR(31 downto 0);
            sel : in  STD_LOGIC;
            mux_out : out  STD_LOGIC_VECTOR(31 downto 0));
end component;

component RF_register_file
  port(     Ard1 : in STD_LOGIC_VECTOR(4 downto 0);  --dieufhnsh 1ou register
            Ard2 : in STD_LOGIC_VECTOR(4 downto 0);  --dieufhnsh 2ou register
            Awr : in  STD_LOGIC_VECTOR(4 downto 0); --dieufhnsh kataxwrhth gia eggrafh
            Dout1 : out  STD_LOGIC_VECTOR(31 downto 0);
            Dout2 : out  STD_LOGIC_VECTOR(31 downto 0);
            Din : in  STD_LOGIC_VECTOR(31 downto 0);  --dedomena gia eggrafh
            WrEn : in  STD_LOGIC;
            Clk : in  STD_LOGIC;
            reset : in STD_LOGIC := '0');
end component;

begin

--zero filling
instr_two   <=  "000000000000000000000000000" &  Instr(15 downto 11);-- std_logic_vector(resize(unsigned(one_5bit), 32));
instr_three <=  "000000000000000000000000000" & Instr(20 downto 16);

--We need to check for the opcode
--cloud : Cloud_for_DECSTAGE port map (Opcode    => ImmExt,
--                                     In_cloud  => Instr(15 downto 0),
--                                     Out_cloud => Immed);
  
mux_one: MUX2x1 port map(     mux_in_zero => instr_two,  --mux2x1 takes as input 32 bits so we have to turn it into a 32 bit num
                              mux_in_one  => instr_three,  --same above
                              sel         => RF_B_sel,
                              mux_out     => mux_out_first_32_bit);

mux_two: MUX2x1 port map(     mux_in_zero => ALU_out,
                              mux_in_one  => MEM_out,
                              sel         => RF_WrData_sel,
                              mux_out     => mux_out_second);

register_file_Rf: RF_register_file port map(  Ard1  => Instr(25 downto 21),   --5 bits so its okay
                                              Ard2  => mux_out_first_32_bit(4 downto 0),        --5 bits each side so its okay 
                                              Awr   => WriteReg,   --dieufhnsh kataxwrhth gia eggrafh  (EINAI TO TRITO KALWDIO THS Instr)
                                              Dout1 => RF_A,
                                              Dout2 => RF_B,
                                              Din   => mux_out_second,        --dedomena gia eggrafh
                                              WrEn  => WrEn,
                                              Clk   => Clk,
                                              reset => Rst);

with Instr(15) select 
sign_sig <= x"FFFF" when '1',
            x"0000" when '0',
            x"0000" when others;

with ImmExt select
Immed <= x"0000" & Instr(15 downto 0) when "00",
         sign_sig & Instr(15 downto 0) when "01",
         Instr(15 downto 0) & x"0000" when "10",
         Instr(15 downto 0) & sign_sig when "11",
          Instr(15 downto 0) & x"0000" when others;


end Behavioral;

