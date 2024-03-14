with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO;
with Ada.Numerics.Discrete_Random;

package body buffer_package is

   task body Buffer is
      Storage_Capacity: constant Integer := 30;
      type Storage_type is array (Product_Type) of Integer;
      Storage: Storage_type
        := (0, 0, 0, 0, 0);
      Assembly_Content: array(Assembly_Type, Product_Type) of Integer
        := ((2, 2, 1, 0, 0),
            (0, 0, 1, 2, 1),
            (2, 2, 0, 0, 1));
      -- 4, 4, 2, 2, 2 => 14
      -- 1, 2: 30/14 * 4 = 8.57 -> 9
      -- 3,4,5: 30/14 * 2 = 4.28 -> 4
      -- sum(9, 9, 4, 4, 4) = capacity = 30
      Max_Assembly_Content: array(Product_Type) of Integer;
      Assembly_Number: array(Assembly_Type) of Integer
        := (1, 1, 1);
      In_Storage: Integer := 0;
      Max_Capacity_For_Product: array(Product_Type) of Integer
        := (0, 0, 0, 0, 0);

      procedure Setup_Variables is
         Product_Proportions_Sum: Integer := 0;
         Product_Proportions: array(Product_Type) of Integer := (0, 0, 0, 0, 0);
         Coefficient: Float := 0.0;
      begin

         for W in Product_Type loop
            Max_Assembly_Content(W) := 0;

            for Z in Assembly_Type loop
               if Assembly_Content(Z, W) > Max_Assembly_Content(W) then
                  Max_Assembly_Content(W) := Assembly_Content(Z, W);
               end if;
               Product_Proportions(W) := Product_Proportions(W) + Assembly_Content(Z, W);

            end loop;

            Product_Proportions_Sum := Product_Proportions_Sum + Product_Proportions(W);

         end loop;

         Coefficient := Float(Storage_Capacity) / Float (Product_Proportions_Sum);

         for Product_Index in Product_Type loop
            Max_Capacity_For_Product(Product_Index) := Integer (Float'Rounding (Coefficient * Float(Product_Proportions(Product_Index))));
         end loop;


      end Setup_Variables;


      function Can_Accept(Product: Product_Type) return Boolean is
         Free: Integer;    --  free room in the storage
         -- how many products are for production of arbitrary assembly
         Lacking: array(Product_Type) of Integer;
         -- how much room is needed in storage to produce arbitrary assembly
         Lacking_room: Integer;
         MP: Boolean;      --  can accept
      begin
         if Storage(Product) >= Max_Capacity_For_Product(Product) then
            return False;
         end if;
         -- There is free room in the storage
         Free := Storage_Capacity - In_Storage;
         MP := True;
         for W in Product_Type loop
            if Storage(W) < Max_Assembly_Content(W) then
               MP := False;
            end if;
         end loop;
         if MP then
            return True;    --  storage has products for arbitrary
            --  assembly
         end if;
         if Integer'Max(0, Max_Assembly_Content(Product) - Storage(Product)) > 0 then
            -- exactly this product lacks
            return True;
         end if;
         Lacking_room := 1;      --  insert current product
         for W in Product_Type loop
            Lacking(W) := Integer'Max(0, Max_Assembly_Content(W) - Storage(W));
            Lacking_room := Lacking_room + Lacking(W);
         end loop;
         if Free >= Lacking_room then
            -- there is enough room in storage for arbitrary assembly
            return True;
         else
            -- no room for this product
            return False;
         end if;
      end Can_Accept;

      function Can_Deliver(Assembly: Assembly_Type) return Boolean is
      begin
         for W in Product_Type loop
            if Storage(W) < Assembly_Content(Assembly, W) then
               return False;
            end if;
         end loop;
         return True;
      end Can_Deliver;

      procedure Storage_Contents is
      begin
         Put_Line("------------------------------------------------------------------------");
         for W in Product_Type loop
            Put_Line("[STORAGE]" & Integer'Image(Storage(W)) & " "
                     & Product_Name(W));
         end loop;
         Put_Line("------------------------------------------------------------------------");
      end Storage_Contents;

   begin
      Put_Line("STORAGE started");
      Setup_Variables;
      loop
         select
            when In_Storage < Storage_Capacity =>
               accept Take(Product: in Product_Type; Number: in Integer; IsTaken: out Boolean) do
                  IsTaken := Can_Accept(Product);
                  if IsTaken then
                     Put_Line("[STORAGE] Accepted product [" & Integer'Image(Number) & " ] " & Product_Name(Product) );
                     Storage(Product) := Storage(Product) + 1;
                     In_Storage := In_Storage + 1;
                     Storage_Contents;
                  else
                     Put_Line("[STORAGE] Storage is full, we can't accept [" & Integer'Image(Number) & " ] " & Product_Name(Product));
                  end if;
               end Take;
         or
            accept Deliver(Assembly: in Assembly_Type; Number: out Integer; HasTaken: out Boolean) do
               Number := Assembly_Number(Assembly);

               if Can_Deliver(Assembly) then
                  for W in Product_Type loop
                     Storage(W) := Storage(W) - Assembly_Content(Assembly, W);
                     In_Storage := In_Storage - Assembly_Content(Assembly, W);
                  end loop;
                  Assembly_Number(Assembly) := Assembly_Number(Assembly) + 1;
                  HasTaken := True;
                  Storage_Contents;
               else
                  HasTaken := False;
               end if;

            end Deliver;

         end select;
      end loop;
   end Buffer;  
   
end buffer_package;
