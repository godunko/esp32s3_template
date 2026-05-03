with Ada.Exceptions;

package RTS_Exception_Hooks is

   procedure On_Program_Error (Occurrence : Ada.Exceptions.Exception_Occurrence);

end RTS_Exception_Hooks;
