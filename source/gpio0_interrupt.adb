with Interfaces;
with System;
with ESP32.GPIO;
with ESP32.S3.GPIO;

package body GPIO0_Interrupt is
   use type Interfaces.Unsigned_32;

   GPIO0            : constant ESP32.S3.GPIO.Safe_GPIO_Pin := 0;
   GPIO_Intr_Source : constant := ESP32.S3.GPIO.Core_0_Interrupt_Source;

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
         Press_Count := @ + 1;
      end On_Low;

      function Trigger_Count return Interfaces.Unsigned_32 is
      begin
         return Press_Count;
      end Trigger_Count;

   end GPIO0_Handler;

   procedure Initialize is
   begin
      ESP32.GPIO.Reset_Pin (GPIO0);
      ESP32.GPIO.Set_Direction (GPIO0, ESP32.GPIO.Mode_Input);
      ESP32.GPIO.Pullup_Enable (GPIO0);
      ESP32.GPIO.Pulldown_Disable (GPIO0);
      ESP32.GPIO.Set_Intr_Type (GPIO0, ESP32.GPIO.Intr_Negative_Edge);
      ESP32.GPIO.Intr_Enable (GPIO0);
   end Initialize;

   function Trigger_Count return Interfaces.Unsigned_32 is
   begin
      return GPIO0_Handler.Trigger_Count;
   end Trigger_Count;

end GPIO0_Interrupt;
