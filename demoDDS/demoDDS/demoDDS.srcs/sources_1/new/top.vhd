----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/11/2015 09:19:05 PM
-- Design Name: 
-- Module Name: top - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    port (
    GCLK :   in std_logic;
    DATA : out std_logic_vector(15 downto 0);
    VALID : out std_logic;
    BTNC : in std_logic
    );
end top;

architecture Behavioral of top is

component debounce is
  port
  (
    clk       : in  std_logic;
    button_in  : in  std_logic;
    button_db : out std_logic
  );
end component debounce;

component dds_compiler_0 is
    port ( 
    aclk : IN STD_LOGIC;
    m_axis_data_tvalid : OUT STD_LOGIC;
    m_axis_data_tdata : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_phase_tvalid : OUT STD_LOGIC;
    m_axis_phase_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
end component dds_compiler_0;

signal rst : std_logic;
signal d : std_logic_vector(15 downto 0);
signal en : std_logic;
signal foo : std_logic;
signal bar : std_logic_vector(31 downto 0);

begin

     oscilator : dds_compiler_0
     port map (
      aclk => GCLK,
      m_axis_data_tvalid => en,
      m_axis_data_tdata => d,
      m_axis_phase_tvalid => foo,
     m_axis_phase_tdata => bar  
    );

    deb : debounce
    port map (
        clk => GCLK,
        button_in => BTNC,
        button_db => rst
      );

    process(GCLK,rst)
    begin
    if (rst = '1') then
            data <= (others => '0');
        elsif rising_edge(GCLK)then
            --if (en = '1') then
            data <= d;
            --end if;
        --end if;
    end if;  
    end process;

end Behavioral;
