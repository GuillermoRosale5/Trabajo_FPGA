
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Multiplex is
    generic (
        NUM_DIGITS : positive := 8;
        NUM_SEGS   : positive := 8  -- 7 segmentos + punto (bit 0)
    );
    port (
        clk           : in  STD_LOGIC;

        DISP_DIG1     : in  STD_LOGIC_VECTOR(NUM_SEGS-1 downto 0);
        DISP_DIG2     : in  STD_LOGIC_VECTOR(NUM_SEGS-1 downto 0);
        DISP_DIG3     : in  STD_LOGIC_VECTOR(NUM_SEGS-1 downto 0);
        DISP_DIG4     : in  STD_LOGIC_VECTOR(NUM_SEGS-1 downto 0);
        DISP_DIG5     : in  STD_LOGIC_VECTOR(NUM_SEGS-1 downto 0);
        DISP_DIG6     : in  STD_LOGIC_VECTOR(NUM_SEGS-1 downto 0);
        DISP_DIG7     : in  STD_LOGIC_VECTOR(NUM_SEGS-1 downto 0);
        DISP_DIG8     : in  STD_LOGIC_VECTOR(NUM_SEGS-1 downto 0);

        segment_mult  : out STD_LOGIC_VECTOR(NUM_SEGS-1 downto 0); -- el 7 es el punto del digito
        digselec_mult : out STD_LOGIC_VECTOR(NUM_DIGITS-1 downto 0) -- an[0..7] (active-low)
    );
end Multiplex;

architecture Behavioral of Multiplex is
    signal sel : unsigned(2 downto 0) := (others => '0');
begin

    process(clk)
    begin
        if rising_edge(clk) then

            sel <= sel + 1;

            case sel is
                when "000" =>
                    segment_mult  <= DISP_DIG8;
                    digselec_mult <= "01111111";  -- AN7 activo (0)

                when "001" =>
                    segment_mult  <= DISP_DIG7;
                    digselec_mult <= "10111111";  -- AN6 activo (0)

                when "010" =>
                    segment_mult  <= DISP_DIG6;
                    digselec_mult <= "11011111";  -- AN5 activo (0)

                when "011" =>
                    segment_mult  <= DISP_DIG5;
                    digselec_mult <= "11101111";  -- AN4 activo (0)

                when "100" =>
                    segment_mult  <= DISP_DIG4;
                    digselec_mult <= "11110111";  -- AN3 activo (0)

                when "101" =>
                    segment_mult  <= DISP_DIG3;
                    digselec_mult <= "11111011";  -- AN2 activo (0)

                when "110" =>
                    segment_mult  <= DISP_DIG2;
                    digselec_mult <= "11111101";  -- AN1 activo (0)

                when others =>
                    segment_mult  <= DISP_DIG1;
                    digselec_mult <= "11111110";  -- AN0 activo (0)
            end case;

        end if;
    end process;

end Behavioral;

         
