pragma Ada_2022;

pragma Warnings (Off, "is an internal GNAT unit");
with System.Tasking.Initialization;
pragma Elaborate_All (System.Tasking.Initialization);
pragma Warnings (On, "is an internal GNAT unit");
--  `System.Tasking.Initialization` should be with-ed to setup task-safe soft
--  links, which is required due to use of FreeRTOS by ESP-IDF.

with Ada.Exceptions;
with Ada.Text_IO;
with GNAT.Exception_Actions;
with GPIO0_Interrupt;
with RTS_Exception_Hooks;
with Interfaces;

procedure Main is
   use type Interfaces.Unsigned_32;

   Last_Count : Interfaces.Unsigned_32 := 0;
begin
   GNAT.Exception_Actions.Register_Id_Action (Program_Error'Identity, RTS_Exception_Hooks.On_Program_Error'Access);

   GPIO0_Interrupt.Initialize;

   Ada.Text_IO.New_Line;
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put_Line ("Hello, Ada world!");
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put_Line ("GPIO0 is configured as INPUT_PULLUP with falling-edge interrupt");
   Ada.Text_IO.Put_Line ("Pull GPIO0 low to trigger the Ada interrupt procedure");
   Ada.Text_IO.New_Line;

   loop
      declare
         Count : constant Interfaces.Unsigned_32 := GPIO0_Interrupt.Trigger_Count;
      begin
         if Count /= Last_Count then
            Last_Count := Count;
            Ada.Text_IO.Put_Line ("GPIO0 interrupt count:" & Interfaces.Unsigned_32'Image (Count));
         end if;
      end;

      delay 0.05;
   end loop;
end Main;
