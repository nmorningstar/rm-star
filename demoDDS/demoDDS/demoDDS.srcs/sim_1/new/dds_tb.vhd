----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/11/2015 10:09:30 PM
-- Design Name: 
-- Module Name: dds_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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

entity dds_tb is
end dds_tb;

architecture Behavioral of dds_tb is

  constant CLK_PER : time := 10 ns;  -- 100 MHz
  signal gclk : std_logic;
  signal en : std_logic;
  signal d: std_logic_vector(15 downto 0);
  signal btnc : std_logic;
  
    component top is
        port (
        GCLK :   in std_logic;
        DATA : out std_logic_vector(15 downto 0);
        VALID : out std_logic;
        BTNC : in std_logic
        );
    end component top;

begin
----------------------------------------------------------------------------
-- Clockgen 100 MHz
----------------------------------------------------------------------------
  gclkgen : process
  begin
    gclk <= '0';
    wait for CLK_PER/2;
    gclk <= '1';
    wait for CLK_PER/2;
  end process;

----------------------------------------------------------------------------
-- UUT
----------------------------------------------------------------------------
    uut : top
        port map (
        GCLK => gclk,
        DATA => d,
        VALID => en,
        BTNC => btnc
        );
 
 
        stimulus : process
        begin
        -----------------------------------------------------
        -- Initialization
        -----------------------------------------------------
        
            btnc  <= '1';
            wait for 10 ns;
        
        -----------------------------------------------------
        -- Release External Reset and Set RX high
        -----------------------------------------------------
        
            btnc    <= '0';
            wait for 10 ns;
        wait;
        end process;
       -- end;
 
end Behavioral;








------------------------------------------------------------------------------
---- Stimulus
------------------------------------------------------------------------------
--  stimulus : process
--  begin

-------------------------------------------------------
---- Initialization
-------------------------------------------------------

--    btnc      <= '1';
--    uart_rx   <= '0';
--    --ARM_EN    <= '0';
--    ARM_WRITE <= '0';
--    wait for 1000 ns;

-------------------------------------------------------
---- Release External Reset and Set RX high
-------------------------------------------------------

--    btnc    <= '0';
--    uart_rx <= '1';

-------------------------------------------------------
---- GO and start read pulses
-------------------------------------------------------
   
   
--    -- CASE 1
--    wait for 200 ns;
--    ARM_WRITE <= '1';
--    wait for 200 ns;
--    uart_send("w 0001 0001");           -- Set BURST_MODE ON
--    uart_send("w 0002 0800");           -- Set BURST_LEN = 2048
--    uart_send("w 0 1");                 -- Go!
--    report "Go sent";
--    wait for RDEN_DELAY;                -- or longer/shorter, we just need to wait for the RDEN's
--    wait for 5 ns;
--    --ARM_EN <= '1';
--    report "Arm model enabled";
--    wait for 1000 ns;                   -- or longer/shorter...
--    uart_send("w 0 2");                 -- Stop!
    
    
--    -- CASE 2 -- we want to see the fifo go EM
--     wait for 1000 ns;                   -- or longer/shorter...
--     ARM_WRITE <= '0';
--    uart_send("w 0 1");                 -- Go!
        
    
    
--    wait;                               -- will wait forever
--  end process;
























































------------------------------------------------------------------------------------
---- Company:
---- Engineer: Bob/Natalie
----
---- Create Date: 01/16/2015 10:39:06 AM
---- Design Name:
---- Module Name: uart_tb_1 - Behavioral
---- Project Name:
---- Target Devices:
---- Tool Versions:
---- Description:
----
---- Dependencies:
----
---- Revision:
---- Revision 0.01 - File Created
---- Additional Comments:
----
------------------------------------------------------------------------------------

---------------------------------------------------------------------------------
---- Fragmented Spectrum - Transmitter : Test Bench
---------------------------------------------------------------------------------
----
---- File: zed_fragspec_tx_tb.vhd
---- Company: Geon Technologies, LLC
---- Engineer: Bob Martin
----
---- Description:
----
---------------------------------------------------------------------------------
---- Revision Log:
---------------------------------------------------------------------------------
---- 11/18/13: RMM
---- File Created
---------------------------------------------------------------------------------

--library ieee;
--use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;
--use ieee.math_real.all;
--use std.textio.all;
--use ieee.std_logic_textio.all;

--entity uart_tb_1 is
--end uart_tb_1;

