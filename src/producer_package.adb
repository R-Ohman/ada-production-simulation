with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO;
with Ada.Numerics.Discrete_Random;


package body producer_package is

   task body Producer is
      package Random_Production is new
        Ada.Numerics.Discrete_Random(Production_Time_Range);
      G: Random_Production.Generator;  --  generator liczb losowych
      Product_Type_Number: Integer;
      Product_Number: Integer;
      Production: Integer;
      IsTaken: Boolean := True;

   begin
      accept Start(Product: in Product_Type; Production_Time: in Integer) do
         Random_Production.Reset(G);  --  start random number generator
         Product_Number := 1;
         Product_Type_Number := Product;
         Production := Production_Time;
      end Start;
      Put_Line("[PRODUCER] Started producer of " & Product_Name(Product_Type_Number));
      loop
         delay Duration(Random_Production.Random(G)); --  symuluj produkcje
         if IsTaken then
            Put_Line("[PRODUCER] Produced product [" & Integer'Image(Product_Number) & " ] " & Product_Name(Product_Type_Number));
         end if;
         -- Accept for storage
         select
            B.Take(Product_Type_Number, Product_Number, IsTaken);
         
         else
            delay 5.0;
            IsTaken := False;
            Put_Line("[STORAGE] We can't take it now, try later ;( [" & Integer'Image(Product_Number) & " ] "
                     & Product_Name(Product_Type_Number));
         end select;
         if IsTaken then
            Product_Number := Product_Number + 1;
         end if;
      end loop;
   end Producer;
   
end producer_package;
