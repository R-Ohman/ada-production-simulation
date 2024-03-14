with Product_Assemblies; use Product_Assemblies;

package buffer_package is
   
   -- In the Buffer, products are assemblied into an assembly
   task type Buffer is
      -- Accept a product to the storage provided there is a room for it
      entry Take(Product: in Product_Type; Number: in Integer; IsTaken: out Boolean);
      -- Deliver an assembly provided there are enough products for it
      entry Deliver(Assembly: in Assembly_Type; Number: out Integer; HasTaken: out Boolean);
   end Buffer;

   B: Buffer;
   
end buffer_package;