--architecture Behavioral of uart_tb_1 is

--  constant DATA_SAMPLES  : positive                                := 2048;
--  constant CLK_PER       : time                                    := 10 ns;  -- 100 MHz
--  constant BAUD_TIME     : time                                    := 2.0 us;  -- 500000 baud    --3.906 us; -- 256000 baud     --8.6806 us; -- 115200 baud
--  constant BURST_AMOUNT  : positive                                := 64;
--  constant FIFO_WIDTH    : positive                                := 32;
----constant   FIFO_DEPTH : positive := 32;
--  constant FIFO_DEPTH    : positive                                := 1024;
--  constant WCNT_WIDTH    : positive                                := 10;
--  constant DEB_CNT_MAX   : positive                                := 10;  --500000;
--  constant DEB_CNT_WIDTH : positive                                := 22;
--  constant THRESH        : std_logic_vector(FIFO_WIDTH-1 downto 0) := X"00000100";
--  constant RDEN_DELAY : time := 2000 ns;  -- or longer/shorter, we just need to wait for the RDEN's




--  component pkt_rate_test_a is
--    generic(
--      FIFO_WIDTH    : positive;
--      FIFO_DEPTH    : positive;
--      WCNT_WIDTH    : positive;
--      DEB_CNT_MAX   : positive;
--      DEB_CNT_WIDTH : positive
--      );
--    port(
--      GCLK           : in  std_logic;
--      BTNC           : in  std_logic;
--      LEDS           : out std_logic_vector(7 downto 0);
--      UART_TX        : out std_logic;
--      UART_RX        : in  std_logic;
--      -- ARM MODEL --
--      ARM_FIFO_WREN  : in  std_logic;
--      ARM_FIFO_WDATA : in  std_logic_vector(FIFO_WIDTH-1 downto 0);
--      ARM_FIFO_EMPTY : out std_logic;
--      ARM_FIFO_FULL  : out std_logic;
--      ARM_FIFO_WCNT  : out std_logic_vector(WCNT_WIDTH-1 downto 0);
--      -- FMC -- MODEL
--      FMC_CLK        : out std_logic;
--      FMC_RST        : out std_logic;
--      FMC_WREN       : out std_logic;
--      FMC_DATA       : out std_logic_vector(FIFO_WIDTH-1 downto 0)
--      );
--  end component;

--  signal gclk           : std_logic;
--  signal btnc           : std_logic;
--  signal uart_rx        : std_logic;
--  signal uart_tx        : std_logic;
--  signal leds           : std_logic_vector(7 downto 0);
--  signal arm_fifo_wren  : std_logic                               := '0';
--  signal arm_fifo_wdata : std_logic_vector(FIFO_WIDTH-1 downto 0) := x"00000000";
--  signal arm_fifo_empty : std_logic;
--  signal arm_fifo_full  : std_logic;
--  signal arm_fifo_wcnt  : std_logic_vector(WCNT_WIDTH-1 downto 0);
--  signal fmc_clk        : std_logic;
--  signal fmc_rst        : std_logic;
--  signal fmc_wren       : std_logic;
--  signal fmc_data       : std_logic_vector(FIFO_WIDTH-1 downto 0);
--  signal tb_burst       : std_logic                               := '0';
--  signal this_data      : std_logic_vector(7 downto 0)            := (others => '0');
--  --signal ARM_EN         : std_logic;
--  --signal SET_DONE       : std_logic;
--  signal ARM_WRITE      : std_logic;
--  signal arm_write_en   : std_logic                               := '0';
--    signal burst_starting : std_logic :='0';


--begin

------------------------------------------------------------------------------
---- Clockgen 100 MHz
------------------------------------------------------------------------------

--  gclkgen : process
--  begin
--    gclk <= '0';
--    wait for CLK_PER/2;
--    gclk <= '1';
--    wait for CLK_PER/2;
--  end process;

--  data_gen : process
  
--     variable i : integer :=0;  
  
--  begin
  
--    wait until (arm_fifo_wren = '1');  -- this should enable the bursts of data, check
 
    
--    for i in 0 to (BURST_AMOUNT-1) loop
    
--        if (i = 1) then
--            burst_starting <= '1';
--        end if;
    
