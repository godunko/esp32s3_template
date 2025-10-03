
pragma Ada_2022;

with A0B.Types;
with Ada.Text_IO;

procedure Main is
   use type A0B.Types.Unsigned_32;

   function F return String;

   function F return String is ("def");

   Count : A0B.Types.Unsigned_32 := 0;
   S     : String := "abc" & F & A0B.Types.Unsigned_32'Image (Count);

begin
   for J in 1 .. 1_000 loop
      Count := @ + 1;
   end loop;


   Ada.Text_IO.Put_Line (S & A0B.Types.Unsigned_32'Image (Count));
end Main;
