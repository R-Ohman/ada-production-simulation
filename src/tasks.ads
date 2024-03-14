with Product_Assemblies; use Product_Assemblies;
with producer_package; use producer_package;
with buffer_package; use buffer_package;

package Tasks is
   Number_Of_Consumers  : constant Integer := 2;
   subtype Consumer_Type is Integer range 1 .. Number_Of_Consumers;

   -- Producer
   
   -- Consumer gets an arbitrary assembly of several products from the buffer
   task type Consumer is
      -- Give the Consumer an identity
      entry Start(Consumer_Number: in Consumer_Type;
                  Consumption_Time: in Integer);
   end Consumer;

   -- Buffer
end Tasks;
