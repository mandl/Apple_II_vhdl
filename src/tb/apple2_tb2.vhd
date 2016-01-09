-- TestBench Template 

  LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

  ENTITY apple2_papilio_tb IS
  END apple2_papilio_tb;

  ARCHITECTURE behavior OF apple2_papilio_tb IS 

  -- Component Declaration
  COMPONENT apple2_papilio
         

    port (
    -- Clocks
    CLK : in std_logic;                            -- 32 MHz
	 
	 RESET_I : in std_logic;                        -- reset positiv
	
   
    -- SRAM
    SRAM_DQ : inout unsigned(7 downto 0);          -- Data bus 8 Bits
    SRAM_ADDR : out unsigned(20 downto 0);         -- Address bus 21 Bits
    SRAM_WE_N,                                     -- Write Enable
    SRAM_CE_N,                                     -- Chip Enable
    SRAM_OE_N : out std_logic;                     -- Output Enable

    -- SD card interface
    
    SD_DAT : in std_logic;      -- SD Card Data      SD pin 7 "DAT 0/DataOut"
    SD_DAT3 : out std_logic;    -- SD Card Data 3    SD pin 1 "DAT 3/nCS"
    SD_CMD : out std_logic;     -- SD Card Command   SD pin 2 "CMD/DataIn"
    SD_CLK : out std_logic;     -- SD Card Clock     SD pin 5 "CLK"
 
    -- Led
	 LED : out std_logic_vector(3 downto 0);
	 
    -- PS/2 port
    PS2_DAT,                    -- Data
    PS2_CLK : inout std_logic;     -- Clock
	 
	 O_AUDIO_L : out std_logic;  -- Audio out
	 O_AUDIO_R : out std_logic;  -- Ausdio out

    -- VGA output
    VGA_HS,                                             -- H_SYNC
    VGA_VS  : out std_logic;                            -- V_SYNC
  
	 VGA_R,                                              -- Red[3:0]
    VGA_G,                                              -- Green[3:0]
    VGA_B : out unsigned(3 downto 0)                    -- Blue[3:0]
   
    );
    END COMPONENT;
	 
	 
	 signal CLK_32M : std_logic; 
	
	 
	 signal RESET_I : std_logic := '0';        -- reset positiv
	
   
    -- SRAM
    signal SRAM_DQ : unsigned(7 downto 0);    -- Data bus 8 Bits
    signal SRAM_ADDR : unsigned(20 downto 0); -- Address bus 21 Bits
    signal SRAM_WE_N,                         -- Write Enable
    SRAM_CE_N,                                -- Chip Enable
    SRAM_OE_N : std_logic;                    -- Output Enable

    -- SD card interface
    
    signal SD_DAT : std_logic;      -- SD Card Data      SD pin 7 "DAT 0/DataOut"
    signal SD_DAT3 : std_logic;    -- SD Card Data 3    SD pin 1 "DAT 3/nCS"
    signal SD_CMD : std_logic;     -- SD Card Command   SD pin 2 "CMD/DataIn"
    signal SD_CLK : std_logic;     -- SD Card Clock     SD pin 5 "CLK"
 
    -- Led
	 signal LED : std_logic_vector(3 downto 0);
	 
    -- PS/2 port
    signal PS2_DAT,                    -- Data
     PS2_CLK : std_logic;     -- Clock
	 
	 signal O_AUDIO_L : std_logic;  -- Audio out
	 signal O_AUDIO_R : std_logic;  -- Ausdio out

    -- VGA output
    signal VGA_HS,                                             -- H_SYNC
    VGA_VS  : std_logic;                            -- V_SYNC
  
	 signal VGA_R,                                              -- Red[3:0]
    VGA_G,                                              -- Green[3:0]
    VGA_B : unsigned(3 downto 0);                    -- Blue[3:0]

      -- Clock period definitions
   constant CLK_32M_period : time := 32.25 ns;    

  BEGIN

  -- Component Instantiation
   uut:apple2_papilio PORT MAP(
   					
    -- Clocks
    CLK      => CLK_32M,      -- 32 MHz
	 RESET_I  => RESET_I,  -- reset positiv
	  
    -- SRAM
    SRAM_DQ   => SRAM_DQ,         -- Data bus 8 Bits
    SRAM_ADDR => SRAM_ADDR,       -- Address bus 21 Bits
    SRAM_WE_N => SRAM_WE_N,       -- Write Enable
    SRAM_CE_N => SRAM_CE_N,       -- Chip Enable
    SRAM_OE_N => SRAM_OE_N,       -- Output Enable

    -- SD card interface
    
    SD_DAT    => SD_DAT,         -- SD Card Data      SD pin 7 "DAT 0/DataOut"
    SD_DAT3   => SD_DAT3,        -- SD Card Data 3    SD pin 1 "DAT 3/nCS"
    SD_CMD    => SD_CMD,         -- SD Card Command   SD pin 2 "CMD/DataIn"
    SD_CLK    => SD_CLK,         -- SD Card Clock     SD pin 5 "CLK"
 
    -- Led
	 LED       => LED,
	 
    -- PS/2 port
    PS2_DAT   => PS2_DAT,
    PS2_CLK   => PS2_CLK,
	 
	 O_AUDIO_L => O_AUDIO_L,
	 O_AUDIO_R => O_AUDIO_R,

    -- VGA output
    VGA_HS  => VGA_HS,
    VGA_VS  => VGA_VS,
  
	 VGA_R   => VGA_R,
    VGA_G   => VGA_G,                                           -- Green[3:0]
    VGA_B   => VGA_B
    );
			 
 -- Clock process definitions
   CLK_32M_process :process
   begin
		CLK_32M <= '0';
		wait for CLK_32M_period/2;
		CLK_32M <= '1';
		wait for CLK_32M_period/2;
   end process;

  --  Test Bench Statements
     tb : PROCESS
     BEGIN

        wait for 100 ns; -- wait until global set/reset completes

        -- Add user defined stimulus here

        wait; -- will wait forever
     END PROCESS tb;
  --  End Test Bench 

  END;
