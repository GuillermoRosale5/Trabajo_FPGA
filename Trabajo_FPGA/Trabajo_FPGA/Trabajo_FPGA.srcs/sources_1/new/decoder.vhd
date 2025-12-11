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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity decoder is
 Port (    
 
           switches : in STD_LOGIC_VECTOR (8 downto 0);
           led_1: out STD_LOGIC_VECTOR (6 downto 0);
           led_2:out STD_LOGIC_VECTOR (6 downto 0)
                      
       );
           
end decoder;

ARCHITECTURE dataflow OF decoder IS
 BEGIN

           
   process(switches)
begin
    if switches(0) = '0' then
        led_1 <= "0000111";
        led_2 <= "1100001";
        
    elsif switches(1) = '1' then
        led_1 <= "0000001";
        led_2 <= "0000001";

    elsif switches(2) = '1' then
        led_1 <= "0000001";
        led_2 <= "0000001";

    elsif switches(3)= '1' then
        led_1 <= "0000001";
        led_2 <= "0000001";
        
    elsif switches(4)= '1' then
        led_1 <= "0000001";
        led_2 <= "0000001";
        
    elsif switches(5)= '1' then
        led_1 <= "0000001";
        led_2 <= "0000001";
        
    elsif switches(6)= '1' then
        led_1 <= "0000001";
        led_2 <= "0000001";
        
    elsif switches(7)= '1' then
        led_1 <= "0000001";
        led_2 <= "0000001";
        
    elsif switches(8)= '1' then
        led_1 <= "0000001";
        led_2 <= "0000001";
        

    else
        led_1 <= "0000000";
        led_2 <= "0000000";  -- valor por defecto
    end if;
    

    
end process;        
       
    END ARCHITECTURE dataflow; 
    
    
