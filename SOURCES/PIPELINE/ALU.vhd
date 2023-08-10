----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:43:15 03/09/2022 
-- Design Name: 
-- Module Name:    ALU - Behavioral 
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

entity ALU is
    --generic ( 
    --       constant N: natural := 1  -- number of shited or rotated bits
    --);

    Port ( A : in  STD_LOGIC_VECTOR (31 downto 0);
           B : in  STD_LOGIC_VECTOR (31 downto 0);
           Op : in  STD_LOGIC_VECTOR (3 downto 0);
           Outp : out  STD_LOGIC_VECTOR (31 downto 0);
           Zero : out  STD_LOGIC;                         --energopoihmenh an to apotelesma einai 0
           Cout : out  STD_LOGIC;                         --energopoihmenh an uphr3e kratoumeno e3odou (carry out) 
           Ovf : out  STD_LOGIC);                         --on an uphr3e overflow
end ALU;

architecture Behavioral of ALU is
--what we need is an "in between SIGNAL which we are going to call out_sig"
signal out_sig: std_logic_vector (31 downto 0);
signal cout_sig: std_logic_vector (32 downto 0);

begin

	Alu_process: process(A, B, Op,out_sig, cout_sig)

begin

	Ovf <= '0';
	Cout <= '0';
	Zero <= '0';

    case Op is
		when "0000" =>                           --ADD
			out_sig <= ( A  +  B) ; 

			if out_sig = x"00000000" then 
				Zero <= '1' after 10 ns;
			end if;
	                                                          --make it 33 bits
			
			cout_sig <= ('0' & A) + ('0' & B);                                            --parse the out_sig to cout sig          

			if (out_sig(31) = '1' AND A(31) = '0' AND B(31) = '0') then        --- if the 31 bit (MSB bit) of out_sig is equal to 1 then Ovf = 1 (ON)
				Ovf <= '1'after 10 ns;
			elsif (out_sig(31) = '0' AND A(31) = '1' AND B(31) = '1') then     --- if the 31 bit (MSB bit) of out_sig is equal to 1 then Ovf = 1 (ON)
				Ovf <= '1' after 10 ns;
			end if;

			if (cout_sig(32) = '1') then    --- if the 32 bit (MSB bit) of cout_sig is equal to 1 then Carry out = 1 (ON)
				Cout <= '1'after 10 ns;
			else
				Cout <= '0'after 10 ns;
			end if;

-----------------------------------------------------------------------------------------------------------------
		when "0001" =>                        --SUB

			out_sig <=  A  -  B ; 

			if out_sig = x"00000000" then 
				Zero <= '1' after 10 ns;
			end if;                                 --make it 33 bits
			
			cout_sig <= ('0' & A) - ('0' & B);                                             --parse the out_sig to cout sig 
                                 
            if (out_sig(31) = B(31)) then 
                Ovf <= '1'after 10 ns;                                     --Overflow occurs if
			--if (A(31) /= B(31) AND A > B AND out_sig(31) = '1') then                     --(+A) − (−B) = −C
			--	Ovf <= '1'after 10 ns; 
			--elsif (A(31) /= B(31) AND B > A AND out_sig(31) = '0') then                  --(−A) − (+B) = +C                                                                  
       		--	Ovf <= '1'after 10 ns;  
     		end if;

			if (cout_sig(32) = '1') then Cout <= '1' after 10 ns;   --- if the 32 bit (MSB bit) of cout_sig is equal to 1 then Carry out = 1 (ON)
			end if;
-----------------------------------------------------------------------------------------------------------------

	    when "0010" =>                        --logic and
			out_sig <= A AND B after 10 ns;
			if out_sig = x"00000000" then 
				Zero <= '1' after 10 ns;
			end if;

	    when "0011" =>                        --logic or
			out_sig <= A OR B after 10 ns;
			if out_sig = x"00000000" then 
				Zero <= '1' after 10 ns;
			end if;

	    when "0100" =>                        --anastrofh
			out_sig <= not A after 10 ns;
			if out_sig = x"00000000" then 
				Zero <= '1' after 10 ns;
			end if;

	    when "0101" =>                        --logic nand
			out_sig <= A NAND B after 10 ns;
			if out_sig = x"00000000" then 
				Zero <= '1' after 10 ns;
			end if;

		when "0110" =>                        --logic nor
			out_sig <= A NOR B after 10 ns;
			if out_sig = x"00000000" then 
				Zero <= '1' after 10 ns;
			end if;

		when "1000" =>                        --arithmetical shift right 
			out_sig <= std_logic_vector(shift_right(signed(A),1)) after 10 ns;	   --here if we move the bits MSB STAYS THE SAME 
			if out_sig = x"00000000" then 
				Zero <= '1' after 10 ns;
			end if;

		when "1001" =>                        --logic shift right
			out_sig <= std_logic_vector(shift_right(unsigned(A),1)) after 10ns ;
			if out_sig = x"00000000" then 
				Zero <= '1' after 10 ns;
			end if;

		when "1010" =>                        --logic shift left
			out_sig <= std_logic_vector(shift_left(unsigned(A),1)) after 10 ns;
			if out_sig = x"00000000" then 
				Zero <= '1' after 10 ns;
			end if;

		when "1100" =>                        --rotate left
			out_sig <= std_logic_vector(signed(A) rol 1) after 10 ns;
			if out_sig = x"00000000" then 
				Zero <= '1' after 10 ns;
			end if;

		when "1101" =>                        --rotate right
			out_sig <= std_logic_vector(signed(A) ror 1) after 10 ns;
			if out_sig = x"00000000" then 
				Zero <= '1' after 10 ns;
			end if;

	   when others => out_sig<= x"00000000";
                      Zero <= '1' after 10 ns;
		
	end case ;
	
	Outp <= out_sig ;

end process;

end Behavioral;