--        if (i = BURST_AMOUNT-1) then
--            burst_starting <= '0';
--        end if;
        
    
--        if (i < BURST_AMOUNT-1) then
--            arm_fifo_wdata <= std_logic_vector(unsigned(arm_fifo_wdata)+1);
--        else 
--            arm_fifo_wdata <=(others => '0');
--        end if;
        
--      wait until rising_edge (gclk);
      
--    end loop;


--    wait;
--  end process;




---- if arm wc is less than threshold then send a burst of data
--  arm_write_en <= '1' when (unsigned(arm_fifo_wcnt) < unsigned(THRESH)) else '0';

--  write_controller_stop : process(gclk)
--  begin

--    if rising_edge (gclk) then
--      if (ARM_WRITE = '1') and (arm_write_en = '1') then
----      if (arm_write_en = '1') then

--        arm_fifo_wren <= '1';
--      else
--        arm_fifo_wren <= '0';
--      end if;
--    end if;

--  end process;

--    uut : top
--        port map (
--        GCLK => gclk,
--        DATA => d,
--        VALID => en
--        );
 

------------------------------------------------------------------------------
---- UUT
------------------------------------------------------------------------------

--  uut : pkt_rate_test_a
--    generic map(
--      FIFO_WIDTH    => FIFO_WIDTH,
--      FIFO_DEPTH    => FIFO_DEPTH,
--      WCNT_WIDTH    => WCNT_WIDTH,
--      DEB_CNT_MAX   => DEB_CNT_MAX,
--      DEB_CNT_WIDTH => DEB_CNT_WIDTH
--      )
--    port map(
--      GCLK           => gclk,
--      BTNC           => btnc,
--      LEDS           => leds,
--        -- UART
--      UART_RX        => uart_rx,
--      UART_TX        => uart_tx,
--        -- ARM MODEL --
--      ARM_FIFO_WREN  => arm_fifo_wren,
--      ARM_FIFO_WDATA => arm_fifo_wdata,
--      ARM_FIFO_EMPTY => arm_fifo_empty,
--      ARM_FIFO_FULL  => arm_fifo_full,
--      ARM_FIFO_WCNT  => arm_fifo_wcnt,
--        -- FMC -- MODEL
--      FMC_CLK        => fmc_clk,
--      FMC_RST        => fmc_rst,
--      FMC_WREN       => fmc_wren,
--      FMC_DATA       => fmc_data
--      );

------------------------------------------------------------------------------
---- Stimulus
------------------------------------------------------------------------------

--  stimulus : process

--    procedure uart_send_byte(data : std_logic_vector(7 downto 0)) is
--    begin

--      this_data <= data;

--      uart_rx <= '0'; wait for BAUD_TIME;  -- start bit
--      uart_rx <= data(0); wait for BAUD_TIME;
--      uart_rx <= data(1); wait for BAUD_TIME;
--      uart_rx <= data(2); wait for BAUD_TIME;
--      uart_rx <= data(3); wait for BAUD_TIME;
--      uart_rx <= data(4); wait for BAUD_TIME;
--      uart_rx <= data(5); wait for BAUD_TIME;
--      uart_rx <= data(6); wait for BAUD_TIME;
--      uart_rx <= data(7); wait for BAUD_TIME;
--      uart_rx <= '1'; wait for BAUD_TIME;  -- stop bit

--    end procedure;

--    procedure uart_send(cmd : string) is
--      variable ch   : character;
--      variable byte : std_logic_vector(7 downto 0);
--    begin
--      for i in 1 to cmd'length loop
--        ch := cmd(i);
--        case (ch) is
--          when 'r'    => byte := X"72";
--          when 'w'    => byte := X"77";
--          when ' '    => byte := X"20";
--          when '0'    => byte := X"30";
--          when '1'    => byte := X"31";
--          when '2'    => byte := X"32";
--          when '3'    => byte := X"33";
--          when '4'    => byte := X"34";
--          when '5'    => byte := X"35";
--          when '6'    => byte := X"36";
--          when '7'    => byte := X"37";
--          when '8'    => byte := X"38";
--          when '9'    => byte := X"39";
--          when 'A'    => byte := X"41";
--          when 'B'    => byte := X"42";
--          when 'C'    => byte := X"43";
--          when 'D'    => byte := X"44";
--          when 'E'    => byte := X"45";
--          when 'F'    => byte := X"46";
--          when others => byte := X"30";
--        end case;
--        uart_send_byte(byte);
--      end loop;
--      uart_send_byte(X"0D");
--    end procedure;

--  begin

