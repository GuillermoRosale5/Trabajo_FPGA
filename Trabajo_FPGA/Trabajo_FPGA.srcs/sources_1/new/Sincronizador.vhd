----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.12.2025 18:31:04
-- Design Name: 
-- Module Name: Sincronizador - Behavioral
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

entity Sincronizador is
 Port ( CLK : in STD_LOGIC;
           ASYNC_IN : in STD_LOGIC;
           SYNC_OUT : out STD_LOGIC);
end Sincronizador;

architecture Behavioral of Sincronizador is
signal sreg: std_logic_vector(1 downto 0);
begin
    process (CLK)
    begin
        if rising_edge(CLK) then
        sync_out <= sreg(1);
        sreg <= sreg(0) & async_in;
        end if;
    end process;

end Behavioral;
