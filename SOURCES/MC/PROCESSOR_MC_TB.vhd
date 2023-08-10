--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   08:32:41 05/17/2022
-- Design Name:   
-- Module Name:   C:/Users/eleot/ORGANWSH VHDL PROJECT/PROJECT/PROCESSOR_MC_TB.vhd
-- Project Name:  PROJECT
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PROCESSOR_MULTICYCLE
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY PROCESSOR_MC_TB IS
END PROCESSOR_MC_TB;
 
ARCHITECTURE behavior OF PROCESSOR_MC_TB IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PROCESSOR_MULTICYCLE
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         instr : IN  std_logic_vector(31 downto 0);
         MM_RdData : IN  std_logic_vector(31 downto 0);
         pc : OUT  std_logic_vector(31 downto 0);
         MM_Addr : OUT  std_logic_vector(31 downto 0);
         MM_WrData : OUT  std_logic_vector(31 downto 0);
         MM_WrEn : OUT  std_logic
        );
    END COMPONENT;

    component RAMx2048 
    port(
          clk : in  STD_LOGIC;
          inst_addr : in  STD_LOGIC_VECTOR(10 downto 0);
          inst_dout : out  STD_LOGIC_VECTOR(31 downto 0);
          data_we : in  STD_LOGIC;                               --flag
          data_addr : in  STD_LOGIC_VECTOR(10 downto 0);
          data_din : in  STD_LOGIC_VECTOR(31 downto 0);
          data_dout : out  STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal instr : std_logic_vector(31 downto 0) := (others => '0');
   signal MM_RdData : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal pc : std_logic_vector(31 downto 0);
   signal MM_Addr : std_logic_vector(31 downto 0);
   signal MM_WrData : std_logic_vector(31 downto 0);
   signal MM_WrEn : std_logic;

   -- Clock period definitions
   constant clk_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PROCESSOR_MULTICYCLE PORT MAP (
          clk => clk,
          rst => rst,
          instr => instr,
          MM_RdData => MM_RdData,
          pc => pc,
          MM_Addr => MM_Addr,
          MM_WrData => MM_WrData,
          MM_WrEn => MM_WrEn
        );

   mem: RAMx2048 port map(
          clk => clk,
          inst_addr => pc(12 downto 2),
          inst_dout => instr,
          data_we => MM_WrEn,                      --flag
          data_addr => MM_Addr(12 downto 2),
          data_din => MM_WrData,
          data_dout => MM_RdData
    );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
     rst <= '0';

      wait;
   end process;

END;