-------------------------------------------------------
---- Initialization
-------------------------------------------------------

--    btnc      <= '1';
--    uart_rx   <= '0';
--    --ARM_EN    <= '0';
--    ARM_WRITE <= '0';
--    wait for 1000 ns;

-------------------------------------------------------
---- Release External Reset and Set RX high
-------------------------------------------------------

--    btnc    <= '0';
--    uart_rx <= '1';

-------------------------------------------------------
---- GO and start read pulses
-------------------------------------------------------
   
   
--    -- CASE 1
--    wait for 200 ns;
--    ARM_WRITE <= '1';
--    wait for 200 ns;
--    uart_send("w 0001 0001");           -- Set BURST_MODE ON
--    uart_send("w 0002 0800");           -- Set BURST_LEN = 2048
--    uart_send("w 0 1");                 -- Go!
--    report "Go sent";
--    wait for RDEN_DELAY;                -- or longer/shorter, we just need to wait for the RDEN's
--    wait for 5 ns;
--    --ARM_EN <= '1';
--    report "Arm model enabled";
--    wait for 1000 ns;                   -- or longer/shorter...
--    uart_send("w 0 2");                 -- Stop!
    
    
--    -- CASE 2 -- we want to see the fifo go EM
--     wait for 1000 ns;                   -- or longer/shorter...
--     ARM_WRITE <= '0';
--    uart_send("w 0 1");                 -- Go!
        
    
    
--    wait;                               -- will wait forever
--  end process;
  
--end;

---- NATALIES OLD SLOPPY CODE

----    write_controller_stop: process(gclk)
----    begin

----        wait until rising_edge (gclk);
----        wait until (ARM_WRITE <= '1');
----        wait until (arm_fifo_wcnt < THRESH);
----                arm_fifo_wren <= '1';
----        wait until rising_edge (gclk);
----        wait until (arm_fifo_wcnt >= THRESH);
----            arm_fifo_wren <= '0';

----    end process;

----    write_controller_go: process
----    begin
----        wait until rising_edge (gclk);
----        wait until (ARM_WRITE <= '1');
----        wait until (arm_fifo_wcnt < THRESH);
----            arm_fifo_wren <= '1';
----         wait;
----    end process;

----   arm_model: process
----   begin
----        wait until (arm_fifo_wcnt < THRESH) and (ARM_EN <= '1') and rising_edge (gclk) ;
----        for i in 0 to 15 loop
----            arm_fifo_wdata <= std_logic_vector(unsigned(arm_fifo_wdata)+1);
----            --arm_fifo_wren <= '1';
----        wait until rising_edge (gclk);
----        end loop;

----        arm_fifo_wdata <= (others => '0');
----        --arm_fifo_wren <= '0';
----        wait;
----   end process;

----    pulse_gen: process
----    begin
----        arm_fifo_wren <= '0';
----        wait for CLK_PER/1;
----        arm_fifo_wren <= '1';
----        wait for CLK_PER/1;
----    end process;

----    data_gen: process(gclk, arm_fifo_wcnt,ARM_EN)
----    begin
----        if (ARM_EN = '0') then
----            arm_fifo_wdata <= (others => '0');
------ elsif( rising_edge(gclk) and (arm_fifo_wcnt < THRESH) and (ARM_EN = '1') ) then
----         elsif( rising_edge(gclk) and (arm_fifo_wcnt < THRESH) and (ARM_EN = '1') ) then
----            arm_fifo_wdata <= std_logic_vector(unsigned(arm_fifo_wdata)+1);
----        end if;
----    end process;

----    data_gen: process
----    begin
----        wait until (arm_fifo_wcnt < THRESH) and rising_edge (gclk) ;
----            for i in 0 to 15 loop
----                 arm_fifo_wdata <= std_logic_vector(unsigned(arm_fifo_wdata)+1);
----            end loop;
----        wait;
----    end process;

----    data_gen: process
----begin
---- --   while (arm_fifo_wcnt < THRESH) and rising_edge (gclk) loop
----  --arm_fifo_wdata <= x"00000000";
----  --arm_fifo_wren <= '0';
------        wait until rising_edge (gclk);
------        wait until (arm_fifo_wcnt < THRESH);
------        wait until (ARM_WRITE <= '1');
----    wait until (arm_fifo_wren = '1'); -- this should enable the bursts of data, check
---- --   arm_fifo_wren <= '1';
----    for i in 0 to (BURST_AMOUNT-1) loop
----        arm_fifo_wdata <= std_logic_vector(unsigned(arm_fifo_wdata)+1);
----    wait until rising_edge (gclk);
----    end loop;

