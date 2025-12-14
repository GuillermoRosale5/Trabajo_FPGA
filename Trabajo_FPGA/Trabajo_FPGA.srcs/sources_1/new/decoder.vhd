----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.12.2025 18:37:12
-- Design Name: 
-- Module Name: decoder - Behavioral
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

entity decoder is
    Port (
        switches : in  STD_LOGIC_VECTOR (8 downto 0);
        led_1    : out STD_LOGIC_VECTOR (6 downto 0);
        led_2    : out STD_LOGIC_VECTOR (6 downto 0)
    );
end decoder;

architecture dataflow of decoder is
begin

    process(switches)
    begin
        if switches = "000000001" then
            led_1 <= "1110111";
            led_2 <= "1111110";

        elsif switches = "000000010" then
            led_1 <= "1110111";
            led_2 <= "0110000";

        elsif switches = "000000100" then
            led_1 <= "1110111";
            led_2 <= "1101101";

        elsif switches = "000001000" then
            led_1 <= "0011111";
            led_2 <= "1111110";

        elsif switches = "000010000" then
            led_1 <= "0011111";
            led_2 <= "0110000";

        elsif switches = "000100000" then
            led_1 <= "0011111";
            led_2 <= "1101101";

        elsif switches = "001000000" then
            led_1 <= "0001101";
            led_2 <= "1111110";

        elsif switches = "010000000" then
            led_1 <= "0001101";
            led_2 <= "0110000";

        elsif switches = "100000000" then
            led_1 <= "0001101";
            led_2 <= "1101101";

        else
            led_1 <= "0000000";
            led_2 <= "0000000";
        end if;

    end process;

end architecture dataflow;
