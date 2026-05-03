with Interfaces.C;

package ESP32.GPIO is

   --  General pin number type: any non-negative value accepted by the IDF.
   --  Variant-specific packages (e.g. ESP32.S3.GPIO) narrow this further
   --  and provide Safe_GPIO_Pin which also excludes module-reserved pins.
   subtype GPIO_Pin is Interfaces.C.int range 0 .. Interfaces.C.int'Last;

   GPIO_Error : exception;

   type GPIO_Mode is
     (Mode_Disable, Mode_Input, Mode_Output, Mode_Output_Open_Drain, Mode_Input_Output_Open_Drain, Mode_Input_Output);

   for GPIO_Mode use
     (Mode_Disable                 => 0,
      Mode_Input                   => 1,
      Mode_Output                  => 2,
      Mode_Output_Open_Drain       => 3,
      Mode_Input_Output_Open_Drain => 4,
      Mode_Input_Output            => 5);

   type GPIO_Intr_Type is
     (Intr_Disabled, Intr_Positive_Edge, Intr_Negative_Edge, Intr_Any_Edge, Intr_Low_Level, Intr_High_Level);

   for GPIO_Intr_Type use
     (Intr_Disabled      => 0,
      Intr_Positive_Edge => 1,
      Intr_Negative_Edge => 2,
      Intr_Any_Edge      => 3,
      Intr_Low_Level     => 4,
      Intr_High_Level    => 5);

   type GPIO_Level is (Low, High);

   procedure Reset_Pin (Pin : GPIO_Pin);

   procedure Set_Direction (Pin : GPIO_Pin; Mode : GPIO_Mode);

   procedure Pullup_Enable (Pin : GPIO_Pin);
   procedure Pullup_Disable (Pin : GPIO_Pin);

   procedure Pulldown_Enable (Pin : GPIO_Pin);
   procedure Pulldown_Disable (Pin : GPIO_Pin);

   procedure Set_Intr_Type (Pin : GPIO_Pin; Kind : GPIO_Intr_Type);

   procedure Intr_Enable (Pin : GPIO_Pin);
   procedure Intr_Disable (Pin : GPIO_Pin);

   procedure Set_Level (Pin : GPIO_Pin; Level : GPIO_Level);

   function Get_Level (Pin : GPIO_Pin) return GPIO_Level;

end ESP32.GPIO;