----     --arm_fifo_wren <= '0';
----    --wait until rising_edge (gclk);
----    --wait until (arm_fifo_wcnt >= THRESH);
------        while  (arm_fifo_wcnt >= THRESH) loop
------            arm_fifo_wdata <= x"00000000";
------        end loop;

----  --  end loop;
------        while (ARM_EN <= '0') loop
------            arm_fifo_wdata <= x"00000000";
------        end loop;
----    wait;
----end process;


-----------------------------------------------------------------------------------
------ Fragmented Spectrum - Transmitter : Test Bench
-----------------------------------------------------------------------------------
------
------ File: zed_fragspec_tx_tb.vhd
------ Company: Geon Technologies, LLC
------ Engineer: Bob Martin
------
------ Description:
------
-----------------------------------------------------------------------------------
------ Revision Log:
-----------------------------------------------------------------------------------
------ 11/18/13: RMM
------ File Created
-----------------------------------------------------------------------------------

----library ieee;
----use ieee.std_logic_1164.all;
----use ieee.numeric_std.all;
----use ieee.math_real.all;
----use std.textio.all;
----use ieee.std_logic_textio.all;

----library modelsim_lib;
----use modelsim_lib.util.all;

----entity zed_fragspec_tx_tb is
----end zed_fragspec_tx_tb;

----architecture rtl of zed_fragspec_tx_tb is

----   constant DATA_SAMPLES : positive := 2048;
----   constant CLK_PER      : time := 10 ns; -- 100 MHz
----   constant BAUD_TIME    : time := 2.0 us; -- 500000 baud    --3.906 us; -- 256000 baud     --8.6806 us; -- 115200 baud

----   constant M            : positive := 32;  -- Number of Channels
----   constant C            : positive := 6;   -- Polyphase Filter Columns
----   constant DIN_WIDTH    : positive := 16;
----   constant COEFF_WIDTH  : positive := 20;
----   constant COEFF_AWIDTH : positive := 16;
----   constant PROD_WIDTH   : positive := 24;
----   constant ADDER_WIDTH  : positive := 28;
----   constant FFT_DWIDTH   : positive := 24;
----   constant FFT_TWIDTH   : positive := 28;
----   constant DOUT_WIDTH   : positive := 16;

----   component zed_fragspec_tx is
----   generic(
----      M            : positive;
----      C            : positive;
----      DIN_WIDTH    : positive;
----      COEFF_WIDTH  : positive;
----      COEFF_AWIDTH : positive;
----      PROD_WIDTH   : positive;
----      ADDER_WIDTH  : positive;
----      FFT_DWIDTH   : positive;
----      FFT_TWIDTH   : positive;
----      DOUT_WIDTH   : positive;
----      DEB_CNT_MAX  : positive);
----   port(
----      GCLK         : in std_logic;
----      BTNC         : in std_logic;
----      BTND         : in std_logic;
----      LD0          : out std_logic;
----      LD1          : out std_logic;
----      LD2          : out std_logic;
----      LD3          : out std_logic;
----      LD4          : out std_logic;
----      LD5          : out std_logic;
----      LD6          : out std_logic;
----      LD7          : out std_logic;
----      SW0          : in std_logic;
----      SW1          : in std_logic;
----      SW2          : in std_logic;
----      SW3          : in std_logic;
----      SW4          : in std_logic;
----      SW5          : in std_logic;
----      SW6          : in std_logic;
----      SW7          : in std_logic;
----      UART_RX      : in std_logic;
----      UART_TX      : out std_logic);
----   end component;

----   component sim_capture
----   generic(
----      FILE_NAME   : string  := "out.txt";
----      DATA_WIDTH  : integer := 16);
----   port(
----      CLK      : in std_logic;
----      RST      : in std_logic;
----      DONE     : in std_logic;
----      DIN      : in std_logic_vector(DATA_WIDTH-1 downto 0);
----      DIN_VLD  : in std_logic);
----   end component;

