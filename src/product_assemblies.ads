package Product_Assemblies is
   
   Number_Of_Products: constant Integer := 5;
   Number_Of_Assemblies: constant Integer := 3;
   subtype Product_Type is Integer range 1 .. Number_Of_Products;
   subtype Assembly_Type is Integer range 1 .. Number_Of_Assemblies;
   Product_Name: constant array (Product_Type) of String(1 .. 14)
     := ("Potato        ", "Chicken breast", "Broccoli      ", "Tomato        ", "Lemon         ");
   Assembly_Name: constant array (Assembly_Type) of String(1 .. 37)
     := ("Chicken and Potato with Broccoli     ", "Tomato Salad with Lemon              ", "Baked Chicken and Potatoes with Lemon");
   
   subtype Production_Time_Range is Integer range 6 .. 10;
   subtype Consumption_Time_Range is Integer range 8 .. 12;
     
end Product_Assemblies;
