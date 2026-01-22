
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity EDGEDTCTR is
    Generic(
            NUM_MONEDAS: positive:= 4;
            NUM_PULSOS: positive := 5
    );

    Port ( 
            CLK : in STD_LOGIC;
           
           -- BOTONES QUE REQUIEREN DE UN FLANCO para definir un estado de activación

           -- EMTRADAS DE LOS BOTONES
           SYNC_IN_MONEDAS : in STD_LOGIC_VECTOR (NUM_MONEDAS -1 downto 0);
           SYNC_IN_CONFIRMACION: in STD_LOGIC;
           RESET_EDGE_DTC : in STD_LOGIC;
           
           -- SALIDAS como FLANCOS DE SUBIDA
           EDGE_MONEDAS_DETECTADO : out STD_LOGIC;
           EDGE_BOTON_PAGO : out STD_LOGIC;
           
           -- Vector para monedas, si se detecta que una de las 4 monedas se activa sacamos un vector 
           -- determinista que define qué moneda ha entrado y lo mantiene encendido hasta 
           Vector_monedas_deter: out STD_LOGIC_VECTOR (NUM_MONEDAS -1 downto 0)
           );
end EDGEDTCTR;


architecture Behavioral of EDGEDTCTR is

    -- DETECCION DE FLANCO CON VECTORES DE 3 BITS ( van desplazandose temporalmente)
    -- Registros para los botones de monedas ( 10, 20 , 50 y 1€)
    signal sreg_1: std_logic_vector (2 downto 0) := (others => '0');
    signal sreg_2: std_logic_vector (2 downto 0) := (others => '0');
    signal sreg_3: std_logic_vector (2 downto 0) := (others => '0');
    signal sreg_4: std_logic_vector (2 downto 0) := (others => '0');
    -- registro del boton de confirmacion de pago (renombrado como pediste)
    signal sreg_boton_pago: std_logic_vector (2 downto 0) := (others => '0');
    
    
    -- vector candidato a ser el determinista (el que queda permanente para avisar al contador de qué moneda es)
    -- Esto del determinismo se hace por una cuestion de seguridad, NO QUEREMOS 2 monedas al mismo tiempo
    signal Vect_MONEDAS_POSIBLE_s : std_logic_vector (NUM_MONEDAS -1 downto 0) := (others => '0');
    signal Vect_MONEDAS_DETERMINISTA : std_logic_vector (NUM_MONEDAS -1 downto 0) := (others => '0');
    
    
    -- FLANCOS DE 5 CLOCKS DE ACTIVACION
    -- Registros para el Flanco de MONEDAS que dura 5 ciclos
    signal r_edge_monedas : std_logic := '0';
    signal pulsos_flanco_monedas  : unsigned(NUM_PULSOS-1 downto 0) := (others => '0');  -- hasta 5
    -- Registros para el Flanco DEL BOTON CONFIRMAR PAGO que dura 5 ciclos
    signal r_edge_boton_pago : std_logic := '0';
    signal pulsos_flanco_boton  : unsigned(NUM_PULSOS-1 downto 0) := (others => '0');  -- hasta 5

    
   
   
   
begin
    process (CLK)
    begin
        if rising_edge(CLK) then
            sreg_1 <= sreg_1(1 downto 0) & SYNC_IN_MONEDAS(0);
            sreg_2 <= sreg_2(1 downto 0) & SYNC_IN_MONEDAS(1);
            sreg_3 <= sreg_3(1 downto 0) & SYNC_IN_MONEDAS(2);
            sreg_4 <= sreg_4(1 downto 0) & SYNC_IN_MONEDAS(3);
       ------------------------------------------------------------------------------- EDGE DETECTOR DE LA PRÁCTICA 2 PARA EL BOTÓN DE CONFIRMAR
            sreg_boton_pago <= sreg_boton_pago(1 downto 0) & SYNC_IN_CONFIRMACION;
            
        end if;
    end process;
    
    
    -------------------------------------------------------------------------
    -- DETECCION DE FLANCO (combinacional, fuera del clk)
    -------------------------------------------------------------------------
    
    with sreg_1 select
        Vect_MONEDAS_POSIBLE_s(0) <= '1' when "001", '0' when others;
    with sreg_2 select
        Vect_MONEDAS_POSIBLE_s(1) <= '1' when "001", '0' when others;
    with sreg_3 select
        Vect_MONEDAS_POSIBLE_s(2) <= '1' when "001", '0' when others;
    with sreg_4 select
        Vect_MONEDAS_POSIBLE_s(3) <= '1' when "001", '0' when others;





-- Pulso estirado 5 clocks para BOTÓN PAGO (depende de CLK para poder contar los 5 clks) 
    process (CLK)
    begin
        if rising_edge(CLK) then

            if pulsos_flanco_boton = to_unsigned(0, NUM_PULSOS) then
                if sreg_boton_pago = "001" then
                    pulsos_flanco_boton <= to_unsigned(NUM_PULSOS, NUM_PULSOS);
                    r_edge_boton_pago   <= '1';
                else
                    r_edge_boton_pago <= '0';
                end if;

            else
                if pulsos_flanco_boton = to_unsigned(1, NUM_PULSOS) then
                    pulsos_flanco_boton <= (others => '0');
                    r_edge_boton_pago   <= '0';
                else
                    pulsos_flanco_boton <= pulsos_flanco_boton - 1;                                 -- RESTA
                    r_edge_boton_pago   <= '1';
                end if;
            end if;

        end if;
    end process;


    -- Pulso estirado 5 clocks para MONEDAS + vector determinista
    process (CLK)
    begin
        if rising_edge(CLK) then

            -- PAGO ANULA MONEDAS
            if (sreg_boton_pago = "001") or
               (pulsos_flanco_boton /= to_unsigned(0, NUM_PULSOS)) then

                pulsos_flanco_monedas     <= (others => '0');
                r_edge_monedas            <= '0';
                Vect_MONEDAS_DETERMINISTA <= (others => '0');

            else
                if pulsos_flanco_monedas = to_unsigned(0, NUM_PULSOS) then

                    if (Vect_MONEDAS_POSIBLE_s = "0001" or
                        Vect_MONEDAS_POSIBLE_s = "0010" or
                        Vect_MONEDAS_POSIBLE_s = "0100" or
                        Vect_MONEDAS_POSIBLE_s = "1000") then

                        pulsos_flanco_monedas     <= to_unsigned(NUM_PULSOS, NUM_PULSOS);
                        r_edge_monedas            <= '1';
                        Vect_MONEDAS_DETERMINISTA <= Vect_MONEDAS_POSIBLE_s;

                    else
                        r_edge_monedas            <= '0';
                        Vect_MONEDAS_DETERMINISTA <= (others => '0');
                    end if;

                else
                    if pulsos_flanco_monedas = to_unsigned(1, NUM_PULSOS) then
                        pulsos_flanco_monedas     <= (others => '0');
                        r_edge_monedas            <= '0';
                        Vect_MONEDAS_DETERMINISTA <= (others => '0');
                    else
                        pulsos_flanco_monedas <= pulsos_flanco_monedas - 1;
                        r_edge_monedas        <= '1';
                    end if;
                end if;

            end if;

        end if;
    end process;


    -- Salidas desde registros (lo que se estira es el registro)
    EDGE_MONEDAS_DETECTADO <= r_edge_monedas;
    EDGE_BOTON_PAGO        <= r_edge_boton_pago;
    Vector_monedas_deter   <= Vect_MONEDAS_DETERMINISTA;

end Behavioral;



   


