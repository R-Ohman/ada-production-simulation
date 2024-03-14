with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO;
with Ada.Numerics.Discrete_Random;

package body tasks is
   -- B : Buffer;
   
   package Random_Consumption is new Ada.Numerics.Discrete_Random
     (Consumption_Time_Range);

   package Random_Assembly is new Ada.Numerics.Discrete_Random (Assembly_Type);
   type My_Str is new String (1 .. 256);

   -- Producer

   task body Consumer is
      G: Random_Consumption.Generator;  --  random number generator (time)
      G2: Random_Assembly.Generator;  --  also (assemblies)
      Consumer_Nb: Consumer_Type;
      Assembly_Number: Integer := 1;
      Consumption: Integer;
      Assembly_Type: Integer;
      Consumer_Name: constant array (1 .. Number_Of_Consumers)
        of String(1 .. 7)
        := ("Bebra  ", "Vitalii");
      HasTaken: Boolean := True;
      Waiting_Counter: Integer := 0;
   begin
      accept Start(Consumer_Number: in Consumer_Type;
                   Consumption_Time: in Integer) do
         Random_Consumption.Reset(G);
         Random_Assembly.Reset(G2);
         Consumer_Nb := Consumer_Number;
         Consumption := Consumption_Time;
      end Start;
      Put_Line("Started consumer " & Consumer_Name(Consumer_Nb));
      loop
         delay Duration(Random_Consumption.Random(G)); --  simulate consumption
         Waiting_Counter := Waiting_Counter + 1;
         if Waiting_Counter = 3 then
            Waiting_Counter := 0;
            HasTaken := True;
            Put_Line("[CONSUMER] " & Consumer_Name(Consumer_Nb) & ": has been waiting for too long time and left.");
         else
            if HasTaken then
               Assembly_Type := Random_Assembly.Random(G2);
               -- take an assembly for consumption
               Waiting_Counter := 0;
               Put_Line("[CONSUMER] " & Consumer_Name(Consumer_Nb) & ": ordered dish " &
                          Assembly_Name(Assembly_Type));
            end if;

            HasTaken := False;
            select
               B.Deliver(Assembly_Type, Assembly_Number, HasTaken);
               if HasTaken then
                  Put_Line("[CONSUMER] " & Consumer_Name(Consumer_Nb) & ": taken dish [" & Integer'Image(Assembly_Number) & " ] " &
                             Assembly_Name(Assembly_Type));
               else
                  Put_Line("[CONSUMER] " & Consumer_Name(Consumer_Nb) & ": Please, wait. Lacking products for dish ["
                           & Integer'Image(Assembly_Number) & " ] " & Assembly_Name(Assembly_Type));
               end if;
            else
               Put_Line("[CONSUMER] " & Consumer_Name(Consumer_Nb) & ": Now we can't deliver your ["
                        & Integer'Image(Assembly_Number) & " ] " & Assembly_Name(Assembly_Type));
            end select;

         end if;

      end loop;
   end Consumer;

   -- Buffer
    
end tasks;
