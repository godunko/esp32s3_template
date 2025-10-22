
package body Interrupts is

   protected My is
      procedure Handler with Attach_Handler => 1;
   end My;

   protected body My is

      procedure Handler is
      begin
         null;
      end Handler;

   end My;

end Interrupts;
