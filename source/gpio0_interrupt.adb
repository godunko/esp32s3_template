with Interfaces;
with Interfaces.C;
with System;
with Ada.Interrupts;

package body GPIO0_Interrupt is
   use type Interfaces.C.int;
   use type Interfaces.Unsigned_32;

   GPIO0             : constant Interfaces.C.int := 0;
   GPIO_Mode_Input   : constant Interfaces.C.int := 1;
   GPIO_Intr_Negedge : constant Interfaces.C.int := 2;
   GPIO_Intr_Source  : constant Ada.Interrupts.Interrupt_ID := 16;

   protected GPIO0_Handler is
      pragma Interrupt_Priority (System.Interrupt_Priority'Last);

      procedure On_Low;
      pragma Attach_Handler (On_Low, GPIO_Intr_Source);

      function Trigger_Count return Interfaces.Unsigned_32;

   private
      Press_Count : Interfaces.Unsigned_32 := 0;
   end GPIO0_Handler;

   protected body GPIO0_Handler is

      procedure On_Low is
      begin
         Press_Count := Press_Count + 1;
      end On_Low;

      function Trigger_Count return Interfaces.Unsigned_32 is
      begin
         return Press_Count;
      end Trigger_Count;

   end GPIO0_Handler;

   function Gpio_Reset_Pin (Pin : Interfaces.C.int) return Interfaces.C.int
   with Import, Convention => C, External_Name => "gpio_reset_pin";

   function Gpio_Set_Direction
     (Pin : Interfaces.C.int; Mode : Interfaces.C.int) return Interfaces.C.int
   with Import, Convention => C, External_Name => "gpio_set_direction";

   function Gpio_Pullup_En (Pin : Interfaces.C.int) return Interfaces.C.int
   with Import, Convention => C, External_Name => "gpio_pullup_en";

   function Gpio_Pulldown_Dis (Pin : Interfaces.C.int) return Interfaces.C.int
   with Import, Convention => C, External_Name => "gpio_pulldown_dis";

   function Gpio_Set_Intr_Type
     (Pin : Interfaces.C.int; Intr_Type : Interfaces.C.int)
      return Interfaces.C.int
   with Import, Convention => C, External_Name => "gpio_set_intr_type";

   function Gpio_Intr_Enable (Pin : Interfaces.C.int) return Interfaces.C.int
   with Import, Convention => C, External_Name => "gpio_intr_enable";

   procedure Check (Result : Interfaces.C.int; Step : String) is
   begin
      if Result /= 0 then
         raise Program_Error
           with Step & " failed, esp_err_t=" & Interfaces.C.int'Image (Result);
      end if;
   end Check;

   procedure Initialize is
   begin
      Check (Gpio_Reset_Pin (GPIO0), "gpio_reset_pin(GPIO0)");
      Check
        (Gpio_Set_Direction (GPIO0, GPIO_Mode_Input),
         "gpio_set_direction(GPIO0, INPUT)");
      Check (Gpio_Pullup_En (GPIO0), "gpio_pullup_en(GPIO0)");
      Check (Gpio_Pulldown_Dis (GPIO0), "gpio_pulldown_dis(GPIO0)");
      Check
        (Gpio_Set_Intr_Type (GPIO0, GPIO_Intr_Negedge),
         "gpio_set_intr_type(GPIO0, NEGEDGE)");
      Check (Gpio_Intr_Enable (GPIO0), "gpio_intr_enable(GPIO0)");
   end Initialize;

   function Trigger_Count return Interfaces.Unsigned_32 is
   begin
      return GPIO0_Handler.Trigger_Count;
   end Trigger_Count;

end GPIO0_Interrupt;
