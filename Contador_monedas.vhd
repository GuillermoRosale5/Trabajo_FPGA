library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity contador_monedas is
 port(
        clk            : in  std_logic;
        edge_monedas   : in  std_logic; -- flanco que indica que la moneda se ha metido
        edge_confir    : in  std_logic; -- boton de confirmar el pago cuando se hayan metido todas las monedas
        monedas        : in  std_logic_vector(3 downto 0); -- vector que representa qué moneda se ha metido (10, 20, 50, 1€)
        estado         : in  unsigned(2 downto 0); -- Entrada de la FSM que indica el estado global
        Reset_Contador : in std_logic ;

        faltan_monedas_contador : out unsigned(3 downto 0); -- Número de monedas que falta, de cara al DISPLAY para que pueda mostrarlo por pantalla
        ok             : out std_logic; -- Señal para la FSM de que el pago se ha podido realizar correctamente
        error          : out std_logic -- Señal para la FSM de que el pago ha sido erroneo, por pasarse o quedarse corto con el importe
    );
end contador_monedas;

architecture Behavioral of contador_monedas is

  constant ESTADO_0 : unsigned(2 downto 0) := (others => '0');
  constant ESTADO_1 : unsigned(2 downto 0) := "001";

  signal faltan_reg    : unsigned(3 downto 0) := to_unsigned(10, 4); -- 0..10
  signal resta         : unsigned(3 downto 0) := (others => '0');
  signal estado_prev   : unsigned(2 downto 0) := (others => '0');

  signal ok_pago       : std_logic := '0';
  signal error_pago    : std_logic := '0';
  signal pago_excedido : std_logic := '0';

  -- AÑADIDO (mínimo): detectar evento 1 vez aunque edge_* dure varios clocks
  signal edge_monedas_prev : std_logic := '0';
  signal edge_confir_prev  : std_logic := '0';
  signal monedas_guardadas : std_logic_vector(3 downto 0) := (others => '0');

begin

  process(clk)
    variable resta_calc : unsigned(3 downto 0);
    variable pulso_monedas : std_logic;
    variable pulso_confir  : std_logic;
  begin
    if rising_edge(clk) then

      resta_calc := (others => '0');

      -- AÑADIDO: pulso interno de 1 ciclo
      pulso_monedas := '0';
      pulso_confir  := '0';

      if (edge_monedas = '1') and (edge_monedas_prev = '0') then
        pulso_monedas := '1';
      end if;

      if (edge_confir = '1') and (edge_confir_prev = '0') then
        pulso_confir := '1';
      end if;

      if pulso_monedas = '1' then
        monedas_guardadas <= monedas;
      end if;

      ----------------------------------------------------------------
      -- RESET GLOBAL (funciona en cualquier estado)
      ----------------------------------------------------------------
      if Reset_Contador = '0' then
        faltan_reg    <= to_unsigned(10, 4);
        resta         <= (others => '0');
        pago_excedido <= '0';
        ok_pago       <= '0';
        error_pago    <= '0';
        monedas_guardadas <= (others => '0');

      else
        ----------------------------------------------------------------
        -- Al volver a ESTADO_0: reinicio total
        ----------------------------------------------------------------
        if (estado_prev /= ESTADO_0) and (estado = ESTADO_0) then
          faltan_reg    <= to_unsigned(10, 4);
          resta         <= (others => '0');
          pago_excedido <= '0';
          ok_pago       <= '0';
          error_pago    <= '0';
          monedas_guardadas <= (others => '0');
        end if;

        ----------------------------------------------------------------
        -- Si salimos de ESTADO_1, borramos el contexto de pago
        ----------------------------------------------------------------
        if (estado_prev = ESTADO_1) and (estado /= ESTADO_1) then
          faltan_reg    <= to_unsigned(10, 4);
          resta         <= (others => '0');
          pago_excedido <= '0';
          monedas_guardadas <= (others => '0');
        end if;

        ----------------------------------------------------------------
        -- OPERACIÓN SOLO EN ESTADO_1
        ----------------------------------------------------------------
        if (estado = ESTADO_1) then

          -- Si ya hay resultado, no aceptar más acciones
          if (ok_pago = '0') and (error_pago = '0') then

            ------------------------------------------------------------
            -- Inserción de moneda
            ------------------------------------------------------------
            if pulso_monedas = '1' then

              -- monedas: one-hot
              -- (0)=10c, (1)=20c, (2)=50c, (3)=1€
              if monedas_guardadas(0) = '1' then
                resta_calc := to_unsigned(1, 4);
              elsif monedas_guardadas(1) = '1' then
                resta_calc := to_unsigned(2, 4);
              elsif monedas_guardadas(2) = '1' then
                resta_calc := to_unsigned(5, 4);
              elsif monedas_guardadas(3) = '1' then
                resta_calc := to_unsigned(10, 4);
              else
                resta_calc := (others => '0');
              end if;

              resta <= resta_calc;

              if resta_calc /= to_unsigned(0, 4) then
                if faltan_reg > resta_calc then
                  faltan_reg <= faltan_reg - resta_calc;
                elsif faltan_reg = resta_calc then
                  faltan_reg <= (others => '0');
                else
                  faltan_reg    <= (others => '0');
                  pago_excedido <= '1';
                end if;
              end if;

            ------------------------------------------------------------
            -- Confirmar pago
            ------------------------------------------------------------
            elsif pulso_confir = '1' then

              if faltan_reg = to_unsigned(10, 4) then
                -- no se ha metido ninguna moneda
                null;

              elsif (faltan_reg = to_unsigned(0, 4)) and (pago_excedido = '0') then
                ok_pago <= '1';

              else
                error_pago <= '1';
              end if;

            end if;

          end if;
        end if;

      end if;

      estado_prev <= estado;

      -- AÑADIDO: memorias para detectar flanco
      edge_monedas_prev <= edge_monedas;
      edge_confir_prev  <= edge_confir;

    end if;
  end process;

  -- Salidas
  faltan_monedas_contador <= faltan_reg;  -- 0..10
  ok    <= ok_pago;
  error <= error_pago;

end Behavioral;