----   signal gclk           : std_logic;
----   signal btnc           : std_logic;
----   signal ld0            : std_logic;
----   signal ld1            : std_logic;
----   signal ld2            : std_logic;
----   signal ld3            : std_logic;
----   signal ld4            : std_logic;
----   signal ld5            : std_logic;
----   signal ld6            : std_logic;
----   signal ld7            : std_logic;
----   signal uart_rx        : std_logic;
----   signal uart_tx        : std_logic;

----   signal clk            : std_logic;
----   signal rst            : std_logic;
----   signal syn_out_cnt    : integer;
----   signal syn_out_done   : std_logic;
----   signal syn_out_re     : std_logic_vector(DOUT_WIDTH-1 downto 0);
----   signal syn_out_im     : std_logic_vector(DOUT_WIDTH-1 downto 0);
----   signal syn_out_vld    : std_logic;

----begin

----   ----------------------------------------------------------------------------
----   -- Clockgen
----   ----------------------------------------------------------------------------

----   gclkgen: process
----   begin
----      gclk <= '0';
----      wait for CLK_PER/2;
----      gclk <= '1';
----      wait for CLK_PER/2;
----   end process;

----   ----------------------------------------------------------------------------
----   -- UUT
----   ----------------------------------------------------------------------------

----   uut: zed_fragspec_tx
----   generic map (
----      M            => M,
----      C            => C,
----      DIN_WIDTH    => DIN_WIDTH,
----      COEFF_WIDTH  => COEFF_WIDTH,
----      COEFF_AWIDTH => COEFF_AWIDTH,
----      PROD_WIDTH   => PROD_WIDTH,
----      ADDER_WIDTH  => ADDER_WIDTH,
----      FFT_DWIDTH   => FFT_DWIDTH,
----      FFT_TWIDTH   => FFT_TWIDTH,
----      DOUT_WIDTH   => DOUT_WIDTH,
----      DEB_CNT_MAX  => 10)
----   port map (
----      GCLK         => gclk,
----      BTNC         => btnc,
----      BTND         => '0',
----      LD0          => ld0,
----      LD1          => ld1,
----      LD2          => ld2,
----      LD3          => ld3,
----      LD4          => ld4,
----      LD5          => ld5,
----      LD6          => ld6,
----      LD7          => ld7,
----      SW0          => '1',  -- Set Baud Select switches to 0x9 for 500K Baud
----      SW1          => '0',  -- See uart_to_bus.vhd
----      SW2          => '0',  --
----      SW3          => '1',  --
----      SW4          => '0',  --
----      SW5          => '0',  --
----      SW6          => '0',  --
----      SW7          => '0',  --
----      UART_RX      => uart_rx,
----      UART_TX      => uart_tx);

----   ----------------------------------------------------------------------------
----   -- Stimulus
----   ----------------------------------------------------------------------------

----   stimulus: process

----      file coeff_file: text;
----      variable coeff_line: line;
----      variable coeff_data : std_logic_vector(COEFF_WIDTH-1 downto 0);

----      file din_file: text;
----      variable din_line: line;
----      variable din_data : std_logic_vector(DIN_WIDTH-1 downto 0);

----      variable temp1 : line;
----      variable temp2 : line;

----      procedure uart_send_byte(data : std_logic_vector(7 downto 0)) is
----      begin
----         uart_rx <= '0'    ; wait for BAUD_TIME; -- start bit
----         uart_rx <= data(0); wait for BAUD_TIME;
----         uart_rx <= data(1); wait for BAUD_TIME;
----         uart_rx <= data(2); wait for BAUD_TIME;
----         uart_rx <= data(3); wait for BAUD_TIME;
----         uart_rx <= data(4); wait for BAUD_TIME;
----         uart_rx <= data(5); wait for BAUD_TIME;
----         uart_rx <= data(6); wait for BAUD_TIME;
----         uart_rx <= data(7); wait for BAUD_TIME;
----         uart_rx <= '1'    ; wait for BAUD_TIME; -- stop bit
----      end procedure;

----      procedure uart_send(cmd : string) is
----         variable ch    : character;
----         variable byte  : std_logic_vector(7 downto 0);
----      begin
----         for i in 1 to cmd'length  loop
----            ch := cmd(i);
----            case (ch) is
----               when 'r' => byte := X"72";
----               when 'w' => byte := X"77";
----               when ' ' => byte := X"20";
----               when '0' => byte := X"30";
----               when '1' => byte := X"31";
----               when '2' => byte := X"32";
----               when '3' => byte := X"33";
----               when '4' => byte := X"34";
----               when '5' => byte := X"35";
----               when '6' => byte := X"36";
----               when '7' => byte := X"37";
----               when '8' => byte := X"38";
----               when '9' => byte := X"39";
----               when 'A' => byte := X"41";
----               when 'B' => byte := X"42";
----               when 'C' => byte := X"43";
----               when 'D' => byte := X"44";
----               when 'E' => byte := X"45";
----               when 'F' => byte := X"46";
----               when others => byte := X"30";
----            end case;
----            uart_send_byte(byte);
----         end loop;
----         uart_send_byte(X"0D");
----      end procedure;

