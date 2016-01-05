-------------------------------------------------------------------------------
--
-- DE2 top-level module for the Apple ][
--
-- Stephen A. Edwards, Columbia University, sedwards@cs.columbia.edu
--
-- From an original by Terasic Technology, Inc.
-- (DE2_TOP.v, part of the DE2 system board CD supplied by Altera)
--
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity apple2_papilio is

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
  
end apple2_papilio;

architecture datapath of apple2_papilio is
  
    signal cpuDebugDim : std_logic;   -- CPU Debug
    signal cpuDebug :    std_logic;   -- CPU Debug
	 
	 signal diskDebugDim : std_logic;   -- disk Debug
    signal diskDebug :    std_logic;   -- disk Debug
	 
	 signal debug_info_on : std_logic;  -- switch debug info screen on / off
    
	 signal VGAR,                                   -- Red[9:0]
    VGAG,                                          -- Green[9:0]
    VGAB : unsigned(9 downto 0);                   -- Blue[9:0]
	 
	 signal VGAHS,                                  -- H_SYNC
    VGAVS  : std_logic;                            -- V_SYNC
	 
   
	signal audio : std_logic;   -- audio
	
    -- LED displays
   signal LEDG : std_logic_vector(8 downto 0);       -- Green LEDs
  	
	  -- Buttons and switches
   signal KEY :  std_logic_vector(3 downto 0);         -- Push buttons
  	
  signal CLK_28M, CLK_14M, CLK_2M, PRE_PHASE_ZERO : std_logic;
  signal IO_SELECT, DEVICE_SELECT : std_logic_vector(7 downto 0);
  signal ADDR : unsigned(15 downto 0);
  signal D, PD : unsigned(7 downto 0);

  signal ram_we : std_logic;
  signal VIDEO, HBL, VBL, LD194 : std_logic;
  signal COLOR_LINE : std_logic;
  signal COLOR_LINE_CONTROL : std_logic;
  signal GAMEPORT : std_logic_vector(7 downto 0);
  signal cpu_pc : unsigned(15 downto 0);
  signal cpuDebugOpcode : unsigned(7 downto 0);
  signal	cpuDebugPc : unsigned(15 downto 0);
  signal	cpuDebugA : unsigned(7 downto 0);
  signal	cpuDebugX : unsigned(7 downto 0);
  signal	cpuDebugY : unsigned(7 downto 0);
  signal	cpuDebugS : unsigned(7 downto 0);

  signal K : unsigned(7 downto 0);
  signal read_key : std_logic;

  signal flash_clk : unsigned(22 downto 0) := (others => '0');
  signal power_on_reset : std_logic := '1';
  signal reset : std_logic;
  signal reset_n : std_logic;

  signal speaker : std_logic;

  signal track : unsigned(5 downto 0);
  signal image : unsigned(9 downto 0);
  signal trackmsb : unsigned(3 downto 0);
  signal D1_ACTIVE, D2_ACTIVE : std_logic;
  signal track_addr : unsigned(13 downto 0);
  signal TRACK_RAM_ADDR : unsigned(13 downto 0);
  signal tra : unsigned(15 downto 0);
  signal TRACK_RAM_DI : unsigned(7 downto 0);
  signal TRACK_RAM_WE : std_logic;

  signal CS_N, MOSI, MISO, SCLK : std_logic;
  
  signal de_RESET_I : std_logic;
  signal color_bw : std_logic;

begin

  --reset <= (not KEY(3)) or power_on_reset;
   reset <= power_on_reset or de_RESET_I;
	reset_n <= not power_on_reset;
	
  

  power_on : process(CLK_14M)
  begin
    if rising_edge(CLK_14M) then
      if flash_clk(22) = '1' then
        power_on_reset <= '0';
      end if;
    end if;
  end process;

  -- In the Apple ][, this was a 555 timer
  flash_clkgen : process (CLK_14M)
  begin
    if rising_edge(CLK_14M) then
      flash_clk <= flash_clk + 1;
		
    end if;     
  end process;

  -- Use a PLL to divide the 50 MHz down to 28 MHz and 14 MHz
  pll : entity work.clock port map (
    CLK_IN_32  => CLK,
    CLK_28     => CLK_28M,
    CLK_14     => CLK_14M,
	 RESET  => '0',
	 LOCKED  =>open
	 
    );
	 
	inst_debouncer : entity work.grp_debouncer 
	
	generic map (
	
	     N  => 1,
        CNT_VAL  => 10000                                        
		
		)
	port map (
	
	clk_i  => CLK_28M,
   data_i(0) => RESET_I,
   data_o(0) => de_RESET_I,
   strb_o => open  
	
	);

  -- Paddle buttons
  GAMEPORT <=  "0000" & (not KEY(2 downto 0)) & "0";

  COLOR_LINE_CONTROL <= COLOR_LINE and color_bw;  -- Color or B&W mode
  
  core : entity work.apple2 
  
  generic map (
       
       use_monitor_rom  => false,
       use_auto_rom     => true
       )
		 
  port map (
    CLK_14M        => CLK_14M,
    CLK_2M         => CLK_2M,
    PRE_PHASE_ZERO => PRE_PHASE_ZERO,
    FLASH_CLK      => flash_clk(22),
    reset          => reset,
    ADDR           => ADDR,
    ram_addr       => SRAM_ADDR(15 downto 0),
    D              => D,
    ram_do         => SRAM_DQ(7 downto 0),
    PD             => PD,
    ram_we         => ram_we,
    VIDEO          => VIDEO,
    COLOR_LINE     => COLOR_LINE,
    HBL            => HBL,
    VBL            => VBL,
    LD194          => LD194,
    K              => K,
    read_key       => read_key,
    AN             => LEDG(7 downto 4),
    GAMEPORT       => GAMEPORT,
    IO_SELECT      => IO_SELECT,
    DEVICE_SELECT  => DEVICE_SELECT,
    debugPc        => cpuDebugPc,
	 debugOpcode    => cpuDebugOpcode,
	 debugA         => cpuDebugA,
	 debugX         => cpuDebugX,
	 debugY         => cpuDebugY,
	 debugS         => cpuDebugS,
    speaker        => speaker
    );

  vga : entity work.vga_controller port map (
    CLK_28M    => CLK_28M,
    VIDEO      => VIDEO,
    COLOR_LINE => COLOR_LINE_CONTROL,
    HBL        => HBL,
    VBL        => VBL,
    LD194      => LD194,
    --VGA_CLK    => open,
    VGA_HS     => VGAHS,
    VGA_VS     => VGAVS,
    --VGA_BLANK  => open,
    VGA_R => VGAR,
    VGA_G => VGAG,
    VGA_B => VGAB
    );
	 
  hexyInstance : entity work.cpu_hexy
		generic map (
			xoffset => 200,
			yoffset => 60
		)
		port map (
			clk   =>  CLK_28M,
			vSync => VGAVS,
			hSync => VGAHS,
			video => cpuDebug,  
			dim   => cpuDebugDim,  -- 1 if aktiv
			
			spyAddr => ADDR,
			spyPc   => cpuDebugPc,
			spyDo   => D,
			
			spyOpcode => cpuDebugOpcode,
			spyA => cpuDebugA,
			spyX => cpuDebugX,
			spyY => cpuDebugY,
			spyS => cpuDebugS
		);	
		
	  disk_hexyInstance : entity work.disk_disp
		generic map (
			xoffset => 200,
			yoffset => 70
		)
		port map (
			clk   =>  CLK_28M,
			vSync => VGAVS,
			hSync => VGAHS,
			video => diskDebug,  
			dim   => diskDebugDim,  -- 1 if aktiv
			
			track  =>  track,
         image  =>  image,
         trackmsb => trackmsb		
			
			
		);	


  process(CLK_28M)
	begin
		if rising_edge(CLK_28M) then
			 VGA_R <= VGAR( 9 downto 6);
          VGA_G <= VGAG( 9 downto 6);
          VGA_B <= VGAB( 9 downto 6); 
			 
			if debug_info_on = '1' then
				
				if cpuDebugDim = '1' then
					VGA_R <= cpuDebug & vgaR(8 downto 6);
					VGA_G <= cpuDebug & vgaG(8 downto 6);
					VGA_B <= cpuDebug & vgaB(8 downto 6);
				end if;
				
					if diskDebugDim = '1' then
					VGA_R <= diskDebug & vgaR(8 downto 6);
					VGA_G <= diskDebug & vgaG(8 downto 6);
					VGA_B <= diskDebug & vgaB(8 downto 6);
				end if;
		   end if;	
        			
		end if;
	end process;		

 
  
  VGA_VS <= VGAVS;
  VGA_HS <= VGAHS;

  keyboard : entity work.keyboard_apple
  port map (
    PS2_Clk       => PS2_CLK,
    PS2_Data      => PS2_DAT,
    CLK_14M       => CLK_14M,
    reset         => reset,
    read          => read_key,
	 image_out     => image,
	 debug_info_on => debug_info_on,
    K             => K,
	 out_color_bw  => color_bw
    );

  disk : entity work.disk_ii port map (
    CLK_14M        => CLK_14M,
    CLK_2M         => CLK_2M,
    PRE_PHASE_ZERO => PRE_PHASE_ZERO,
    IO_SELECT      => IO_SELECT(6),
    DEVICE_SELECT  => DEVICE_SELECT(6),
    RESET          => reset,
    A              => ADDR,
    D_IN           => D,
    D_OUT          => PD,
    TRACK          => TRACK,
    TRACK_ADDR     => TRACK_ADDR,
    D1_ACTIVE      => D1_ACTIVE,
    D2_ACTIVE      => D2_ACTIVE,
    ram_write_addr => TRACK_RAM_ADDR,
    ram_di         => TRACK_RAM_DI,
    ram_we         => TRACK_RAM_WE
    );

  sdcard_interface : entity work.spi_controller port map (
    CLK_14M        => CLK_14M,
    RESET          => RESET,

    CS_N           => CS_N,
    MOSI           => MOSI,
    MISO           => MISO,
    SCLK           => SCLK,
    
    track          => TRACK,
    image          => image,
    
    ram_write_addr => TRACK_RAM_ADDR,
    ram_di         => TRACK_RAM_DI,
    ram_we         => TRACK_RAM_WE
    );
	 
	 
	 inst_dac : entity work.dac port map (

    clk_i   => CLK_28M,
    res_n_i => reset_n,
    dac_i   => "00" & speaker & "00000",
    dac_o   => audio
  );
  
  
  
  O_AUDIO_L <= audio;
  O_AUDIO_R <= audio;
  --image <= SW(9 downto 0);

  SD_DAT3 <= CS_N;
  SD_CMD  <= MOSI;
  MISO    <= SD_DAT;
  SD_CLK  <= SCLK;


  

  -- Current disk track on middle two digits 
  trackmsb <= "00" & track(5 downto 4);
  
  SRAM_DQ(7 downto 0) <= D when ram_we = '1' else (others => 'Z');
  SRAM_ADDR(20 downto 16 ) <= (others => '0');
    
  SRAM_CE_N <= '0';
  SRAM_WE_N <= not ram_we;
  SRAM_OE_N <= ram_we;
 
  LED(1) <= D1_ACTIVE;  -- Disk 1
  LED(2) <= D2_ACTIVE;  -- Disk 2
  
  LEDG(3 downto 1) <= (others => '0');
  
  LED(0) <= '0';
  LED(3) <= '0';
   
  

end datapath;
