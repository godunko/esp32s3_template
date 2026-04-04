
pragma Warnings (Off, "is an internal GNAT unit");
with System.Tasking.Initialization;
pragma Elaborate_All (System.Tasking.Initialization);
pragma Warnings (On, "is an internal GNAT unit");
--  `System.Tasking.Initialization` should be with-ed to setup task-safe soft
--  links, which is required due to use of FreeRTOS by ESP-IDF.

with Main;

package body Application is

   procedure adainit
     with Import, Convention => C, Link_Name => "adainit";

   procedure app_main
     with Export, Convention => C, Link_Name => "app_main";

   --------------
   -- app_main --
   --------------

   procedure app_main is
   begin
      adainit;
      Main;
   end app_main;

end Application;