----   begin

----      -- Signal Spy Init
----      -- init_signal_spy("/..._tb/uut/...","<signal name>",0);

----      -----------------------------------------------------
----      -- Initialization
----      -----------------------------------------------------

----      btnc <= '1';
----      uart_rx <= '0';

----      wait for 1000 ns;

----      -----------------------------------------------------
----      -- Release External Reset and Set RX high
----      -----------------------------------------------------

----      btnc <= '0';
----      uart_rx <= '1';

----      wait for 200 ns;

----      -----------------------------------------------------
----      -- Peek/Poke/Peek Test
----      -----------------------------------------------------

----      --uart_send("r 0005");      -- Test reg init value is X"1234"
----      --uart_send("w 0100 5678");
----      --uart_send("r 0100");      -- Verify changed value

----      -----------------------------------------------------
----      -- Start self-running test
----      -----------------------------------------------------

----      --uart_send("w 0001 0001");    -- Set BURST_MODE ON
----      --uart_send("w 0002 0800");    -- Set BURST_LEN = 2048
----      --uart_send("w 0000 0002");    -- Clear Capture FIFOs
----      --uart_send("w 0000 0001");    -- Go!

----      -----------------------------------------------------
----      -- Set Prototype Filter Taps and Load Pattern RAMs
----      -----------------------------------------------------

----      -- Doing this with uart_send commands would be prohibitive due to
----      -- how much time is required for even a single transaction at the
----      -- max UART baud rate used in this sim (256K). So, I "cheated" and
----      -- used a bunch of 'force' and 'change' commands in the modelsim
----      -- sim.do file.
----      --
----      -- It's still a good idea to check that the above commands work on
----      -- their own though if checking in major changes...

----      wait;

----   end process;

----   -----------------------------------------------------
----   -- Output Capture
----   -----------------------------------------------------

----   -- TX

----   init_signal_spy( "/zed_fragspec_tx_tb/uut/clk"         , "/zed_fragspec_tx_tb/clk"         ,1,1 );
----   init_signal_spy( "/zed_fragspec_tx_tb/uut/rst"         , "/zed_fragspec_tx_tb/rst"         ,1,1 );
----   init_signal_spy( "/zed_fragspec_tx_tb/uut/syn_out_re"  , "/zed_fragspec_tx_tb/syn_out_re"  ,1,1 );
----   init_signal_spy( "/zed_fragspec_tx_tb/uut/syn_out_im"  , "/zed_fragspec_tx_tb/syn_out_im"  ,1,1 );
----   init_signal_spy( "/zed_fragspec_tx_tb/uut/syn_out_vld" , "/zed_fragspec_tx_tb/syn_out_vld" ,1,1 );

----   process(clk,rst)
----   begin
----      if (rst = '1') then
----         syn_out_cnt <= 0;
----      elsif rising_edge(clk) then
----         if (syn_out_vld = '1') then
----            syn_out_cnt <= syn_out_cnt + 1;
----         end if;
----      end if;
----   end process;

----   syn_out_done <= '1' when syn_out_cnt = DATA_SAMPLES  else '0';

----   tx_capture_re: sim_capture
----   generic map(
----      FILE_NAME   => "tb_tx_dout_re.txt",
----      DATA_WIDTH  => 16)
----   port map(
----      CLK      => clk,
----      RST      => rst,
----      DONE     => syn_out_done,
----      DIN      => syn_out_re,
----      DIN_VLD  => syn_out_vld);

----   tx_capture_im: sim_capture
----   generic map(
----      FILE_NAME   => "tb_tx_dout_im.txt",
----      DATA_WIDTH  => 16)
----   port map(
----      CLK      => clk,
----      RST      => rst,
--      DONE     => syn_out_done,
--      DIN      => syn_out_im,
--      DIN_VLD  => syn_out_vld);


--end;
