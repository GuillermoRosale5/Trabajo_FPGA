----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.12.2025 19:33:09
-- Design Name: 
-- Module Name: Prescaler - Behavioral
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Prescaler is
    port(
        clk_in  : in  std_logic;   -- 100 MHz
        rst     : in  std_logic;   -- Reset síncrono
        clk_out : out std_logic    -- 16 kHz
    );
end Prescaler;

architecture Behavioral of Prescaler is

    constant DIV_COUNT : integer := 3124;  -- (100M/16k)/2 - 1
    signal counter     : integer range 0 to DIV_COUNT := 0;
    signal clk_reg     : std_logic := '0';

begin

    process(clk_in)
    begin
        if rising_edge(clk_in) then
            if rst = '1' then
                counter <= 0;
                clk_reg <= '0';
            else
                if counter = DIV_COUNT then
                    counter <= 0;
                    clk_reg <= not clk_reg; -- toggle del divisor
                else
                    counter <= counter + 1;
                end if;
            end if;
        end if;
    end process;

    clk_out <= clk_reg;

end Behavioral;
