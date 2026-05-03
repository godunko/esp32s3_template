with Ada.Exceptions;
with Ada.Text_IO;

package body RTS_Exception_Hooks is

   procedure On_Program_Error
     (Occurrence : Ada.Exceptions.Exception_Occurrence)
   is
   begin
      Ada.Text_IO.Put_Line ("Program_Error action invoked:");
      Ada.Text_IO.Put_Line (Ada.Exceptions.Exception_Information (Occurrence));

      loop
         delay 1.0;
      end loop;
   end On_Program_Error;

end RTS_Exception_Hooks;