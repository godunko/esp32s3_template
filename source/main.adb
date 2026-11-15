
pragma Ada_2022;

with Ada.Text_IO;

procedure Main is

   procedure ESP_Restart
     with Import, Convention => C, External_Name => "esp_restart";

begin
   Ada.Text_IO.New_Line;
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put_Line ("Hello, Ada world!");
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put_Line
     ("This application tests few features of the Ada runtime");
   Ada.Text_IO.Put_Line
     ("Feel free to replace it by your application!");
   Ada.Text_IO.New_Line;

   delay 1.0;

   Ada.Text_IO.Put_Line ("Restarting...");

   ESP_Restart;
   --  Restart to exit from Qemu in CI.
end Main;
