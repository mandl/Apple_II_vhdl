--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   21:41:31 01/06/2016
-- Design Name:   
-- Module Name:   /home/mandl/Entwicklung/Apple2/timing_tb2.vhd
-- Project Name:  Apple2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: timing_generator
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
use ieee.numeric_std.all; 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY timing_tb2 IS
END timing_tb2;
 
ARCHITECTURE behavior OF timing_tb2 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT timing_generator
    PORT(
         CLK_14M : IN  std_logic;
         CLK_7M_out : OUT  std_logic;
         Q3_out : OUT  std_logic;
         RAS_N_out : OUT  std_logic;
         CAS_N_out : OUT  std_logic;
         AX_out : OUT  std_logic;
         PHI0_out : OUT  std_logic;
         PRE_PHI0_out : OUT  std_logic;
         COLOR_REF_out : OUT  std_logic;
         TEXT_MODE : IN  std_logic;
         PAGE2 : IN  std_logic;
         HIRES : IN  std_logic;
         VIDEO_ADDRESS : OUT  unsigned(15 downto 0);
         H0 : OUT  std_logic;
         VA : OUT  std_logic;
         VB : OUT  std_logic;
         VC : OUT  std_logic;
         V2 : OUT  std_logic;
         V4 : OUT  std_logic;
         HBL_out : OUT  std_logic;
         VBL_out : OUT  std_logic;
         BLANK : OUT  std_logic;
         LDPS_N : OUT  std_logic;
         LD194 : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK_14M : std_logic := '0';
   signal TEXT_MODE : std_logic := '0';
   signal PAGE2 : std_logic := '0';
   signal HIRES : std_logic := '0';

 	--Outputs
   signal CLK_7M_out : std_logic;
   signal Q3_out : std_logic;
   signal RAS_N_out : std_logic;
   signal CAS_N_out : std_logic;
   signal AX_out : std_logic;
   signal PHI0_out : std_logic;
   signal PRE_PHI0_out : std_logic;
   signal COLOR_REF_out : std_logic;
   signal VIDEO_ADDRESS : std_logic_vector(15 downto 0);
   signal H0 : std_logic;
   signal VA : std_logic;
   signal VB : std_logic;
   signal VC : std_logic;
   signal V2 : std_logic;
   signal V4 : std_logic;
   signal HBL_out : std_logic;
   signal VBL_out : std_logic;
   signal BLANK : std_logic;
   signal LDPS_N : std_logic;
   signal LD194 : std_logic;

   -- Clock period definitions
   constant CLK_14M_period : time := 71.42 ns;
  
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: timing_generator PORT MAP (
          CLK_14M => CLK_14M,
          CLK_7M_out => CLK_7M_out,
          Q3_out => Q3_out,
          RAS_N_out => RAS_N_out,
          CAS_N_out => CAS_N_out,
          AX_out => AX_out,
          PHI0_out => PHI0_out,
          PRE_PHI0_out => PRE_PHI0_out,
          COLOR_REF_out => COLOR_REF_out,
          TEXT_MODE => TEXT_MODE,
          PAGE2 => PAGE2,
          HIRES => HIRES,
          std_logic_vector(VIDEO_ADDRESS) => VIDEO_ADDRESS,
          H0 => H0,
          VA => VA,
          VB => VB,
          VC => VC,
          V2 => V2,
          V4 => V4,
          HBL_out => HBL_out,
          VBL_out => VBL_out,
          BLANK => BLANK,
          LDPS_N => LDPS_N,
          LD194 => LD194
        );

   -- Clock process definitions
   CLK_14M_process :process
   begin
		CLK_14M <= '0';
		wait for CLK_14M_period/2;
		CLK_14M <= '1';
		wait for CLK_14M_period/2;
   end process;
 
   
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLK_14M_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
