----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.12.2025 23:00:44
-- Design Name: 
-- Module Name: Multiplex - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Multiplex is
Port (
        clk      : in  STD_LOGIC;                      -- Reloj 100 MHz
        disp1_mult    : in  STD_LOGIC_VECTOR(6 downto 0);   -- Display 1 (AN0)
        disp2_mult    : in  STD_LOGIC_VECTOR(6 downto 0);   -- Display 2 (AN1)
        segment_mult  : out STD_LOGIC_VECTOR(6 downto 0);   -- Bus único de segmentos
        digselec_mult : out STD_LOGIC_VECTOR(1 downto 0)    -- Selección de display
    );
end Multiplex;

architecture Behavioral of Multiplex is
        signal clkdiv : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
        signal mux_sel : STD_LOGIC := '0';
        signal sel : std_logic := '0';
begin
--Divisor de frecuencia para el multiplexor
-- process(clk)
--    begin
--      if rising_edge(clk) then
--            clkdiv <= std_logic_vector(unsigned(clkdiv) + 1);
--            mux_sel <= clkdiv(15);  -- Alterna a ~1.5 ms
--        end if;
--    end process;
    
    --Multiplexor 
    process(clk)
    begin
        if rising_edge (clk) then
            sel <= not sel;
            
            if sel = '0' then
                segment_mult  <= disp1_mult;
                digselec_mult <= "10";   -- AN0 = 0 (ON), AN1 = 1 (OFF)
            
            else 
                segment_mult  <= disp2_mult;
                digselec_mult <= "01";   -- AN0 = 1 (OFF), AN1 = 0 (ON)
            end if;
        end if;
    end process;

end Behavioral;
