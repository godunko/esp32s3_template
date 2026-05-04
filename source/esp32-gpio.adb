--  Implementation of ESP32.GPIO.
--  Each public procedure calls the corresponding IDF C function via a thin
--  import and forwards any non-zero esp_err_t to Raise_On_Error.
--  Configure_Pin applies all settings from a GPIO_Pin_Config record in one
--  call; its Dynamic_Predicate on the record type enforces valid pull-resistor
--  combinations before any IDF calls are made.
with Interfaces.C;

package body ESP32.GPIO is
   use type Interfaces.C.int;

   subtype ESP_Error is Interfaces.C.int;

   function Gpio_Set_Direction_Raw
     (Pin : Interfaces.C.int; Mode : Interfaces.C.int) return Interfaces.C.int
   with Import, Convention => C, External_Name => "gpio_set_direction";

   function Gpio_Set_Intr_Type_Raw
     (Pin : Interfaces.C.int; Intr_Type : Interfaces.C.int)
      return Interfaces.C.int
   with Import, Convention => C, External_Name => "gpio_set_intr_type";

   function Gpio_Set_Level_Raw
     (Pin : Interfaces.C.int; Level : Interfaces.C.unsigned)
      return Interfaces.C.int
   with Import, Convention => C, External_Name => "gpio_set_level";

   function Gpio_Get_Level_Raw (Pin : Interfaces.C.int) return Interfaces.C.int
   with Import, Convention => C, External_Name => "gpio_get_level";

   function Gpio_Reset_Pin_Raw (Pin : GPIO_Pin) return Interfaces.C.int
   with Import, Convention => C, External_Name => "gpio_reset_pin";

   function Gpio_Pullup_Enable_Raw (Pin : GPIO_Pin) return Interfaces.C.int
   with Import, Convention => C, External_Name => "gpio_pullup_en";

   function Gpio_Pullup_Disable_Raw (Pin : GPIO_Pin) return Interfaces.C.int
   with Import, Convention => C, External_Name => "gpio_pullup_dis";

   function Gpio_Pulldown_Enable_Raw (Pin : GPIO_Pin) return Interfaces.C.int
   with Import, Convention => C, External_Name => "gpio_pulldown_en";

   function Gpio_Pulldown_Disable_Raw (Pin : GPIO_Pin) return Interfaces.C.int
   with Import, Convention => C, External_Name => "gpio_pulldown_dis";

   function Gpio_Intr_Enable_Raw (Pin : GPIO_Pin) return Interfaces.C.int
   with Import, Convention => C, External_Name => "gpio_intr_enable";

   function Gpio_Intr_Disable_Raw (Pin : GPIO_Pin) return Interfaces.C.int
   with Import, Convention => C, External_Name => "gpio_intr_disable";

   procedure Raise_On_Error (Result : ESP_Error; Step : String) is
   begin
      if Result /= 0 then
         raise GPIO_Error with Step & " failed, esp_err_t=" & Result'Image;
      end if;
   end Raise_On_Error;

   procedure Reset_Pin (Pin : GPIO_Pin) is
   begin
      Raise_On_Error (Gpio_Reset_Pin_Raw (Pin), "gpio_reset_pin");
   end Reset_Pin;

   procedure Pullup_Enable (Pin : GPIO_Pin) is
   begin
      Raise_On_Error (Gpio_Pullup_Enable_Raw (Pin), "gpio_pullup_en");
   end Pullup_Enable;

   procedure Pullup_Disable (Pin : GPIO_Pin) is
   begin
      Raise_On_Error (Gpio_Pullup_Disable_Raw (Pin), "gpio_pullup_dis");
   end Pullup_Disable;

   procedure Pulldown_Enable (Pin : GPIO_Pin) is
   begin
      Raise_On_Error (Gpio_Pulldown_Enable_Raw (Pin), "gpio_pulldown_en");
   end Pulldown_Enable;

   procedure Pulldown_Disable (Pin : GPIO_Pin) is
   begin
      Raise_On_Error (Gpio_Pulldown_Disable_Raw (Pin), "gpio_pulldown_dis");
   end Pulldown_Disable;

   procedure Intr_Enable (Pin : GPIO_Pin) is
   begin
      Raise_On_Error (Gpio_Intr_Enable_Raw (Pin), "gpio_intr_enable");
   end Intr_Enable;

   procedure Intr_Disable (Pin : GPIO_Pin) is
   begin
      Raise_On_Error (Gpio_Intr_Disable_Raw (Pin), "gpio_intr_disable");
   end Intr_Disable;

   function Mode_To_C (Mode : GPIO_Mode) return Interfaces.C.int
   is (Interfaces.C.int (GPIO_Mode'Pos (Mode)));

   function Intr_Type_To_C (Kind : GPIO_Intr_Type) return Interfaces.C.int
   is (Interfaces.C.int (GPIO_Intr_Type'Pos (Kind)));

   procedure Set_Direction (Pin : GPIO_Pin; Mode : GPIO_Mode) is
   begin
      Raise_On_Error
        (Gpio_Set_Direction_Raw (Pin, Mode_To_C (Mode)), "gpio_set_direction");
   end Set_Direction;

   procedure Set_Intr_Type (Pin : GPIO_Pin; Kind : GPIO_Intr_Type) is
   begin
      Raise_On_Error
        (Gpio_Set_Intr_Type_Raw (Pin, Intr_Type_To_C (Kind)),
         "gpio_set_intr_type");
   end Set_Intr_Type;

   procedure Set_Level (Pin : GPIO_Pin; Level : GPIO_Level) is
      Raw_Level : constant Interfaces.C.unsigned :=
        (if Level = High then 1 else 0);
   begin
      Raise_On_Error (Gpio_Set_Level_Raw (Pin, Raw_Level), "gpio_set_level");
   end Set_Level;

   function Get_Level (Pin : GPIO_Pin) return GPIO_Level
   is (if Gpio_Get_Level_Raw (Pin) = 0 then Low else High);

   procedure Configure_Pin (Pin : GPIO_Pin; Config : GPIO_Pin_Config) is
   begin
      if Config.Reset_First then
         Reset_Pin (Pin);
      end if;

      Set_Direction (Pin, Config.Mode);

      if Config.Pullup then
         Pullup_Enable (Pin);
      else
         Pullup_Disable (Pin);
      end if;
      if Config.Pulldown then
         Pulldown_Enable (Pin);
      else
         Pulldown_Disable (Pin);
      end if;

      Set_Intr_Type (Pin, Config.Interrupt_Type);

      if Config.Interrupt_Enable then
         Intr_Enable (Pin);
      else
         Intr_Disable (Pin);
      end if;

   end Configure_Pin;

end ESP32.GPIO;
